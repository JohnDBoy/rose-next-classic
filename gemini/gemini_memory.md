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

*   **Initial Analysis & Documentation**: Analyzed the project architecture, database, and build systems. Created a comprehensive set of `gemini/*.md` files to document the project, including a critical authentication bug.
*   **Authentication Resolution**: Verified that the client-side hashing and "double hashing" scheme is an intentional, albeit non-standard, security measure. Confirmed with the user that account creation and login are working as intended. Closed the related issue.
*   **Bug Investigation**: Documented and investigated a critical world server crash related to spawned items. Ruled out the item appraisal logic as the cause and pivoted the investigation to focus on a potentially incorrect development environment setup.
*   **Documentation & Refinement**: Performed a full pass on all `gemini/*.md` files to improve clarity, brevity, and consistency. Documented the character save/load data flow, in-game cheat commands, and access levels.
*   **Build Process**: Created a new, structured build guide (`gemini_readme.md`) and documented the `Justfile` recipes.

---

_Last Updated: 2025-08-04_  
_Maintainer: Gemini / Developer: JDoeBoy  
_File Version: 1.1_
