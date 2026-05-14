{ pkgs, ... }:
{
  home.packages = with pkgs; [
    amberol
    bibata-cursors
    bitwarden-desktop
    blueman
    brightnessctl
    btop
    claude-code
    cliphist
    curl
    discord
    eza
    google-chrome
    grim
    hypridle
    hyprlock
    hyprpaper
    kitty
    libnotify
    localsend
    lutris
    maim
    mangohud
    nemo
    networkmanagerapplet
    kdePackages.okular
    obsidian
    pavucontrol
    pkg-config
    playerctl
    prismlauncher
    qbittorrent
    qgnomeplatform
    qgnomeplatform-qt6
    rofi
    screen
    slurp
    swaynotificationcenter
    tmux
    tree
    vlc
    waybar
    wl-clipboard
    wlogout
    zoom-us
    zsh-powerlevel10k
  ];
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = false;
    configType = "hyprlang";
  };
  programs.bash = {
    enable = true;
  };

  programs.zsh = {
    enable = true;
    shellAliases = {
      nrs = "cd ~/dotfiles && git add . && sudo nixos-rebuild switch --flake ~/dotfiles#nixos";
      ls = "eza -l";
      compile = "particle compile photon2 src/ --saveTo firmware.bin";
      flash = "particle flash --usb firmware.bin";
    };
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "sudo"
        "z"
      ];
    };
    initContent = ''
      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
      [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
      fastfetch
    '';
  };

  programs.git = {
    enable = true;
    settings = {
      user.name = "DrGymz";
      user.email = "258542754+DrGymz@users.noreply.github.com";
    };
  };

  gtk = {
    enable = true;
    theme = {
      name = "Gruvbox-Dark";
      package = pkgs.gruvbox-gtk-theme;
    };
    iconTheme = {
      name = "kora";
      package = pkgs.kora-icon-theme;
    };
    font = {
      name = "Adwaita Sans";
      size = 11;
    };
    gtk3.extraConfig.gtk-application-prefer-dark-theme = true;
    gtk4.extraConfig.gtk-application-prefer-dark-theme = true;
  };

  qt = {
    enable = true;
    platformTheme.name = "adwaita";
    style = {
      name = "Breeze";
      package = pkgs.kdePackages.breeze;
    };
  };

  dconf.settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
}
