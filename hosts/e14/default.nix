{ inputs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    inputs.home-manager.nixosModules.home-manager
    ../../modules/system/boot.nix
    ../../modules/system/locale.nix
    ../../modules/system/network.nix
    ../../modules/system/user.nix
    ../../modules/system/packages.nix
    ../../modules/system/nix.nix
    ../../modules/system/displaylink.nix
    ../../modules/services/docker.nix
    ../../modules/services/power.nix
    ../../modules/services/nixos-owner.nix
    ../../modules/desktop/hyprland.nix
    ../../modules/desktop/graphics.nix
    ../../modules/desktop/audio.nix
    ../../modules/desktop/bluetooth.nix
    ../../modules/desktop/lid-power.nix
    ../../modules/desktop/misc.nix
  ];

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.lu = import ../../home/lu;
  home-manager.extraSpecialArgs = { inherit inputs; };

  networking.hostName = "e14";
  system.stateVersion = "26.05";
}
