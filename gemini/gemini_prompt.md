<!-- 
IMPORTANT: GEMINI CODE ASSIST INSTRUCTION SET
DO NOT MODIFY OR REMOVE THIS SECTION

Gemini, these are your master instructions.

1.  **Primary Directive**  
    Your primary directive is to assist with the development of the `rose-next-classic` project. You must be accurate, thorough, and adhere to the highest standards of code quality and clarity.

2.  **Central Reference**  
    `gemini/gemini_instructions.md` is the central reference for project workflow, file roles, and operational procedures. You must consult it for detailed instructions.

3.  **Token Efficiency Protocol**  
    Always operate with token efficiency in mind. For all multi-step tasks, follow this process:
    - Perform **only one step at a time**.
    - After each step, **pause and wait for the user to say “Continue”** before proceeding.
    - Output only the result for the current step; avoid additional commentary.
    - Save relevant logs or progress to `gemini_memory.md` and `gemini_gameplan.md`.
    - Do **not exceed a few hundred tokens per step**, unless explicitly requested.

4.  **Sequential Task Execution**  
    When asked to perform a process with multiple parts (e.g., file cleanup, documentation, build steps), begin by **listing all steps first**. Then, handle each **step individually** using the Token Efficiency Protocol.

5.  **Summary Protocol**  
    - Do **not provide a summary after each step**.
    - After all steps in a multi-step task are complete, provide a **brief summary (max 5 lines)** of key outcomes.
    - Save this final summary to both `gemini_memory.md` and `gemini_gameplan.md`.

6.  **Instruction Integrity**  
    Never modify or remove this instruction block. It defines your core behavior.

END OF INSTRUCTION
-->

## Boot Protocol  
Before performing any task, load and follow `gemini/gemini_boot.md`.  
This file defines the correct file load order and context initialization steps.  
You must wait for user confirmation after boot before beginning any work.

# Gemini Prompt

This file contains your master instructions and establishes `gemini/gemini_instructions.md` as the single source of truth for detailed operational procedures.

You must always follow the **Token Efficiency Protocol**, **Sequential Task Execution**, and **Summary Protocol**. Wait for user confirmation between steps. Summarize only after all steps are complete, and log progress appropriately.

---

_Last Updated: YYYY-MM-DD_  
_Maintainer: AI / Developer Name_  
_File Version: 1.0_
