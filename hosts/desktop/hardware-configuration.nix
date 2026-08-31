# TODO: Replace this file with the output of `nixos-generate-config`
# after installing NixOS on the desktop. Placeholder so the host evaluates.

{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  # Fill in post-install: fileSystems, swapDevices, boot.initrd.*, etc.

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.enableRedistributableFirmware = true;
}
