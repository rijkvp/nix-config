{ inputs, outputs, lib, config, pkgs, ... }: {
  imports = [
    inputs.agenix.nixosModules.default
  ];

  nixpkgs.config.allowUnfree = true;

  nix = {
    # This will add each flake input as a registry
    # To make nix3 commands consistent with your flake
    registry = lib.mapAttrs (_: value: { flake = value; }) inputs;

    # This will additionally add your inputs to the system's legacy channels
    # Making legacy nix commands consistent as well, awesome!
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;

    settings = {
      # Enable flakes and new 'nix' command
      experimental-features = "nix-command flakes";
      # Deduplicate and optimize nix store
      auto-optimise-store = true;

      # Hyprland Cache
      substituters = ["https://hyprland.cachix.org"];
      trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
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
  users.defaultUserShell = pkgs.zsh;
  users.users.rijk = {
     isNormalUser = true;
     extraGroups = [ "wheel" "video" "audio" "lp" "scanner" "docker" ];
     initialPassword = "password";
     shell = pkgs.zsh;
   };

  # Wayland variables
  environment.variables = {
    MOZ_ENABLE_WAYLAND = "1";
    GTK_USE_PORTAL = "1";
    GDK_BACKEND = "wayland,x11"; # Wayland with fallback to x11 (via xwayland)
    XDG_SESSION_TYPE = "wayland";
    QT_QPA_PLATFORM = "wayland";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
  };

  # Sytem Packages
  environment.systemPackages = with pkgs; [
    # A few essential pacakges
    wget
    git
    gnupg
    neofetch
    htop
    zsh

    ((vim_configurable.override {  }).customize{
      name = "vim";
      vimrcConfig.packages.myplugins = with pkgs.vimPlugins; {
        start = [ vim-nix vim-lastplace ];
        opt = [];
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

  # Fonts
  fonts.fonts = with pkgs; [
    liberation_ttf
    fira
    fira-code
    vistafonts
    open-sans
    noto-fonts
    noto-fonts-emoji
    (nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" "Iosevka" ]; })
  ];

  programs = {
    zsh.enable = true;
    light.enable = true;
    dconf.enable = true;
    thunar = {
      enable = true;
      plugins = with pkgs.xfce; [ thunar-archive-plugin thunar-volman ];
    };
  };

  # Enable the OpenSSH daemon.
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

    # CUPS Printing
    printing.enable = true;
  };

  # XDG Portal
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-wlr xdg-desktop-portal-gtk ];
  };

  services.greetd = {
    enable = true;
    settings = rec {
      initial_session = { # Autologin
        command = "Hyprland";
        user = "rijk";
      };
      default_session = initial_session;
    };
  };

  # Security
  security.pam.services.swaylock = {
    text = "auth include login";
  };
  security.rtkit.enable = true;
  security.polkit.enable = true;

  system.stateVersion = "23.05"; # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
}

