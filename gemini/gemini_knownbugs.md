<!-- 
⚠️ **IMPORTANT NOTICE — DO NOT MODIFY THIS SECTION** ⚠️
**Be thorough. Be accurate. Think through every process carefully. Mistakes must be avoided at all costs.**
This section is **critical** for proper function and reference. **Never change, move, or delete this section.**  
Any edits here may cause significant errors or loss of data integrity.
**END OF NOTICE**
-->
# Known Bugs

This document tracks known bugs within the `rose-next-classic` project. Each bug entry should include a title, a detailed description of the issue, the affected files, and a proposed resolution if known.

---

## 1. Client/Server Double Hashing on Login

*   **Status:** Confirmed
*   **Severity:** Critical
*   **Description:** The client/server authentication flow has a logical flaw where the user's password gets hashed twice.
    1.  The client (`CNetwork::send_login_req`) takes the raw password, computes a SHA256 hash, and sends this hash to the login server.
    2.  The login server (`lsv_threadsql.cpp`) receives this *already-hashed* password.
    3.  It fetches the `salt` for the account from the database.
    4.  It then computes a new hash: `sha256( <client_sent_hash> + <database_salt> )`.
    5.  This final hash is compared against the `password` field in the database.
*   **Impact:** For a user to log in, their database `password` field must be pre-calculated as `sha256(sha256(raw_password) + salt)`. The `scripts/generate-password.py` script correctly implements this flawed logic, but the logic itself is incorrect.
*   **Proposed Fix:** The client should send the raw password. The server-side logic, which correctly calculates `sha256(raw_password + salt)`, will then work as intended. The fix involves removing the hashing step from `CNetwork::send_login_req` in `src/client/Network/CNetwork.cpp`.
