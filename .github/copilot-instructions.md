### Repository rules and guidelines:

**NOTE - If you see something here that conflicts with the current state of the repository, ask about it in chat.**

- Follow the existing structure and style of the folder or file you are editing.
- Keep changes small, local, and recoverable.
- Prefer extending existing Haxe patterns over introducing new abstractions.
- When adding verification, use the narrowest relevant command for the touched area before broad repo-wide checks.

### Agent guidelines:

- Split work into as many simple tasks as needed to keep execution reliable and resumable.
- For multi-step work, create a detailed markdown plan under `.github/plans/{PLAN_NAME}.md` instead of keeping the plan only in chat.
- Work on one plan at a time.
- Record concise progress notes in `.github/agent-progress/{CURRENT_CHAT_TITLE}.md` so another agent can resume without chat history.
- At the end of a plan, update the matching plan file under `.github/plans/`, even for small plans.
- Before claiming work is complete, ensure the relevant diagnostics for the touched scope are clean.
- If written conventions and repository reality conflict, stop and surface the conflict instead of guessing.