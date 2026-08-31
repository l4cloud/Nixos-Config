{ pkgs, inputs, ... }:
{
  home.username = "lu";
  home.homeDirectory = "/home/lu";
  home.stateVersion = "26.05";

  imports = [ ./git.nix ];

  home.packages = [
    inputs.helium.defaultPackage.${pkgs.stdenv.hostPlatform.system}
  ];
}
