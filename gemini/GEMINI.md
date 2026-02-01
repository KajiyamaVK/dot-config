# Antigravity User Configuration

## General Preferences

- **Configuration Location**: The user prefers to maintain all configuration files in `~/.config/gemini/`. This directory is version controlled.
- **Rule Persistence**: Any new rules or behavioral adjustments for Antigravity must be recorded in this file (`~/.config/gemini/GEMINI.md`) to ensure they persist across sessions.

## Professional Vibe Coding Workflow

To "Vibe Code" effectively without accumulating "Shadow Technical Debt," the agent must adopt a "Senior Dev" perspective. This workflow combines the speed of AI generation with the rigor of TDD and Domain/Interface definition.

### Core Philosophy

- **Anti-Pattern**: Asking AI to "write a feature" -> Copying code -> Hoping it works.
- **Pro-Pattern**: **Define Intent (Interface)** -> **AI Generates Tests (Contract)** -> **AI Implements (Code)**.

### The Algorithm

1. **Phase 1: The Blueprint (DDD / Interface First)**
    - **Do not** ask for implementation code yet.
    - **Do** ask for the **Interface** or **Type Definition** first. This defines the "Domain" and ensures the new feature fits the "architectural soul" of the project.
    - *Example*: "Define a TypeScript interface for a service that handles Telegram message queuing, with 3 retries and Winston logging."

2. **Phase 2: The Contract (Test-Driven)**
    - **Do ensure** the AI defines verification steps *before* implementation.
    - **Do** ask the AI to generate a complete **Test Suite** (e.g., Jest, Vitest, Go table tests) based *strictly* on the Interface from Phase 1.
    - **Action**: Run the tests. They **must fail** (Red). This confirms the tests are checking for behavior that doesn't exist yet.

3. **Phase 3: The Implementation (Red-to-Green)**
    - **Do** ask the AI to write the implementation code to make the *specific failing tests pass*.
    - **Action**: Run tests again. If they pass (Green), the task is done.
    - **Refactor**: If needed, refactor the code while keeping tests Green.

### Why this matters

- **Prevents Hallucinations**: The test suite acts as a strict contract aka "The Vibe" that the AI must satisfy.
- **Prevents Shadow Debt**: By defining the Interface first, we ensure the code is "globally coherent" with the rest of the project, not just a "locally perfect" snippet.
