<!-- 
IMPORTANT: GEMINI CODE ASSIST INSTRUCTION SET
DO NOT MODIFY OR REMOVE THIS SECTION

Gemini, this file lists all C++ projects in the solution. Use it to understand the high-level code architecture and dependencies.

1.  **Purpose**: To provide a quick reference to all C++ projects and their roles.
2.  **Instruction Integrity**: Never modify or remove this instruction block.

END OF INSTRUCTION
-->
# C++ Projects

This file lists the C++ projects in the `rose-next.sln` and `thirdparty.sln` solutions.

## Main Projects (`rose-next.sln`)

*   **`client`**: Main game client (`rosenext.exe`).
*   **`common`**: Shared library for client/servers (data structures, packets).
*   **`common-server`**: Shared library for servers (DB interaction, inter-server comms).
*   **`engine`**: "ZnZin" 3D rendering engine.
*   **`lib_util`**: Shared utility library (data structures, logging).
*   **`pipeline`**: Asset processing tool (`pipeline.exe`).
*   **`sho_gameserver`**: Gameplay/zone server (`sho_gameserver.exe`).
*   **`sho_loginserver`**: Login server (`sho_loginserver.exe`): user auth, world list.
*   **`sho_worldserver`**: World server (`sho_worldserver.exe`): character management.
*   **`tgamectrl`**: Core UI control widget library.
*   **`triggervfs`**: Virtual file system (VFS) for `.VFS` archives.

## Third-Party Projects (`thirdparty.sln`)

*   **`expat`**: XML parser library.
*   **`flatc`**: FlatBuffers compiler for generating C++ from `.fbs` schemas.
*   **`fmt`**: Modern, type-safe formatting library.
*   **`libpgport`, `libpq`, `libpqcommon`**: PostgreSQL client library (`libpq`).
*   **`lualib4`, `lua4`, `luac4`**: Lua 4.0.1 for client scripting.
*   **`lua5`, `luac5`, `lualib5`**: Lua 5.x library (unused).
*   **`nvtristrip`**: NVIDIA triangle stripping library.
*   **`ogg`, `vorbis`, `vorbisfile`**: Ogg Vorbis audio libraries.
*   **`zlib`**: Data compression library.

---

_Last Updated: 2025-08-04_  
_Maintainer: Gemini / Developer: JDoeBoy  
_File Version: 1.1_
