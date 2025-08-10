# Defensive Error Handling for Accessory Slot Issues

## Overview

This document outlines code locations where defensive error handling can be added to log problems rather than crash when encountering accessory slot corruption. These changes convert fatal errors into logged warnings while keeping the server running.

## Critical Code Locations to Add Safety Checks

### 1. inventory2part() Function Safety
**File**: `src/common/shared/datatype.h` (line ~933)

**Current Issue**: Out-of-bounds array access for slots 9-11

**Defensive Fix**:
```cpp
constexpr size_t inventory2part(size_t inventory_idx) {
    // Add comprehensive bounds checking
    if (inventory_idx == 0 || inventory_idx > EQUIP_IDX_EARRING) {
        return BODY_PART_INVALID;
    }
    
    // Add safety check for accessories
    if (inventory_idx >= EQUIP_IDX_NECKLACE && inventory_idx <= EQUIP_IDX_EARRING) {
        // Accessories don't have visual parts
        return BODY_PART_INVALID;
    }
    
    const size_t map[] = {
        BODY_PART_INVALID,    // 0: EQUIP_IDX_NULL
        BODY_PART_FACE_ITEM,  // 1
        BODY_PART_HELMET,     // 2
        BODY_PART_ARMOR,      // 3
        BODY_PART_KNAPSACK,   // 4
        BODY_PART_GAUNTLET,   // 5
        BODY_PART_BOOTS,      // 6
        BODY_PART_WEAPON_R,   // 7
        BODY_PART_WEAPON_L,   // 8
    };
    
    // Defensive array bounds check
    if (inventory_idx >= sizeof(map)/sizeof(map[0])) {
        return BODY_PART_INVALID;
    }
    
    return map[inventory_idx];
}
```

### 2. Game Server Character Loading
**File**: `src/sho_gameserver/src/gs_threadsql.cpp` (line ~680)

**Current Issue**: Uses potentially invalid part_idx without validation

**Defensive Fix**:
```cpp
// Around line 680
size_t part_idx = inventory2part(slot);

// Add validation before using part_idx
if (part_idx == BODY_PART_INVALID) {
    LOG_WARN("Invalid part mapping for slot {}: character {}", 
             slot, user->Get_NAME());
    continue;  // Skip this item, don't crash
}

if (part_idx >= BODY_PART_HELMET && part_idx < MAX_BODY_PART) {
    tagPartITEM& part = basic_etc.m_PartITEM[part_idx];
    part.m_nItemNo = item_res.get_int32(row_idx, INV_COL_GAME_DATA_ID);
    // ... rest of code
} else {
    LOG_ERROR("Part index {} out of bounds for slot {}: character {}", 
              part_idx, slot, user->Get_NAME());
    // Continue loading, don't crash
}
```

### 3. World Server Character List Display
**File**: `src/sho_worldserver/src/ws_threadsql.cpp` (line ~295)

**Current Issue**: Writes to equipment array without bounds checking

**Defensive Fix**:
```cpp
// Around line 295
size_t part_idx = inventory2part(slot);

// Add safety checks
if (part_idx == BODY_PART_INVALID) {
    LOG_DEBUG("Skipping non-visual slot {}", slot);
    continue;
}

if (slot >= 0 && slot < MAX_EQUIP_IDX && part_idx < MAX_BODY_PART) {
    equipment[part_idx].m_nItemNo = game_data_id;
} else {
    LOG_WARN("Invalid equipment mapping - slot: {}, part_idx: {}, char: {}", 
             slot, part_idx, char_name);
    // Log but continue, don't crash
}
```

### 4. CObjAVT::SetPartITEM Safety
**File**: `src/sho_gameserver/src/cobjavt.cpp` (line ~192)

**Current Issue**: Array access without comprehensive validation

**Defensive Fix**:
```cpp
void CObjAVT::SetPartITEM(short nEquipInvIDX) {
    // Add pre-validation
    if (nEquipInvIDX < 0 || nEquipInvIDX >= MAX_EQUIP_IDX) {
        LOG_ERROR("SetPartITEM called with invalid index: {}", nEquipInvIDX);
        return;
    }
    
    // Check array bounds explicitly
    static const size_t array_size = sizeof(s_nEquipIdxToPartNO) / sizeof(s_nEquipIdxToPartNO[0]);
    if (nEquipInvIDX >= array_size) {
        LOG_ERROR("SetPartITEM index {} exceeds array size {}", 
                  nEquipInvIDX, array_size);
        return;
    }
    
    short nPartNO = s_nEquipIdxToPartNO[nEquipInvIDX];
    
    // Validate part number
    if (nPartNO < 0) {
        LOG_DEBUG("No visual part for equipment slot {}", nEquipInvIDX);
        // This is normal for accessories, just update abilities
    } else if (nPartNO >= MAX_BODY_PART) {
        LOG_ERROR("Invalid part number {} for slot {}", nPartNO, nEquipInvIDX);
        return;
    } else {
        this->SetPartITEM(nPartNO, m_Inventory.m_ItemLIST[nEquipInvIDX]);
    }
    
    if (this->GetCur_MOVE_MODE() <= MOVE_MODE_RUN)
        this->UpdateAbility();
}
```

### 5. Inventory Save Operations
**File**: `src/sho_gameserver/src/gs_threadsql.cpp` (line ~183)

**Current Issue**: May save corrupted slot data

**Defensive Fix**:
```cpp
for (size_t i = 0; i < INVENTORY_TOTAL_SIZE; ++i) {
    tagITEM& item = user->m_Inventory.m_ItemLIST[i];
    
    // Skip problematic slots with warning
    if (i >= EQUIP_IDX_NECKLACE && i <= EQUIP_IDX_EARRING) {
        if (!item.IsEmpty()) {
            LOG_WARN("Accessory in slot {} for character {} - relocating", 
                     i, user->Get_NAME());
            // Move to safe slot
            size_t safe_slot = i + 100;
            if (safe_slot < INVENTORY_TOTAL_SIZE) {
                user->m_Inventory.m_ItemLIST[safe_slot] = item;
                item.Clear();  // Clear the dangerous slot
            }
        }
    }
    
    if (item.GetTYPE() == 0 || item.IsEmpty() || !item.IsValidITEM()) {
        inventory_delete_list.push_back(i);
        continue;
    }
    
    // ... rest of save logic
}
```

## Logging Macros to Add

### Enhanced Logging System
**File**: `src/common/include/rose/common/log.h` (if not exists, create it)

```cpp
#ifndef ROSE_COMMON_LOG_H
#define ROSE_COMMON_LOG_H

#include <fmt/format.h>
#include <chrono>
#include <fstream>

enum LogLevel {
    LOG_LEVEL_DEBUG = 0,
    LOG_LEVEL_INFO = 1,
    LOG_LEVEL_WARN = 2,
    LOG_LEVEL_ERROR = 3,
    LOG_LEVEL_CRITICAL = 4
};

class AccessoryLogger {
private:
    static std::ofstream log_file;
    static LogLevel min_level;
    
public:
    template<typename... Args>
    static void log(LogLevel level, const char* format, Args... args) {
        if (level < min_level) return;
        
        auto now = std::chrono::system_clock::now();
        auto time_t = std::chrono::system_clock::to_time_t(now);
        
        std::string message = fmt::format(format, args...);
        std::string level_str = get_level_string(level);
        
        // Log to file
        if (log_file.is_open()) {
            log_file << fmt::format("[{}] {} - {}\n", 
                                   time_t, level_str, message);
            log_file.flush();
        }
        
        // Also log to console for ERROR and above
        if (level >= LOG_LEVEL_ERROR) {
            fprintf(stderr, "[%s] %s\n", level_str.c_str(), message.c_str());
        }
    }
    
    static const char* get_level_string(LogLevel level) {
        switch(level) {
            case LOG_LEVEL_DEBUG: return "DEBUG";
            case LOG_LEVEL_INFO: return "INFO";
            case LOG_LEVEL_WARN: return "WARN";
            case LOG_LEVEL_ERROR: return "ERROR";
            case LOG_LEVEL_CRITICAL: return "CRITICAL";
            default: return "UNKNOWN";
        }
    }
};

// Convenience macros
#define LOG_DEBUG(...) AccessoryLogger::log(LOG_LEVEL_DEBUG, __VA_ARGS__)
#define LOG_INFO(...) AccessoryLogger::log(LOG_LEVEL_INFO, __VA_ARGS__)
#define LOG_WARN(...) AccessoryLogger::log(LOG_LEVEL_WARN, __VA_ARGS__)
#define LOG_ERROR(...) AccessoryLogger::log(LOG_LEVEL_ERROR, __VA_ARGS__)
#define LOG_CRITICAL(...) AccessoryLogger::log(LOG_LEVEL_CRITICAL, __VA_ARGS__)

// Specific accessory issue logging
#define LOG_ACCESSORY_ISSUE(slot, char_name, issue) \
    LOG_ERROR("Accessory issue in slot {} for character '{}': {}", \
              slot, char_name, issue)

#endif // ROSE_COMMON_LOG_H
```

## Debug Build Assertions

### Add Debug-Only Checks
```cpp
#ifdef _DEBUG
    #define ASSERT_VALID_EQUIP_SLOT(slot) \
        do { \
            if ((slot) < 0 || (slot) >= MAX_EQUIP_IDX) { \
                LOG_ERROR("Invalid equipment slot: {} at {}:{}", \
                         (slot), __FILE__, __LINE__); \
                assert(false); \
            } \
        } while(0)
    
    #define ASSERT_VALID_PART_IDX(idx) \
        do { \
            if ((idx) != BODY_PART_INVALID && \
                ((idx) < 0 || (idx) >= MAX_BODY_PART)) { \
                LOG_ERROR("Invalid part index: {} at {}:{}", \
                         (idx), __FILE__, __LINE__); \
                assert(false); \
            } \
        } while(0)
#else
    #define ASSERT_VALID_EQUIP_SLOT(slot) ((void)0)
    #define ASSERT_VALID_PART_IDX(idx) ((void)0)
#endif
```

## Runtime Configuration

### Add Server Configuration Options
**File**: `server.toml` or equivalent config

```toml
[safety]
# How to handle accessory slot errors
# Options: "crash", "log", "fix"
accessory_error_mode = "log"

# Auto-relocate accessories to safe slots
auto_fix_accessories = true

# Log all accessory operations for debugging
verbose_accessory_logging = false

# Maximum number of accessory errors before disconnecting player
max_accessory_errors_per_player = 10
```

### Configuration Handler
```cpp
struct SafetyConfig {
    enum ErrorMode {
        CRASH,    // Original behavior
        LOG,      // Log and continue
        FIX       // Log and auto-fix
    };
    
    ErrorMode accessory_error_mode = LOG;
    bool auto_fix_accessories = true;
    bool verbose_logging = false;
    int max_errors_per_player = 10;
    
    static SafetyConfig& get() {
        static SafetyConfig instance;
        return instance;
    }
};

// Use in error handlers
if (SafetyConfig::get().accessory_error_mode == SafetyConfig::CRASH) {
    abort();  // Original behavior
} else if (SafetyConfig::get().accessory_error_mode == SafetyConfig::LOG) {
    LOG_ERROR("Accessory error: {}", error_msg);
} else {
    LOG_WARN("Accessory error (auto-fixing): {}", error_msg);
    // Apply fix
}
```

## Monitoring and Alerting

### Server Health Check
```cpp
class AccessoryMonitor {
    struct PlayerStats {
        int accessory_errors = 0;
        std::chrono::steady_clock::time_point last_error;
    };
    
    std::unordered_map<uint32_t, PlayerStats> player_stats;
    
public:
    void report_error(uint32_t player_id, const std::string& error) {
        auto& stats = player_stats[player_id];
        stats.accessory_errors++;
        stats.last_error = std::chrono::steady_clock::now();
        
        LOG_WARN("Player {} accessory error #{}: {}", 
                 player_id, stats.accessory_errors, error);
        
        if (stats.accessory_errors >= SafetyConfig::get().max_errors_per_player) {
            LOG_ERROR("Player {} exceeded max accessory errors - disconnecting", 
                     player_id);
            // Disconnect player to prevent further issues
        }
    }
    
    void generate_report() {
        LOG_INFO("=== Accessory Error Report ===");
        for (const auto& [player_id, stats] : player_stats) {
            LOG_INFO("Player {}: {} errors", player_id, stats.accessory_errors);
        }
    }
};
```

## Testing Recommendations

1. **Add Unit Tests** for boundary conditions:
   - Test `inventory2part()` with all valid slots (0-11)
   - Test with invalid negative and large values
   - Verify BODY_PART_INVALID is returned for accessories

2. **Integration Tests**:
   - Create test characters with accessories equipped
   - Verify they load without crashing
   - Check logs for appropriate warnings

3. **Stress Testing**:
   - Load multiple characters with corrupted slots
   - Verify server remains stable
   - Monitor memory usage for leaks

## Implementation Priority

1. **Critical** - Fix `inventory2part()` bounds checking
2. **High** - Add safety checks in character loading
3. **Medium** - Implement comprehensive logging
4. **Low** - Add configuration options and monitoring

## Benefits

- **Server Stability**: Converts crashes into logged warnings
- **Player Experience**: Characters remain playable even with data issues
- **Debugging**: Detailed logs help identify problem patterns
- **Monitoring**: Track frequency and patterns of issues
- **Graceful Degradation**: Server continues running while issues are fixed

## Notes

- These changes are defensive measures, not permanent solutions
- The root cause in `inventory2part()` still needs fixing
- Logs should be monitored regularly for accessory issues
- Consider automatic alerts when error rates spike

---

*Document created: 2025-01-10*
*Purpose: Defensive programming to prevent accessory-related crashes*
*Strategy: Log and continue rather than crash*