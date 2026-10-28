---
title: Architecture
status: draft
created: {{DATE}}
updated: {{DATE}}
---

# Architecture

How the system is put together: its parts, how data moves between them, and what it depends
on. Stack choices and their reasons are recorded elsewhere (docs/STACK.md in a project
set up by project-kickoff, otherwise AGENTS.md); this file shows how they fit together. Update the matching section
whenever a feature's Impact names it.

## Overview

{{OVERVIEW: 1–3 sentences on how the system is put together, only from the source (the brief and answers for a new project, clear scan findings for an existing one); otherwise "Not designed yet" for a new project, "Not documented yet" for an existing one}}

## Components

{{COMPONENTS: one bullet "- <part> — <role>" per part the source states, with only the technology the source names for it ("a web app … Next.js" → "- Web app — built with Next.js"); otherwise "Not designed yet" for a new project, "Not documented yet" for an existing one}}

## Data flow

{{DATA_FLOW: how data moves between the parts, only as the source states it; otherwise "Not designed yet" for a new project, "Not documented yet" for an existing one}}

## External services

{{EXTERNAL: one bullet per external service the source names (hosting, database, auth, email, payments, …), with its role only when the source states it ("- Vercel — hosting", "- Supabase — role not stated"); otherwise "Not designed yet" for a new project, "Not documented yet" for an existing one}}

## Constraints

{{CONSTRAINTS: technical limits the source states (performance, offline, data residency, …); otherwise "Not designed yet" for a new project, "Not documented yet" for an existing one}}
