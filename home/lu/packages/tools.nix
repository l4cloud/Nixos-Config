{ pkgs, ... }:
{
  home.packages = with pkgs; [
    ripgrep fd fzf jq toolong zellij zsh starship fetch btop stow kitty
    jetbrains-mono nautilus nwg-displays adw-gtk3 nwg-look yazi samba gvfs
    kdePackages.qt6ct xclip
  ];
}
