---
name: sa-data-dictionary
description: Incrementally create and update the Data Dictionary whenever a new DFD level is generated, preserving existing definitions and refining data types, formats, flows, and Data Stores.
---

# Incremental Data Dictionary Generation

## Inputs
- artifacts/SA/event_list.md
- artifacts/SA/context_diagram.md
- docs/preliminary_requirements.md
- docs/requirements_clarifications.md
- artifacts/SA/DFD/dfd_level_0.md
- artifacts/SA/DFD/dfd_level_1.md
- artifacts/SA/DFD/dfd_level_2.md
- artifacts/SA/DFD/dfd_level_3.md
- artifacts/SA/data_dictionary.md

## Objective
Maintain a continuously updated Data Dictionary
throughout hierarchical DFD decomposition.

Whenever a new DFD level is generated,
update the existing Data Dictionary by adding
new definitions and refining existing ones.

Do not recreate the Data Dictionary from scratch.

## Execution Policy
- Initialize the Data Dictionary from the Event List.
- Update the Data Dictionary immediately after
  generating each DFD level.
- Treat Data Dictionary updates as part of
  the DFD generation workflow.
- Complete each update before proceeding
  to the next DFD level.
- Preserve existing data definitions.
- Refine definitions when new information
  becomes available.
- Report inconsistencies before proceeding.

## Procedure

### Step 1. Initialize from Event List
1. Read the preliminary requirements.
2. Read the Event List.
3. If the Data Dictionary does not exist, initialize it.
4. Preserve all Event List names and descriptions.
5. Define known data types and formats.
6. Mark unspecified information as TBD.
7. Save to artifacts/SA/data_dictionary.md.

### Step 2. Update After Each DFD Level (0-3)
1. Read the newly generated DFD level.
2. Load the existing Data Dictionary.
3. Identify all data flows and control flows.
4. Identify all Data Stores.
5. Compare identified items with existing definitions.
6. Add definitions for newly introduced items.
7. Refine existing definitions when additional
   information becomes available.
8. Update source, destination, and DFD level information.
9. Preserve previously documented definitions.
10. Validate consistency with the current DFD
    and previously generated DFD levels.
11. Save the updated Data Dictionary.

### Step 3. Validate Final Data Dictionary
1. Verify that every DFD flow is defined.
2. Verify that every Data Store is defined.
3. Verify consistency across DFD Levels 0-3.
4. Verify consistency with the Event List.
5. Check for duplicate or conflicting definitions.
6. Report undefined or ambiguous data.


## Incremental Update Rules
- Always read the existing Data Dictionary
  before performing an update.
- Never discard previously defined data.
- Add new entries when new flows or stores appear.
- Refine existing entries when more detailed
  information becomes available.
- Preserve original Event List names.
- Maintain consistent naming across DFD levels.
- Record all levels where each data item appears.
- Do not overwrite definitions with conflicting values.
- Report conflicts and request clarification.
- Do not invent unsupported types or values.

## Required Fields
- Data Name
- Description
- Format / Type
- Flow Category
- Source
- Destination
- DFD Level
- Requirement Reference

## Formatting
Follow templates/data-dictionary.md.

## Output
- artifacts/SA/data_dictionary.md

## Completion Criteria
- The Data Dictionary is updated after each
  generated DFD level (0-3).
- Every data flow and control flow in the
  current DFD level is defined.
- Every Data Store in the current DFD level is defined.
- Existing definitions are preserved or refined.
- No conflicting definitions remain unresolved.
- The Data Dictionary is consistent with
  all generated DFD levels and the Event List.
