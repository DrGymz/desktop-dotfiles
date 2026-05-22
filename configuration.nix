{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader.timeout = null;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub = {
    enable = true;
    device = "nodev";
    efiSupport = true;
    useOSProber = true;
    gfxmodeEfi = "2560x1440";
    theme =
      let
        spaceIsolation = pkgs.fetchFromGitHub {
          owner = "callmenoodles";
          repo = "space-isolation";
          rev = "2f172f7cb6769bbef8dec62738ac168698c48985";
          hash = "sha256-YAzrqaTi9TvoSPsefYAW1ksMBu0yg92jAzFmk7l7shI=";
        };
      in
      "${spaceIsolation}/2560x1440";
  };

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
  time.timeZone = "America/Chicago";

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
    persistent = true;
  };
  nix.settings.auto-optimise-store = true;
  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = [
    (final: prev: {
      openldap = prev.openldap.overrideAttrs (old: {
        doCheck = false;
      });
    })
  ];

  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
    };
    nvidia = {
      modesetting.enable = true;
      powerManagement.enable = true;
      open = true;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };
  };

  boot.kernelPackages = pkgs.linuxPackages_latest;

  services = {
    blueman.enable = true;
    libinput = {
      enable = true;
      mouse = {
        accelSpeed = "1.0";
        accelProfile = "flat";
      };
    };
    xserver = {
      enable = true;
      videoDrivers = [ "nvidia" ];
      dpi = 96;
      autoRepeatDelay = 200;
      autoRepeatInterval = 35;
    };
    openssh.enable = true;
  };

  services.mullvad-vpn = {
    enable = true;
    package = pkgs.mullvad-vpn;
  };

  users.users.asus = {
    isNormalUser = true;
    extraGroups = [
      "networkmanager"
      "wheel"
      "dialout"
      "video"
    ];
  };

  environment.systemPackages = with pkgs; [
    vim
    git
    wget
    fastfetch
  ];

  fonts.packages =
    (with pkgs.nerd-fonts; [
      jetbrains-mono
      geist-mono
    ])
    ++ [
      pkgs.adwaita-fonts
    ];

  programs = {
    dconf.enable = true;
    hyprland.enable = true;
    gamemode.enable = true;
    steam = {
      enable = true;
      gamescopeSession.enable = true;
    };
  };

  programs.silentSDDM = {
    enable = true;
    theme = "default";
    backgrounds = {
      mywall = ./wallpapers/mountain.jpg;
    };
    settings = {
      General.animated-background-placeholder = "mountain.jpg";
      LockScreen.background = "mountain.jpg";
      LoginScreen.background = "mountain.jpg";
    };
  };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  system.stateVersion = "25.11";
}
