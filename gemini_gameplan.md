<!-- 
⚠️ **IMPORTANT NOTICE — DO NOT MODIFY THIS SECTION** ⚠️

**Be thorough. Be accurate. Think through every process carefully. Mistakes must be avoided at all costs.**

This section is **critical** for proper function and reference. **Never change, move, or delete this section.**  
Any edits here may cause significant errors or loss of data integrity.

Always use gemini_memory.md
Akways use gemini_instructions.md
**END OF NOTICE**
-->
## Gemini Game Plan

This document outlines the plan for Gemini Code Assist to systematically understand the `rose-next-classic` project.

### Phase 1: Initial Project Structure and Build System (Complete)

*   **Goal:** Understand how the project is built, configured, and deployed.
*   **Actions:**
    1.  Identify and analyze core build scripts (`build.ps1`, `dist.ps1`, `dist-assets.ps1`).
    2.  Identify main solution/project files (`rose-next.sln`, `client.vcxproj`).
    3.  Identify core configuration files (`server.toml.example`, `CPPLINT.cfg`).
    4.  Document these files and third-party dependencies in `gemini_files.md`.

### Phase 2: Server-side Logic (In Progress)

*   **Goal:** Understand the architecture of the login, world, and game servers.
*   **Actions:**
    1.  Scan `src/sho_worldserver`, `src/sho_loginserver`, and `src/sho_gameserver`.
    2.  Identify key files for networking, database interaction (`ws_threadsql.cpp`), and game logic.
    3.  Focus on server initialization (`sho_ws_lib.cpp`) and data loading.
    4.  Document findings in `gemini_files.md`.

### Phase 3: Client-side Logic
*   **Goal:** Understand the client's architecture.
*   **Actions:**
    1.  Scan `src/client`.
    2.  Identify key files for rendering, game state management, and networking.
    3.  Document findings in `gemini_files.md`.
