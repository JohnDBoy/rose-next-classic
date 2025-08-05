<!-- 
IMPORTANT: GEMINI CODE ASSIST INSTRUCTION SET
DO NOT MODIFY OR REMOVE THIS SECTION

Gemini, this file is your high-level project plan. You must update it as you complete major tasks.

1.  **Purpose**: To track major development phases, goals, and task status.
2.  **Workflow**: Update this file upon completing a major task or phase.
3.  **Instruction Integrity**: Never modify or remove this instruction block.

END OF INSTRUCTION
-->
# Gemini Game Plan

This document outlines the development plan for the `rose-next-classic` project.

### Phase 1: Initial Project Analysis (Complete)
*   **Outcome**: Analyzed project architecture, creating a comprehensive set of `gemini/*.md` files that document the build system, project structure, database, and a critical authentication bug.

### Phase 2: Documentation & Code Refinement (In Progress)
*   **Goal**: Improve documentation clarity, fix critical bugs, and refine the codebase.
*   **Tasks (Completed)**:
    *   Optimized all `gemini/*.md` files for clarity and brevity.
    *   Verified that the authentication hashing scheme is working as intended.
    *   Created a new, structured build guide (`gemini_readme.md`).
    *   Corrected the build instructions in `gemini_readme.md` to include the critical first step of building the Rust dependencies.
*   **Current Task**: Verify Development Environment Setup.
    *   **Rationale**: The persistent world server crash may be caused by an incorrect environment setup (e.g., bad asset paths, misconfigured `server.toml`) rather than a code-level bug.
    *   **Action**: Systematically review the setup process.

---

_Last Updated: 2025-08-05_
_Maintainer: Gemini / Developer: JDoeBoy
_File Version: 1.2_
