{ pkgs, ... }:
{
  # GRUB + os-prober so Windows on a separate disk is auto-detected at boot.
  # NOTE: os-prober only finds UEFI Windows on a *mounted* ESP. When generating
  # the desktop hardware-configuration.nix, mount the Windows ESP too, e.g.:
  #   fileSystems."/boot/windows" = {
  #     device = "/dev/disk/by-uuid/<WINDOWS_ESP_UUID>";
  #     fsType = "vfat";
  #   };
  boot.loader.systemd-boot.enable = false;
  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    device = "nodev"; # UEFI install
    useOSProber = true; # detect Windows on the other disk
  };
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;
}
