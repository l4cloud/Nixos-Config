{ pkgs, inputs, ... }:
{
  home.username = "lu";
  home.homeDirectory = "/home/lu";
  home.stateVersion = "26.05";

  imports = [ ./git.nix ];

  home.packages = [
    inputs.helium.defaultPackage.${pkgs.stdenv.hostPlatform.system}
  ];

  # MangoHud overlay config. Shows when launched via `mangohud %command%`
  # (not session-wide, so it stays out of non-game apps).
  programs.mangohud = {
    enable = true;
    settings = {
      fps = true;
      frametime = true;
      gpu_stats = true;
      cpu_stats = true;
      gpu_temp = true;
      cpu_temp = true;
      vram = true;
      ram = true;
      position = "top-left";
    };
  };
}
