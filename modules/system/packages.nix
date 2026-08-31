{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    tmux
    upower
    zsh
    brightnessctl
    libreoffice
    clang-tools
    clang
    llvmPackages_latest.libllvm
    llvmPackages_latest.libcxx
  ];
}
