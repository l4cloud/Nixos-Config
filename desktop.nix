{ pkgs, config, lib, ...}:

{

  # DE & DM setup
  programs.hyprland.enable = true;
  services.displayManager.ly.enable = true;
  services.displayManager.ly.settings = {
    animation = "colormix";
    hide_borders = true;
    session_log = ".cache/ly/session.log";
  };

  # Audio
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  services.pulseaudio.enable = false;

  # Laptop
  services.logind.settings.Login = {
    HandleLidSwitch = "ignore";
    HandleLidSwitchExternalPower = "ignore";
    HandleLidSwitchDocked = "ignore";
  };

  # Power off 30 minutes after the lid is closed (battery only)
  systemd.services.lid-shutdown = {
    description = "Power off 30 minutes after the laptop lid is closed on battery";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = pkgs.writeShellScript "lid-shutdown" ''
        ${pkgs.gnugrep}/bin/grep -q Discharging /sys/class/power_supply/BAT*/status \
          && ${pkgs.systemd}/bin/systemctl poweroff
      '';
    };
  };

  systemd.timers.lid-shutdown = {
    description = "Trigger lid-shutdown 30 minutes after the lid is closed";
    timerConfig = {
      OnActiveSec = "30min";
    };
  };

  services.udev.extraRules = let
    lidHandler = pkgs.writeShellScript "lid-handler" ''
      state=$(${pkgs.coreutils}/bin/cat /sys$DEVPATH/sw 2>/dev/null || true)
      case "$state" in
        *1*|*3*|*5*|*7*|*9*|*A*|*B*|*C*|*D*|*E*|*F*|*a*|*b*|*c*|*d*|*e*|*f*)
          ${pkgs.systemd}/bin/systemctl start lid-shutdown.timer ;;
        *)
          ${pkgs.systemd}/bin/systemctl stop lid-shutdown.timer ;;
      esac
    '';
  in ''
    SUBSYSTEM=="input", ACTION=="change", ENV{ID_INPUT_SWITCH}=="1", RUN+="${lidHandler}"
  '';


  # Misc Services
  services.printing.enable = true;

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # Graphics
  hardware.graphics.enable = true;

  # XDG
  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
}
