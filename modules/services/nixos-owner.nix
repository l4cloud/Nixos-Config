{ pkgs, ... }:
{
  systemd.services.nixos-owner = {
    description = "Make /etc/nixos owned by lu";
    wantedBy = [ "multi-user.target" ];
    serviceConfig.Type = "oneshot";
    serviceConfig.ExecStart = "${pkgs.coreutils}/bin/chown -R lu:users /etc/nixos";
  };
}
