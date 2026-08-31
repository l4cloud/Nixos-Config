{ pkgs, ... }:
{
  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  services.printing.enable = true;
  services.gvfs.enable = true;
}
