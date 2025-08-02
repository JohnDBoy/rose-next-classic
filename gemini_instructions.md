<!-- 
IMPORTANT: GEMINI CODE ASSIST INSTRUCTION SET
DO NOT MODIFY OR REMOVE THIS SECTION

Gemini, follow these instructions carefully and precisely. Accuracy and consistency are essential. Mistakes must be avoided at all costs.

Your task is to use this `gemini_instructions.md` file as the central reference point for interacting with all `gemini_*.md` helper files.

You must:

1. **Understand and Respect File Roles**  
   Each `gemini_*.md` file has a defined and specific purpose. Refer to the file overview below for clarity. You must not change the purpose or structure of these files.

2. **Use These Files for Contextual Memory and Guidance**  
   - Use `gemini_memory.md` for tracking and recalling short-term and long-term memory relevant to Rose-Next-Classic.
   - Use `gemini_gameplan.md` to manage task progress and development priorities.
   - Use `gemini_projects.md`, `gemini_files.md`, `gemini_imgui.md`, and `gemini_database.md` for technical reference, implementation details, and project structure.

3. **Refinement Objective**  
   You are to **refine and maintain this `gemini_instructions.md` file** so that it accurately and professionally documents the roles of all current and future `gemini_*.md` files. It should serve as the single source of truth for the project's metadata structure.

4. **Preserve Instruction Integrity**  
   Never modify or remove this instruction block. This section governs your behavior and interaction with project metadata.

END OF INSTRUCTION
-->
# Gemini Helper File Overview

This project uses a set of `gemini_*.md` files to maintain state, plan tasks, and document the codebase. Adherence to the purpose of each file is critical for an organized workflow.

-   **`gemini_instructions.md` (This file):** The master instruction set. It defines the roles of all other `gemini_*.md` files and outlines the development workflow.
-   **`gemini_memory.md`:** Your short-term and long-term memory. It records the last action performed, the files scanned, and the immediate next objective. This ensures continuity between interactions.
-   **`gemini_gameplan.md`:** The high-level project plan. It outlines the major phases of the project, tracks their completion status, and defines the current development phase and its goals.
-   **`gemini_projects.md`:** A comprehensive list of all C++ projects within the `rose-next.sln` and `thirdparty.sln` solutions, including their purpose and project file paths.
-   **`gemini_files.md`:** A curated database of important files in the repository. It documents build scripts, configuration files, and the key source files for each major component (client, servers, etc.).
-   **`gemini_imgui.md`:** Specific documentation for the ImGui developer interface, including how to access it and a summary of its features.
-   **`gemini_database.md`:** Documentation related to the database schema, tables, and relationships. *(Currently a placeholder for future work)*.

# Development Workflow

The initial analysis phase is complete. The current focus is on code refinement, debugging, and feature implementation. Follow this workflow for all development tasks:

1.  **Consult the Game Plan:** Refer to `gemini_gameplan.md` to understand the current task listed under "Phase 2: Code Refinement & Feature Development".
2.  **Leverage Existing Knowledge:** Use the information in `gemini_files.md`, `gemini_projects.md`, and other documentation files to gather context for the task.
3.  **Propose Changes:** Provide all code modifications and new files in the `diff` format. Ensure all file paths are absolute.
4.  **Maintain State:** After every action, update `gemini_memory.md` to reflect the work done.
5.  **Update the Plan:** Upon completion of a task, update `gemini_gameplan.md` to mark it as complete and set up the next task.