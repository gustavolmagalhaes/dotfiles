# NixOS Flake Configuration

A modular NixOS configuration inspired by [afsc19/nixos-config](https://github.com/afsc19/nixos-config) and [diogotcorreia's dotfiles](https://github.com/diogotcorreia/dotfiles), structured around **modules** and **profiles** for clarity and ease of maintenance.

---

## Architecture & Directory Structure

```text
.
├── config/                  # Static application configurations and assets
│   └── niri/                # Niri KDL configuration files (config.kdl, monitor.kdl, noctalia.kdl)
├── hosts/                   # System host definitions
│   └── ace/                 # Host 'ace' (imports profiles and hardware configuration)
│       ├── default.nix
│       └── hardware-configuration.nix
├── lib/                     # Helper library and automatic importers
│   ├── default.nix          # Extends lib with lib.my
│   ├── generators.nix       # mkHosts, mkHost, mkProfiles, mkOverlays, mkPkgs
│   └── importers.nix        # rakeLeaves and recursive file gatherers
├── modules/                 # Modular options and definitions (automatically imported)
│   ├── dev/                 # Development modules (e.g. ist / prolog)
│   ├── graphical/           # GUI, Niri, Noctalia, Fuzzel, Browsers, Terminals, Apps
│   ├── home.nix             # Home Manager & user account bridge (provides 'hm' and 'usr')
│   ├── services/            # Services (e.g. greetd, pipewire)
│   ├── shell/               # Shells & CLI tools (zsh, bash, git)
│   ├── system.nix           # Base system defaults (nix experimental features, system packages)
│   └── virtualization/      # Virtualization (VirtualBox guest additions)
├── overlays/                # Custom Nixpkgs overlays (auto-applied)
├── profiles/                # Curated bundles of modules and packages (no options)
│   ├── dev/                 # Dev profiles (ist.nix)
│   ├── graphical/           # Desktop profiles (niri.nix, browsers.nix, terminals.nix, apps.nix)
│   ├── shell/               # CLI profiles (essential.nix)
│   └── virtualization/      # Virtualization profiles (vm.nix)
└── flake.nix                # Flake entry point
```

---

## How It Works

### 1. `modules/` (Options & Implementation)
- Every file in `modules/` is automatically discovered by `lib.my.rakeLeaves` and loaded into each host.
- Modules declare options under `modules.<category>.<name>.enable` (using `lib.mkEnableOption`) and implement behavior with `lib.mkIf cfg.enable`.
- **Seamless Home Manager integration:** `modules/home.nix` creates the `hm` option alias. Any module can configure both NixOS and Home Manager in the same file:
  ```nix
  { config, lib, pkgs, ... }:
  let
    cfg = config.modules.graphical.terminal.ghostty;
  in {
    options.modules.graphical.terminal.ghostty.enable = lib.mkEnableOption "Ghostty Terminal";

    config = lib.mkIf cfg.enable {
      hm.programs.ghostty = {
        enable = true;
        ...
      };
    };
  }
  ```

### 2. `profiles/` (Compositions & Bundles)
- Profiles do not declare options. Instead, they activate modules and/or install bundles of packages for a specific role.
- All profiles are gathered into the `profiles` attribute set.
- Example (`profiles/graphical/niri.nix`):
  ```nix
  { pkgs, ... }:
  {
    modules.graphical = {
      niri.enable = true;
      noctalia.enable = true;
      fuzzel.enable = true;
    };
    modules.services = {
      greetd.enable = true;
      pipewire.enable = true;
    };
    fonts.packages = with pkgs; [ nerd-fonts.jetbrains-mono ];
  }
  ```

### 3. `hosts/` (Per-Machine Configuration)
- Each directory in `hosts/` defines a host. `default.nix` simply imports desired profiles and defines machine-specific settings:
  ```nix
  { profiles, ... }:
  {
    imports = with profiles; [
      graphical.niri
      graphical.browsers
      graphical.terminals
      graphical.apps
      shell.essential
      dev.ist
      virtualization.vm
    ];

    time.timeZone = "Europe/Lisbon";
    boot.loader.systemd-boot.enable = true;
    system.stateVersion = "26.05";
  }
  ```
- Any additional `.nix` files (like `hardware-configuration.nix`) in the host directory are automatically included.

### 4. `config/` (Static Assets)
- Holds non-Nix configuration files (like Niri KDL files in `config/niri/`).
- Modules can access this directory through the `configDir` parameter passed automatically via `extraArgs`.

---

## Usage

### Rebuilding the System
```bash
sudo nixos-rebuild switch --flake .#ace
```

### Checking the Flake
```bash
nix flake check
```
