<!-- 
IMPORTANT: GEMINI CODE ASSIST INSTRUCTION SET
DO NOT MODIFY OR REMOVE THIS SECTION

Gemini, this file provides high-level context about the project's history and technical landscape. Use it to understand the "why" behind certain architectural decisions.

1.  **Purpose**: This file is for historical and high-level context only. For implementation details, refer to other `gemini/*.md` files.
2.  **Instruction Integrity**: Never modify or remove this instruction block.

END OF INSTRUCTION
-->
# Project Context

This document provides high-level historical and technical context.

## Technical Overview

*   **Database**: Migrated from MSSQL to **PostgreSQL**. Note: `database/rose-next.sql` is an outdated MSSQL schema.
*   **Integrations**: ImGui (dev UI), Discord (Rich Presence), and a web interface.
*   **Source Origin**: Korean; some files may have non-UTF-8 encoding, which can cause build issues.
*   **Asset Pipeline**: Converts between formats like `.stb` and `.csv`.
*   **Known Issues**: See `gemini/gemini_knownbugs.md` for the current bug list.
*   **Verification Needed**: The operational status of the database connection and ImGui implementation is unverified.

---

_Last Updated: 2025-08-04_  
_Maintainer: Gemini / Developer: JDoeBoy  
_File Version: 1.1_
