<!-- 
⚠️ **IMPORTANT NOTICE — DO NOT MODIFY THIS SECTION** ⚠️

**Be thorough. Be accurate. Think through every process carefully. Mistakes must be avoided at all costs.**

This section is **critical** for proper function and reference. **Never change, move, or delete this section.**  
Any edits here may cause significant errors or loss of data integrity.

**END OF NOTICE**
-->
# Sections withing the overall project

### Main Projects for Rose-Next-Classic (`rose-next.sln`)

1. **website**  
   This directory contains the project files for the supporting website. Information can be found in `website\README.md`.
2. **tgamectrl**  
   `src\tgamectrl\tgamectrl.vcxproj`
3. **engine**  
   This is the ZnZin game engine `src\engine\engine.vcxproj`
4. **triggervfs**  
   This handles the virtual file system project for game assets `src\triggervfs\triggervfs.vcxproj`
5. **client**  
   This is the game client project`src\client\client.vcxproj`
6. **lib_util**
   A utility library containing helper functions and classes. `src\lib_util\lib_util.vcxproj`
7. **common**
   Code and data structures shared between the client and all servers. `src\common\common.vcxproj`
8. **common-server**
   Code and data structures shared only between the server executables. `src\common-server\common-server.vcxproj`
9. **sho_loginserver**
    The login server, responsible for user authentication and providing the world list. `src/sho_loginserver/sho_loginserver.vcxproj`
10. **sho_worldserver**
    The world server, which manages character selection, creation, and the list of game channels. `src/sho_worldserver/sho_worldserver.vcxproj`
11. **sho_gameserver**
    The game/zone server, where the actual gameplay takes place. `src/sho_gameserver/sho_gameserver.vcxproj`

### Third-Party Projects (`thirdparty.sln`)

12. **lua5, luac5, lualib5**
    Lua 5.x scripting language library, compiler, and standard libraries. Not currently used by the main project.
13. **nvtristrip**
    NVIDIA's library for optimizing triangle meshes. `thirdparty\nvtristrip.vcxproj`
14. **ogg, vorbis, vorbisfile**
    Libraries for Ogg Vorbis audio format. `thirdparty\ogg.vcxproj`, `thirdparty\vorbis.vcxproj`, `thirdparty\vorbisfile.vcxproj`
15. **lualib4, lua4, luac4**
    Lua 4.0.1 scripting language library, executable, and compiler. This is the version used by the client for game scripting. `thirdparty\lualib4.vcxproj`, `thirdparty\lua4.vcxproj`, `thirdparty\luac4.vcxproj`
16. **expat**
    A stream-oriented XML parser library. `thirdparty\expat.vcxproj`
17. **zlib**
    A general-purpose data compression library. `thirdparty\zlib.vcxproj`
18. **flatc**
    The compiler for FlatBuffers, used to generate C++ headers from `.fbs` schema files. `thirdparty\flatc.vcxproj`
19. **libpgport, libpq, libpqcommon**
    The PostgreSQL client libraries, essential for server-database communication. `thirdparty\libpgport.vcxproj`, `thirdparty\libpq.vcxproj`, `thirdparty\libpqcommon.vcxproj`
20. **fmt**
    A modern C++ formatting library. `thirdparty\fmt.vcxproj`
