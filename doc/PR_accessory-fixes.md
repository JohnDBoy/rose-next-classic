# fix(gameserver): prevent accessory equip crashes by guarding slot-to-part mapping

## Summary
Equipping accessories (necklace, ring, earring) could crash the gameserver, sometimes appearing as character rollback. This PR fixes an out-of-bounds access in the equip-index → body-part mapping and adds safety checks.

## Root Cause
- File: `src/sho_gameserver/src/cobjavt.cpp`
- The mapping array `s_nEquipIdxToPartNO` did not include an entry for `EQUIP_IDX_EARRING` (index 11) and was indexed without bounds checks. Equipping an earring indexed past the array, causing undefined behavior/crash.

## Changes
- Extend mapping to cover all equip indices; accessories map to `-1` (no visible part).
- Add `COMPILE_TIME_ASSERT(EQUIP_IDX_EARRING == 11)` to lock in index assumptions.
- Add bounds checks in:
  - `CObjAVT::SetPartITEM(short nEquipInvIDX)`
  - `CObjAVT::set_costume_item(short equip_idx)`
- Docs: `doc/accessory-fixes.md` with root cause, line references, validation, and notes.

## Impact
- Only affects server-side mapping used for model part assignment. No changes to stat calculations.
- Jewel stats remain applied in `src/sho_gameserver/src/common/cuserdata.cpp` for necklace/ring/earring.

## Validation
1. Build: `just build CONFIG=release`
2. Run: `just server-all CONFIG=debug`
3. Test:
   - Equip/unequip necklace, ring, earring (individually and combined).
   - Relog to confirm persistence and stability.
   - If using costume, test equip/unequip to ensure no regressions.

## Risk
- Low. Changes only add guards and a missing array entry; behavior for existing slots unchanged.

## Screenshots/Logs
- N/A (server logs previously showed crashes during earring equip; now stable).

## Checklist
- [x] Code compiles
- [x] Accessory equip/unequip stable
- [x] Docs added (`doc/accessory-fixes.md`)
