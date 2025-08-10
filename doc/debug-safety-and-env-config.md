# Debug-Only Safety Checks and Environment Configuration

## Overview

This document outlines how to implement defensive safety checks that only run in debug builds, along with clean environment variable configuration strategies for the ROSE server.

## Debug-Only Safety Implementation

### 1. Preprocessor Macro Strategy

**File**: `src/common/include/rose/common/debug_safety.h`

```cpp
#ifndef ROSE_DEBUG_SAFETY_H
#define ROSE_DEBUG_SAFETY_H

// Only include safety checks in debug builds
#ifdef DEBUG
    #define DEBUG_ONLY(x) x
    #define RELEASE_ONLY(x)
#else
    #define DEBUG_ONLY(x)
    #define RELEASE_ONLY(x) x
#endif

// Debug-only bounds checking for accessory slots
#ifdef DEBUG
    #include <cassert>
    #include <iostream>
    
    #define DEBUG_CHECK_EQUIP_SLOT(slot) \
        do { \
            if ((slot) >= EQUIP_IDX_NECKLACE && (slot) <= EQUIP_IDX_EARRING) { \
                std::cerr << "[DEBUG] Warning: Accessory slot " << (slot) \
                         << " accessed at " << __FILE__ << ":" << __LINE__ << std::endl; \
            } \
            if ((slot) < 0 || (slot) >= MAX_EQUIP_IDX) { \
                std::cerr << "[DEBUG] Error: Invalid slot " << (slot) \
                         << " at " << __FILE__ << ":" << __LINE__ << std::endl; \
                assert(false && "Invalid equipment slot"); \
            } \
        } while(0)
    
    #define DEBUG_CHECK_PART_INDEX(idx) \
        do { \
            if ((idx) >= MAX_BODY_PART) { \
                std::cerr << "[DEBUG] Error: Part index " << (idx) \
                         << " out of bounds at " << __FILE__ << ":" << __LINE__ << std::endl; \
                assert(false && "Part index out of bounds"); \
            } \
        } while(0)
    
    #define DEBUG_LOG_ACCESSORY(msg, ...) \
        fprintf(stderr, "[DEBUG ACCESSORY] " msg "\n", ##__VA_ARGS__)
        
#else
    // In release builds, these macros do nothing
    #define DEBUG_CHECK_EQUIP_SLOT(slot) ((void)0)
    #define DEBUG_CHECK_PART_INDEX(idx) ((void)0)
    #define DEBUG_LOG_ACCESSORY(msg, ...) ((void)0)
#endif

// Inline debug-only validation function
inline bool debug_validate_inventory_slot(int slot) {
    DEBUG_ONLY(
        if (slot >= EQUIP_IDX_NECKLACE && slot <= EQUIP_IDX_EARRING) {
            DEBUG_LOG_ACCESSORY("Accessory slot %d detected", slot);
            return false;
        }
    );
    return true;
}

#endif // ROSE_DEBUG_SAFETY_H
```

### 2. Debug-Only inventory2part Safety

**File**: `src/common/shared/datatype.h`

```cpp
#include "rose/common/debug_safety.h"

constexpr size_t inventory2part(size_t inventory_idx) {
    // Debug-only comprehensive logging
    DEBUG_ONLY(
        if (inventory_idx >= EQUIP_IDX_NECKLACE && inventory_idx <= EQUIP_IDX_EARRING) {
            // In debug, we want to know when accessories are being mapped
            static int accessory_warning_count = 0;
            if (++accessory_warning_count <= 10) {  // Limit spam
                fprintf(stderr, "[DEBUG] inventory2part: Accessory slot %zu has no visual part\n", 
                        inventory_idx);
            }
        }
    );
    
    if (inventory_idx == 0 || inventory_idx > EQUIP_IDX_WEAPON_L) {
        return BODY_PART_INVALID;
    }
    
    const size_t map[] = {
        BODY_PART_INVALID,    // 0
        BODY_PART_FACE_ITEM,  // 1
        BODY_PART_HELMET,     // 2
        BODY_PART_ARMOR,      // 3
        BODY_PART_KNAPSACK,   // 4
        BODY_PART_GAUNTLET,   // 5
        BODY_PART_BOOTS,      // 6
        BODY_PART_WEAPON_R,   // 7
        BODY_PART_WEAPON_L,   // 8
    };
    
    // Debug-only bounds assertion
    DEBUG_ONLY(
        assert(inventory_idx < sizeof(map)/sizeof(map[0]) && 
               "inventory2part: Array index out of bounds!");
    );
    
    return map[inventory_idx];
}
```

### 3. Debug Build Configuration

**File**: `CMakeLists.txt` or build configuration

```cmake
# Debug build settings
if(CMAKE_BUILD_TYPE STREQUAL "Debug")
    add_compile_definitions(DEBUG)
    add_compile_definitions(ENABLE_ACCESSORY_CHECKS)
    add_compile_definitions(VERBOSE_DEBUG_LOGGING)
    
    # Debug-only warning flags
    add_compile_options(-Wall -Wextra -Wpedantic)
    add_compile_options(-Warray-bounds -Wformat=2)
endif()

# Release build settings
if(CMAKE_BUILD_TYPE STREQUAL "Release")
    add_compile_definitions(NDEBUG)
    add_compile_options(-O3)
endif()
```

## Environment Variable Configuration

### 1. Clean Environment Variable Handler

**File**: `src/common/include/rose/common/env_config.h`

```cpp
#ifndef ROSE_ENV_CONFIG_H
#define ROSE_ENV_CONFIG_H

#include <string>
#include <cstdlib>
#include <unordered_map>

class EnvConfig {
private:
    // Cache environment variables to avoid repeated getenv calls
    mutable std::unordered_map<std::string, std::string> cache_;
    
    EnvConfig() = default;
    
public:
    static EnvConfig& instance() {
        static EnvConfig instance;
        return instance;
    }
    
    // Get string value with default
    std::string get(const std::string& key, const std::string& default_value = "") const {
        // Check cache first
        auto it = cache_.find(key);
        if (it != cache_.end()) {
            return it->second;
        }
        
        // Get from environment
        const char* value = std::getenv(key.c_str());
        std::string result = value ? value : default_value;
        
        // Cache the result
        cache_[key] = result;
        return result;
    }
    
    // Get integer value with default
    int get_int(const std::string& key, int default_value = 0) const {
        std::string str_value = get(key, std::to_string(default_value));
        try {
            return std::stoi(str_value);
        } catch (...) {
            return default_value;
        }
    }
    
    // Get boolean value with default
    bool get_bool(const std::string& key, bool default_value = false) const {
        std::string str_value = get(key, default_value ? "true" : "false");
        
        // Accept multiple truthy values
        if (str_value == "1" || str_value == "true" || 
            str_value == "TRUE" || str_value == "yes" || 
            str_value == "YES" || str_value == "on" || 
            str_value == "ON") {
            return true;
        }
        return false;
    }
    
    // Check if environment variable exists
    bool exists(const std::string& key) const {
        return std::getenv(key.c_str()) != nullptr;
    }
    
    // Clear cache (useful for testing)
    void clear_cache() {
        cache_.clear();
    }
};

// Convenience macros for common environment variables
#define ENV_GET(key, default) EnvConfig::instance().get(key, default)
#define ENV_GET_INT(key, default) EnvConfig::instance().get_int(key, default)
#define ENV_GET_BOOL(key, default) EnvConfig::instance().get_bool(key, default)

#endif // ROSE_ENV_CONFIG_H
```

### 2. Server Configuration with Environment Variables

**File**: `src/common/include/rose/common/server_config.h`

```cpp
#ifndef ROSE_SERVER_CONFIG_H
#define ROSE_SERVER_CONFIG_H

#include "env_config.h"
#include "debug_safety.h"

struct ServerConfig {
    // Database configuration
    std::string db_host;
    int db_port;
    std::string db_name;
    std::string db_user;
    std::string db_password;
    
    // Server settings
    int server_port;
    std::string server_ip;
    int max_players;
    
    // Debug settings (only active in debug builds)
    bool enable_accessory_checks;
    bool verbose_logging;
    bool crash_on_error;
    int max_debug_warnings;
    
    static ServerConfig& instance() {
        static ServerConfig config;
        static bool initialized = false;
        
        if (!initialized) {
            config.load_from_env();
            initialized = true;
        }
        
        return config;
    }
    
private:
    void load_from_env() {
        // Database configuration with defaults
        db_host = ENV_GET("ROSE_DB_HOST", "localhost");
        db_port = ENV_GET_INT("ROSE_DB_PORT", 5432);
        db_name = ENV_GET("ROSE_DB_NAME", "rose");
        db_user = ENV_GET("ROSE_DB_USER", "rose_user");
        db_password = ENV_GET("ROSE_DB_PASSWORD", "");
        
        // Server configuration
        server_port = ENV_GET_INT("ROSE_SERVER_PORT", 29000);
        server_ip = ENV_GET("ROSE_SERVER_IP", "0.0.0.0");
        max_players = ENV_GET_INT("ROSE_MAX_PLAYERS", 1000);
        
        // Debug-only settings
        #ifdef DEBUG
            enable_accessory_checks = ENV_GET_BOOL("ROSE_DEBUG_ACCESSORY_CHECKS", true);
            verbose_logging = ENV_GET_BOOL("ROSE_DEBUG_VERBOSE", false);
            crash_on_error = ENV_GET_BOOL("ROSE_DEBUG_CRASH_ON_ERROR", false);
            max_debug_warnings = ENV_GET_INT("ROSE_DEBUG_MAX_WARNINGS", 100);
            
            // Print debug configuration on startup
            fprintf(stderr, "[DEBUG] Configuration loaded:\n");
            fprintf(stderr, "  - Accessory checks: %s\n", enable_accessory_checks ? "ON" : "OFF");
            fprintf(stderr, "  - Verbose logging: %s\n", verbose_logging ? "ON" : "OFF");
            fprintf(stderr, "  - Crash on error: %s\n", crash_on_error ? "ON" : "OFF");
            fprintf(stderr, "  - Max warnings: %d\n", max_debug_warnings);
        #else
            // Force disable in release builds
            enable_accessory_checks = false;
            verbose_logging = false;
            crash_on_error = false;
            max_debug_warnings = 0;
        #endif
    }
};

// Convenience macro
#define SERVER_CONFIG ServerConfig::instance()

#endif // ROSE_SERVER_CONFIG_H
```

### 3. Debug-Only Accessory Safety Handler

**File**: `src/sho_gameserver/src/accessory_safety.cpp`

```cpp
#include "rose/common/debug_safety.h"
#include "rose/common/server_config.h"

class AccessorySafetyHandler {
private:
    #ifdef DEBUG
    struct DebugStats {
        int total_warnings = 0;
        int accessory_access_count = 0;
        std::unordered_map<int, int> slot_access_frequency;
    };
    
    static DebugStats debug_stats;
    #endif
    
public:
    static bool validate_equipment_slot(int slot, const char* function_name) {
        #ifdef DEBUG
        if (!SERVER_CONFIG.enable_accessory_checks) {
            return true;  // Skip checks if disabled
        }
        
        debug_stats.total_warnings++;
        
        if (slot >= EQUIP_IDX_NECKLACE && slot <= EQUIP_IDX_EARRING) {
            debug_stats.accessory_access_count++;
            debug_stats.slot_access_frequency[slot]++;
            
            if (SERVER_CONFIG.verbose_logging) {
                fprintf(stderr, "[DEBUG] %s: Accessory slot %d accessed (count: %d)\n",
                        function_name, slot, debug_stats.slot_access_frequency[slot]);
            }
            
            if (SERVER_CONFIG.crash_on_error) {
                assert(false && "Accessory slot accessed in debug mode with crash_on_error");
            }
            
            // Check if we've exceeded max warnings
            if (debug_stats.total_warnings >= SERVER_CONFIG.max_debug_warnings) {
                fprintf(stderr, "[DEBUG] Maximum debug warnings reached (%d). Disabling further checks.\n",
                        SERVER_CONFIG.max_debug_warnings);
                // Disable further checks to avoid spam
                const_cast<ServerConfig&>(SERVER_CONFIG).enable_accessory_checks = false;
            }
            
            return false;  // Invalid slot
        }
        #endif
        
        return true;  // Valid slot (or release build)
    }
    
    static void print_debug_report() {
        #ifdef DEBUG
        if (!SERVER_CONFIG.enable_accessory_checks) {
            return;
        }
        
        fprintf(stderr, "\n=== Accessory Safety Debug Report ===\n");
        fprintf(stderr, "Total warnings: %d\n", debug_stats.total_warnings);
        fprintf(stderr, "Accessory accesses: %d\n", debug_stats.accessory_access_count);
        fprintf(stderr, "Slot frequency:\n");
        for (const auto& [slot, count] : debug_stats.slot_access_frequency) {
            fprintf(stderr, "  Slot %d: %d times\n", slot, count);
        }
        fprintf(stderr, "=====================================\n\n");
        #endif
    }
};

#ifdef DEBUG
AccessorySafetyHandler::DebugStats AccessorySafetyHandler::debug_stats;
#endif

// Macro for easy use
#define VALIDATE_EQUIP_SLOT(slot) \
    AccessorySafetyHandler::validate_equipment_slot(slot, __FUNCTION__)
```

### 4. Example .env File

**File**: `.env.example`

```bash
# Database Configuration
ROSE_DB_HOST=localhost
ROSE_DB_PORT=5432
ROSE_DB_NAME=rose
ROSE_DB_USER=rose_user
ROSE_DB_PASSWORD=your_password_here

# Server Configuration
ROSE_SERVER_PORT=29000
ROSE_SERVER_IP=0.0.0.0
ROSE_MAX_PLAYERS=1000

# Debug Settings (only work in debug builds)
# These are ignored in release builds for safety
ROSE_DEBUG_ACCESSORY_CHECKS=true
ROSE_DEBUG_VERBOSE=false
ROSE_DEBUG_CRASH_ON_ERROR=false
ROSE_DEBUG_MAX_WARNINGS=100

# Logging Configuration
ROSE_LOG_LEVEL=INFO  # DEBUG, INFO, WARN, ERROR
ROSE_LOG_FILE=/var/log/rose/server.log
ROSE_LOG_ROTATE_SIZE=10485760  # 10MB
ROSE_LOG_KEEP_DAYS=7
```

### 5. Docker Compose Integration

**File**: `docker-compose.yml`

```yaml
version: '3.8'

services:
  gameserver:
    build: .
    environment:
      # Production settings
      - ROSE_DB_HOST=${ROSE_DB_HOST:-postgres}
      - ROSE_DB_PORT=${ROSE_DB_PORT:-5432}
      - ROSE_DB_NAME=${ROSE_DB_NAME:-rose}
      - ROSE_DB_USER=${ROSE_DB_USER:-rose_user}
      - ROSE_DB_PASSWORD=${ROSE_DB_PASSWORD}
      - ROSE_SERVER_PORT=${ROSE_SERVER_PORT:-29000}
      
      # Debug settings (only in development)
      - ROSE_DEBUG_ACCESSORY_CHECKS=${ROSE_DEBUG_ACCESSORY_CHECKS:-false}
      - ROSE_DEBUG_VERBOSE=${ROSE_DEBUG_VERBOSE:-false}
    
    # Override for development
    profiles:
      - production
  
  gameserver-debug:
    extends: gameserver
    build:
      context: .
      target: debug  # Use debug build stage
    environment:
      - ROSE_DEBUG_ACCESSORY_CHECKS=true
      - ROSE_DEBUG_VERBOSE=true
      - ROSE_DEBUG_MAX_WARNINGS=1000
    profiles:
      - development
```

## Usage Examples

### 1. Modified Character Loading with Debug Safety

```cpp
// In gs_threadsql.cpp
#include "rose/common/debug_safety.h"

// ... in character loading function
for (size_t row_idx = 0; row_idx < item_res.row_count; ++row_idx) {
    int slot = item_res.get_int32(row_idx, INV_COL_SLOT);
    
    // Debug-only validation
    DEBUG_CHECK_EQUIP_SLOT(slot);
    
    // Debug-only detailed logging
    DEBUG_ONLY(
        if (!VALIDATE_EQUIP_SLOT(slot)) {
            DEBUG_LOG_ACCESSORY("Skipping accessory slot %d for character %s", 
                              slot, user->Get_NAME());
            continue;
        }
    );
    
    size_t part_idx = inventory2part(slot);
    DEBUG_CHECK_PART_INDEX(part_idx);
    
    // ... rest of code
}
```

### 2. CObjAVT with Debug Protection

```cpp
void CObjAVT::SetPartITEM(short nEquipInvIDX) {
    // Debug-only comprehensive validation
    DEBUG_ONLY(
        if (!VALIDATE_EQUIP_SLOT(nEquipInvIDX)) {
            DEBUG_LOG_ACCESSORY("SetPartITEM called with accessory slot %d", 
                              nEquipInvIDX);
            // In debug, we still process but with logging
        }
        
        // Check array bounds in debug
        static const size_t array_size = sizeof(s_nEquipIdxToPartNO) / 
                                        sizeof(s_nEquipIdxToPartNO[0]);
        assert(nEquipInvIDX < array_size && "SetPartITEM: index out of bounds");
    );
    
    // Guard for both debug and release
    if (nEquipInvIDX < 0 || nEquipInvIDX >= 
        (short)(sizeof(s_nEquipIdxToPartNO) / sizeof(s_nEquipIdxToPartNO[0]))) {
        return;
    }
    
    // ... rest of function
}
```

## Build Commands

```bash
# Debug build with all safety checks
cmake -DCMAKE_BUILD_TYPE=Debug ..
make

# Release build with no debug code
cmake -DCMAKE_BUILD_TYPE=Release ..
make

# Run with debug environment
ROSE_DEBUG_ACCESSORY_CHECKS=true \
ROSE_DEBUG_VERBOSE=true \
ROSE_DEBUG_MAX_WARNINGS=500 \
./gameserver

# Run in production (debug vars ignored in release build)
ROSE_DB_HOST=prod-db.example.com \
ROSE_DB_PASSWORD=secure_password \
./gameserver
```

## Benefits

1. **Zero Performance Impact in Production**: All debug code is compiled out in release builds
2. **Clean Environment Configuration**: Centralized, cached, type-safe environment variable handling
3. **Flexible Debug Control**: Fine-grained control over debug behavior via environment variables
4. **Safety Without Risk**: Debug builds catch issues, release builds run at full speed
5. **Clear Separation**: Debug and production configurations are clearly separated

## Testing Strategy

```cpp
// Unit test example
#ifdef DEBUG
TEST(AccessorySafety, DetectsInvalidSlots) {
    // Enable checks for test
    setenv("ROSE_DEBUG_ACCESSORY_CHECKS", "true", 1);
    setenv("ROSE_DEBUG_CRASH_ON_ERROR", "false", 1);
    
    // This should trigger debug warning but not crash
    EXPECT_FALSE(VALIDATE_EQUIP_SLOT(EQUIP_IDX_EARRING));
    
    // This should pass
    EXPECT_TRUE(VALIDATE_EQUIP_SLOT(EQUIP_IDX_HELMET));
}
#endif
```

---

*Document created: 2025-01-10*
*Purpose: Debug-only safety implementation with clean environment configuration*
*Principle: Zero cost in production, maximum safety in development*