---
name: sa-dfd
description: Generate hierarchical Data Flow Diagrams (DFD Levels 0-3) and a Level 4 Controller FSM using preliminary requirements, the Event List, and the System Context Diagram.
---

# Data Flow Diagram Generation

## Inputs
- preliminary_requirements.md
- artifacts/SA/event_list.md
- artifacts/SA/context_diagram.md
- artifacts/SA/DFD/dfd_level_0.md
- artifacts/SA/DFD/dfd_level_1.md
- artifacts/SA/DFD/dfd_level_2.md
- artifacts/SA/DFD/dfd_level_3.md

## Objective
Perform functional decomposition of the system
using hierarchical Data Flow Diagrams.

Generate DFD Levels 0 through 3 and represent
the Controller as an FSM at Level 4.

## Procedure

### Step 1. Review Inputs
1. Read the preliminary requirements.
2. Read the Event List.
3. Read the System Context Diagram.
4. Identify external entities and data flows.
5. Identify system functions and control events.

### Step 2. Generate DFD Level 0
1. Use the System Context Diagram as the basis.
2. Represent the entire system as Process 0.
3. Identify external entities interacting with the system.
4. Represent input and output data flows.
5. Add control flows when supported by requirements.
6. Ensure consistency with the Context Diagram.

### Step 3. Generate DFD Level 1
1. Decompose Process 0 into major system functions.
2. Assign process numbers 1, 2, 3, etc.
3. Identify data and control flows between processes.
4. Introduce Data Stores when necessary.
5. Preserve the external interfaces of Level 0.
6. Verify balancing between Level 0 and Level 1.

### Step 4. Generate DFD Level 2
1. Decompose Level 1 processes into sub-processes.
2. Use hierarchical numbering:
   1.1, 1.2, 1.3, 2.1, 2.2, etc.
3. Identify detailed functional responsibilities.
4. Identify data and control flows.
5. Identify required Data Stores.
6. Verify balancing with each parent process.
7. Create separate diagrams for distinct
   parent processes when necessary.

### Step 5. Generate DFD Level 3
1. Select the processes that require further decomposition.
2. Decompose them into lower-level functions.
3. Use hierarchical numbering:
   2.1.1, 2.1.2, 2.1.3, etc.
4. Separate control and data processing functions.
5. Identify detailed data and control flows.
6. Preserve the parent process interfaces.
7. Verify balancing with Level 2.
8. Continue until the Controller can be
   represented using an FSM.

### Step 6. Generate DFD Level 4 (Controller FSM)
1. Identify the Controller process from Level 3.
2. Read its inputs, outputs, and control flows.
3. Identify controller states.
4. Identify triggering events and transition conditions.
5. Identify actions associated with transitions.
6. Define the initial state.
7. Define all required state transitions.
8. Represent the FSM using Mermaid stateDiagram-v2.
9. Ensure consistency with the Level 3 Controller.

## DFD Notation
- Data Process: Circular node.
- Control Process: Dashed circular node.
- Terminator: Rectangular node.
- Data Store: Data Store node.
- Data Flow: Solid directed arrow.
- Control Flow: Dashed directed arrow.

## Decomposition Rules
- Each lower level must refine a process
  from the immediately preceding level.
- Preserve the parent process input/output interface.
- Do not introduce unexplained external flows.
- Every process must have a meaningful function.
- Use consistent process numbering.
- Do not decompose functions without justification.
- Do not invent unsupported system behavior.

## Mermaid Guidelines
- Use flowchart LR for DFD Levels 0-3.
- Use stateDiagram-v2 for the Controller FSM.
- Follow templates/dfd-template.md.
- Follow templates/fsm-template.md.
- Label all data and control flows.
- Distinguish control flows from data flows.
- Use valid Mermaid syntax.

## Validation
- Verify DFD balancing between adjacent levels.
- Verify process numbering consistency.
- Verify input/output consistency.
- Verify data and control flow labels.
- Verify Controller FSM consistency with Level 3.
- Report missing or ambiguous requirements.
- Do not silently resolve inconsistencies.

## Outputs
- artifacts/SA/DFD/dfd_level_0.md
- artifacts/SA/DFD/dfd_level_1.md
- artifacts/SA/DFD/dfd_level_2.md
- artifacts/SA/DFD/dfd_level_3.md
- artifacts/SA/DFD/dfd_level_4_fsm.md
