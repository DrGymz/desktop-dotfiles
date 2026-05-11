{
  config,
  pkgs,
  lib,
  ...
}:

{
  home.packages = with pkgs; [
    clang-tools
    cmake
    fd
    fzf
    gcc
    gradle
    jdk
    jdt-language-server
    lua-language-server
    maven
    nil
    nixfmt
    nodejs
    particle-cli
    pyright
    raylib
    ripgrep
    xclip
  ];

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    initLua = builtins.readFile ../nixos-config/nvim/init.lua;

    plugins = with pkgs.vimPlugins; [
      plenary-nvim
      telescope-nvim
      telescope-fzf-native-nvim
      nvim-treesitter

      lualine-nvim
      gruvbox-nvim
      tokyonight-nvim
      catppuccin-nvim
      comment-nvim
      nvim-web-devicons

      nvim-cmp
      cmp-nvim-lsp
      neodev-nvim
      nvim-lspconfig
      cmp-buffer
      cmp-path
      cmp-cmdline
      luasnip
      cmp_luasnip

      nvim-colorizer-lua
      mini-pairs
      indent-blankline-nvim

      (nvim-treesitter.withPlugins (p: [
        p.tree-sitter-nix
        p.tree-sitter-vim
        p.tree-sitter-lua
        p.tree-sitter-bash
        p.tree-sitter-python
        p.tree-sitter-c
        p.tree-sitter-cpp
        p.tree-sitter-css
        p.tree-sitter-java
      ]))
    ];
  };
}
