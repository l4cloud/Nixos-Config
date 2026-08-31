{ pkgs, ... }:
{
  services.upower.enable = true;
  services.power-profiles-daemon.enable = true;

  services.udev.extraRules = ''
    ACTION=="change", SUBSYSTEM=="power_supply", ATTR{type}=="Mains", \
      RUN+="${pkgs.systemd}/bin/systemctl --no-block start power-profile-switch.service"
  '';

  systemd.services.power-profile-switch = {
    description = "Switch power profile based on AC/battery";
    wantedBy = [ "multi-user.target" ];
    after = [ "power-profiles-daemon.service" ];
    serviceConfig.Type = "oneshot";
    script = ''
      # grep any mains supply reporting online=1 (robust to AC/AC0/ADP1 naming)
      if grep -q 1 /sys/class/power_supply/*/online; then
        profile="performance"
      else
        profile="power-saver"
      fi
      # power-profiles-daemon can be briefly unavailable (boot race) and report
      # an empty profile list. Retry ~15s, then give up quietly — a transient
      # failure must never mark the unit failed.
      for i in {1..15}; do
        ${pkgs.power-profiles-daemon}/bin/powerprofilesctl set "$profile" 2>/dev/null && exit 0
        sleep 1
      done
      exit 0
    '';
  };
}
