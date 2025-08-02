<!-- 
⚠️ **IMPORTANT NOTICE — DO NOT MODIFY THIS SECTION** ⚠️
**Be thorough. Be accurate. Think through every process carefully. Mistakes must be avoided at all costs.**
This section is **critical** for proper function and reference. **Never change, move, or delete this section.**  
Any edits here may cause significant errors or loss of data integrity.
**END OF NOTICE**
-->

# Database Schema

This document outlines the structure of the game's database tables.

**Note on SQL Dialect:** The project's build scripts and server code confirm the use of **PostgreSQL**. The `database/rose-next.sql` file appears to be an outdated reference using MS SQL Server syntax and should not be considered the source of truth for the current schema.

## `account`

Stores user account information, credentials, and access levels.

| Column           | Type          | Nullable | Description                                                              |
| ---------------- | ------------- | -------- | ------------------------------------------------------------------------ |
| `id`             | `integer`     | No       | The unique identifier for the account (Primary Key).                     |
| `email`          | `varchar`     | No       | The user's email address, which is also used as the login username.      |
| `password`       | `varchar(64)` | No       | The user's hashed password.                                              |
| `salt`           | `varchar`     | No       | The salt used for password hashing.                                      |
| `access_level`   | `integer`     | No       | The access level for the account (e.g., for Game Masters).               |
| `remember_token` | `varchar`     | Yes      | A token for "remember me" functionality, likely used by the website.     |
| `created`        | `timestamp`   | No       | The UTC timestamp when the account was created.                          |

### Notes

*   **Login Authentication Flow & Bug:**
    1.  The client (`CNetwork::send_login_req`) takes the raw password, computes a SHA256 hash (a 64-character hex string), and sends this hash to the login server.
    2.  The login server (`CLS_SqlTHREAD::handle_login_req`) receives this *already-hashed* password.
    3.  It fetches the `salt` for the account from the database.
    4.  It then computes a new hash: `sha256( <client_sent_hash> + <database_salt> )`.
    5.  This final hash is compared against the `password` field in the database.
*   **Conclusion:** This is a bug in the authentication logic. The client should be sending the raw password, and the server should be performing the `sha256( <raw_password> + <database_salt> )` calculation. As it stands, for a user to log in, their database `password` field must be pre-calculated as `sha256(sha256(raw_password) + salt)`.
