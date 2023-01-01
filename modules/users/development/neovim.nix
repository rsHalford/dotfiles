{ pkgs, config, lib, ... }:
with lib;

let
  cfg = config.richard.development.neovim;
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
        extraConfig = ''
          luafile ${builtins.toString ./nvim/init_lua.lua}
          luafile ${builtins.toString ./nvim/lua/keymaps.lua}
          luafile ${builtins.toString ./nvim/lua/options.lua}
          luafile ${builtins.toString ./nvim/lua/config/git.lua}
          luafile ${builtins.toString ./nvim/lua/config/lsp.lua}
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
          cmp-cmdline
          cmp_luasnip
          cmp-nvim-lsp
          cmp-nvim-lua
          cmp-path
          lspkind-nvim

          # UI/UX
          rose-pine
          nvim-colorizer-lua
          nvim-web-devicons
          nvim-tree-lua
          lualine-nvim
          vim-surround
          vim-repeat
          nvim-autopairs
          comment-nvim
          fidget-nvim

          # Telescope
          telescope-nvim
          popup-nvim
          plenary-nvim
          telescope-file-browser-nvim
          harpoon

          # Undotree
          undotree


          # Tree-sitter
          nvim-treesitter.withAllGrammars
          nvim-ts-rainbow
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
