<!-- 
IMPORTANT: GEMINI CODE ASSIST INSTRUCTION SET
DO NOT MODIFY OR REMOVE THIS SECTION

Gemini, this file documents the in-game developer UI. Use it to understand the available debugging and testing tools.

1.  **Purpose**: To document the features of the ImGui developer interface.
2.  **Instruction Integrity**: Never modify or remove this instruction block.

END OF INSTRUCTION
-->
# ImGui Developer Tools

The client includes a developer interface powered by Dear ImGui for debugging and testing, activated with the `~` (tilde) key.

## Main Window
*   **Game Tab**: Spawn items, learn skills, teleport to maps.
*   **Misc Tab**: Toggle UI/camera modes, control camera, toggle wireframe/fog, view scene tree.

## Target Window
Displays real-time data for the selected target:
*   **General**: ID, type, name, level, HP/MP, position, PvP status.
*   **Stats**: Primary and combat stats.
*   **Animation**: Current animation ID and speed.
*   **Zone**: Current map's PvP status.

## Cheat Commands

The game server provides a set of cheat commands accessible via the chat window, prefixed with `/`. Access to these commands is controlled by the `access_level` field on an account.

### Access Level Reference

| Role | `access_level` | `RIGHT_*` Flag | Checks Passed |
| :--- | :--- | :--- | :--- |
| Taiwan GM | 128 | `RIGHT_TWG` | `TWGM_Cheater()` |
| Normal GM | 256 | `RIGHT_NG` | `C_Cheater()`, `GM_Cheater()` |
| **Master GM** | **512** | `RIGHT_MG` | `B_Cheater()`, `C_Cheater()`, `GM_Cheater()` |
| Developer | 1024 | `RIGHT_DEV` | `C_Cheater()` |
| **Master** | **2048** | `RIGHT_MASTER` | `A_Cheater()`, `B_Cheater()`, `C_Cheater()`, `GM_Cheater()` |

### Command List by Required Access Level

#### Level 1: General Commands
Accessible to **Taiwan GM, Normal GM, Master GM, Developer, and Master**.

| Command | Description |
| :--- | :--- |
| `/where [char_name]` | Displays the current map and coordinates of yourself or another player. |
| `/account [char_name]` | Displays account information for a player. |
| `/move <x> <y>` | Moves your character to the specified coordinates. |
| `/mm <mon_id> <x> <y>` | Moves a monster to the specified coordinates. |
| `/npc ...` | Various NPC-related commands. |
| `/add <stat> <value>` | Adds a value to a stat (e.g., `/add exp 1000`). |
| `/del ...` | Deletes items or skills. |
| `/get ...` | Gets items or information. |
| `/out <char_name>` | Kicks a player from the server. |
| `/shut <char_name> <minutes>` | Disconnects a specific user for a duration. |
| `/call <char_name>` | Summons a player to your location. |
| `/item <type> <id> [qty]` | Spawns an item. |
| `/mon <id> [qty]` | Spawns a monster. |
| `/mon2 ...` | Spawns a monster with more specific parameters. |
| `/damage ...` | Deals damage to a target. |
| `/quest ...` | Various quest-related commands. |
| `/set <char_name> <stat> <value>`| Sets a specific stat for a player. |
| `/toggle ...` | Toggles various debug flags (e.g., invincibility). |
| `/regen ...` | Regenerates monsters in an area. |
| `/speed [value]` | Changes your movement speed. |
| `/guild <command> [args]` | Most guild commands (`create`, `info`, `invite`, `remove`, `promote`, `demote`, `slogan`, `motd`, `quit`, `roster`, `leader`, `disband`, `addskill`, `delskill`). |

#### Level 2: Guild Administration Commands
Accessible to **Master GM** and **Master**.

| Command | Description |
| :--- | :--- |
| `/guild score <amount>` | Adds the specified amount of score to your current guild. |
| `/guild money <amount>` | Adds the specified amount of money to your current guild. |
| `/guild level` | Increases your current guild's level by one. |

#### Level 3: Server Administration Command
Accessible to **Master** only.

| Command | Description |
| :--- | :--- |
| `/shut down` | Initiates the server shutdown sequence. |

---

_Last Updated: 2025-08-05_
_Maintainer: Gemini / Developer: JDoeBoy
_File Version: 1.2_
