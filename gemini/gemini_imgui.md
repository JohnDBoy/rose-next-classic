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
