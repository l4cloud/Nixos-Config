{ pkgs, inputs, ... }:
{
  home.username = "lu";
  home.homeDirectory = "/home/lu";
  home.stateVersion = "26.05";

  imports = [ ./git.nix ];

  home.packages = [
    inputs.helium.defaultPackage.${pkgs.stdenv.hostPlatform.system}
  ];

  # Boot straight into a console-like experience: Steam Big Picture
  # auto-starts on Plasma login. "Exit Big Picture Mode" returns to the
  # KDE desktop (which has normal logout).
  xdg.configFile."autostart/steam-bigpicture.desktop".text = ''
    [Desktop Entry]
    Type=Application
    Name=Steam Big Picture
    Comment=Launch Steam in Big Picture Mode on login
    Exec=steam -bigpicture
    X-KDE-autostart-after=panel
  '';
}
