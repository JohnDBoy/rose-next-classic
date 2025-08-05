# Rose Next Classic - Build Instructions

This document provides a structured, step-by-step guide to building the `rose-next-classic` project.

## Build Order & Configurations

The project must be built in a specific order. A critical requirement is that **all C++ projects must be built in Debug mode first, before building in Release mode.**

1.  **Rust Dependencies**
    *   **Requirement**: Requires the `stable-i686-pc-windows-msvc` Rust toolchain.
    *   **Build Order**: Build these first.
    *   **Configurations**: Must be built in **Debug**, then **Release**.

2.  **Third-Party C++ Dependencies (`thirdparty.sln`)**
    *   **Projects**: `expat`, `flatc`, `fmt`, `libpq`, `lua4`, `zlib`, and other third-party libraries.
    *   **Build Order**: Build this solution second.
    *   **Configurations**: Must be built in **Debug**, then **Release**.

3.  **Main C++ Solution (`rose-next.sln`)**
    *   **Projects**: `client`, `sho_loginserver`, `sho_worldserver`, `sho_gameserver`, `pipeline`, etc.
    *   **Build Order**: Build this solution third.
    *   **Configurations**: Must be built in **Debug**, then **Release**.

4.  **Game Assets**
    *   **Build Order**: Build assets last.
    *   **Requirement**: This step requires the `pipeline.exe` tool, which is built from the `rose-next.sln` solution.

---

## Step 1: Build Rust Dependencies

The project uses some Rust crates that must be compiled before the C++ solutions. These must be built with the 32-bit MSVC toolchain.

### Instructions

1.  Open a PowerShell terminal.
2.  Install the required Rust toolchain:
    ```powershell
    rustup toolchain install stable-i686-pc-windows-msvc
    ```
3.  Navigate to the `src/` directory:
    ```powershell
    cd src
    ```
4.  Set the toolchain override for the directory:
    ```powershell
    rustup override set stable-i686-pc-windows-msvc
    ```
5.  Build the Rust crates for both Debug and Release configurations:
    ```powershell
    # Build Debug crates
    cargo build

    # Build Release crates
    cargo build --release
    ```

---

## Step 2: Build Third-Party Dependencies (`thirdparty.sln`)

The main project depends on several external libraries for functionality like database connections (`libpq`), data compression (`zlib`), and XML parsing (`expat`). These must be compiled before building the main project.

### Instructions

1.  Open the `d:\RoseNext\rose-next-classic\thirdparty.sln` file in Visual Studio.
2.  Select the **Debug** configuration from the dropdown menu in the toolbar.
3.  Build the entire solution by selecting **Build > Build Solution** (or by pressing `Ctrl+Shift+B`).
4.  Once the Debug build is complete, select the **Release** configuration from the dropdown menu.
5.  Build the solution again.

It is critical to build both configurations, as the main project will link against the corresponding versions of these libraries.

---

## Step 3: Build Main Solution (`rose-next.sln`)

With the third-party dependencies compiled, you can now build the main project executables, including the client, servers, and asset pipeline tool.

### Instructions

1.  Open the `d:\RoseNext\rose-next-classic\rose-next.sln` file in Visual Studio.
2.  Select the **Debug** configuration from the dropdown menu.
3.  Build the entire solution (**Build > Build Solution** or `Ctrl+Shift+B`).
4.  Once complete, select the **Release** configuration.
5.  Build the solution again.

---

## Step 4: Build Game Assets

The game client and servers require data files (e.g., models, textures, sounds) to be processed and packed into an optimized format. This is handled by the `pipeline.exe` tool, which was compiled in the previous step.

The asset build process is controlled by two manifest files:
*   `assets/bake.manifest`: Defines rules for processing raw source assets.
*   `assets/pack.manifest`: Defines rules for packing baked assets into virtual file system (`.VFS`) archives.

### Instructions

The easiest way to build the assets is to run the provided PowerShell script.

1.  Open a PowerShell terminal.
2.  Navigate to the project's root directory: `d:\RoseNext\rose-next-classic\`.
3.  Execute the build script for both Debug and Release configurations:
    ```powershell
    # Build Debug assets
    .\scripts\build-assets.ps1 -config debug

    # Build Release assets
    .\scripts\build-assets.ps1 -config release
    ```
This will create the necessary `3ddata`, `sound`, and other asset folders inside the `bin/assets/debug` and `bin/assets/release` directories.

**Note:** You must re-run the `dev-setup.ps1` script (Step 5) after building assets to ensure the symbolic links are updated.

---

## Step 5: Development Environment Setup

To run the client and servers from Visual Studio or the command line, they need to be able to find the compiled assets and configuration files. A setup script is provided to create a `dev/` directory with the necessary structure and symbolic links.

### Instructions

1.  **Run the Setup Script**:
    Open a PowerShell terminal in the project root and run:
    ```powershell
    .\scripts\dev-setup.ps1
    ```
    This script creates symbolic links from `dev/client/` and `dev/server/` to the compiled assets in `bin/assets/`. This allows the executables to find their data files when run from the `dev/` directory.

2.  **Configure the Servers**:
    - Copy `doc/server.toml.example` to `dev/server/server.toml`.
    - Edit `dev/server/server.toml` and update the `[database]` section with your PostgreSQL connection details (username, password, database name).

3.  **Configure Client Auto-Connect (Optional)**:
    - Copy `doc/.env.example` to the project root as `.env`.
    - Edit the `.env` file with the account credentials you want to use for the auto-connect feature.

With these steps complete, you can now run the servers and client.

---

## Step 6: Running the Project

The servers must be started in a specific order: Login Server, then World Server, then Game Server.

### Instructions

1.  **Start the Login Server**:
    - Navigate to `dev/server/` and run `sho_loginserver.exe`.

2.  **Start the World Server**:
    - Navigate to `dev/server/` and run `sho_worldserver.exe`.

3.  **Start the Game Server**:
    - Navigate to `dev/server/` and run `sho_gameserver.exe`.

4.  **Start the Client**:
    - Navigate to `dev/client/` and run `rosenext.exe`.

---

## Appendix: Justfile Quickstart

The project includes a `Justfile` to automate common tasks. Just is a command runner, similar to `make`.

### Build Recipes

*   **`just build config=CONFIG`**
    *   **Description**: Builds the C++ code projects (`thirdparty.sln` and `rose-next.sln`).
    *   **`CONFIG`**: `debug` or `release`.
*   **`just build-all config=CONFIG`**
    *   **Description**: Builds both the C++ code and the game assets.
    *   **`CONFIG`**: `debug` or `release`.
*   **`just build-assets config=CONFIG`**
    *   **Description**: Builds the game assets using the `pipeline.exe` tool.
    *   **`CONFIG`**: `debug` or `release`.

### Environment & Running Recipes

*   **`just dev-setup`**
    *   **Description**: Sets up the development environment by building release assets and creating symbolic links in the `dev/` directory.
*   **`just client config=CONFIG`**
    *   **Description**: Starts the game client.
    *   **`CONFIG`**: `debug` or `release`.
*   **`just client-auto key=KEY`**
    *   **Description**: Starts the client and automatically connects to the server using credentials defined in the `.env` file.
    *   **`KEY`**: The prefix for the environment variables (e.g., `RALPH` for `RALPH_USERNAME`).
*   **`just server-all config=CONFIG`**
    *   **Description**: Starts all three servers (`loginserver`, `worldserver`, `gameserver`) in the correct order.
    *   **`CONFIG`**: `debug` or `release`.
*   **`just loginserver | worldserver | gameserver config=CONFIG`**
    *   **Description**: Starts a specific server.
    *   **`CONFIG`**: `debug` or `release`.

---

## Appendix: Developer & Contributor Notes

This project uses a set of helper scripts and documentation located in the `gemini/` directory to assist with development and maintenance. For instructions on how to use these tools and interact with the AI coding assistant, please refer to the following guide:

*   **`gemini/How_to_gemini.md`**: A step-by-step checklist for starting a new development session with Gemini Code Assist.

---

_Last Updated: 2025-08-04_  
_Maintainer: Gemini / Developer JDoeBoy  
_File Version: 1.1_
