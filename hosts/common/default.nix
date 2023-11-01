{ inputs, outputs, lib, config, pkgs, nixosModules, ... }: {
  imports = [
    inputs.agenix.nixosModules.default
  ];

  nixpkgs.config.allowUnfree = true;

  nix = {
    settings = {
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;

      # Hyprland Cache
      substituters = [ "https://hyprland.cachix.org" ];
      trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
    };
  };

  # Time/locale
  time.timeZone = "Europe/Amsterdam";
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true; # use xkbOptions in tty.
  };

  # Users
  users = {
    defaultUserShell = pkgs.zsh;
    mutableUsers = false;
    users.rijk = {
      isNormalUser = true;
      initialHashedPassword = "$y$j9T$nI4JsR4y7bWg3wAaplo4h1$ZLXayiNA2cAe/JaOnHnvy9w19eoBdb3pXmjQ.f88UR/";
      extraGroups = [ "wheel" "video" "audio" "lp" "scanner" "docker" "libvirtd" "network" "lxd" ];
      shell = pkgs.zsh;
    };
  };


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
    zsh
    wireguard-tools

    ((vim_configurable.override { }).customize {
      name = "vim";
      vimrcConfig.packages.myplugins = with pkgs.vimPlugins; {
        start = [ vim-nix vim-lastplace ];
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
  environment.interactiveShellInit = ''
    alias neofetch=freshfetch
  '';

  # Fonts
  fonts.fontDir.enable = true;
  fonts.fonts = with pkgs; [
    liberation_ttf
    fira
    fira-code
    vistafonts
    open-sans
    noto-fonts
    noto-fonts-emoji
    (nerdfonts.override { fonts = [ "Iosevka" "CodeNewRoman" "ComicShannsMono" "JetBrainsMono" ]; })
  ];

  programs = {
    zsh.enable = true;
    light.enable = true;
    dconf.enable = true;
    thunar.enable = true;
    kdeconnect.enable = true;
  };

  hardware.pulseaudio.enable = false;

  services = {
    dbus.enable = true;
    openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        PermitRootLogin = "no";
      };
      hostKeys = [
        {
          path = "/etc/nixconf-key";
          rounds = 100;
          type = "ed25519";
        }
      ];
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

  # Printing/scanning services
  services.printing = {
    enable = true;
    drivers = [ pkgs.hplip ];
  };

  # XDG Portal
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-wlr
      xdg-desktop-portal-gtk
    ];
  };

  services.greetd = {
    enable = true;
    settings = rec {
      # Autologin
      initial_session = {
        command = "Hyprland";
        user = "rijk";
      };
      default_session = initial_session;
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

