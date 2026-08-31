{ pkgs, ... }:
{
  # NVIDIA driver (proprietary, open kernel module)
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    modesetting.enable = true;
    open = true;
  };

  # Steam (desktop client); Big Picture auto-starts via the home autostart entry
  programs.steam = {
    enable = true;
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
}
