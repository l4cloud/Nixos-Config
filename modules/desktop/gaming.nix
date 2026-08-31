{ pkgs, ... }:
{
  # NVIDIA driver (proprietary, open kernel module)
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    modesetting.enable = true;
    open = true;
  };

  # Steam + game mode (gamescope Big Picture session).
  # -bigpicture instead of -tenfoot so Steam keeps a working "Exit Steam"
  # (returns to SDDM), since -tenfoot replaces it with a "Switch to Desktop
  # Mode" button that needs a SteamOS session manager we don't have.
  programs.steam = {
    enable = true;
    gamescopeSession = {
      enable = true;
      steamArgs = [ "-bigpicture" "-pipewire-dmabuf" ];
    };
    protontricks.enable = true;
    extraCompatPackages = [ pkgs.proton-ge-bin ];
  };

  # Performance governor / process priority boost
  programs.gamemode.enable = true;

  # Gaming helpers
  environment.systemPackages = with pkgs; [
    mangohud
    lutris
    heroic
    bottles
  ];

  # Steam preselected at the SDDM login screen; no autologin so you can
  # still pick Plasma (desktop) instead of getting trapped in game mode.
  services.displayManager.defaultSession = "steam";
}
