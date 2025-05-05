{ pkgs, ... }:
{
  imports = [
    ./default/fonts.nix
    ./default/greetd.nix
    ./default/hyprland.nix
  ];

  nix = {
    settings = {
      experimental-features = "nix-command flakes";
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
    optimise.automatic = true; # periodic optimisation of the nix store
  };

  nixpkgs.config = {
    allowUnfree = true;
    allowUnfreePredicate = _: true;
  };

  # include systemd in initial ram disk
  boot.initrd.systemd.enable = true;
  # boot animation
  boot.plymouth.enable = true;

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
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      2992
      5000
    ];
  };
  networking.nftables.enable = true; # use nftables instead of iptables
  services.tailscale.enable = true;

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
        "docker"
        "podman"
      ];
      shell = pkgs.fish;
    };
  };

  # Sytem Packages
  environment.systemPackages = with pkgs; [
    # A few essential pacakges
    curl
    wget
    git
    freshfetch
    htop
    wireguard-tools

    # adb
    android-tools

    # Customized vim
    ((vim_configurable.override { }).customize {
      name = "vim";
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

  programs.fish.enable = true; # fish shell

  programs = {
    light.enable = true;
    dconf.enable = true;
    thunar.enable = true;
  };

  programs.adb.enable = true;

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
  };

  # PipeWire Audio
  hardware.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
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

  # Security
  security = {
    pam.services.swaylock = {
      text = "auth include login";
    };
    pam.services.sudo.nodelay = true;
    pam.services.su.nodelay = true;
    rtkit.enable = true;
    polkit.enable = true;
  };

  system.stateVersion = "23.05"; # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
}
