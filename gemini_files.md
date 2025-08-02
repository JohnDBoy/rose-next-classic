<!-- 
⚠️ **IMPORTANT NOTICE — DO NOT MODIFY THIS SECTION** ⚠️
**Be thorough. Be accurate. Think through every process carefully. Mistakes must be avoided at all costs.**
This section is **critical** for proper function and reference. **Never change, move, or delete this section.**  
Any edits here may cause significant errors or loss of data integrity.
**END OF NOTICE**
-->
## Gemini Files of Interest

This file contains a curated list of important files in the `rose-next-classic` project, along with their purpose and relevance.

### Build & Distribution Scripts

*   **`scripts/build.ps1`**: The main build script for the entire project. It uses `vswhere.exe` to locate Visual Studio and orchestrates `MSBuild` for C++ and `cargo` for Rust components. This is the primary entry point for compiling the source code.
*   **`scripts/dist.ps1`**: Handles the collection of compiled binaries and assets into a distributable `dist/` folder. It differentiates between client, server, tools, and database assets.
*   **`scripts/dist-assets.ps1`**: Manages the processing of game assets. It calls the `pipeline.exe` tool to "bake" (process) and "pack" (archive) assets for client distribution. It also copies necessary raw assets for the server.
 
### Core Project & Configuration

*   **`rose-next.sln`**: The main Visual Studio solution file that contains all C++ projects.
*   **`src/client/client.vcxproj`**: The Visual Studio project file for the game client (`rosenext.exe`). It defines all source files, include paths, and library dependencies (`ntdll.lib`, `common.lib`, etc.) required to build the client.
*   **`README.md`**: Provides a high-level overview of the project, setup instructions, build requirements (Rust, VS2019, PostgreSQL), and basic operational commands.
*   **`doc/server.toml.example`**: An example configuration file for all servers. Defines database connection details, IP/ports, log levels, and data directories.

### World Server (`sho_worldserver`)

*   **`src/sho_worldserver/src/sho_ws_lib.cpp`**: The main library initialization file for the world server. It's responsible for loading essential STB (Simple Table) data files like `INIT_AVATAR.STB`, `LIST_SKILL.STB`, etc.
*   **`src/sho_worldserver/src/ws_threadsql.cpp`**: A critical file that handles all database-related operations for the world server in a separate thread. This includes character creation, selection, deletion, and mail/memo handling.
*   **`src/sho_worldserver/src/ws_threadsql.h`**: The header file for `ws_threadsql.cpp`, defining the `CWS_ThreadSQL` class and related data structures.

### Login Server (`sho_loginserver`)

*   **`src/sho_loginserver/src/main.cpp`**: The main entry point for the `sho_loginserver.exe` application. It initializes the core server object (`SHO_LSV`) and starts the server's main loop.
*   **`src/sho_loginserver/src/sho_lsv_lib.cpp`**: The central library for the login server. It's responsible for initializing server sockets, loading configuration from `server.toml`, and managing the lists of connected clients and world servers.
*   **`src/sho_loginserver/src/lsv_client.cpp`**: Defines the `CLS_Client` class, which represents a single game client connection. This file contains the logic for handling incoming packets from clients, most importantly the login request (`CLI_LOGIN_REQ`).
*   **`src/sho_loginserver/src/lsv_server.cpp`**: Defines the `CLS_Server` class, which represents a single world server connection. It handles world server registration, status updates (e.g., user count), and provides the list of available worlds to authenticated clients.
*   **`src/sho_loginserver/src/lsv_threadsql.cpp`**: Manages all database interactions for the login server, primarily user authentication. It receives login requests from the main thread, validates credentials against the `account` table in a separate thread, and returns the result.

### Game Server (`sho_gameserver`)

*   **`src/sho_gameserver/src/main.cpp`**: The main entry point for the `sho_gameserver.exe` application.
*   **`src/sho_gameserver/src/lib_gsmain.cpp`**: The core library for the game server. It initializes the server, loads all necessary zone data, and manages the main game loop via `gs_threadzone`.
*   **`src/sho_gameserver/src/gs_user.cpp`**: Defines the `CGS_User` class, which represents a single player in the game world. This is a critical file that manages a player's state, including their character data, inventory, position, and network connection.
*   **`src/sho_gameserver/src/network.cpp`**: Contains the primary packet handling logic for gameplay. It processes incoming requests from clients for actions like movement, combat, skill usage, and interaction with NPCs and objects.
*   **`src/sho_gameserver/src/gs_threadzone.cpp`**: Implements the main thread for a game zone. This thread runs the core game loop, processing AI for NPCs, character actions, and other real-time world events.
*   **`src/sho_gameserver/src/cgameobj.cpp`**: The base class for all interactive objects within the game world, such as characters, NPCs, and monsters.
*   **`src/sho_gameserver/src/cobjchar.cpp`**: A fundamental class derived from `CGameOBJ`, representing any character-like entity (players, NPCs, monsters). It manages stats, state (alive, dead), and basic actions.
*   **`src/sho_gameserver/src/cobjnpc.cpp`**: Represents a Non-Player Character. It handles NPC-specific logic, such as vendor stores, quests, and dialog interactions.
*   **`src/sho_gameserver/src/common/cobjai.cpp`**: Implements the Artificial Intelligence for NPCs and monsters, controlling their behavior, pathfinding, and combat logic based on AI patterns loaded from `*.aip` files.
*   **`src/sho_gameserver/src/gs_threadsql.cpp`**: Handles all database operations for the game server, primarily focused on periodically saving character data (position, stats, inventory) to prevent data loss.

### Database

*   **`database/migrations/`**: Contains individual SQL migration scripts for evolving the database schema.
*   **`scripts/squash-migrations.ps1`**: A helper script to combine all migration files into a single `rose-next.sql` file for easy database setup.
*   **`database/rose-next.sql`**: The resulting squashed SQL schema file. This is the primary file for setting up a new database from scratch.

### Client (`client`)

*   **`src/client/winMAIN.cpp`**: The main Windows entry point (`WinMain`) for the client application. It creates the main window and initializes the `CApplication` object.
*   **`src/client/CApplication.cpp`**: The core application class. It manages the main message loop, and owns the `CGame` object.
*   **`src/client/System/CGame.cpp`**: The heart of the client. It manages the game's state machine (`CGameState`), the main game loop, and processes frame updates and rendering.
*   **`src/client/System/CGameState.h`**: The base class for all game states. The client operates as a state machine, with states like `CGameStateTitle`, `CGameStateLogin`, `CGameStateSelectAvatar`, and `CGameStateMain` controlling the flow of the application.
*   **`src/client/Network/CNetwork.cpp`**: Handles all client-side network communication. It's responsible for connecting to servers and sending/receiving packets. `RecvPACKET.cpp` contains the logic for processing incoming packets.
*   **`src/client/CObjUSER.cpp`**: Represents the local player's character (`CObjAVT` is the base for all avatars). It's a `CObjCHAR` that is controlled by the player.
*   **`src/client/interface/CUIMediator.cpp`**: Acts as a central hub for managing and mediating interactions between various UI components (dialogs, windows, etc.).
*   **`src/client/interface/it_mgr.cpp`**: The "Interface Manager". It initializes and manages all the UI dialogs defined in the `DLGs` folder.
*   **`src/client/interface/DLGs/`**: This directory contains the source code for all the individual UI windows and dialogs, such as the inventory (`InventoryDLG.cpp`), character info (`CharacterDLG.cpp`), and chat (`ChattingDLG.cpp`).
*   **`src/client/Game_FUNC.cpp` & `src/client/LUA_Func.cpp`**: These files expose C++ functions to the Lua scripting engine, allowing game events and logic to be controlled by Lua scripts. The `scripts/gen_script_interface.lua` script is used to generate the necessary binding code.

#### ImGui (Developer UI)

*   **`src/client/interface/dev/dev_ui.cpp`**: The main entry point for the ImGui developer interface. It handles the initialization (`dev_ui_init`), destruction (`dev_ui_destroy`), and rendering of all ImGui windows.
*   **`src/client/interface/dev/dev_main_window.cpp`**: Implements the main ImGui window which acts as a container or menu for other developer tools.
*   **`src/client/interface/dev/dev_game_window.cpp`**: Provides a developer window with general game information and controls.
*   **`src/client/interface/dev/dev_target_window.cpp`**: Implements an ImGui window to display detailed information about the currently targeted game object.
*   **`src/client/thirdparty/imgui/imgui_imp.cpp`**: Contains the specific rendering implementation that translates ImGui's draw commands into DirectX 9 calls for this project.

### Third-Party Dependencies (`thirdparty/`)

This directory contains external libraries used by the project. They are compiled via `thirdparty.sln`.

*   **`discord-2.5.6/`**: The Discord Game SDK, used for rich presence integration with the Discord client.
*   **`expat-2.0.1/`**: A stream-oriented XML parser library.
*   **`flatbuffers-1.11.0/`**: An efficient cross-platform serialization library from Google. Used for network packets (see `src/common-lib/packets/`).
*   **`fmt-6.2.1/`**: A modern formatting library providing a fast and safe alternative to C-style printf.
*   **`imgui-1.77/`**: Dear ImGui, a bloat-free graphical user interface library used for creating the in-game development and debugging tools.
*   **`json-3.7.3/`**: JSON for Modern C++, used for handling JSON data, likely for configuration or data files.
*   **`libogg-1.1.3/` & `libvorbis-1.2.0/`**: Libraries for Ogg Vorbis, a free and open audio compression format. Used for game audio.
*   **`lua-4.0.1/`**: A lightweight, embeddable scripting language. Used for game logic, quests, and events (see `scripts/gen_script_interface.lua`).
*   **`libpq/`**: The official C client library for PostgreSQL. This is a critical dependency for the servers to communicate with the game database.
*   **`nvtristrip/`**: NVIDIA's triangle stripping library. Likely used by the asset pipeline to optimize 3D models for rendering.
*   **`zlib-1.2.3/`**: A general-purpose data compression library.
*   **`directx9/`**: Microsoft DirectX 9 SDK components, used as the primary graphics rendering API for the client.

### Asset Pipeline

*   **`src/pipeline/`**: The source code for the `pipeline.exe` tool. This tool is responsible for processing game assets.
*   **`assets/bake.manifest`**: A manifest file that defines the rules for the "bake" step. It likely specifies which source files to process and what operations to perform on them (e.g., texture compression, model optimization).
*   **`assets/pack.manifest`**: A manifest file that defines the rules for the "pack" step. It likely specifies how to group the "baked" assets into VFS archives for the final client distribution.
*   **`bin/<config>/pipeline.exe`**: The compiled executable for the asset pipeline tool. It is called by `dist-assets.ps1` to perform the bake and pack operations.
