<img src="https://raw.githubusercontent.com/jsdotlua/branding/main/Logo.png" align="right" height="128"/>

# stronk-jest

Stronk’s fork of `jsdotlua/jest-lua` (baseline: `v3.10.0`).

[![Tests](https://github.com/EYYCHEEV/stronk-jest/actions/workflows/test.yml/badge.svg)](https://github.com/EYYCHEEV/stronk-jest/actions/workflows/test.yml)

---

This repo keeps a minimal Stronk-specific patch set required for Roblox game runtime constraints (e.g. `debug.loadmodule` fallback / `ModuleScript.Source` capability handling), and publishes Wally packages under the `eyycheev/*` namespace using explicit `-stronk.N` versions.

## Wally packages

- `eyycheev/stronk-jest`
- `eyycheev/jest-core`
- `eyycheev/jest-circus`
- `eyycheev/jest-runner`
- `eyycheev/jest-runtime`
- `eyycheev/stronk-jest-globals`

## Installation (Wally)

Add this package to your `dev-dependencies` in your `wally.toml`, for example:

```toml
StronkJest = "eyycheev/stronk-jest@3.10.0-stronk.7"
JestGlobals = "eyycheev/stronk-jest-globals@3.10.0-stronk.7"
```

Then, require anything you need from `JestGlobals`:

```lua
local JestGlobals = require("@Packages/JestGlobals")
local expect = JestGlobals.expect
```

## Publishing (Wally)

1. Edit source-of-truth code in this repo (do not edit generated installs in downstream projects).
2. Bump `version` in the relevant `wally.toml` files to a new `-stronk.N`.
3. Build publishable Roblox/Wally outputs:
   - One-time: install pinned CLI tools via Foreman (`foreman.toml`): `foreman install`
   - Install JS deps: `yarn install --immutable`
   - Build outputs: `yarn build:wally:stronk` (outputs to `build/stronk-wally/`).
4. Publish in dependency order from `build/stronk-wally/*`:
   `jest-runtime` → `jest-circus` → `jest-runner` → `jest-core` → `stronk-jest` → `stronk-jest-globals`.
5. In downstream projects, run `wally install` and regenerate any alias modules.

Why the build step? The upstream `jsdotlua/jest-lua` sources use `require("@pkg/...")`, which is not valid in Roblox runtime. The build pipeline (Rojo sourcemap + Darklua require conversion) produces Roblox-ready `require(script.Parent:WaitForChild(...))` paths for Wally-installed packages.

## Contributing

This repository is intentionally maintained separately from upstream GitHub fork networks. If GitHub still shows this repo as part of a fork network, request GitHub Support to detach it.

## License

MIT. See [LICENSE](LICENSE).
