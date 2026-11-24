---
name: story
description: Takes ONE user story from the backlog, adds acceptance criteria and proposes an implementation plan.
disable-model-invocation: true
---

# Story

We refine a single story, right before building it. You propose and I decide.

## Steps

1. **Read the story** I give you and review the current code and the project's agent instructions file to understand the context.
2. **Expensive decisions.** Check if this story touches any "expensive decision" recorded in the project's agent instructions file. If so, flag it and briefly lay out 2–3 options with trade-offs before planning.
3. **Acceptance criteria.** Propose in Given/When/Then format. They only describe *what* the user sees or gets, never *how* it's implemented.
4. **If it needs more than 3 criteria, evaluate splitting it.** Deliver the new stories in backlog format (`As a…, I want…, so that…`) for me to add to the tracker, and we continue with the first one.
5. **Mini plan.** 5 bullets max, no code. How it cuts through the layers and which modules or files it touches.
6. **Wait for my approval.** We adjust until I say yes.

## Rules

- **Don't invent requirements.** If information is missing, ask me.
- **The simplest thing that meets the criteria.** No abstractions, layers, configuration or patterns "for the future".
- **Suggest, don't decide.** If a pattern could help, mention it under "Suggestions" with its why. Only suggest it if there's a concrete signal in the current code, not in advance.

## Output format

A block ready to paste into the issue.

```markdown
## Story
As a <actor>, I want <action>, so that <benefit>.

## Acceptance criteria
- [ ] Given <context>, when <action>, then <result>.
- [ ] ...

## Plan
- ...

## Out of scope
- <what's left out of this story, so it doesn't sneak in>

## Suggestions (your call)
- <optional>
```
