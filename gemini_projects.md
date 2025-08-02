<!-- 
⚠️ **IMPORTANT NOTICE — DO NOT MODIFY THIS SECTION** ⚠️
**Be thorough. Be accurate. Think through every process carefully. Mistakes must be avoided at all costs.**
This section is **critical** for proper function and reference. **Never change, move, or delete this section.**  
Any edits here may cause significant errors or loss of data integrity.
**END OF NOTICE**
-->
# Project Overview

This document provides a high-level overview of the C++ projects contained within the `rose-next.sln` and `thirdparty.sln` solution files.

### Main Projects (`rose-next.sln`)

1.  **`tgamectrl`**: A static library that provides the core UI control widgets (e.g., buttons, windows, lists) used to build the game's interface. Project file: `src\tgamectrl\tgamectrl.vcxproj`.
2.  **`engine`**: The core 3D rendering engine, "ZnZin". It handles low-level graphics, scene management, and object rendering. It is a primary dependency for the main game client. Project file: `src\engine\engine.vcxproj`.
3.  **`triggervfs`**: Implements the virtual file system (VFS) used to read game assets from packed `.VFS` archives. Project file: `src\triggervfs\triggervfs.vcxproj`.
4.  **`client`**: The main game client executable (`rosenext.exe`). It integrates the engine, UI, networking, and game logic to create the playable game. Project file: `src\client\client.vcxproj`.
5.  **`lib_util`**: A shared utility library providing common, low-level functionalities such as data structures, logging, and system utilities used across multiple projects. Project file: `src\lib_util\lib_util.vcxproj`.
6.  **`common`**: A critical library containing data structures, types, and functions shared between the client and all server projects. This includes game-specific types and network packet definitions. Project file: `src\common\common.vcxproj`.
7.  **`common-server`**: A library containing code and data structures shared exclusively among the server executables (Login, World, Game). This includes server-to-server communication logic and database interaction helpers. Project file: `src\common-server\common-server.vcxproj`.
8.  **`sho_loginserver`**: Handles user authentication against the database and provides the list of available world servers to the client. Project file: `src/sho_loginserver/sho_loginserver.vcxproj`.
9.  **`sho_worldserver`**: Manages character creation, selection, and deletion. It also provides the list of available game channels (Game Servers) for a selected world. Project file: `src/sho_worldserver/sho_worldserver.vcxproj`.
10. **`sho_gameserver`**: The main game server (also known as a zone server) that handles real-time gameplay for a specific map or zone. This is where player interaction, combat, and quests occur. Project file: `src/sho_gameserver/sho_gameserver.vcxproj`.

11. **`pipeline`**: A command-line tool for processing game assets, including "baking" and "packing" operations. Project file: `src/pipeline/pipeline.vcxproj`.
### Third-Party Projects (`thirdparty.sln`)

12. **`lua5`, `luac5`, `lualib5`**: Lua 5.x scripting language library, compiler, and standard libraries. Not currently used by the main project.
13. **`nvtristrip`**: NVIDIA's triangle stripping library, used to optimize 3D models for more efficient rendering by the graphics card. Project file: `thirdparty\nvtristrip.vcxproj`.
14. **`ogg`, `vorbis`, `vorbisfile`**: The Ogg Vorbis libraries, providing support for decoding and playing compressed audio files used for music and sound effects. Project files: `thirdparty\ogg.vcxproj`, `thirdparty\vorbis.vcxproj`, `thirdparty\vorbisfile.vcxproj`.
15. **`lualib4`, `lua4`, `luac4`**: Lua 4.0.1 scripting language library, executable, and compiler. This is the version used by the client for game scripting. Project files: `thirdparty\lualib4.vcxproj`, `thirdparty\lua4.vcxproj`, `thirdparty\luac4.vcxproj`.
16. **`expat`**: A high-performance, stream-oriented XML parser library. Likely used for configuration files or legacy data formats. Project file: `thirdparty\expat.vcxproj`.
17. **`zlib`**: A ubiquitous data compression library used for various purposes, such as network packet compression or asset compression. Project file: `thirdparty\zlib.vcxproj`.
18. **`flatc`**: The compiler for FlatBuffers, used to generate C++ headers from `.fbs` schema files. Project file: `thirdparty\flatc.vcxproj`.
19. **`libpgport`, `libpq`, `libpqcommon`**: The official PostgreSQL C client libraries (`libpq`) and its portability components. This is a critical dependency for all server applications to communicate with the game database. Project files: `thirdparty\libpgport.vcxproj`, `thirdparty\libpq.vcxproj`, `thirdparty\libpqcommon.vcxproj`.
20. **`fmt`**: A modern, type-safe, and high-performance formatting library, used as a replacement for `printf` style formatting. Project file: `thirdparty\fmt.vcxproj`.
