
# How I work with AI

I build with AI coding agents every day, set up so they follow my engineering
standards instead of guessing.

## Tools

- **Claude Code** in the terminal: my main tool for design, coding, review and
  releases.
- **Claude** on the web and desktop: research, writing and documents.
- **Ollama**: local models for offline experiments.
- **Earlier:** Cursor and GitHub Copilot.

## Setup

- **Project instructions:** every active repository has its own `CLAUDE.md`
  (or `AGENTS.md`) describing the architecture, conventions, commands and
  pitfalls. There are more than 20 across my projects.
- **Global rules:** cost and quality guardrails, such as which model does which
  job (small models for search, mid-size for code, large for architecture),
  at most 3 parallel subagents, and short reports.
- **Persistent memory:** per-project notes on decisions, feedback and context,
  so sessions don't start from zero.
- **Custom skills, generated with AI:**
  - a Material 3 design audit for Flutter apps
  - a design audit for Django + Bootstrap apps
  - a release flow: semver bump, Croatian release notes, tagged release
  - visual explainers
- **Plugins:** Superpowers (brainstorm → plan → test-driven implementation →
  review), Google's Elephant–Goldfish document review, a Pyright language
  server.
- **MCP servers:** a Trello integration I built myself, plus Dart, Firebase,
  Serverpod and other per-project servers.
- **Hooks:** deterministic automation around the agent, such as terminal status,
  notifications when it needs me, and context reminders.

## Workflow

1. **Design first:** a short written design (`design/*.md`) before any code.
2. **Tests first:** failing tests, then the implementation, then the full
   suite, analyzer and formatter.
3. **Visual checks:** the agent renders the UI to images and inspects them
   before calling UI work done.
4. **Review:** an independent review pass before merging. Releases are scripted
   as skills.
5. **Human in charge:** I own architecture, product decisions and anything
   irreversible. The agent asks before deploys, pushes and deletions.

## Scale

Most of my 2025–2026 output was built this way.
