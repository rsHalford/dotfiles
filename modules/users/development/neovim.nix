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
      nixvim = {
        enable = true;
        enableMan = true;
        colorscheme = "tokyonight";
        extraConfigLuaPre = "";
        extraConfigLua = ''
          vim.opt.path:append "**";
          vim.opt.shortmess:append "c";
        '';
        extraConfigLuaPost = "";
        extraConfigVim = "";
        extraFiles = {};
        extraPackages = [];
        extraPlugins = [];
        globals = {};
        match = {};
        options = {
          autochdir = true;
          cmdheight = 1;
          colorcolumn = "80";
          completeopt = ["menu" "menuone" "noselect"];
          cursorcolumn = true;
          cursorline = true;
          errorbells = false;
          expandtab = true;
          exrc = true;
          hlsearch = false;
          ignorecase = true;
          number = true;
          # path:append "**"; # added to extraConfigLua
          relativenumber = true;
          scrolloff = 8;
          shiftwidth = 2;
          # shortmess:append "c"; # added to extraConfigLua
          showmode = false;
          signcolumn = "no";
          smartcase = true;
          smartindent = true;
          softtabstop = 2;
          spelllang = "en_gb";
          splitbelow = true;
          splitright = true;
          tabstop = 2;
          termguicolors = true;
          timeoutlen = 500;
          title = true;
          undofile = true;
          updatetime = 50;
          wildmode = ["longest" "full"];
          wrap = false;
        };
        plugins = {
          comment-nvim = {
            enable = true;
            ignore = "^$";
            mappings.extended = true;
          };
          fidget = {
            enable = true;
          };
          gitsigns = {
            enable = true;
            currentLineBlame = true;
            numhl = true;
            signcolumn = false;
            trouble = true; # TODO: true if trouble is enabled
          };
          lualine = {
            enable = true;
            componentSeparators = {
              left = "";
              right = "";
            };
            sectionSeparators = {
              left = "";
              right = "";
            };
            sections = {
              lualine_a = ["mode"];
              lualine_b = [
                "diagnostics"
                # { sources = "nvim_diagnostic"; }
              ];
              lualine_c = [
                "filename"
                # { newfile_status = true; }
                # { path = 3; }
              ];
              lualine_x = ["diff" "branch"];
              lualine_y = ["filetype"];
              lualine_z = ["location" "progress"];
            };
            extensions = [
              "fzf"
              # "nvim-tree"
              "quickfix"
              "symbols-outline"
              # "toggleterm"
              "trouble"
            ];
          };
          lint = {
            enable = true;
            autoCmd = {
              callback = {
                __raw = ''
                  function()
                    require('lint').try_lint()
                  end
                '';
              };
              event = ["BufWritePost" "BufEnter" "BufLeave"];
            };
            customLinters = {};
            extraOptions = {};
            lintersByFt = {
              elixir = ["credo"];
              go = ["golangcilint"];
              lua = ["selene"];
              markdown = ["vale"];
              nix = ["nix"];
              python = ["mypy" "ruff"];
              sh = ["shellcheck"];
              # text = ["vale"];
            };
          };
          lsp = {
            enable = true;
            servers = {
              astro.enable = true;
              bashls.enable = true;
              biome.enable = false;
              cssls.enable = true;
              elixirls.enable = true;
              gopls.enable = true;
              html.enable = false;
              jsonls.enable = false;
              lua-ls.enable = false;
              nil_ls.enable = true;
              nixd.enable = false;
              tailwindcss.enable = true;
              taplo.enable = true;
              texlab.enable = false;
              tsserver.enable = true;
              typst-lsp.enable = true;
              yamlls.enable = false;
              zls.enable = true;
            };
          };
          lsp-format = {
            enable = true;
          };
          neogit = {
            enable = true;
          };
          nvim-autopairs = {
            enable = true;
            checkTs = true;
            disableInMacro = true;
          };
          nvim-colorizer = {
            enable = true;
            userDefaultOptions = {
              css = true;
              mode = "background";
              names = false;
              tailwind = "both";
            };
          };
          trouble = {
            enable = true;
          };
        };
        colorschemes = {
          tokyonight = {
            enable = true;
            style = "night";
          };
        };
      };
      neovim = {
        enable = false;
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
          trouble-nvim
          lspsaga-nvim
          tokyonight-nvim
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
          nvim-treesitter-context
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
