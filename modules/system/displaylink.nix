{ ... }:
{
  services.xserver.videoDrivers = [ "displaylink" ];
  nixpkgs.overlays = [ (import ../../overlays/displaylink.nix) ];
}
