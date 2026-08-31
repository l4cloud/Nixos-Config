{ pkgs, ... }:
{
  users.users."lu" = {
    isNormalUser = true;
    description = "lu";
    extraGroups = [ "networkmanager" "wheel" "video" "render" "docker" ];
    packages = with pkgs; [];
    shell = pkgs.zsh;
  };
}
