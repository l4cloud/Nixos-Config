{ config, pkgs, inputs,  ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./desktop.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "nixos"; # Define your hostname.

  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  networking.networkmanager.enable = true;

  time.timeZone = "Europe/London";

  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };

  services.xserver.xkb = {
    layout = "gb";
    variant = "";
  };

  services.xserver.videoDrivers = [ "displaylink" ];

  console.keyMap = "uk";

  users.users."lu" = {
    isNormalUser = true;
    description = "lu";
    extraGroups = [ "networkmanager" "wheel" "video" "render" "docker" ];
    packages = with pkgs; [];
    shell = pkgs.zsh;
  };

  virtualisation.docker.enable = true;

  nixpkgs.config.allowUnfree = true;

  nixpkgs.overlays = [
    (final: prev: {
      displaylink = prev.displaylink.overrideAttrs (old: {
        src = final.fetchurl {
          url = "https://www.synaptics.com/sites/default/files/exe_files/2025-09/DisplayLink%20USB%20Graphics%20Software%20for%20Ubuntu6.2-EXE.zip";
          hash = "sha256-JQO7eEz4pdoPkhcn9tIuy5R4KyfsCniuw6eXw/rLaYE=";
          name = "displaylink-620.zip";
        };
      });
    })
  ];

  environment.systemPackages = with pkgs; [
     vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
     wget
     git
     tmux
     upower
     zsh
     brightnessctl
     libreoffice
     clang-tools   # Provides clangd
     clang
     llvmPackages_latest.libllvm
     llvmPackages_latest.libcxx 
   ];

  # services.openssh.enable = true;
  services.upower.enable = true;
  services.power-profiles-daemon.enable = true;

  services.udev.extraRules = ''
      ACTION=="change", SUBSYSTEM=="power_supply", ATTR{type}=="Mains", \
        RUN+="${pkgs.systemd}/bin/systemctl --no-block start power-profile-switch.service"
    '';

    systemd.services.power-profile-switch = {
      description = "Switch power profile based on AC/battery";
      wantedBy = [ "multi-user.target" ];  # sets the correct profile at boot too
      # Don't try to talk to the daemon before it's up (also races its
      # restart during nixos-rebuild switch)
      after = [ "power-profiles-daemon.service" ];
      serviceConfig.Type = "oneshot";
      script = ''
        # grep any mains supply reporting online=1 (robust to AC/AC0/ADP1 naming)
        if grep -q 1 /sys/class/power_supply/*/online; then
          profile="performance"
        else
          profile="power-saver"
        fi
        # power-profiles-daemon can be briefly unavailable (boot race / switch
        # restart) and then reports an empty profile list. Retry for ~15s,
        # then give up quietly — a transient failure must never mark the unit
        # failed, since a plug/unplug event will re-trigger it anyway.
        for i in {1..15}; do
          ${pkgs.power-profiles-daemon}/bin/powerprofilesctl set "$profile" 2>/dev/null && exit 0
          sleep 1
        done
        exit 0
      '';
    };
   services.gvfs.enable = true;

   systemd.services.nixos-owner = {
     description = "Make /etc/nixos owned by lu";
     wantedBy = [ "multi-user.target" ];
     serviceConfig.Type = "oneshot";
     serviceConfig.ExecStart = "${pkgs.coreutils}/bin/chown -R lu:users /etc/nixos";
   };
   system.stateVersion = "26.05"; # Did you read the comment?
  nix.settings.experimental-features = ["nix-command flakes"];
  programs.zsh.enable = true;

}
