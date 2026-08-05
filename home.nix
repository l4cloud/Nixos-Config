{ pkgs, inputs,  ... }:

{
  home.username = "lu";
  home.homeDirectory = "/home/lu";
  home.stateVersion = "26.05";

  home.packages = with pkgs; [

    # System Tools
    ripgrep
    fd
    fzf
    jq
    toolong
    zellij 
    zsh
    starship
    fetch
    btop
    stow
    kitty
    nautilus
    nwg-displays
    adw-gtk3
    nwg-look
    yazi
    samba
    gvfs
    kdePackages.qt6ct
    xclip

    # Desktop Apps
    libreoffice
    inputs.helium.defaultPackage.${pkgs.stdenv.hostPlatform.system}
    inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
    anki-bin


    # Dev Packages
    gh
    k9s
    neovim
    typescript
    cargo
    rustc
    nodejs
    lua
    luarocks
    go
    python3
    uv
    pipx
    terraform
    awscli2
    azure-cli
    cloudlens
    google-cloud-sdk
    gcc
    opencode
    lazygit
    unzip
  ];

  home.sessionVariables = {
    VK_ICD_FILENAMES = "/run/opengl-driver/share/vulkan/icd.d/radeon_icd.x86_64.json";
    LIBVA_DRIVER_NAME = "radeonsi";
    LIBVA_DRIVERS_PATH = "/run/opengl-driver/lib/dri";
  };

  wayland.windowManager.hyprland.settings = {
    env = [
      "QT_QPA_PLATFORMTHEME,qt6ct"
      "VK_ICD_FILENAMES,/run/opengl-driver/share/vulkan/icd.d/radeon_icd.x86_64.json"
      "LIBVA_DRIVER_NAME,radeonsi"
      "LIBVA_DRIVERS_PATH,/run/opengl-driver/lib/dri"
      "AQ_DRM_DEVICES,/dev/dri/card0:/dev/dri/card1"
    ] ;
  };

  programs.git = {
    enable = true;
    settings.user = {
      name = "lu";
      email = "lculleton@protonmail.com";
    };
  };
} 
