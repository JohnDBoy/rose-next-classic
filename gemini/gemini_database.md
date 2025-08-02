<!-- 
IMPORTANT: GEMINI CODE ASSIST INSTRUCTION SET
DO NOT MODIFY OR REMOVE THIS SECTION

Gemini, this file documents the database schema. Use it to understand data relationships and to construct correct SQL queries.

1.  **Purpose**: To serve as the reference for database tables, columns, and relationships.
2.  **Instruction Integrity**: Never modify or remove this instruction block.

END OF INSTRUCTION
-->

# Database Schema

This document outlines the PostgreSQL database schema.
**Note:** `database/rose-next.sql` is an outdated MSSQL reference.

## Key Tables

### `account`
Stores user account information and credentials.

| Column         | Type          | Description                                  |
| -------------- | ------------- | -------------------------------------------- |
| `id`           | `integer`     | Unique account ID (PK).                      |
| `email`        | `varchar`     | User's email, used for login.                |
| `password`     | `varchar(64)` | Hashed password.                             |
| `salt`         | `varchar`     | Salt for password hashing.                   |
| `access_level` | `integer`     | Account access level (e.g., GM).             |
| `created`      | `timestamp`   | UTC timestamp of account creation.           |

**Note:** A critical login authentication bug exists related to password hashing. See `gemini/gemini_knownbugs.md`.

### `character`
Stores all data for a player character.

| Column                   | Type        | Description                                      |
| ------------------------ | ----------- | ------------------------------------------------ |
| `id`                     | `integer`   | Unique character ID (PK).                        |
| `account_email`          | `varchar`   | Owner account email.                             |
| `name`                   | `varchar`   | Unique character name.                           |
| `level`                  | `smallint`  | Current level.                                   |
| `exp`                    | `bigint`    | Current experience points.                       |
| `job_id`                 | `smallint`  | Job/class ID.                                    |
| `money`                  | `bigint`    | Carried currency.                                |
| `hp`, `mp`, `stamina`    | `integer`   | Current HP/MP/Stamina.                           |
| `str`, `dex`, `intt`, `con`, `cha`, `sen` | `integer` | Base stats.                            |
| `map_id`                 | `smallint`  | Current map ID.                                  |
| `respawn_x`, `respawn_y` | `float`     | Current world coordinates.                       |
| `skills`, `quests`, `hotbar`, `wishlist` | `json` | JSON data for skills, quests, hotbar, etc. |
| `delete_by`              | `timestamp` | Timestamp for scheduled deletion.                |

### `item`
Stores unique instances of every item in the game world.

| Column         | Type        | Description                                      |
| -------------- | ----------- | ------------------------------------------------ |
| `id`           | `integer`   | Unique item instance ID (PK).                    |
| `uuid`         | `uuid`      | Universally unique item ID.                      |
| `game_data_id` | `integer`   | Static item type ID (from STB files).            |
| `type_id`      | `integer`   | Item type category (e.g., Weapon, Armor).        |
| `grade`, `durability`, etc. | `smallint`/`boolean` | Various item stats and flags. |

### `inventory`
A link table connecting characters to their items.

| Column     | Type      | Description                                      |
| ---------- | --------- | ------------------------------------------------ |
| `owner_id` | `integer` | Owner character ID.                              |
| `slot`     | `integer` | Inventory slot number.                           |
| `quantity` | `integer` | Stack size for stackable items.                  |
| `item_id`  | `integer` | Item instance ID (FK to `item.id`).              |
