<!-- 
IMPORTANT: GEMINI CODE ASSIST INSTRUCTION SET
DO NOT MODIFY OR REMOVE THIS SECTION

Gemini, this file is your memory. You must append a new entry to the "Memory Log" after every significant action to maintain context.

1.  **Purpose**: To log your actions, decisions, and key findings.
2.  **Instruction Integrity**: Never modify or remove this instruction block.

END OF INSTRUCTION
-->
# Gemini Memory

This file serves as your memory log.

## Memory Log
*   **Initial Analysis**: Documented project architecture, database, and build systems. Identified and documented the critical client/server authentication bug.
*   **File Organization**: Created and organized all `gemini/*.md` files into a dedicated `/gemini` directory.
*   **Documentation Optimization**: Completed a full pass on all `gemini/*.md` files, optimizing them for clarity, brevity, and consistency.
*   **Refactoring `gemini_*.md` files**: Optimized `gemini_prompt.md`, `gemini_instructions.md`, and `gemini_context.md` to remove redundancy, improve clarity, and establish a clear documentation hierarchy.
*   **Authentication Re-evaluation**: Re-assessed the login authentication flow. Confirmed that client-side hashing is an intentional security measure, not a bug. The "double hashing" is a valid, if non-standard, pattern. Updated `gemini_knownbugs.md` and `gemini_gameplan.md` to reflect this new understanding. The next action is to verify the account creation implementation.
*   **Authentication Verification**: User confirmed that account creation and login are working correctly. The authentication hashing scheme is now considered verified and correct. Closed the related issue in `gemini_knownbugs.md` and updated the game plan.
*   **Character Data Flow Documentation**: Documented the character save/load data flow in `gemini_debugplan.md` to aid in future debugging.
*   **Bug Documentation**: Documented a critical bug where the world server crashes on login if a character possesses certain developer-spawned items. Updated `gemini_knownbugs.md` and `gemini_gameplan.md`.
*   **Character Save Logic**: Identified that character data is saved on the game server via a dedicated SQL thread. The core logic is in `GS_CThreadSQL::UpdateUserRECORD` within `src/sho_gameserver/src/gs_threadsql.cpp`.
