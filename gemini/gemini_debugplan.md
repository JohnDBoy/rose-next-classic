<!-- 
⚠️ **IMPORTANT NOTICE — DO NOT MODIFY THIS SECTION** ⚠️
**Be thorough. Be accurate. Think through every process carefully. Mistakes must be avoided at all costs.**
This section is **critical** for proper function and reference. **Never change, move, or delete this section.**  
Any edits here may cause significant errors or loss of data integrity.
**END OF NOTICE**
-->
# Debugging Plan

This document outlines the strategies and tools for debugging the `rose-next-classic` project.

## 1. General Tools
*   **Visual Studio Debugger:** The primary tool for debugging all C++ components.
*   **ImGui Developer UI:** In-game interface for real-time inspection and manipulation. Activated with the `~` key. See `gemini/gemini_imgui.md` for details.
*   **Logging:** Server and client logs provide crucial information. Log levels can be configured in `server.toml`.

## 2. Debugging The Client (`rosenext.exe`)
*   **Setup:** Set `client` as the startup project in Visual Studio.
*   **Common Issues:** Graphics glitches, crashes on startup, network connection failures.
*   **Key Files:** `src/client/winMAIN.cpp`, `src/client/CApplication.cpp`, `src/client/System/CGame.cpp`, `src/client/Network/CNetwork.cpp`.

## 3. Debugging Servers
*   **Setup:** Servers can be run directly or attached to with the VS debugger.
*   **Login Server (`sho_loginserver.exe`):** Focus on authentication logic (`lsv_threadsql.cpp`) and client connection handling (`lsv_client.cpp`).
*   **World Server (`sho_worldserver.exe`):** Focus on character management (`ws_threadsql.cpp`).
*   **Game Server (`sho_gameserver.exe`):** Focus on gameplay logic (`network.cpp`), player state (`gs_user.cpp`), and the main zone loop (`gs_threadzone.cpp`).
