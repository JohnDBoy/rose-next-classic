<!-- 
IMPORTANT: GEMINI CODE ASSIST INSTRUCTION SET
DO NOT MODIFY OR REMOVE THIS SECTION

Gemini, this file is a curated list of important files in the repository. Use it as a quick reference to locate key logic.

1.  **Purpose**: To provide a quick reference to important files and their roles.
2.  **Instruction Integrity**: Never modify or remove this instruction block.

END OF INSTRUCTION
-->
## Important Files
This file is a curated list of important files in the `rose-next-classic` project.

### Build & Configuration
*   **`rose-next.sln`**: Main Visual Studio solution for all C++ projects.
*   **`scripts/build.ps1`**: Main build script for C++ and Rust components.
*   **`scripts/dist.ps1`**: Collects compiled binaries and assets into a `dist/` folder.
*   **`doc/server.toml.example`**: Example configuration for all servers (DB, network, logging).

### ImGui (Developer UI)
*   **`src/client/interface/dev/dev_ui.cpp`**: Main entry point for the ImGui interface.
*   **`src/client/interface/dev/dev_target_window.cpp`**: ImGui window for displaying target object details.
*   **`src/client/thirdparty/imgui/imgui_imp.cpp`**: DirectX 9 rendering implementation for ImGui.

### Servers
#### Login Server (`sho_loginserver`)
*   **`src/sho_loginserver/src/lsv_client.cpp`**: Handles client connections and login requests.
*   **`src/sho_loginserver/src/lsv_server.cpp`**: Manages world server connections and status.
*   **`src/sho_loginserver/src/lsv_threadsql.cpp`**: Handles database interactions, primarily user authentication.

#### World Server (`sho_worldserver`)
*   **`src/sho_worldserver/src/ws_threadsql.cpp`**: Handles database operations (character management, mail).
*   **`src/sho_worldserver/src/sho_ws_lib.cpp`**: Main library, loads STB data files.

#### Game Server (`sho_gameserver`)
*   **`src/sho_gameserver/src/gs_user.cpp`**: `CGS_User` class, represents a player in the world.
*   **`src/sho_gameserver/src/network.cpp`**: Core packet handling for gameplay actions.
*   **`src/sho_gameserver/src/gs_threadzone.cpp`**: Main game loop for a zone (AI, events).
*   **`src/sho_gameserver/src/cobjchar.cpp`**: Base class for character-like entities (players, NPCs).
*   **`src/sho_gameserver/src/common/cobjai.cpp`**: AI implementation for NPCs and monsters.

### Client
*   **`src/client/winMAIN.cpp`**: Windows entry point (`WinMain`).
*   **`src/client/System/CGame.cpp`**: Core game logic, state machine, and main loop.
*   **`src/client/Network/CNetwork.cpp`**: Client-side network communication.
*   **`src/client/interface/CUIMediator.cpp`**: Manages interactions between UI components.
*   **`src/client/interface/DLGs/`**: Directory containing source for all UI dialogs.
*   **`src/client/Game_FUNC.cpp` & `src/client/LUA_Func.cpp`**: Expose C++ functions to Lua.

### Database
*   **`database/migrations/`**: Individual SQL migration scripts.
*   **`scripts/squash-migrations.ps1`**: Combines migrations into a single setup file.
*   **`database/rose-next.sql`**: The squashed SQL schema file for new database setup.

### Asset Pipeline
*   **`src/pipeline/`**: Source code for the `pipeline.exe` asset processing tool.
*   **`assets/bake.manifest`**: Defines rules for processing source assets.
*   **`assets/pack.manifest`**: Defines rules for packing baked assets into VFS archives.
