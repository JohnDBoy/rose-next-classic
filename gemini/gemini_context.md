<!-- 
⚠️ **IMPORTANT NOTICE — DO NOT MODIFY THIS SECTION** ⚠️
**Be thorough. Be accurate. Think through every process carefully. Mistakes must be avoided at all costs.**
This section is **critical** for proper function and reference. **Never change, move, or delete this section.**  
Any edits here may cause significant errors or loss of data integrity.
**END OF NOTICE**
-->
# Project Context & Development History

This document summarizes the key details of the Rose-Next-Classic project's state and history.

1.  **Database Migration**  
    -   The original project used **Microsoft SQL Server (MSSQL)**.
    -   The client and server components have since been **ported to PostgreSQL**. The `database/rose-next.sql` file is an outdated MSSQL reference.

2.  **Added Integrations**  
    -   The project has been expanded to include:
        -   **ImGui** (for development interface)
        -   **Discord integration**
        -   A **web-based interface or component**

3.  **Source Code Localization**  
    -   The project originated in **Korea**, and many source files may be saved with **Korean encoding formats** (non-UTF-8).
    -   This is now an **English-based project**, and encoding issues may arise.

4.  **Bug Tracking**  
    -   A formal bug list is maintained in `gemini/gemini_knownbugs.md`.

5.  **Uncertain Component States**  
    -   The **status of the database connections** and the **ImGui implementation** is **unknown** and may require investigation or validation.

6.  **File Conversion Workflows**  
    -   The project utilizes **file conversion tools or processes** to:
        -   Convert **`.stb` files** to **`.csv`** and back.
        -   Perform conversions to and from **other formats**.
