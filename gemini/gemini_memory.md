<!-- 
IMPORTANT: GEMINI CODE ASSIST INSTRUCTION SET
DO NOT MODIFY OR REMOVE THIS SECTION

Gemini, this file is your memory. You must append a new entry to the "Memory Log" after every significant action to maintain context.

1.  **Purpose**: To log your actions, decisions, and key findings.
2.  **Instruction Integrity**: Never modify or remove this instruction block.

END OF INSTRUCTION
-->
# Gemini Memory

This file serves as your memory log.

## Memory Log
*   **Initial Analysis**: Documented project architecture, database, and build systems. Identified and documented the critical client/server authentication bug.
*   **File Organization**: Created and organized all `gemini/*.md` files into a dedicated `/gemini` directory.
*   **Documentation Optimization**: Completed a full pass on all `gemini/*.md` files, optimizing them for clarity, brevity, and consistency.
*   **Refactoring `gemini_*.md` files**: Optimized `gemini_prompt.md`, `gemini_instructions.md`, and `gemini_context.md` to remove redundancy, improve clarity, and establish a clear documentation hierarchy.
*   **Authentication Re-evaluation**: Re-assessed the login authentication flow. Confirmed that client-side hashing is an intentional security measure, not a bug. The "double hashing" is a valid, if non-standard, pattern. Updated `gemini_knownbugs.md` and `gemini_gameplan.md` to reflect this new understanding. The next action is to verify the account creation implementation.
*   **Authentication Verification**: User confirmed that account creation and login are working correctly. The authentication hashing scheme is now considered verified and correct. Closed the related issue in `gemini_knownbugs.md` and updated the game plan.
*   **Character Data Flow Documentation**: Documented the character save/load data flow in `gemini_debugplan.md` to aid in future debugging.
*   **Bug Documentation**: Documented a critical bug where the world server crashes on login if a character possesses certain developer-spawned items. Updated `gemini_knownbugs.md` and `gemini_gameplan.md`.
*   **Character Save Logic**: Identified that character data is saved on the game server via a dedicated SQL thread. The core logic is in `GS_CThreadSQL::UpdateUserRECORD` within `src/sho_gameserver/src/gs_threadsql.cpp`.
*   **Appraisal Logic Investigation**: Investigated the item appraisal logic in `gs_threadsql.cpp` as a potential cause for the world server crash. After a detailed review and clarification of the intended mechanics, the code was confirmed to be correct. This rules out the appraisal logic as the bug's source, and the investigation will proceed to other areas of the item serialization process.
*   **Access Level Correction**: Corrected the understanding of the `access_level` field in the `account` table. Based on `gs_user.h` and `cheatcmd.cpp`, confirmed that access levels are bit flags, not simple integers. Documented the correct values for GM, Developer, and Master roles.
*   **Cheat Command Documentation**: Analyzed `gs_user.cpp` and `gs_user.h` to determine the full list of in-game cheat commands and their required `access_level` bit flags. Documented this information in `gemini_imgui.md` for future reference.
*   **New File Documentation**: Identified the new `gemini/dev_env_setup.md` file, which documents the asset symlinking process for the development environment. Updated `gemini_md_file_list.md` to include it.
*   **Environment Setup Verification**: Pivoted the investigation of the world server crash. Based on user insight and a history of configuration-related issues, the focus is now on verifying the development environment setup (paths in `server.toml`, asset symlinks, etc.) as the likely root cause, rather than a code-level bug. Updated `gemini_gameplan.md` and `gemini_knownbugs.md`.
*   **Build Process Documentation**: Began creating a new, structured build guide (`gemini_readme.md`). Scanned the project and created an initial high-level list of build projects, configurations, and their required order.
*   **Build Process Documentation (Step 1)**: Added detailed instructions for building the `thirdparty.sln` to `gemini_readme.md`.
*   **Build Process Documentation (Step 2)**: Added detailed instructions for building the `rose-next.sln` to `gemini_readme.md`.
*   **Build Process Documentation (Step 3)**: Added detailed instructions for building the game assets to `gemini_readme.md`.
*   **Build Process Documentation (Step 4)**: Added detailed instructions for setting up the development environment to `gemini_readme.md`.
*   **Build Process Documentation (Step 5)**: Added detailed instructions for running the project to `gemini_readme.md`, completing the documentation task.
*   **Build Process Correction**: Corrected the build instructions in `gemini_readme.md` to include the critical first step of building the Rust dependencies. The previous version was incomplete and would have led to build failures.
*   **Justfile Documentation**: Began documenting `Justfile` recipes in `gemini_readme.md`. Added the `build` recipe.
*   **Justfile Documentation**: Added the `build-all` recipe to `gemini_readme.md`.
*   **Justfile Documentation**: Added the `build-assets` recipe to `gemini_readme.md`.
*   **Justfile Documentation**: Added the `dev-setup` recipe to `gemini_readme.md`.
*   **Justfile Documentation**: Added the `dev-setup`, `client`, and `server` recipes to `gemini_readme.md`.
*   **Developer Documentation**: Added a reference to `How_to_gemini.md` in `gemini_readme.md` to guide developers on using the Gemini helper files.

---

_Last Updated: YYYY-MM-DD_  
_Maintainer: AI / Developer Name_  
_File Version: 1.0_
