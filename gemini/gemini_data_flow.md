# Project Data Flow

This document outlines the data flow for the `rose-next-classic` project, from the development data files to the final client and server builds.

## 1. Data Source (`.csv`)

The canonical source of all game data is a set of `.csv` files, likely located in a development directory such as `dev/`. These files are used for editing and version control.

## 2. Asset Pipeline (`pipeline.exe`)

The `pipeline.exe` utility processes the `.csv` data files and converts them into the binary `.stb` (STB Table) format.

## 3. Data Consumption

### Server
The server always loads the raw `.stb` files directly from its `server/data/` directory. This directory is populated with the compiled `.stb` files during the build process.

### Client
The client's data access method depends on the build environment:

*   **Development Builds:** For easier debugging and iteration, the development client loads the unpacked `.stb` files directly from the build output directory (e.g., `dist/release/client/debug/3ddata/stb/`).

*   **Distribution Builds:** For the final release, the `dist.ps1` script is used to package the entire `3ddata` directory (which includes all `.stb` files, models, textures, etc.) into a single virtual file system archive (`.vfs`). The distributed client then reads all its data from this `.vfs` file.

---

_Last Updated: 2025-08-05_
_Maintainer: Gemini / Developer: JDoeBoy
_File Version: 1.2_