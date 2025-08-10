# Using Diff Files for Patches and Code Review

## Overview

Diff files (also called patches) are a powerful way to share code changes without modifying the original source files. They're especially useful for testing fixes, reviewing changes, and distributing updates that users can apply themselves.

## What is a Diff File?

A diff file shows the differences between two versions of a file or set of files. It contains:
- Lines to be removed (prefixed with `-`)
- Lines to be added (prefixed with `+`)
- Context lines (prefixed with space or no prefix)
- File paths and metadata

## Creating Diff Files

### 1. Create a Diff from Uncommitted Changes

```bash
# See all changes in your working directory
git diff > my-changes.diff

# Create diff for specific files only
git diff src/common/shared/datatype.h > datatype-fix.diff

# Create diff with more context (useful for complex changes)
git diff -U10 > detailed-changes.diff
```

### 2. Create a Diff Between Commits

```bash
# Diff between two commits
git diff commit1..commit2 > changes-between-commits.diff

# Diff from a specific commit to HEAD
git diff abc123..HEAD > recent-changes.diff

# Diff for the last commit
git diff HEAD~1..HEAD > last-commit.diff
```

### 3. Create a Diff Between Branches

```bash
# Compare current branch with master
git diff master..HEAD > branch-changes.diff

# Compare two branches
git diff master..accessory-fixes > accessory-fixes.diff
```

### 4. Format-Patch for Email-Ready Patches

```bash
# Create a patch file with commit message
git format-patch -1 HEAD

# Create patches for last 3 commits
git format-patch -3

# Create patch for specific commit
git format-patch -1 abc123
```

## Accessory Fix Diff Example

Here's the specific diff for the accessory slot corruption fix:

**File**: `accessory-slot-fix.diff`

```diff
diff --git a/src/common/shared/datatype.h b/src/common/shared/datatype.h
index e9eb2e77..fix12345 100644
--- a/src/common/shared/datatype.h
+++ b/src/common/shared/datatype.h
@@ -932,7 +932,7 @@ constexpr size_t
 inventory2part(size_t inventory_idx) {
-    if (inventory_idx == 0 || inventory_idx > EQUIP_IDX_WEAPON_L) {
+    if (inventory_idx == 0 || inventory_idx > EQUIP_IDX_EARRING) {
         return BODY_PART_INVALID;
     }
 
@@ -945,6 +945,9 @@ inventory2part(size_t inventory_idx) {
         BODY_PART_BOOTS,      // EQUIP_IDX_BOOTS
         BODY_PART_WEAPON_R,   // EQUIP_IDX_WEAPON_R
         BODY_PART_WEAPON_L,   // EQUIP_IDX_WEAPON_L
+        BODY_PART_INVALID,    // EQUIP_IDX_NECKLACE (no visual)
+        BODY_PART_INVALID,    // EQUIP_IDX_RING (no visual)
+        BODY_PART_INVALID,    // EQUIP_IDX_EARRING (no visual)
     };
 
     return map[inventory_idx];

diff --git a/src/sho_gameserver/src/gs_threadsql.cpp b/src/sho_gameserver/src/gs_threadsql.cpp
index old123..new456 100644
--- a/src/sho_gameserver/src/gs_threadsql.cpp
+++ b/src/sho_gameserver/src/gs_threadsql.cpp
@@ -678,6 +678,11 @@ bool GS_ThreadSQL::Load_CHAR_Data(classUSER* user, t_PACKET* pPacket) {
         }
 
         size_t part_idx = inventory2part(slot);
+        
+        // Skip accessories - they don't have visual parts
+        if (part_idx == BODY_PART_INVALID) {
+            continue;
+        }
+        
         if (part_idx >= BODY_PART_HELMET && part_idx < MAX_BODY_PART) {
             tagPartITEM& part = basic_etc.m_PartITEM[part_idx];

diff --git a/src/sho_worldserver/src/ws_threadsql.cpp b/src/sho_worldserver/src/ws_threadsql.cpp
index abc789..def012 100644
--- a/src/sho_worldserver/src/ws_threadsql.cpp
+++ b/src/sho_worldserver/src/ws_threadsql.cpp
@@ -295,7 +295,11 @@ bool CWS_ThreadSQL::Proc_cli_CHAR_LIST(tagQueryDATA* pSqlPACKET) {
             size_t part_idx = inventory2part(slot);
-            if (slot >= 0 && slot < MAX_EQUIP_IDX) {
+            
+            // Validate part index before using it
+            if (slot >= 0 && slot < MAX_EQUIP_IDX && 
+                part_idx != BODY_PART_INVALID && 
+                part_idx < MAX_BODY_PART) {
                 equipment[part_idx].m_nItemNo = game_data_id;
             }
```

## Applying Diff Files

### 1. Using Git Apply (Recommended)

```bash
# Test if patch applies cleanly (dry run)
git apply --check accessory-fix.diff

# Apply the patch
git apply accessory-fix.diff

# Apply with 3-way merge (handles conflicts better)
git apply -3 accessory-fix.diff

# Apply ignoring whitespace issues
git apply --ignore-whitespace accessory-fix.diff

# Reverse a patch (undo changes)
git apply --reverse accessory-fix.diff
```

### 2. Using Unix Patch Command

```bash
# Apply a patch
patch -p1 < accessory-fix.diff

# Dry run to test
patch -p1 --dry-run < accessory-fix.diff

# Create backup files
patch -p1 -b < accessory-fix.diff

# Reverse a patch
patch -p1 -R < accessory-fix.diff
```

### 3. Manual Application

If automated patching fails, you can apply changes manually:

1. Open the diff file
2. Find each file mentioned (lines starting with `+++` or `---`)
3. Locate the line numbers (shown after `@@`)
4. Remove lines marked with `-`
5. Add lines marked with `+`

## Reading Diff Files

### Diff Header Format

```diff
diff --git a/src/file.cpp b/src/file.cpp
index abc123..def456 100644
--- a/src/file.cpp        (original file)
+++ b/src/file.cpp        (modified file)
@@ -175,7 +175,10 @@     (line 175, 7 lines of context → 10 lines after change)
```

### Change Indicators

- **`-`** Line removed
- **`+`** Line added
- **` `** (space) Context line (unchanged)
- **`@@`** Hunk header showing line numbers

## Creating Patches for Distribution

### 1. Simple Fix Patch

```bash
# Create a minimal patch for the accessory fix
cat > accessory-fix-minimal.diff << 'EOF'
--- a/src/common/shared/datatype.h
+++ b/src/common/shared/datatype.h
@@ -934,7 +934,7 @@
 inventory2part(size_t inventory_idx) {
-    if (inventory_idx == 0 || inventory_idx > EQUIP_IDX_WEAPON_L) {
+    if (inventory_idx == 0 || inventory_idx > EQUIP_IDX_EARRING) {
         return BODY_PART_INVALID;
     }
EOF
```

### 2. Comprehensive Patch with Instructions

```bash
#!/bin/bash
# File: apply-accessory-fix.sh

echo "Applying accessory slot corruption fix..."

# Check if we're in the right directory
if [ ! -f "src/common/shared/datatype.h" ]; then
    echo "Error: Run this from the ROSE project root directory"
    exit 1
fi

# Create backup
cp src/common/shared/datatype.h src/common/shared/datatype.h.backup

# Apply the patch
git apply --check accessory-fix.diff
if [ $? -eq 0 ]; then
    git apply accessory-fix.diff
    echo "Patch applied successfully!"
else
    echo "Patch failed. Please apply manually."
    exit 1
fi
```

## Sharing Diff Files

### 1. Via GitHub Gist

```bash
# Create a gist with your diff
# 1. Go to https://gist.github.com
# 2. Paste your diff content
# 3. Name it "accessory-fix.diff"
# 4. Share the URL

# Users can then download and apply:
curl -O https://gist.githubusercontent.com/username/gistid/raw/accessory-fix.diff
git apply accessory-fix.diff
```

### 2. Via Pull Request

```bash
# Generate diff from PR
curl -L https://github.com/owner/repo/pull/123.diff > pr-123.diff

# Apply PR changes locally
git apply pr-123.diff
```

### 3. In Documentation

```markdown
## Quick Fix for Accessory Crash

Save this as `fix.diff` and run `git apply fix.diff`:

\`\`\`diff
--- a/src/common/shared/datatype.h
+++ b/src/common/shared/datatype.h
@@ -934,7 +934,7 @@
-    if (inventory_idx == 0 || inventory_idx > EQUIP_IDX_WEAPON_L) {
+    if (inventory_idx == 0 || inventory_idx > EQUIP_IDX_EARRING) {
\`\`\`
```

## Testing Patches Safely

### 1. Create a Test Branch

```bash
# Create a test branch
git checkout -b test-patch

# Apply patch
git apply accessory-fix.diff

# Test the changes
make && ./run-tests

# If good, commit
git add -A
git commit -m "Applied accessory fix patch"

# If bad, just switch back
git checkout master
git branch -D test-patch
```

### 2. Using Git Stash

```bash
# Save current work
git stash

# Apply patch
git apply accessory-fix.diff

# Test...

# If bad, reset
git checkout -- .
git stash pop
```

## Common Issues and Solutions

### Issue 1: Patch Doesn't Apply

```bash
# Error: patch does not apply

# Solution 1: Check for whitespace issues
git apply --ignore-whitespace accessory-fix.diff

# Solution 2: Use 3-way merge
git apply -3 accessory-fix.diff

# Solution 3: Apply with fuzz factor
patch -p1 -F3 < accessory-fix.diff
```

### Issue 2: Wrong Directory Level

```bash
# If patch was created from different directory level
# Try different -p values:
patch -p0 < accessory-fix.diff  # No directory stripping
patch -p1 < accessory-fix.diff  # Strip one level (most common)
patch -p2 < accessory-fix.diff  # Strip two levels
```

### Issue 3: Line Endings (Windows/Linux)

```bash
# Convert line endings before applying
dos2unix accessory-fix.diff
git apply accessory-fix.diff

# Or ignore line ending issues
git apply --ignore-whitespace accessory-fix.diff
```

## Best Practices

1. **Always Test First**
   ```bash
   git apply --check patch.diff
   ```

2. **Create Backups**
   ```bash
   cp -r src src.backup
   ```

3. **Use Version Control**
   ```bash
   git stash  # Save current work
   git apply patch.diff
   ```

4. **Document Patches**
   - Include description of what it fixes
   - Specify which version/commit it's for
   - Add application instructions

5. **Keep Patches Small**
   - One fix per patch
   - Easier to review and apply
   - Less chance of conflicts

## Example: Complete Accessory Fix Distribution

```bash
#!/bin/bash
# File: distribute-accessory-fix.sh

# Create the patch file
cat > ROSE-accessory-fix-v1.0.diff << 'EOF'
# ROSE Next Classic - Accessory Slot Corruption Fix
# Version: 1.0
# Date: 2025-01-10
# 
# This patch fixes server crashes when characters have accessories equipped
# in slots 9-11 (necklace, ring, earring) due to out-of-bounds array access.
#
# To apply:
#   git apply ROSE-accessory-fix-v1.0.diff
#
# To test first:
#   git apply --check ROSE-accessory-fix-v1.0.diff
#
# To reverse:
#   git apply --reverse ROSE-accessory-fix-v1.0.diff

diff --git a/src/common/shared/datatype.h b/src/common/shared/datatype.h
index e9eb2e77..fix12345 100644
--- a/src/common/shared/datatype.h
+++ b/src/common/shared/datatype.h
@@ -934,7 +934,7 @@ inventory2part(size_t inventory_idx) {
-    if (inventory_idx == 0 || inventory_idx > EQUIP_IDX_WEAPON_L) {
+    if (inventory_idx == 0 || inventory_idx > EQUIP_IDX_EARRING) {
         return BODY_PART_INVALID;
     }
EOF

echo "Patch file created: ROSE-accessory-fix-v1.0.diff"
echo "Share this file with server operators to fix the accessory crash issue."
```

---

*Document created: 2025-01-10*
*Purpose: Guide for creating, applying, and distributing diff files*
*Use case: Sharing the accessory slot fix and other patches*