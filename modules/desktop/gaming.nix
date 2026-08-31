{ pkgs, ... }:
{
  # NVIDIA driver (proprietary, open kernel module)
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    modesetting.enable = true;
    open = true;
  };

  # Steam + SteamOS-style "game mode" (gamescope Big Picture session)
  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
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

  # Boot straight into Steam Big Picture (game mode), like SteamOS
  services.displayManager.defaultSession = "steam";
  services.displayManager.autoLogin = {
    enable = true;
    user = "lu";
  };
}
