{ pkgs, inputs, ... }:
{
  home.packages = with pkgs; [
    libreoffice
    inputs.helium.defaultPackage.${pkgs.stdenv.hostPlatform.system}
    inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
    anki-bin
    discord-ptb
  ];
}
