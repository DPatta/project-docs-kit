#!/usr/bin/env bash
# Checks the structure-2 decision log: docs/decisions/D-NNNN-<slug>.md plus the index
# docs/DECISIONS.md. Read-only: it writes nothing in the project (scratch files go to $TMPDIR).
# Used by project-kickoff's upgrade mode (references/upgrade.md) and by the kit's dev tests.
# Usage: bash scripts/check-decisions.sh <project-dir> [<old-DECISIONS.md>]
#   <old-DECISIONS.md>: the structure-1 log before migration (e.g. from `git show HEAD:docs/DECISIONS.md`).
#   With it, every old entry must exist as a file with the same date, title and a byte-identical body.
# Exit 0 + "PASS" when valid, exit 1 + "FAIL: ..." lines otherwise. "WARN: ..." lines never fail.
set -u
dir="${1:?usage: check-decisions.sh <project-dir> [<old-DECISIONS.md>]}"
old="${2:-}"
fail=0
err() { echo "FAIL: $*"; fail=1; }
warn() { echo "WARN: $*"; }

idx="$dir/docs/DECISIONS.md"
dd="$dir/docs/decisions"
[ -f "$idx" ] || err "missing docs/DECISIONS.md"
[ -d "$dd" ] || err "missing dir docs/decisions"
[ -z "$old" ] || [ -f "$old" ] || err "old log not found: $old"
[ "$fail" -eq 0 ] || exit 1

tmp=$(mktemp -d "${TMPDIR:-/tmp}/check-decisions.XXXXXX")
trap 'rm -rf "$tmp"' EXIT
mkdir -p "$tmp/new" "$tmp/old"

# fm <file> <key> -> raw value of a top-level front matter key (empty if absent)
fm() {
  awk -v k="$2" '
    NR==1 && $0!="---" { exit }
    NR>1 && $0=="---"  { exit }
    NR>1 && index($0, k":")==1 { v = substr($0, length(k) + 2); sub(/^ /, "", v); print v; exit }
  ' "$1"
}
# has_key <file> <key> -> 0 when the key is in the front matter
has_key() {
  awk -v k="$2" '
    NR==1 && $0!="---" { exit 1 }
    NR>1 && $0=="---"  { exit 1 }
    NR>1 && index($0, k":")==1 { found = 1; exit 0 }
    END { exit found ? 0 : 1 }
  ' "$1"
}
# unquote a YAML scalar: "a \"b\"" -> a "b"
unquote() {
  case "$1" in
    \"*\") printf '%s' "$1" | sed -e 's/^"//' -e 's/"$//' -e 's/\\"/"/g' -e 's/\\\\/\\/g' ;;
    \'*\') printf '%s' "$1" | sed -e "s/^'//" -e "s/'\$//" -e "s/''/'/g" ;;
    *) printf '%s' "$1" ;;
  esac
}
# id list "[D-0001, D-0002]  # comment" -> "D-0001 D-0002" (empty for []); "BAD" if malformed
idlist() {
  local v
  v=$(printf '%s' "$1" | sed -e 's/[[:space:]]*#.*$//' -e 's/[[:space:]]*$//')
  if ! printf '%s' "$v" | grep -Eqx '\[(D-[0-9]{4}(, *D-[0-9]{4})*)?\]'; then echo BAD; return; fi
  printf '%s' "$v" | tr -d '[] ' | tr ',' ' '
}
# body <file> <first-line-regex> -> lines after the first line matching the regex, up to the next
# old-style entry heading or EOF, without leading and trailing blank lines
body() {
  awk -v start="$2" '
    !on && $0 ~ start { on = 1; next }
    on && /^## D-[0-9][0-9][0-9][0-9] / { exit }
    on { buf[++n] = $0 }
    END {
      first = 1; while (first <= n && buf[first] ~ /^[[:space:]]*$/) first++
      last = n;  while (last >= first && buf[last] ~ /^[[:space:]]*$/) last--
      for (i = first; i <= last; i++) print buf[i]
    }
  ' "$1"
}

# ---- 1. Decision files ----
n=0
: > "$tmp/files.tsv"
for p in "$dd"/*; do
  [ -e "$p" ] || continue
  b=$(basename "$p")
  case "$b" in .gitkeep) continue ;; esac
  if ! echo "$b" | grep -Eq '^D-[0-9]{4}-[a-z0-9]+(-[a-z0-9]+)*\.md$'; then
    err "bad file name decisions/$b (D-NNNN-<kebab-slug>.md)"; continue
  fi
  num=${b#D-}; num=${num%%-*}
  n=$((n + 1)); expect=$(printf '%04d' "$n")
  [ "$num" = "$expect" ] || err "decisions/$b: expected D-$expect (ids run from D-0001 with no gap)"
  id="D-$num"
  slug=${b#D-"$num"-}; slug=${slug%.md}
  words=$(printf '%s' "$slug" | tr '-' '\n' | grep -c .)
  [ "$words" -le 8 ] || warn "decisions/$b: slug has $words parts (rule: the first 1–6 words of the title)"

  for k in id title date supersedes superseded-by; do
    has_key "$p" "$k" || err "decisions/$b: missing front matter '$k'"
  done
  fid=$(fm "$p" id); [ "$fid" = "$id" ] || err "decisions/$b: id '$fid' != $id"
  title=$(unquote "$(fm "$p" title)")
  [ -n "$title" ] || err "decisions/$b: empty title"
  date=$(fm "$p" date)
  echo "$date" | grep -Eqx '[0-9]{4}-[0-9]{2}-[0-9]{2}' || err "decisions/$b: bad date '$date'"
  sup=$(idlist "$(fm "$p" supersedes)")
  supby=$(idlist "$(fm "$p" superseded-by)")
  [ "$sup" != BAD ] || { err "decisions/$b: supersedes must be [] or [D-NNNN, ...]"; sup=; }
  [ "$supby" != BAD ] || { err "decisions/$b: superseded-by must be [] or [D-NNNN, ...]"; supby=; }

  heading=$(awk 'NR==1 && $0=="---" { infm = 1; next } infm && $0=="---" { infm = 0; next }
                 !infm && /^# / { print; exit }' "$p")
  [ "$heading" = "# $id — $title" ] || err "decisions/$b: heading '$heading' != '# $id — $title'"

  body "$p" "^# D-[0-9]{4} " > "$tmp/new/$id"
  [ -s "$tmp/new/$id" ] || err "decisions/$b: empty body"
  if [ -z "$old" ]; then   # new entries follow the entry format; migrated ones keep their old body
    for k in Decision Why Rejected; do
      grep -q "^- \*\*$k:\*\* " "$p" || err "decisions/$b: missing '- **$k:**' line"
    done
  fi

  printf '%s\t%s\t%s\t%s\t%s\t%s\n' "$id" "$date" "$title" "$(echo $sup)" "$(echo $supby)" "$b" >> "$tmp/files.tsv"
done
[ "$n" -ge 1 ] || err "no decision files in docs/decisions"

# ---- 2. supersedes / superseded-by links: existing ids, older/newer, both directions ----
awk -F'\t' '
  { ids[$1] = 1; sup[$1] = $4; supby[$1] = $5 }
  END {
    for (id in ids) {
      m = split(sup[id], a, " ")
      for (i = 1; i <= m; i++) {
        x = a[i]
        if (!(x in ids)) { print "FAIL: " id " supersedes unknown " x; continue }
        if (x >= id) print "FAIL: " id " supersedes " x ", which is not older"
        if ((" " supby[x] " ") !~ (" " id " ")) print "FAIL: " id " supersedes " x ", but " x " superseded-by does not list " id
      }
      m = split(supby[id], a, " ")
      for (i = 1; i <= m; i++) {
        x = a[i]
        if (!(x in ids)) { print "FAIL: " id " superseded-by unknown " x; continue }
        if (x <= id) print "FAIL: " id " superseded-by " x ", which is not newer"
        if ((" " sup[x] " ") !~ (" " id " ")) print "FAIL: " id " superseded-by " x ", but " x " supersedes does not list " id
      }
    }
  }' "$tmp/files.tsv" | sort > "$tmp/links.out"
while IFS= read -r line; do err "${line#FAIL: }"; done < "$tmp/links.out"

# ---- 3. Index rows: one per file, oldest first, same date and title, status from superseded-by ----
grep -E '^\| *\[D-' "$idx" > "$tmp/rows.txt" || true
rows=$(grep -c . "$tmp/rows.txt" || true)
[ "${rows:-0}" -eq "$n" ] || err "DECISIONS.md has ${rows:-0} decision rows for $n files"
grep -q '^| Decision | Date | Title | Status |$' "$idx" || err "DECISIONS.md: table header must be '| Decision | Date | Title | Status |'"
i=0
while IFS= read -r row; do
  i=$((i + 1))
  parsed=$(printf '%s\n' "$row" | sed -nE 's/^\| \[(D-[0-9]{4})\]\(decisions\/([^)]+)\) \| ([^|]+) \| (.*) \| ([^|]+) \|$/\1	\2	\3	\4	\5/p')
  if [ -z "$parsed" ]; then err "DECISIONS.md: bad row: $row"; continue; fi
  rid=$(printf '%s' "$parsed" | cut -f1); rfile=$(printf '%s' "$parsed" | cut -f2)
  rdate=$(printf '%s' "$parsed" | cut -f3); rtitle=$(printf '%s' "$parsed" | cut -f4 | sed 's/\\|/|/g')
  rstatus=$(printf '%s' "$parsed" | cut -f5)
  line=$(awk -F'\t' -v id="$rid" '$1 == id' "$tmp/files.tsv")
  [ "$rid" = "D-$(printf '%04d' "$i")" ] || err "DECISIONS.md row $i is $rid (rows go oldest first, one per decision)"
  if [ -z "$line" ]; then err "DECISIONS.md: $rid has no file in docs/decisions"; continue; fi
  fdate=$(printf '%s' "$line" | cut -f2); ftitle=$(printf '%s' "$line" | cut -f3)
  fsupby=$(printf '%s' "$line" | cut -f5); fname=$(printf '%s' "$line" | cut -f6)
  [ "$rfile" = "$fname" ] || err "DECISIONS.md: $rid links to '$rfile', file is '$fname'"
  [ "$rdate" = "$fdate" ] || err "DECISIONS.md: $rid date '$rdate' != file date '$fdate'"
  [ "$rtitle" = "$ftitle" ] || err "DECISIONS.md: $rid title differs from its file: '$rtitle' vs '$ftitle'"
  if [ -z "$fsupby" ]; then
    [ "$rstatus" = active ] || err "DECISIONS.md: $rid status '$rstatus' but its superseded-by is empty (expected 'active')"
  else
    want=$(echo "$fsupby" | sed 's/ /, /g')
    case "$rstatus" in
      "superseded by $want"|"partly superseded by $want") ;;
      *) err "DECISIONS.md: $rid status '$rstatus' must be 'superseded by $want' or 'partly superseded by $want'" ;;
    esac
  fi
done < "$tmp/rows.txt"

# ---- 4. Migration: every old entry kept with the same date, title and byte-identical body ----
if [ -n "$old" ]; then
  sed -nE 's/^## (D-[0-9]{4}) — ([0-9]{4}-[0-9]{2}-[0-9]{2}) — (.*)$/\1	\2	\3/p' "$old" > "$tmp/old.tsv"
  oldn=$(grep -c . "$tmp/old.tsv" || true)
  heads=$(grep -cE '^## D-[0-9]{4}' "$old" || true)
  [ "${oldn:-0}" -eq "${heads:-0}" ] || err "old log: ${heads:-0} entry headings, only ${oldn:-0} match '## D-NNNN — YYYY-MM-DD — <title>'"
  [ "${oldn:-0}" -ge 1 ] || err "old log has no entries"
  while IFS="$(printf '\t')" read -r oid odate otitle; do
    line=$(awk -F'\t' -v id="$oid" '$1 == id' "$tmp/files.tsv")
    if [ -z "$line" ]; then err "$oid from the old log has no file"; continue; fi
    [ "$(printf '%s' "$line" | cut -f2)" = "$odate" ] || err "$oid: date changed in migration"
    [ "$(printf '%s' "$line" | cut -f3)" = "$otitle" ] || err "$oid: title changed in migration"
    body "$old" "^## $oid — " > "$tmp/old/$oid"
    cmp -s "$tmp/old/$oid" "$tmp/new/$oid" || err "$oid: body is not byte-identical to the old log — diff <(...) shows: $(diff "$tmp/old/$oid" "$tmp/new/$oid" | head -n 3 | tr '\n' ' ')"

    # Relations the migration must have found.
    # Binding: the ids in the leading clause of a Supersedes bullet ("D-0010, only ..." -> D-0010;
    # "D-0010 and D-0012; ..." -> both). Hints (WARN): other ids in that bullet, ids in a Changes
    # bullet, and ids that follow supersede/amend/narrow/refine/... wording elsewhere, unless the
    # phrase is negated ("supersedes nothing").
    fsup=" $(printf '%s' "$line" | cut -f4) "
    bullet=$(grep -E '^- \*\*Supersedes:\*\*' "$tmp/old/$oid" | sed 's/^- \*\*Supersedes:\*\* *//')
    lead=$(printf '%s\n' "$bullet" | sed -E 's/[,;.].*$//; s/ only .*$//')
    for x in $(printf '%s\n' "$lead" | grep -Eo 'D-[0-9]{4}' | sort -u); do
      [ "$x" \< "$oid" ] || continue
      case "$fsup" in *" $x "*) ;; *) err "$oid: its Supersedes line starts with $x, but supersedes does not list it" ;; esac
    done
    for x in $( { printf '%s\n' "$bullet" | grep -Eo 'D-[0-9]{4}'
                  grep -E '^- \*\*Changes:\*\*' "$tmp/old/$oid" | grep -Eo 'D-[0-9]{4}'
                  { printf '%s\n' "$otitle"; cat "$tmp/old/$oid"; } \
                    | grep -Eio '([A-Za-z]+ ){0,3}(supersed|amend|narrow|replac|overrid|revers|refin)[a-z]*[^.;]{0,40}D-[0-9]{4}[^.;]*' \
                    | grep -Eiv '(^|[^a-z])(nothing|no|not|never)[^a-z]' \
                    | grep -Eo 'D-[0-9]{4}'; } | sort -u); do
      [ "$x" \< "$oid" ] || continue
      case "$fsup" in *" $x "*) ;; *) warn "$oid: mentions $x next to supersede/amend wording; check whether it should be in supersedes" ;; esac
    done
    # Back-notes in the older entry: "Narrowed 2026-11-06 by D-0074", "Superseded in part by D-0090".
    fsupby=" $(printf '%s' "$line" | cut -f5) "
    for x in $( cat "$tmp/old/$oid" \
        | grep -Eio '(supersed|amend|narrow|replac|overrid|revers|chang|limit)[a-z]*[^.;]{0,40}[^a-z]by D-[0-9]{4}' \
        | grep -Eiv '(^|[^a-z])(nothing|no|not|never)[^a-z]' \
        | grep -Eo 'D-[0-9]{4}$' | sort -u); do
      [ "$oid" \< "$x" ] || continue
      case "$fsupby" in *" $x "*) ;; *) warn "$oid: says it was changed by $x; check whether $x should list it in supersedes" ;; esac
    done
  done < "$tmp/old.tsv"
fi

if [ "$fail" -eq 0 ]; then echo "PASS"; else exit 1; fi
