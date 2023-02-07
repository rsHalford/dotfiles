{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.richard.development.neovim;
in {
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
        extraConfig = ''
          luafile ${builtins.toString ./nvim/init_lua.lua}
          luafile ${builtins.toString ./nvim/lua/keymaps.lua}
          luafile ${builtins.toString ./nvim/lua/options.lua}
          luafile ${builtins.toString ./nvim/lua/config/git.lua}
          luafile ${builtins.toString ./nvim/lua/config/lsp.lua}
          luafile ${builtins.toString ./nvim/lua/config/prose.lua}
          luafile ${builtins.toString ./nvim/lua/config/telescope.lua}
          luafile ${builtins.toString ./nvim/lua/config/treesitter.lua}
          luafile ${builtins.toString ./nvim/lua/config/ux.lua}
        '';
        plugins = with pkgs.vimPlugins; [
          # Git
          gitsigns-nvim
          neogit

          # LSP
          nvim-lspconfig
          nvim-cmp
          luasnip
          cmp-buffer
          cmp_luasnip
          cmp-nvim-lsp-signature-help
          cmp-nvim-lsp
          cmp-nvim-lua
          cmp-path
          lspkind-nvim
          friendly-snippets
          neodev-nvim
          nvim-lint
          formatter-nvim
          symbols-outline-nvim
          nvim-code-action-menu

          # UI/UX
          lspsaga-nvim-original
          rose-pine
          alpha-nvim
          nvim-colorizer-lua
          nvim-web-devicons
          nvim-tree-lua
          lualine-nvim
          nvim-surround
          vim-repeat
          nvim-autopairs
          comment-nvim
          fidget-nvim
          which-key-nvim
          undotree
          toggleterm-nvim
          nvim-lightbulb
          FixCursorHold-nvim

          # Telescope
          telescope-nvim
          popup-nvim
          plenary-nvim
          telescope-fzf-native-nvim
          harpoon
          todo-comments-nvim
          refactoring-nvim

          # Tree-sitter
          nvim-treesitter.withAllGrammars
          nvim-treesitter-textobjects
          nvim-ts-rainbow
          nvim-ts-autotag

          # Writing
          markdown-preview-nvim
          zen-mode-nvim
          twilight-nvim
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
