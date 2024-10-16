{ pkgs, outputs, ... }:
{
  imports = [
    ./greetd.nix
    ./hyprland.nix
    outputs.nixosModules.movebeam
  ];

  nixpkgs.config.allowUnfree = true;

  nix = {
    settings = {
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;
    };
    extraOptions = ''
      use-xdg-base-directories = true
      extra-substituters = https://devenv.cachix.org;
      extra-trusted-public-keys = devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=;
    '';
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };

  # include systemd in initial ram disk
  boot.initrd.systemd.enable = true;
  services.irqbalance.enable = true; # deamon to balance interrupts across CPUs, can help to avoid freezing DE
  services.dbus = {
    enable = true;
    implementation = "broker"; # use dbus-broker, a high performance implementation of dbus
  };

  # Time/locale
  time.timeZone = "Europe/Amsterdam";
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true; # use xkbOptions in tty.
  };

  # Networking
  # this does not work with libvirtd so stay on iptables for now
  # networking.nftables.enable = true; # use nftables instead of iptables

  # syncthing ports
  networking.firewall.allowedTCPPorts = [ 22000 ];
  networking.firewall.allowedUDPPorts = [
    22000
    21027
  ];

  # ADB
  programs.adb.enable = true;

  # Users
  users = {
    defaultUserShell = pkgs.fish;
    mutableUsers = false;
    users.rijk = {
      isNormalUser = true;
      hashedPassword = "$y$j9T$e68AODd7XbX6pmjHKlAMT1$bwaqLqGPX72/S8zMoThqEFX0fZ6T/h8cRiY0vUlFQY1";
      extraGroups = [
        "wheel"
        "video"
        "audio"
        "lp"
        "scanner"
        "docker"
        "libvirtd"
        "kvm"
        "network"
        "lxd"
        "plugdev"
        "adbusers"
      ];
      shell = pkgs.fish;
    };
  };

  # Movebeam service
  services.movebeam.enable = true;

  services.tailscale.enable = true;

  # Sytem Packages
  environment.systemPackages = with pkgs; [
    cage
    # A few essential pacakges
    wget
    git
    gnupg
    macchina
    freshfetch
    htop
    fish
    wireguard-tools

    # Man pages
    man-pages
    man-pages-posix

    # Customized vim
    ((vim_configurable.override { }).customize {
      name = "vim";
      vimrcConfig.packages.myplugins = with pkgs.vimPlugins; {
        start = [
          vim-nix
          vim-lastplace
        ];
        opt = [ ];
      };
      vimrcConfig.customRC = ''
        set nocompatible
        set backspace=indent,eol,start
        syntax on
        set number
        set relativenumber
        set expandtab
        set shiftwidth=2
        set tabstop=2
        set softtabstop=2
        set nowrap
      '';
    })
  ];
  environment.shellAliases = {
    "ff" = "freshfetch";
  };

  # Desktop portal
  # (The Hyprland module adds the hyprland portal to the list)
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
  };

  # Fonts
  fonts.fontDir.enable = true;
  fonts.packages = with pkgs; [
    liberation_ttf
    fira
    fira-code
    vistafonts
    open-sans
    noto-fonts
    noto-fonts-emoji
    (nerdfonts.override {
      fonts = [
        "Iosevka"
        "JetBrainsMono"
        "FiraCode"
        "CascadiaCode"
      ];
    })
  ];

  programs = {
    fish.enable = true;
    light.enable = true;
    dconf.enable = true;
    thunar.enable = true;
  };

  hardware.pulseaudio.enable = false;

  services = {
    resolved.enable = true;
    openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        PermitRootLogin = "no";
      };
    };
    gvfs.enable = true;
    # PipeWire Audio
    pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
    };

    # Flatpak
    flatpak.enable = true;
  };

  # Key remaps daemon
  services.keyd = {
    enable = true;
    keyboards.default = {
      ids = [ "*" ];
      settings = {
        main = {
          capslock = "overload(control, esc)";
          rightalt = "layer(rightalt)";
        };
        rightalt = {
          h = "left";
          j = "down";
          k = "up";
          l = "right";
        };
      };
    };
  };

  # Printing/scanning services
  services.printing = {
    enable = true;
    drivers = [ pkgs.hplip ];
  };

  # Boot animation
  boot.plymouth = {
    enable = true;
  };

  # Security
  security = {
    pam.services.swaylock = {
      text = "auth include login";
    };
    rtkit.enable = true;
    polkit.enable = true;
  };

  system.stateVersion = "23.05"; # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
}
