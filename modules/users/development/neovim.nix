{ pkgs, config, lib, ... }:
with lib;

let
  cfg = config.richard.development.neovim;

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
  options.richard.development.neovim = {
    enable = mkOption {
      description = "Enable editing with neovim";
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
            luafile ${builtins.toString ./nvim/lua/config/git.lua}
            luafile ${builtins.toString ./nvim/lua/config/lsp.lua}
            luafile ${builtins.toString ./nvim/lua/config/telescope.lua}
            luafile ${builtins.toString ./nvim/lua/config/treesitter.lua}
            luafile ${builtins.toString ./nvim/lua/config/ux.lua}
          ''
        ];
        extraPackages = with pkgs; [
          # Language Server
          nodePackages.bash-language-server
          nodePackages.vim-language-server
          nodePackages.vscode-langservers-extracted
          nodePackages.yaml-language-server
          rnix-lsp
          shellcheck
          stylua

          # Tree-sitter
          tree-sitter
          gcc
        ];
        plugins = with pkgs.vimPlugins; [
          # UI/UX
          (plugin "gruvbox-community/gruvbox")
          (plugin "norcalli/nvim-colorizer.lua")
          (plugin "kyazdani42/nvim-web-devicons")
          (plugin "kyazdani42/nvim-tree.lua")
          (plugin "nvim-lualine/lualine.nvim")
          (plugin "tpope/vim-surround")
          (plugin "tpope/vim-repeat")
          (plugin "windwp/nvim-autopairs")
          (plugin "numToStr/Comment.nvim")

          # Language Server
          (plugin "neovim/nvim-lspconfig")
          (plugin "jose-elias-alvarez/null-ls.nvim")

          # Telescope
          (plugin "nvim-telescope/telescope.nvim")
          (plugin "nvim-lua/popup.nvim")
          (plugin "nvim-lua/plenary.nvim")
          (plugin "nvim-telescope/telescope-file-browser.nvim")
          (plugin "ThePrimeagen/harpoon")

          # Undotree
          (plugin "mbbill/undotree")

          # Git
          (plugin "lewis6991/gitsigns.nvim")

          # Tree-sitter
          (nvim-treesitter)
          (plugin "p00f/nvim-ts-rainbow")
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
