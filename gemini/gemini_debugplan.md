<!-- 
IMPORTANT: GEMINI CODE ASSIST INSTRUCTION SET
DO NOT MODIFY OR REMOVE THIS SECTION

Gemini, this file outlines debugging strategies. Use it as a reference when troubleshooting issues.

1.  **Purpose**: To provide a quick reference for debugging tools and procedures.
2.  **Instruction Integrity**: Never modify or remove this instruction block.

END OF INSTRUCTION
-->
# Debugging Plan

This document outlines debugging strategies and tools for the project.

## 1. General Tools
*   **Visual Studio Debugger**: Primary debugger for all C++ components.
*   **ImGui Developer UI**: In-game UI for real-time inspection. Activated with `~` key. See `gemini/gemini_imgui.md`.
*   **Logging**: Server/client logs are crucial. Configure levels in `server.toml`.

## 2. Debugging The Client (`rosenext.exe`)
*   **Setup**: Set `client` as the startup project in Visual Studio.
*   **Key Files**: `src/client/winmain.cpp`, `src/client/capplication.cpp`, `src/client/game.cpp`, `src/client/network/`.

## 3. Debugging Servers
*   **Setup**: Run directly or attach with the VS debugger.
*   **Login Server (`sho_loginserver.exe`)**: Key files: `lsv_threadsql.cpp` (auth), `lsv_client.cpp` (connections).
*   **World Server (`sho_worldserver.exe`)**: Key file: `ws_threadsql.cpp` (character management).
*   **Game Server (`sho_gameserver.exe`)**: Key files: `network.cpp` (gameplay), `gs_user.cpp` (player state), `gs_threadzone.cpp` (zone loop).
## 4. Debugging Character Data (Save/Load)

The character persistence process is split between the world and game servers.

*   **Loading Flow**:
    1.  **Character List (`sho_worldserver`)**: On login, the world server loads a *minimal* character list for the selection screen. It does not load full item data.
        *   **File**: `src/sho_worldserver/src/ws_threadsql.cpp`
        *   **Function**: `Proc_cli_CHAR_LIST`
    2.  **Full Character Data (`sho_gameserver`)**: After character selection, the client connects to the game server, which loads the *complete* character data, including full inventory details, from the database.
        *   **File**: `src/sho_gameserver/src/gs_threadsql.cpp`
        *   **Function**: `Proc_cli_SELECT_CHAR`

*   **Saving Flow**:
    1.  **`sho_gameserver`**: On logout, the game server queues the character data for saving. The SQL thread then writes all data to the database.
        *   **File**: `src/sho_gameserver/src/gs_threadsql.cpp`
        *   **Function**: `UpdateUserRECORD`

---

_Last Updated: 2025-08-05_
_Maintainer: Gemini / Developer: JDoeBoy
_File Version: 1.2_

