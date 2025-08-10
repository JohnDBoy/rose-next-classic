# Database-Side Fix for Accessory Slot Corruption

## Problem Summary

The game server crashes when loading characters with equipped accessories (necklace, ring, earring) due to an out-of-bounds array access in the `inventory2part()` function. When accessories are equipped in slots 9-11, the function attempts to read beyond array boundaries, causing memory corruption and server crashes.

## Root Cause

The `inventory2part()` function in `src/common/shared/datatype.h` has an array with only 9 elements (indices 0-8), but accessories use slots 9-11. This causes:
- Out-of-bounds memory access
- Random memory corruption
- Server crashes during character load
- Characters appearing "deleted" (unable to select)

## Database-Side Solutions

### 1. Immediate Fix - Move Accessories to Safe Slots

```sql
-- Move accessories from equipment slots to regular inventory
UPDATE inventory 
SET slot = CASE 
    WHEN slot = 9 THEN 12   -- Move necklace to inventory
    WHEN slot = 10 THEN 13  -- Move ring to inventory
    WHEN slot = 11 THEN 14  -- Move earring to inventory
END
WHERE slot IN (9, 10, 11);
```

### 2. Prevent Future Issues with Database Trigger

```sql
-- Create trigger to automatically relocate items placed in dangerous slots
CREATE OR REPLACE FUNCTION prevent_accessory_slots()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.slot IN (9, 10, 11) THEN
        -- Find next available inventory slot
        SELECT COALESCE(MAX(slot) + 1, 12) INTO NEW.slot
        FROM inventory 
        WHERE owner_id = NEW.owner_id 
        AND slot >= 12 AND slot < 100;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER inventory_accessory_safety
BEFORE INSERT OR UPDATE ON inventory
FOR EACH ROW
EXECUTE FUNCTION prevent_accessory_slots();
```

### 3. Backup Before Making Changes

```sql
-- Create backup of affected inventory items
CREATE TABLE inventory_accessory_backup AS 
SELECT i.*, c.name as character_name, NOW() as backup_date
FROM inventory i
JOIN character c ON c.id = i.owner_id
WHERE i.slot IN (9, 10, 11);
```

### 4. Find Affected Characters

```sql
-- List all characters with accessories equipped
SELECT 
    c.id as character_id,
    c.name as character_name,
    c.level,
    CASE i.slot
        WHEN 9 THEN 'Necklace'
        WHEN 10 THEN 'Ring'
        WHEN 11 THEN 'Earring'
    END as accessory_type,
    it.game_data_id
FROM character c
JOIN inventory i ON c.id = i.owner_id
JOIN item it ON i.item_id = it.id
WHERE i.slot IN (9, 10, 11)
ORDER BY c.name;
```

### 5. Monitoring Query

```sql
-- Create monitoring function
CREATE OR REPLACE FUNCTION check_dangerous_slots()
RETURNS TABLE(
    character_id INTEGER,
    character_name VARCHAR(30),
    slot SMALLINT,
    item_count BIGINT
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        c.id,
        c.name,
        i.slot,
        COUNT(*) as item_count
    FROM inventory i
    JOIN character c ON c.id = i.owner_id
    WHERE i.slot IN (9, 10, 11)
    GROUP BY c.id, c.name, i.slot
    ORDER BY c.name;
END;
$$ LANGUAGE plpgsql;

-- Check for problematic slots
SELECT * FROM check_dangerous_slots();
```

### 6. Automated Cleanup (Optional)

```sql
-- For PostgreSQL with pg_cron extension
CREATE EXTENSION IF NOT EXISTS pg_cron;

-- Schedule hourly cleanup
SELECT cron.schedule(
    'fix-accessory-slots',
    '0 * * * *',
    $$
    UPDATE inventory 
    SET slot = slot + 100 
    WHERE slot IN (9, 10, 11);
    $$
);
```

### 7. Rollback Procedure (If Needed)

```sql
-- Restore accessories from backup
INSERT INTO inventory (owner_id, item_id, slot, quantity)
SELECT owner_id, item_id, slot, quantity
FROM inventory_accessory_backup
ON CONFLICT (owner_id, slot) DO NOTHING;

-- Note: Only use this after the source code is properly fixed
```

## Implementation Steps

1. **Backup First**: Run the backup query (#3) to save current state
2. **Find Affected Players**: Use query #4 to identify who needs fixing
3. **Apply Immediate Fix**: Run update query #1 to move accessories
4. **Install Trigger**: Create the prevention trigger (#2)
5. **Monitor**: Set up monitoring query (#5) to track issues
6. **Verify**: Have affected players log in to confirm they can access characters

## Expected Results

- Characters with accessories will have them moved to regular inventory slots
- Players can log in and access their characters again
- Accessories remain safe in inventory (not deleted)
- Future equip attempts will be automatically redirected to safe slots

## Long-term Fix Required

While this database solution prevents crashes, the proper fix requires updating the source code:

**File**: `src/common/shared/datatype.h`
**Function**: `inventory2part()`
**Issue**: Array bounds check should include slots 9-11 to return `BODY_PART_INVALID`

## Notes

- This is a temporary workaround to keep the server running
- No items are deleted - they're just relocated to safe slots
- Players may need to re-equip accessories after the source is properly fixed
- The trigger will prevent future occurrences until code is patched

## Support

If you encounter issues with this fix:
1. Check the backup table first
2. Review server logs for specific error messages
3. Run the monitoring query to identify remaining problems
4. Contact development team with character IDs that still crash

---

*Document created: 2025-01-10*
*Issue discovered: Accessory slots causing out-of-bounds array access*
*Temporary fix: Database-side slot relocation*