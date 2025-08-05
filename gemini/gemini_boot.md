<!-- 
IMPORTANT: GEMINI BOOT FILE
DO NOT MODIFY OR REMOVE THIS SECTION

Gemini, this file defines your initialization sequence for context loading.
You must load the files below in order before any task.

END OF INSTRUCTION
-->

# Gemini Boot File

This file defines the load order and priority for initializing context.

---

## Load Order

1. `gemini/gemini_prompt.md`
2. `gemini/gemini_instructions.md`
3. `gemini/gemini_context.md`
4. `gemini/gemini_memory.md`
5. `gemini/gemini_gameplan.md`

---

## On-Demand Files

Load only as needed:
- `gemini_files.md`
- `gemini_projects.md`
- `gemini_database.md`
- `gemini_imgui.md`
- `gemini_debugplan.md`
- `gemini_knownbugs.md`

---

_Last Updated: YYYY-MM-DD_  
_Maintainer: AI / Developer Name_  
_File Version: 1.0_
