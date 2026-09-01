# NixOS Configuration

Flake-based NixOS configuration for two machines on the unstable channel:
- `e14` — ThinkPad (AMD) daily driver, Hyprland.
- `desktop` — NVIDIA gaming PC, KDE Plasma with a SteamOS-style "game mode".

## Desktop Workflow

The daily-driver setup is a keyboard-driven, terminal-native workflow on Wayland.

| Component    | Role                                                  |
|--------------|-------------------------------------------------------|
| **Hyprland** | Tiling Wayland compositor (`programs.hyprland.enable` in `modules/desktop/hyprland.nix`, keybinds and env vars in `home/lu/hyprland.nix`). Displays power off on lid close via `hyprctl dispatch dpms off` and turn back on when reopened. |
| **Noctalia** | A toolkit/app from `github:noctalia-dev/noctalia` — installed via the flake input and bundled into `home.packages`. |
| **Kitty**    | GPU-accelerated terminal emulator. The primary terminal for shell, editors, and multiplexers. |
| **Neovim**   | Modal editor (installed via `home.packages`). Used as the main code editor alongside LSP tooling (`terraform-ls`, `lua`, `luarocks`). |
| **Zellij**   | Terminal multiplexer with a native UI (tabs, panes, status bar). Replaces tmux for session management inside Kitty. |
| **tmux**     | Available system-wide (`environment.systemPackages`) as a fallback multiplexer. |
| **Starship** | Cross-shell prompt with Git-aware indicators — styled for zsh. |
| **ly**       | Console-based display manager with a colormix animation — launches Hyprland after login. |

This stack keeps everything on Wayland: Hyprland → Kitty → Zellij → Neovim, with Noctalia providing additional desktop utilities.

## Dotfiles

Configuration files for the apps above (Hyprland, Kitty, Neovim, Zellij, etc.) are managed separately in [l4cloud/dotfiles](https://github.com/l4cloud/dotfiles) and linked into `$HOME` via [GNU Stow](https://www.gnu.org/software/stow/). Home-manager handles **package installation** in this repo; `stow` handles the **config files** in the dotfiles repo. The two are designed to be used together — clone the dotfiles and run `stow .` to complete the setup.

## Structure

```
/etc/nixos/
├── flake.nix                  Flake entry point (inputs, outputs, formatter)
├── flake.lock
├── hosts/
│   └── e14/                   Per-machine entry point
│       ├── default.nix        Imports shared modules + hardware config
│       └── hardware-configuration.nix  Auto-generated hardware setup
│   └── desktop/               Gaming PC entry point
│       ├── default.nix        Imports shared modules + hardware config
│       └── hardware-configuration.nix  Placeholder (replace after install)
├── modules/
│   ├── system/                Boot, locale, network, user, packages, nix, displaylink
│   ├── desktop/               Hyprland, audio, bluetooth, lid-power, graphics, misc
│   └── services/              Docker, power profile, nixos-owner
├── home/
│   └── lu/                    Home-manager config for user `lu`
│       ├── default.nix
│       ├── git.nix
│       ├── hyprland.nix
│       └── packages/          tools, desktop, dev, lsp
├── overlays/
│   └── displaylink.nix
├── .gitignore
└── README.md
```

## Applying Changes

```bash
sudo nixos-rebuild switch --flake /etc/nixos
```

To build without switching (dry-run):

```bash
nixos-rebuild build --flake /etc/nixos
```

## Features

### Boot & Kernel

- **Bootloader**: systemd-boot with EFI
- **Kernel**: `linuxPackages_latest` (the latest mainline kernel branch)

### Networking

- **Hostname**: `e14`
- **Manager**: NetworkManager
- Wi-Fi, wired, and VPN connections are handled through `nmcli`, `nmtui`, or the GUI applet

### Locale & Keyboard

| Setting   | Value                |
|-----------|----------------------|
| Timezone  | `Europe/London`      |
| Locale    | `en_GB.UTF-8` (all)  |
| XKB       | `gb`                 |
| Console   | `uk`                  |

### User

| Field       | Value           |
|-------------|-----------------|
| Username    | `lu`            |
| Shell       | `zsh`           |
| Groups      | `networkmanager`, `wheel`, `video`, `render` |

### Desktop Environment

- **Compositor**: [Hyprland](https://hyprland.org/) (Wayland)
- **Display Manager**: [ly](https://github.com/fairyglade/ly) — console-based login manager with a `colormix` animation

### Audio

- **PipeWire** (modern audio server) with ALSA, PulseAudio, and JACK compatibility
- Legacy PulseAudio is **disabled**

### Bluetooth

- Enabled via `bluetoothd` + [Blueman](https://github.com/blueman-project/blueman) GUI

### Graphics

- Hardware acceleration enabled (`hardware.graphics.enable`)
- Radeon GPU environment variables set in `home.sessionVariables`:
  - `VK_ICD_FILENAMES` → Radeon Vulkan ICD
  - `LIBVA_DRIVER_NAME` → `radeonsi`
  - `LIBVA_DRIVERS_PATH` → Mesa lib dri

### Lid & Power Management

Lid-close behavior depends on power state:

| State               | Behavior                                              |
|---------------------|-------------------------------------------------------|
| On battery          | System suspends                                       |
| Plugged in / docked | Laptop screen (eDP-1) disables; external monitors stay active |

Logind handles the suspend-on-battery logic (`modules/desktop/lid-power.nix`). Hyprland disables/enables the internal display on lid events (`home/lu/hyprland.nix`).

Additionally:

- **UPower** (`services.upower.enable`) provides battery status and suspend/hibernate hooks
- **Power Profiles Daemon** (`services.power-profiles-daemon.enable`) offers power-saver / balanced / performance profiles

### System Packages

Installed system-wide (`environment.systemPackages`):

| Package         | Purpose              |
|-----------------|----------------------|
| vim             | Text editor          |
| wget            | HTTP/FTP downloader  |
| git             | Version control      |
| tmux            | Terminal multiplexer |
| upower          | Power CLI tools      |
| zsh             | Shell                |
| brightnessctl   | Backlight control    |
| libreoffice     | Office suite         |

### Home-manager Packages

#### System Tools

`ripgrep`, `fd`, `fzf`, `jq`, `zellij`, `starship`, `fetch`, `btop`, `stow`, `kitty`, `nautilus`, `nwg-displays`, `adw-gtk3`, `nwg-look`, `yazi`, `samba`, `gvfs`, `qt6ct`, `xclip`

#### Desktop Apps

`libreoffice`, **Helium** (from `github:FKouhai/helium2nix`), **Noctalia** (from `github:noctalia-dev/noctalia`)

#### Development

`gh` (GitHub CLI), `k9s` (Kubernetes), `neovim`, `cargo` + `rustc`, `nodejs`, `lua` + `luarocks`, `go`, `python3`, `uv` + `pipx`, `terraform` + `terraform-ls` + `tflint`, `awscli2`, `azure-cli`, `cloudlens`, `google-cloud-sdk`, `gcc`, `opencode`, `lazygit`

### Flake Inputs

| Input         | Source                                        | Notes                          |
|---------------|-----------------------------------------------|--------------------------------|
| `nixpkgs`     | `nixos-unstable`                              | Rolling NixOS packages         |
| `home-manager`| `github:nix-community/home-manager`           | User environment management    |
| `helium`      | `github:FKouhai/helium2nix/main`             | Custom application             |
| `noctalia`    | `github:noctalia-dev/noctalia`               | Custom application             |

All inputs follow `nixpkgs` to keep a consistent package set.

### Custom Systemd Services

**`nixos-owner.service`** — Runs once at boot to chown `/etc/nixos` to `lu:users` so the config repo is editable without `sudo`.

## Desktop (Gaming)

`desktop` is an NVIDIA gaming box. It autologs into KDE Plasma; launch Steam
manually from there.

| Component     | Detail |
|---------------|--------|
| Desktop       | KDE Plasma 6 + SDDM with autologin (`modules/desktop/kde.nix`) |
| GPU           | NVIDIA (open kernel module) |
| Gaming tools  | Steam, GameMode, MangoHud, Proton-GE, protontricks, Lutris, Heroic, Bottles |
| Perf tweaks   | performance governor, `vm.max_map_count`, NVIDIA power mgmt, `mitigations=off` |
| Browser       | Helium (only home package) |

Apply with: `sudo nixos-rebuild switch --flake /etc/nixos#desktop`

## Version

- **NixOS state version**: `26.05`
- **Flake description**: `My nixos setup for my thinkpad`
