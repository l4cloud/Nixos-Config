{ pkgs, inputs, ... }:
{
  programs.hyprland.enable = true;
  programs.hyprland.package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
  services.displayManager.ly.enable = true;
  services.displayManager.ly.settings = {
    animation = "colormix";
    hide_borders = true;
    session_log = ".cache/ly/session.log";
  };
}
