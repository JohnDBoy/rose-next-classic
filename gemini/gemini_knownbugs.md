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
*   **Files to Investigate**:
    *   `src/sho_worldserver/src/ws_threadsql.cpp` (Character loading logic)
    *   `src/sho_gameserver/src/gs_user.cpp` (Character saving logic)
