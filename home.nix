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


    # Dev Packages
    gh
    k9s
    neovim
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
    tflint
    awscli2
    azure-cli
    cloudlens
    google-cloud-sdk
    gcc
    terraform-ls
    opencode
    lazygit
  ];

  home.sessionVariables = {
    VK_ICD_FILENAMES = "/run/opengl-driver/share/vulkan/icd.d/radeon_icd.x86_64.json";
    LIBVA_DRIVER_NAME = "radeonsi";
    LIBVA_DRIVERS_PATH = "/run/opengl-driver/lib/dri";
  };

  wayland.windowManager.hyprland.settings = {
    bindl = [
      "switch:on:Lid Switch, exec, hyprctl dispatch dpms off"
      "switch:off:Lid Switch, exec, hyprctl dispatch dpms on"
    ];
    env = [
      "QT_QPA_PLATFORMTHEME,qt6ct"
      "VK_ICD_FILENAMES,/run/opengl-driver/share/vulkan/icd.d/radeon_icd.x86_64.json"
      "LIBVA_DRIVER_NAME,radeonsi"
      "LIBVA_DRIVERS_PATH,/run/opengl-driver/lib/dri"
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
