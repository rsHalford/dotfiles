{ pkgs, config, lib, ... }:
with lib;

let
  cfg = config.richard.development.editor;

  pluginGit = ref: repo: pkgs.vimUtils.buildVimPluginFrom2Nix {
    pname = "${lib.strings.sanitizeDerivationName repo}";
    version = ref;
    src = builtins.fetchGit {
      url = "https://github.com/${repo}.git";
      ref = ref;
    };
  };
  plugin = pluginGit "HEAD";
in
{
  options.richard.development.editor = {
    enable = mkOption {
      description = "Enable development editor";
      type = types.bool;
      default = false;
    };
  };

  config = mkIf (cfg.enable) {
    programs = {
      neovim = {
        enable = true;
        package = pkgs.neovim-nightly;
        extraConfig = builtins.concatStringsSep "\n" [
          ''
            luafile ${builtins.toString ./nvim/init_lua.lua}
            luafile ${builtins.toString ./nvim/lua/keymaps.lua}
            luafile ${builtins.toString ./nvim/lua/options.lua}
            luafile ${builtins.toString ./nvim/lua/config/cmp.lua}
            luafile ${builtins.toString ./nvim/lua/config/lsp.lua}
          ''
        ];
        extraPackages = with pkgs; [
          gopls
          nodePackages.bash-language-server
          nodePackages.pyright
          nodePackages.svelte-language-server
          nodePackages.vim-language-server
          nodePackages.vscode-langservers-extracted
          nodePackages.vue-language-server
          nodePackages.yaml-language-server
          rnix-lsp
        ];
        plugins = with pkgs.vimPlugins; [
          (plugin "gruvbox-community/gruvbox")
          (plugin "neovim/nvim-lspconfig")
          (plugin "hrsh7th/nvim-cmp")
          (plugin "L3MON4D3/LuaSnip")
          (plugin "hrsh7th/cmp-buffer")
          (plugin "hrsh7th/cmp-nvim-lsp")
          (plugin "hrsh7th/cmp-emoji")
          (plugin "hrsh7th/cmp-nvim-lua")
          (plugin "hrsh7th/cmp-path")
          (plugin "saadparwaiz1/cmp_luasnip")
        ];
        viAlias = true;
        vimAlias = true;
        vimdiffAlias = true;
        withNodeJs = true;
        withPython3 = true;
        withRuby = true;
      };
    };
  };
}
