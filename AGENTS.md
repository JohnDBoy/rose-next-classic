# Repository Guidelines

## Project Structure & Modules
- `src/`: Core code. Mixed C++ (Visual Studio projects) and Rust workspace (`Cargo.toml` with `common-lib`, `pipeline`).
- `thirdparty/`: External C/C++ libs built via `thirdparty.sln`.
- `scripts/`: PowerShell and Python utilities for build, assets, formatting, and dev setup.
- `database/`: SQL migrations and squashed dumps.
- `website/`: Website (Docker-based) with helper scripts.
- `tools/`, `bin/`, `dev/`: Tooling, build outputs, and symlinked dev runtime created by scripts.

## Build, Test, and Dev Commands
- `just build-all [config]`: Build Rust crates, third-party, and C++ (defaults `release`).
- `just build [config]`: Build code only (Rust + C++).
- `just build-assets [config]`: Bake/pack game assets via `pipeline`.
- `just dev-setup`: Create `dev/` links for client and server assets.
- `just client [config]`: Launch client. Use `just cld|clr key=NAME` for auto-connect via env.
- `just server-all [config]`: Run `loginserver`, `worldserver`, `gameserver` (or `just ls|ws|gs`).
Examples: `just build-all debug`, `just server-all release`.

## Coding Style & Naming
- C++: Follow `.clang-format` (4-space indent, no tabs, 100 cols, brace style Attach). Format with `python scripts/format_code.py [-v]`.
- Rust: Use stable `i686-pc-windows-msvc` toolchain (see README “Build”). Prefer `rustfmt` defaults if editing Rust.
- Paths and projects: Keep code under existing module folders; avoid adding new top-levels without discussion.

## Testing Guidelines
- No formal unit test suite in-tree. Validate changes by:
  - Building both `debug` and `release`.
  - Running `just server-all` and `just client` (use a test account; see `scripts/generate-password.py`).
  - Exercising affected gameplay/system flows and watching server logs.

## Commit & Pull Requests
- Commits: Use concise, imperative subjects; include context and reference issues (e.g., `Fix sound bug (#15)`). Group related changes.
- PRs: Provide summary, reproduction/risk notes, linked issues, and screenshots/log snippets when visual or runtime behavior changes. Note config/db impacts and any Windows/Rust toolchain requirements.

## Security & Configuration
- Server config: Start from `doc/server.toml.example` and place `dev/server/server.toml`.
- Secrets: Use local env for client auto-connect (see `scripts/dev-client.ps1`). Do not commit credentials or dumps with PII.
