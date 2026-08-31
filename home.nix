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
    jetbrains-mono
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
    discord-ptb


    # Dev Packages
    gh
    k9s
    neovim
    typescript
    supabase-cli
    cargo
    rustc
    nodejs
    lua
    luarocks
    go
    python3
    uv
    pipx
    kubectl
    kubernetes-helm
    svelte-language-server
    terraform
    awscli2
    azure-cli
    cloudlens
    google-cloud-sdk
    gcc
    opencode
    lazygit
    lazydocker
    docker
    unzip

    # LSP servers & editor tooling (managed via Nix on NixOS, not mason)
    gopls
    python3Packages.python-lsp-server
    terraform-ls
    tflint
    jdt-language-server
    lua-language-server
    typescript-language-server
    vscode-langservers-extracted # eslint + html language servers
    emmet-language-server
    bash-language-server
    yaml-language-server
    stylua
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
