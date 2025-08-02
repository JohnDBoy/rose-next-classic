<!-- 
IMPORTANT: GEMINI CODE ASSIST INSTRUCTION SET
DO NOT MODIFY OR REMOVE THIS SECTION

Gemini, follow these instructions carefully and precisely. Accuracy and consistency are essential. Mistakes must be avoided at all costs.

Your task is to use this `gemini_instructions.md` file as the central reference point for interacting with all `gemini_*.md` helper files.

You must:

1.  **Understand and Respect File Roles**
    Each `gemini/gemini_*.md` file has a defined and specific purpose. Refer to the file overview below for clarity. You must not change the purpose or structure of these files.

2. **Use These Files for Contextual Memory and Guidance**  
   - Use `gemini/gemini_memory.md` for tracking and recalling short-term and long-term memory relevant to Rose-Next-Classic.
   - Use `gemini/gemini_gameplan.md` to manage task progress and development priorities.
   - Use `gemini/gemini_projects.md`, `gemini/gemini_files.md`, `gemini/gemini_imgui.md`, and `gemini/gemini_database.md` for technical reference, implementation details, and project structure.

3. **Refinement Objective**  
   You are to **refine and maintain this `gemini/gemini_instructions.md` file** so that it accurately and professionally documents the roles of all current and future `gemini/gemini_*.md` files. It should serve as the single source of truth for the project's metadata structure.

4. **Preserve Instruction Integrity**  
   Never modify or remove this instruction block. This section governs your behavior and interaction with project metadata.

END OF INSTRUCTION
-->
# Gemini Helper File Overview

This project uses a set of `gemini/gemini_*.md` files to maintain state, plan tasks, and document the codebase. Adherence to the purpose of each file is critical for an organized workflow.

*   **`gemini/gemini_context.md`**: A summary of the project's development history, technical migrations, and other high-level context.
*   **`gemini/gemini_database.md`**: Documentation related to the database schema, tables, and relationships.
*   **`gemini/gemini_debugplan.md`**: Outlines strategies and tools for debugging various components of the project.
*   **`gemini/gemini_files.md`**: A curated database of important files in the repository.
*   **`gemini/gemini_gameplan.md`**: The high-level project plan, outlining major phases and tracking task completion.
*   **`gemini/gemini_imgui.md`**: Specific documentation for the ImGui developer interface.
*   **`gemini/gemini_instructions.md`**: The master instruction set that defines the roles of all other `gemini_*.md` files.
*   **`gemini/gemini_knownbugs.md`**: A curated list of known bugs, their impact, and proposed solutions.
*   **`gemini/gemini_memory.md`**: Your short-term and long-term memory, tracking actions and objectives.
*   **`gemini/gemini_projects.md`**: A comprehensive list of all C++ projects within the solutions.
*   **`gemini/gemini_prompt.md`**: Contains the master instructions that guide your behavior and interaction with all project metadata files.

# Development Workflow

The initial analysis phase is complete. The current focus is on code refinement, debugging, and feature implementation. Follow this workflow for all development tasks:

1.  **Consult the Game Plan:** Refer to `gemini/gemini_gameplan.md` to understand the current task listed under "Phase 2: Code Refinement & Feature Development".
2.  **Leverage Existing Knowledge:** Use the information in `gemini/gemini_files.md`, `gemini/gemini_projects.md`, and other documentation files to gather context for the task.
3.  **Propose Changes:** Provide all code modifications and new files in the `diff` format. Ensure all file paths are absolute.
4.  **Maintain State:** After every action, update `gemini/gemini_memory.md` to reflect the work done.
5.  **Update the Plan:** Upon completion of a task, update `gemini/gemini_gameplan.md` to mark it as complete and set up the next task.
