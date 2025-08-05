<!-- 
IMPORTANT: GEMINI CODE ASSIST INSTRUCTION SET
DO NOT MODIFY OR REMOVE THIS SECTION

Gemini, this file tracks known bugs. Refer to it before starting new work.

1.  **Purpose**: To document known bugs, their impact, and potential fixes.
2.  **Instruction Integrity**: Never modify or remove this instruction block.

END OF INSTRUCTION
-->
# Known Bugs

This document tracks known bugs in the `rose-next-classic` project.

---

## 1. World Server Crash on Login with Spawned Items

*   **Status**: To Be Investigated
*   **Severity**: Critical
*   **Description**: The `sho_worldserver.exe` process crashes when a player attempts to log in with a character that has certain items (e.g., "socket ring") spawned via the in-game developer tools.
*   **Steps to Reproduce**:
    1.  Log in with any character.
    2.  Open the ImGui developer tools (`~` key).
    3.  Spawn a "socket ring" item.
    4.  Log out. The character data will appear to save correctly.
    5.  Attempt to log back into the same account.
    6.  The world server will crash during character loading.
*   **Preliminary Analysis**: This is likely a data serialization/deserialization bug. The game server saves the item data to the database in a format that the world server cannot correctly parse when loading the character. The "socket" property of the item is a likely culprit.
*   **Investigation Update**: The character loading logic in `gs_threadsql.cpp` (`Proc_cli_SELECT_CHAR`) was reviewed. A section of code handling item appraisal was initially suspected, but after clarification of the `IsAppraisal()` mechanic, it was found to be correct. This rules out that specific logic block as the cause. The investigation should continue to compare the item saving logic in `gs_threadsql.cpp` with the character loading logic on the world server.
*   **Investigation Update (New Direction)**: Based on a review of past issues, there is a strong possibility that this crash is not a code bug, but rather a symptom of an incorrect development environment setup. The server may be failing to load necessary game data files (STBs) due to incorrect paths in `server.toml` or improper asset symlinking as described in `dev_env_setup.md`. The next step is to verify the full environment configuration.
*   **Files to Investigate**:
    *   `README.md` (Setup instructions)
    *   `gemini/dev_env_setup.md` (Asset symlinking log)
    *   `doc/server.toml.example` (Server configuration)

    ---

_Last Updated: YYYY-MM-DD_  
_Maintainer: AI / Developer Name_  
_File Version: 1.0_

