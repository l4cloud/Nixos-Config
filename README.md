# NixOS Configuration

Flake-based NixOS configuration for a ThinkPad (AMD) running Hyprland on the unstable channel.

## Structure

```
/etc/nixos/
├── flake.nix                  Flake entry point (inputs, outputs)
├── configuration.nix          System-level config (boot, networking, users, systemd)
├── desktop.nix                DE/WM, audio, Bluetooth, lid management
├── hardware-configuration.nix Auto-generated hardware setup (disks, kernel modules)
├── home.nix                   Home-manager config for user `lu` (packages, Hyprland, env)
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

- **Hostname**: `nixos`
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

When the laptop lid is **closed**:

1. Hyprland turns off the displays via `dpms off`
2. A udev rule detects the lid-close event and starts a systemd timer

If the lid stays closed for **30 minutes** (and the laptop is on battery):

3. The system powers off automatically

The 30-minute shutdown timer is **cancelled** if the lid is reopened before the time elapses. This behavior is defined in `desktop.nix`.

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

## Version

- **NixOS state version**: `26.05`
- **Flake description**: `My nixos setup for my thinkpad`
