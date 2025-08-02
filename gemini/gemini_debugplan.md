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
*   **Key Files**: `src/client/winMAIN.cpp`, `src/client/CApplication.cpp`, `src/client/System/CGame.cpp`, `src/client/Network/CNetwork.cpp`.

## 3. Debugging Servers
*   **Setup**: Run directly or attach with the VS debugger.
*   **Login Server (`sho_loginserver.exe`)**: Key files: `lsv_threadsql.cpp` (auth), `lsv_client.cpp` (connections).
*   **World Server (`sho_worldserver.exe`)**: Key file: `ws_threadsql.cpp` (character management).
*   **Game Server (`sho_gameserver.exe`)**: Key files: `network.cpp` (gameplay), `gs_user.cpp` (player state), `gs_threadzone.cpp` (zone loop).
