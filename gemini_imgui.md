<!-- 
⚠️ **IMPORTANT NOTICE — DO NOT MODIFY THIS SECTION** ⚠️
**Be thorough. Be accurate. Think through every process carefully. Mistakes must be avoided at all costs.**
This section is **critical** for proper function and reference. **Never change, move, or delete this section.**  
Any edits here may cause significant errors or loss of data integrity.
**END OF NOTICE**
-->
# ImGui Developer Tools Overview

The client includes a developer interface powered by the Dear ImGui library. This interface provides a powerful set of tools for debugging, content creation, and testing.

## How to Access

The developer tools can be toggled on and off by pressing the **tilde (`~`) key**. This key is typically located below the `Esc` key on most keyboards.

## Features

The developer interface is organized into several windows and tabs, each providing specific functionality.

### Main Window

This is the primary window that appears when the tools are activated.

*   **Game Tab**: Contains tools for spawning items, learning skills, and teleporting.
    *   **Item Spawner**:
        *   Browse all game items, filtered by type (e.g., Weapon, Armor, Consumable).
        *   Filter items by name.
        *   Set spawn parameters such as quantity, refine level, durability, stats, and socket status.
        *   Spawns items by sending an `/item` command to the server.
    *   **Skill Learner**:
        *   Browse all skills, filtered by job.
        *   Learn any skill with a single click by sending an `/add skill` command.
    *   **Map Teleporter**:
        *   Lists all available maps in the game.
        *   Teleport to any selected map by sending a `/tp` command.
*   **Misc Tab**: Contains various engine and client settings.
    *   **General**: Toggles for disabling the UI, entering filming mode (which hides the UI), and enabling observer camera mode. Includes a button to reload the UI definition files.
    *   **Camera**: Provides direct control over the game camera, including follow mode, distance (zoom), pitch, and yaw.
    *   **Engine Settings**:
        *   Toggle wireframe rendering.
        *   Toggle and configure fog settings, including color and range.
    *   **Scene Tree**: Displays a live tree view of all visible objects currently being rendered by the engine.
    *   **Class Information**: A quick reference for job/class IDs.

### Target Window

This window can be opened from the "Misc" tab in the Main Window. It displays detailed, real-time information about the currently selected target.

*   **General Info**: Target ID, object type, name, level, HP/MP, world position, and PvP status.
*   **Stats**: A comprehensive list of all combat and character stats, including:
    *   Primary stats (STR, DEX, INT, CON, CHA, SEN).
    *   Combat stats (Attack, Defense, Magic Resist, Hit Rate, Crit Rate, Dodge Rate).
    *   Movement and attack speed.
*   **Animation**: Shows the current animation ID and speed modifiers.
*   **Zone Info**: Displays the PvP status of the current map.
