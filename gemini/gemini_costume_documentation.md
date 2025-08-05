# Costume System Documentation

This document outlines the implementation of the costume system in `rose-next-classic`.

## Files

*   `src/client/cobjchar.h`: This header file contains the core classes for character objects, including `CObjAVT`, which represents a player's avatar.
*   `src/sho_gameserver/src/gs_user.cpp`: This file contains the server-side logic for handling user-related packets, including equipping costume items.
*   `src/sho_gameserver/src/cobjavt.cpp`: This file contains the server-side implementation of the `CObjAVT` class, including the `set_costume_item` function.

## Client-Side Implementation

The client-side implementation is centered around the `CObjAVT` class in `cobjchar.h`.

### Equipment Slots

The avatar's equipment slots are defined by a `union` within the `CObjAVT` class. This `union` includes an array of `tagPartITEM` structs, which represent the items equipped in each slot.

```cpp
union {
    tagPartITEM m_sPartItemIDX[MAX_BODY_PART];
    // short    m_nPartItemIDX[ MAX_BODY_PART ];
    struct {
        // 순서는 t_CharPART에 따라서...
        tagPartITEM m_sFaceIDX; // short m_nFaceIDX;
        tagPartITEM m_sHairIDX; // short m_nHairIDX;
        tagPartITEM m_sHelmetIDX; // short m_nHelmetIDX;

        tagPartITEM m_sArmorIDX; // short m_nArmorIDX;
        tagPartITEM m_sGauntletIDX; // short m_nGauntletIDX;
        tagPartITEM m_sBootsIDX; // short m_nBootsIDX;

        tagPartITEM m_sGoggleIDX; // short m_nGoggleIDX;
        tagPartITEM m_sKnapsackIDX; // short m_nKnapsackIDX;

        tagPartITEM m_sRWeaponIDX; // short m_nRWeaponIDX;
        tagPartITEM m_sLWeaponIDX; // short m_nLWeaponIDX;
    };
};
```

### Applying Costumes

The `set_costume` function is responsible for applying costume items to the avatar. It iterates through the `part_item` array and calls `SetPartITEM` for each valid item.

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

## Server-Side Implementation

The server-side implementation handles the logic for equipping and unequipping costume items.

### Packet Handling

The server receives a packet from the client to equip a costume item in the `classUSER::Recv_cli_EQUIP_ITEM` function in `gs_user.cpp`.

```cpp
//-------------------------------------------------------------------------------------------------
/// 인벤토리 아이템 장착/해제
bool classUSER::Recv_cli_EQUIP_ITEM(t_PACKET* pPacket) {
    // ... (code for equipping regular items)

    //------------------------------------------------------------------------------------------------
    // 2005. 06. 20 JDH
    // 코스튬 아이템 장착...
    //------------------------------------------------------------------------------------------------
    if (pPacket->m_cli_EQUIP_ITEM.m_btInvIDX >= INVENTORY_COSTUME_ITEM0) {
        this->set_costume_item(pPacket->m_cli_EQUIP_ITEM.m_btInvIDX);
        return true;
    }
    //------------------------------------------------------------------------------------------------

    // ... (rest of the function)
}
```

### Equipping Costumes

The `set_costume_item` function in `cobjavt.cpp` is responsible for equipping the costume item on the server.

```cpp
void
CObjAVT::set_costume_item(short equip_idx) {
    short part_index = s_nEquipIdxToPartNO[equip_idx - INVENTORY_COSTUME_ITEM0];
    if (part_index < 0) {
        return;
    }

    this->costume[part_index].m_nItemNo = this->m_Inventory.m_ItemLIST[equip_idx].GetItemNO();
    this->costume[part_index].m_nGEM_OP = this->m_Inventory.m_ItemLIST[equip_idx].GetGemNO();
    this->costume[part_index].m_cGrade = this->m_Inventory.m_ItemLIST[equip_idx].GetGrade();
    this->costume[part_index].m_bHasSocket = this->m_Inventory.m_ItemLIST[equip_idx].m_bHasSocket;
}
```

This function maps the inventory slot to a body part and copies the item data to the character's `costume` array. This data is then sent to other clients to display the updated appearance.

_Last Updated: 2025-08-04_  
_Maintainer: Gemini / Developer: JDoeBoy  
_File Version: 1.0_