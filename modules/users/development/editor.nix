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
            luafile ${builtins.toString ./nvim/lua/config/git.lua}
            luafile ${builtins.toString ./nvim/lua/config/lsp.lua}
            luafile ${builtins.toString ./nvim/lua/config/lspsaga.lua}
            luafile ${builtins.toString ./nvim/lua/config/prose.lua}
            luafile ${builtins.toString ./nvim/lua/config/telescope.lua}
            luafile ${builtins.toString ./nvim/lua/config/treesitter.lua}
            luafile ${builtins.toString ./nvim/lua/config/ux.lua}
          ''
        ];
        extraPackages = with pkgs; [
          # Language Server
          black
          gopls
          python310Packages.flake8
          python310Packages.isort
          nodePackages.bash-language-server
          nodePackages.pyright
          nodePackages.svelte-language-server
          nodePackages.vim-language-server
          nodePackages.vscode-langservers-extracted
          nodePackages.vue-language-server
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
          # (plugin "goolord/alpha-nvim")
          (plugin "kyazdani42/nvim-web-devicons")
          (plugin "kyazdani42/nvim-tree.lua")
          (plugin "nvim-lualine/lualine.nvim")
          (plugin "akinsho/toggleterm.nvim")
          (plugin "tpope/vim-surround")
          (plugin "tpope/vim-repeat")
          (plugin "mattn/emmet-vim")
          (plugin "windwp/nvim-autopairs")
          (plugin "numToStr/Comment.nvim")
          (plugin "dbeniamine/cheat.sh-vim")

          # Language Server
          (plugin "neovim/nvim-lspconfig")
          (plugin "jose-elias-alvarez/null-ls.nvim")
          # (plugin "akinsho/flutter-tools.nvim")
          (plugin "tami5/lspsaga.nvim")

          # Completions
          (plugin "hrsh7th/nvim-cmp")
          (plugin "L3MON4D3/LuaSnip")
          (plugin "hrsh7th/cmp-buffer")
          (plugin "hrsh7th/cmp-nvim-lsp")
          (plugin "hrsh7th/cmp-emoji")
          (plugin "hrsh7th/cmp-nvim-lua")
          (plugin "hrsh7th/cmp-path")
          (plugin "saadparwaiz1/cmp_luasnip")
          (plugin "rafamadriz/friendly-snippets")

          # Telescope
          (plugin "nvim-telescope/telescope.nvim")
          (plugin "nvim-lua/popup.nvim")
          (plugin "nvim-lua/plenary.nvim")
          # (plugin "nvim-telescope/telescope-fzf-native.nvim")
          (plugin "nvim-telescope/telescope-file-browser.nvim")
          (plugin "ThePrimeagen/git-worktree.nvim")
          # (plugin "tknightz/telescope-termfinder.nvim")
          (plugin "ThePrimeagen/harpoon")

          # Undotree
          (plugin "mbbill/undotree")

          # Git
          (plugin "tpope/vim-fugitive")
          (plugin "lewis6991/gitsigns.nvim")

          # Tree-sitter
          (nvim-treesitter.withPlugins (plugins: pkgs.tree-sitter.allGrammars))
          (plugin "p00f/nvim-ts-rainbow")
          (plugin "windwp/nvim-ts-autotag")

          # Prose
          markdown-preview-nvim
          (plugin "nvim-orgmode/orgmode")
          (plugin "folke/zen-mode.nvim")
          (plugin "folke/twilight.nvim")
          (plugin "preservim/vim-pencil")
          (plugin "dbmrq/vim-ditto")
          (plugin "preservim/vim-litecorrect")
          (plugin "kana/vim-textobj-user")
          (plugin "preservim/vim-textobj-quote")
          (plugin "preservim/vim-textobj-sentence")
          (plugin "preservim/vim-wordy")
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
