{ pkgs, ... }:
{
  imports = [
    ./greetd.nix
    ./hyprland.nix
  ];

  nixpkgs.config.allowUnfree = true;

  nix = {
    settings = {
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;
      trusted-users = [
        "root"
        "rijk"
      ];
    };
    extraOptions = ''
      use-xdg-base-directories = true
      extra-substituters = https://devenv.cachix.org
      extra-trusted-public-keys = devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=
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

  # Make non-NixOS programs work
  programs.nix-ld.enable = true;
  services.envfs.enable = true;

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
      # generated using `mkpasswd`
      hashedPassword = "$y$j9T$U88RVLweMcIL8RI6YkS./.$uceVRBP.9XZVAPZ2xITok7tr4x1uDbVgtQwADjSJRxC";
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

  services.tailscale.enable = true;

  # Sytem Packages
  environment.systemPackages = with pkgs; [
    # A few essential pacakges
    wget
    git
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
  fonts.fontDir.enable = true; # for flatpak
  fonts.packages = with pkgs; [
    liberation_ttf
    fira
    fira-code
    vistafonts
    open-sans
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    noto-fonts-monochrome-emoji
    roboto
    roboto-mono
    ubuntu-sans
    (nerdfonts.override {
      fonts = [
        "Iosevka"
        "JetBrainsMono"
        "FiraCode"
      ];
    })
  ];
  fonts.fontconfig.defaultFonts = {
    sansSerif = [ "Fira Sans" ];
    monospace = [ "Fira Code Nerd Font" ];
  };

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

  # Key remaps
  services.keyd = {
    enable = true;
    keyboards.default = {
      ids = [ "*" ];
      settings = {
        main = {
          capslock = "esc"; # remap capslock to escape
        };
      };
    };
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
