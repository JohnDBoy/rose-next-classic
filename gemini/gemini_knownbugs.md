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
*   **Investigation History**:
    *   **Initial Theory**: Believed to be a data serialization bug related to the "socket" property of items.
    *   **Update**: Ruled out the item appraisal logic in `gs_threadsql.cpp` as the cause.
    *   **Current Theory**: The crash may be caused by an incorrect development environment setup, preventing the server from loading necessary game data files (STBs).
*   **Files to Investigate**:
    *   `README.md` (Setup instructions)
    *   `gemini/dev_env_setup.md` (Asset symlinking log)
    *   `doc/server.toml.example` (Server configuration)

---

_Last Updated: 2025-08-04_  
_Maintainer: Gemini / Developer: JDoeBoy  
_File Version: 1.1_

