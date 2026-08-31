{ ... }:
{
  home.username = "lu";
  home.homeDirectory = "/home/lu";
  home.stateVersion = "26.05";

  home.sessionVariables = {
    VK_ICD_FILENAMES = "/run/opengl-driver/share/vulkan/icd.d/radeon_icd.x86_64.json";
    LIBVA_DRIVER_NAME = "radeonsi";
    LIBVA_DRIVERS_PATH = "/run/opengl-driver/lib/dri";
  };

  imports = [
    ./git.nix
    ./hyprland.nix
    ./packages/tools.nix
    ./packages/desktop.nix
    ./packages/dev.nix
    ./packages/lsp.nix
  ];
}
