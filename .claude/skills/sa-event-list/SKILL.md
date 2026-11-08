---
name: sa-event-list
description: Generate an Event List from preliminary requirements for Structured Analysis.
---

# Event List Generation

## Input
- docs/preliminary_requirements.md
- docs/requirements_clarifications.md

## Procedure
1. Read the preliminary requirements.
2. Identify all input and output events.
3. Assign a clear and concise name to each event.
4. Write a description explaining each event.
5. Follow the format defined in templates/event-list.md.
6. Save the result to artifacts/SA/event_list.md.

## Guidelines
- Include both input and output events.
- Identify flow-oriented, temporal, and control events when applicable.
- Use event names that clearly represent the corresponding inputs or outputs.
- Do not invent events not supported by the requirements.
- Ensure that every event is traceable to the preliminary requirements.

## Output
- artifacts/SA/event_list.md
