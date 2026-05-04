{ pkgs, ... }:
{
  home.packages = with pkgs; [
    kitty
    obsidian
    tmux
    waybar
    evince
    swaynotificationcenter
    rofi
    hyprpaper
    hypridle
    discord
    btop
    brightnessctl
    claude-code
    bibata-cursors
    maim
    bitwarden-desktop
    kitty
    tmux
    hyprpaper
    localsend
    hypridle
    wl-clipboard
    cliphist
    grim
    google-chrome
    slurp
    pavucontrol
    playerctl
    nemo
    blueman
    libnotify
    zsh-powerlevel10k
    eza
    raylib
    gcc
    cmake
    pkg-config
    screen
    curl
    particle-cli
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = false;
  };

  programs.bash = {
    enable = true;
  };

  programs.zsh = {
    enable = true;
    shellAliases = {
      nrs = "cd ~/dotfiles && git add . && sudo nixos-rebuild switch --flake ~/dotfiles#nixos";
      ls = "eza -la";
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
      name = "Gruvbox-Plus-Dark";
      package = pkgs.gruvbox-plus-icons;
    };
    font = {
      name = "Adwaita Sans";
      size = 11;
    };
  };
}
