{ pkgs, ... }:
{
  services.logind.settings.Login = {
    HandleLidSwitch = "suspend";
    HandleLidSwitchExternalPower = "ignore";
    HandleLidSwitchDocked = "ignore";
  };
  services.acpid.enable = true;
  services.acpid.handlers.lid = {
    event = "button/lid.*";
    action = ''
      state=$(${pkgs.gnugrep}/bin/grep -o 'open\|closed' /proc/acpi/button/lid/*/state)
      if [ "$state" = "closed" ]; then
        ${pkgs.brightnessctl}/bin/brightnessctl set 0
      else
        ${pkgs.brightnessctl}/bin/brightnessctl set 100%
      fi
    '';
  };
}
