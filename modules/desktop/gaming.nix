{ pkgs, ... }:
{
  # NVIDIA driver (proprietary, open kernel module)
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    modesetting.enable = true;
    open = true;
    powerManagement.enable = true;
    nvidiaSettings = true;
  };

  # Steam (desktop client; launch manually from Plasma)
  programs.steam = {
    enable = true;
    protontricks.enable = true;
    extraCompatPackages = [ pkgs.proton-ge-bin ];
    remotePlay.openFirewall = true;
  };

  # GameMode: boost performance + raise game process priority while playing
  programs.gamemode = {
    enable = true;
    settings = {
      general.renice = 10;
    };
  };

  # Gaming helpers
  environment.systemPackages = with pkgs; [
    mangohud
    lutris
    heroic
    bottles
  ];

  # --- performance tweaks ---

  # Desktop is always on AC: run the CPU at the performance governor.
  powerManagement.cpuFreqGovernor = "performance";

  # Raise vm.max_map_count for Proton/Wine games (fixes stutters/crashes).
  boot.kernel.sysctl."vm.max_map_count" = 1048576;

  # Disable CPU security mitigations for maximum performance.
  # Tradeoff: this weakens Spectre/Meltdown defenses. Remove to keep them.
  boot.kernelParams = [ "mitigations=off" ];
}
