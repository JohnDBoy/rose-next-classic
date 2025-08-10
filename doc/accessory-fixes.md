# Accessory Equip Crash Fixes

## Summary
Equipping accessories (necklace, ring, earring) could crash the gameserver and appear as a character rollback. Root cause was an out-of-bounds access when mapping equip indices to visible body parts.

## Root Cause
- File: `src/sho_gameserver/src/cobjavt.cpp`
- Mapping array `s_nEquipIdxToPartNO` lacked an entry for `EQUIP_IDX_EARRING` and was used without bounds checks.
- When equipping earrings (index 11), the code indexed beyond the array, triggering undefined behavior and crashes.

## Changes
- Extend mapping to cover all equip indices and mark accessories as non-visual:
  - Lines 175–190: added `-1` entry for `EQUIP_IDX_EARRING` and documented mappings.
- Add compile-time safety and runtime guards:
  - Lines 193–203: `COMPILE_TIME_ASSERT(EQUIP_IDX_EARRING == 11)`.
  - Lines 205–209: bounds check in `SetPartITEM` before indexing.
  - Lines 231–239: bounds check in `set_costume_item` for costume mapping.

## Impacted Areas
- Only server-side visual part mapping (no change to stat calculations).
- Jewel stat application remains in `src/sho_gameserver/src/common/cuserdata.cpp`:
  - `EQUIP_IDX_NECKLACE`/`RING`/`EARRING` already mapped to `ITEM_TYPE_JEWEL` and validated.

## Validation
1. Build: `just build CONFIG=release`
2. Run servers: `just server-all CONFIG=debug`
3. Test cases:
   - Equip/unequip necklace, ring, earring (individually and combined).
   - Relog and verify items persist, no crash, stats applied.
   - If using costume, equip/unequip relevant slots and observe stability.

## Notes
- Accessories intentionally have no visible body-part mapping (`-1`).
- To add accessory visuals later, define new body parts and update client rendering accordingly.

## Risk & Rollback
- Low risk: guards only prevent out-of-bounds. Rollback by reverting edits in `cobjavt.cpp` if needed.
