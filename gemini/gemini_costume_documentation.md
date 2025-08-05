# Costume System Documentation

This document provides a thorough analysis of the costume system in `rose-next-classic`, intended to support a backporting effort to an older version of the project.

## 1. Core Implementation

### 1.1. Files

*   **Client:** `src/client/cobjchar.h` - Contains the `CObjAVT` class, which represents the player's avatar and manages its appearance.
*   **Server (Packet Handling):** `src/sho_gameserver/src/gs_user.cpp` - Handles user-related packets, including requests to equip costume items.
*   **Server (Logic):** `src/sho_gameserver/src/cobjavt.cpp` - Implements the server-side logic for the `CObjAVT` class, including the `set_costume_item` function.

### 1.2. Client-Side Implementation

The client-side implementation is centered around the `CObjAVT` class in `cobjchar.h`.

#### Equipment Slots
The avatar’s equipment slots are defined by a `union` within the `CObjAVT` class. This `union` includes an array of `tagPartITEM` structs, which represent the items equipped in each slot.

```cpp
union {
    tagPartITEM m_sPartItemIDX[MAX_BODY_PART];
    // ...
};
```

#### Applying Costumes
The `set_costume` function applies the visual appearance of costume items to the avatar model.

```cpp
void set_costume(tagPartITEM* part_item) {
    for (int index = BODY_PART_HELMET; index < MAX_BODY_PART; index++) {
        if (!part_item[index].m_nItemNo) {
            continue;
        }
        this->SetPartITEM(index, part_item[index]);
    }
}
```

### 1.3. Server-Side Implementation

The server handles the logic for equipping and unequipping costume items.

#### Packet Handling
The server receives a packet from the client to equip a costume item in the `classUSER::Recv_cli_EQUIP_ITEM` function in `gs_user.cpp`.

```cpp
bool classUSER::Recv_cli_EQUIP_ITEM(t_PACKET* pPacket) {
    // ...
    if (pPacket->m_cli_EQUIP_ITEM.m_btInvIDX >= INVENTORY_COSTUME_ITEM0) {
        this->set_costume_item(pPacket->m_cli_EQUIP_ITEM.m_btInvIDX);
        return true;
    }
    // ...
}
```

#### Equipping Costumes
The `set_costume_item` function in `cobjavt.cpp` equips the costume item on the server.

```cpp
void CObjAVT::set_costume_item(short equip_idx) {
    short part_index = s_nEquipIdxToPartNO[equip_idx - INVENTORY_COSTUME_ITEM0];
    if (part_index < 0) {
        return;
    }
    // Copies item data from inventory to the 'costume' array
    this->costume[part_index].m_nItemNo = this->m_Inventory.m_ItemLIST[equip_idx].GetItemNO();
    this->costume[part_index].m_nGEM_OP = this->m_Inventory.m_ItemLIST[equip_idx].GetGemNO();
    this->costume[part_index].m_cGrade = this->m_Inventory.m_ItemLIST[equip_idx].GetGrade();
    this->costume[part_index].m_bHasSocket = this->m_Inventory.m_ItemLIST[equip_idx].m_bHasSocket;
}
```
This function maps the inventory slot to a body part and copies the item data to the character’s `costume` array. This data is then sent to other clients to display the updated appearance.

---

## 2. Stat and Combat Calculations

**Costume items are purely cosmetic and have no impact on character stats or combat calculations.**

A thorough review of the server-side code, particularly `CObjAVT::Cal_ATTACK()` and other stat calculation functions in `src/sho_gameserver/src/cobjavt.cpp`, confirms this. All combat-related calculations are based on the character's base stats and the items equipped in the primary `m_PartITEM` array. The `costume` array is never referenced in these functions.

This simplifies the backporting process, as no complex stat logic needs to be migrated for the costume system.

---

## 3. Item Data Flow (`.stb`, `.csv`, `.vfs`)

The project uses a combination of `.csv` files, `.stb` files, and `.vfs` files to manage item data.

*   **Canonical Data Source (`.csv`):** The primary source of truth for all item data is a set of `.csv` files, likely located in a development directory like `dev/`.

*   **Asset Pipeline (`pipeline.exe`):** The `pipeline.exe` utility is used to convert the `.csv` files into the binary `.stb` format that both the client and server use.

*   **Game Data (`.stb`):** Both the client and server load their data from the same set of `.stb` files.
    *   **Server:** Loads from `server/data/` (populated at build time).
    *   **Client (Development):** Loads unpacked `.stb` files from `dist/release/client/debug/3ddata/stb/`.
    *   **Client (Distribution):** Loads all data, including `.stb` files, from a `.vfs` archive created by the `dist.ps1` script.

Key `.stb` files for the costume system include:
*   `LIST_CAP.STB` (Helmets)
*   `LIST_BODY.STB` (Armor)
*   `LIST_ARMS.STB` (Gauntlets)
*   `LIST_FOOT.STB` (Boots)
*   `LIST_BACK.STB` (Knapsacks)
*   `LIST_FACEITEM.STB` (Face accessories)

---

## 4. Backporting Considerations

Given this data flow, backporting the costume system will require the following:

1.  **Create/Modify `.csv` files:** Add the new costume items to the relevant `.csv` files.

2.  **Generate `.stb` files:** Use the `pipeline.exe` tool to convert the updated `.csv` files into new `.stb` files.

3.  **Deploy `.stb` files:**
    *   Place the new `.stb` files in the appropriate directory for the older server.
    *   For the older client, you will need to either replace the existing `.stb` files or, if the older client uses a `.vfs` system, repack the new `.stb` files into the `.vfs` archive.

4.  **Code Migration:**
    *   The core logic from the files listed in section 1.1 will need to be carefully migrated and adapted to the older codebase.
    *   Pay close attention to differences in class structures, variable names, and packet definitions.
    *   Ensure the client and server code correctly loads and references the data from the updated `.stb` files or `.vfs` archive.

This detailed breakdown should provide a solid foundation for the backporting effort.

---

_Last Updated: 2025-08-05_
_Maintainer: Gemini / Developer: JDoeBoy
_File Version: 1.2_