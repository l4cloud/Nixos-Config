{ inputs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    inputs.home-manager.nixosModules.home-manager
    ../../modules/system/boot-grub.nix
    ../../modules/system/locale.nix
    ../../modules/system/network.nix
    ../../modules/system/user.nix
    ../../modules/system/nix.nix
    ../../modules/desktop/graphics.nix
    ../../modules/desktop/audio.nix
    ../../modules/desktop/bluetooth.nix
    ../../modules/desktop/kde.nix
    ../../modules/desktop/gaming.nix
  ];

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.lu = import ../../home/lu/desktop.nix;
  home-manager.extraSpecialArgs = { inherit inputs; };

  networking.hostName = "desktop";
  system.stateVersion = "26.05";
}
