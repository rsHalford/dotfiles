{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.richard.development.neovim;
  theme = config.richard.theme;
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
        autoCmd = [
          {
            event = "TextYankPost";
            pattern = "*";
            command = "silent! lua vim.highlight.on_yank()";
          }
          {
            event = "FileType";
            pattern = ["markdown" "tex" "typst"];
            command = "setlocal wrap linebreak colorcolumn= nocursorline nocursorcolumn";
          }
        ];
        colorscheme = theme.name;
        extraConfigLua = ''
          vim.opt.path:append "**";
        '';
        filetype = {
          extension = {
            templ = "templ";
            typ = "typst";
          };
        };
        globals = {
          mapleader = " ";
          maplocalleader = " ";
          netrw_banner = 0;
          netrw_winsize = 25;
          netrw_altv = 1;
          netrw_liststyle = 3;
          netrw_list_hide = ",(^|ss)zs\S+";
        };
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
          relativenumber = true;
          scrolloff = 8;
          shiftwidth = 2;
          shortmess = "aoOstTWAIcCFS";
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
        keymaps = [
          {
            key = "<leader>y";
            action = ''"+y'';
            mode = ["n" "v"];
            options = {
              silent = true;
              desc = "Yank selection to clipboard";
            };
          }
          {
            key = "<leader>Y";
            action = ''gg"+yG'';
            mode = "n";
            options = {
              silent = true;
              desc = "Yank file to clipboard";
            };
          }
          {
            key = "<leader>p";
            action = ''"_dP'';
            mode = "n";
            options = {
              silent = true;
              desc = "Preserve yank";
            };
          }
          {
            key = "<leader>d";
            action = ''"_d'';
            mode = ["n" "v"];
            options = {
              silent = true;
              desc = "Delete selection";
            };
          }
          {
            key = "n";
            action = "nzzzv";
            mode = "n";
            options = {
              silent = true;
              desc = "Centre next match";
            };
          }
          {
            key = "N";
            action = "Nzzzv";
            mode = "n";
            options = {
              silent = true;
              desc = "Centre prev match";
            };
          }
          {
            key = "<C-u>";
            action = "<C-u>zz";
            mode = "n";
            options = {
              silent = true;
              desc = "Centre scroll up";
            };
          }
          {
            key = "<C-d>";
            action = "<C-d>zz";
            mode = "n";
            options = {
              silent = true;
              desc = "Centre scroll down";
            };
          }
          {
            key = ",";
            action = ",<C-g>u";
            mode = "i";
            options = {silent = true;};
          }
          {
            key = ".";
            action = ".<C-g>u";
            mode = "i";
            options = {silent = true;};
          }
          {
            key = "?";
            action = "?<C-g>u";
            mode = "i";
            options = {silent = true;};
          }
          {
            key = "!";
            action = "!<C-g>u";
            mode = "i";
            options = {silent = true;};
          }
          {
            key = "[";
            action = "[<C-g>u";
            mode = "i";
            options = {silent = true;};
          }
          {
            key = "{";
            action = "{<C-g>u";
            mode = "i";
            options = {silent = true;};
          }
          {
            key = "(";
            action = "(<C-g>u";
            mode = "i";
            options = {silent = true;};
          }
          {
            key = "<leader>wh";
            action = ":wincmd h<CR>";
            mode = "n";
            options = {silent = true;};
          }
          {
            key = "<leader>wj";
            action = ":wincmd j<CR>";
            mode = "n";
            options = {silent = true;};
          }
          {
            key = "<leader>wk";
            action = ":wincmd k<CR>";
            mode = "n";
            options = {silent = true;};
          }
          {
            key = "<leader>wl";
            action = ":wincmd l<CR>";
            mode = "n";
            options = {silent = true;};
          }
          {
            key = "zh";
            action = ":vertical resize -5<CR>";
            mode = "n";
            options = {
              desc = "Reduce window width";
              silent = true;
            };
          }
          {
            key = "zl";
            action = ":vertical resize +5<CR>";
            mode = "n";
            options = {
              desc = "Increase window width";
              silent = true;
            };
          }
          {
            key = "zk";
            action = ":resize -2<CR>";
            mode = "n";
            options = {
              desc = "Reduce window height";
              silent = true;
            };
          }
          {
            key = "zj";
            action = ":resize +2<CR>";
            mode = "n";
            options = {
              desc = "Increase window height";
              silent = true;
            };
          }
          {
            key = "k";
            action = ''(v:count > 5 ? "m'" . v:count : "") . "k"'';
            mode = "n";
            options = {
              desc = "Mark to jumplist";
              expr = true;
            };
          }
          {
            key = "j";
            action = ''(v:count > 5 ? "m'" . v:count : "") . "j"'';
            mode = "n";
            options = {
              desc = "Mark to jumplist";
              expr = true;
            };
          }
          {
            key = "k";
            action = "v:count == 0 ? 'gk' : 'k'";
            mode = "n";
            options = {
              desc = "Moves cursor up a line, including wrapped lines";
              silent = true;
              expr = true;
            };
          }
          {
            key = "j";
            action = "v:count == 0 ? 'gj' : 'j'";
            mode = "n";
            options = {
              desc = "Moves cursor down a line, including wrapped lines";
              silent = true;
              expr = true;
            };
          }
          {
            key = "J";
            action = ":m '>+1<CR>gv=gv";
            mode = "v";
            options = {
              desc = "Move selection down";
              silent = true;
            };
          }
          {
            key = "K";
            action = ":m '<-2<CR>gv=gv";
            mode = "v";
            options = {
              desc = "Move selection up";
              silent = true;
            };
          }
          {
            key = "<C-j>";
            action = "<esc>:m .+1<CR>==";
            mode = "i";
            options = {
              desc = "Move cursor down";
              silent = true;
            };
          }
          {
            key = "<C-k>";
            action = "<esc>:m .-2<CR>==";
            mode = "i";
            options = {
              desc = "Move cursor up";
              silent = true;
            };
          }
          {
            key = "<leader>j";
            action = ":m .+1<CR>==";
            mode = "n";
            options = {
              desc = "Move line down";
              silent = true;
            };
          }
          {
            key = "<leader>k";
            action = ":m .-2<CR>==";
            mode = "n";
            options = {
              desc = "Move line up";
              silent = true;
            };
          }
          {
            key = "J";
            action = "mzJ`z";
            mode = "n";
            options = {
              desc = "Concatenate with line below";
              silent = true;
            };
          }
          {
            key = "<C-j>";
            action = "<cmd>lua require('illuminate').goto_next_reference()<CR>";
            mode = "n";
            options = {
              desc = "Go to next reference";
              silent = true;
            };
          }
          {
            key = "<C-k>";
            action = "<cmd>lua require('illuminate').goto_prev_reference()<CR>";
            mode = "n";
            options = {
              desc = "Go to prev reference";
              silent = true;
            };
          }
          {
            key = "<leader>gb";
            action = "<cmd>lua require('gitsigns').blame_line({full = true})<CR>";
            mode = "n";
            options = {desc = "Git blame";};
          }
          {
            key = "<leader>gd";
            action = "<cmd>lua require('gitsigns').toggle_linehl() require('gitsigns').toggle_deleted()<CR>";
            mode = "n";
            options = {desc = "Git diff";};
          }
          {
            key = "<leader>gs";
            action = "<cmd>lua require('neogit').open()<CR>";
            mode = "n";
            options = {desc = "Git status";};
          }
          {
            key = "<leader>lr";
            action = ":IncRename ";
            mode = "n";
            options = {desc = "Rename";};
          }
          {
            key = "K";
            action = "<cmd>lua vim.lsp.buf.hover()<CR>";
            mode = "n";
            options = {desc = "Hover documentation";};
          }
          {
            key = "<leader>la";
            action = "<cmd>lua vim.lsp.buf.code_action()<CR>";
            mode = ["n" "v"];
            options = {desc = "Code action";};
          }
          {
            key = "<leader>ld";
            action = "<cmd>lua vim.lsp.buf.definition()<CR>";
            mode = "n";
            options = {desc = "Definition";};
          }
          {
            key = "<leader>lf";
            action = "<cmd>lua require('telescope.builtin').lsp_references()<CR>";
            mode = "n";
            options = {desc = "References";};
          }
          {
            key = "<leader>li";
            action = "<cmd>lua vim.lsp.buf.implementation()<CR>";
            mode = "n";
            options = {desc = "Implementation";};
          }
          {
            key = "<leader>lt";
            action = "<cmd>lua vim.lsp.buf.type_definition()<CR>";
            mode = "n";
            options = {desc = "Definition";};
          }
          {
            key = "<leader>lh";
            action = "<cmd>lua vim.lsp.buf.signature_help()<CR>";
            mode = "n";
            options = {desc = "Signature";};
          }
          {
            key = "<leader>sd";
            action = "<cmd>lua require('telescope.builtin').lsp_document_symbols()<CR>";
            mode = "n";
            options = {desc = "Symbols document";};
          }
          {
            key = "<leader>sw";
            action = "<cmd>lua require('telescope.builtin').lsp_workspace_symbols()<CR>";
            mode = "n";
            options = {desc = "Symbols workspace";};
          }
          {
            key = "]d";
            action = "<cmd>lua vim.diagnostic.goto_next()<CR>";
            mode = "n";
            options = {desc = "Goto next diagnostic error";};
          }
          {
            key = "[d";
            action = "<cmd>lua vim.diagnostic.goto_prev()<CR>";
            mode = "n";
            options = {desc = "Goto prev diagnostic error";};
          }
          {
            key = "<leader>wf";
            action = "<cmd>lua require('telescope.builtin').git_files()<CR>";
            mode = "n";
            options = {desc = "Workspace file";};
          }
          {
            key = "<leader>ws";
            action = "<cmd>lua require('telescope.builtin').live_grep()<CR>";
            mode = "n";
            options = {desc = "Workspace String";};
          }
          {
            key = "<leader>fb";
            action = "<cmd>lua require('telescope.builtin').buffers()<CR>";
            mode = "n";
            options = {desc = "File buffers";};
          }
          {
            key = "<leader>fo";
            action = "<cmd>lua require('telescope.builtin').oldfiles()<CR>";
            mode = "n";
            options = {desc = "File old";};
          }
          {
            key = "<leader>fs";
            action = "<cmd>lua require('telescope.builtin').current_buffer_fuzzy_find()<CR>";
            mode = "n";
            options = {desc = "File search";};
          }
          {
            key = "<leader>vh";
            action = "<cmd>lua require('telescope.builtin').help_tags()<CR>";
            mode = "n";
            options = {desc = "View help";};
          }
          {
            key = "<leader>vk";
            action = "<cmd>lua require('telescope.builtin').keymaps()<CR>";
            mode = "n";
            options = {desc = "View keymaps";};
          }
          {
            key = "<leader>vr";
            action = "<cmd>lua require('telescope.builtin').registers()<CR>";
            mode = "n";
            options = {desc = "View register";};
          }
          {
            key = "<leader>sp";
            action = "<cmd>lua require('telescope.builtin').spell_suggest()<CR>";
            mode = "n";
            options = {desc = "Spell suggest";};
          }
          {
            key = "<leader>wc";
            action = "<cmd>TodoTelescope<CR>";
            mode = "n";
            options = {desc = "Workspace comments";};
          }
          {
            key = "<leader>tc";
            action = "<cmd>TSContextToggle<CR>";
            mode = "n";
            options = {
              silent = true;
              desc = "Toggle treesitter context";
            };
          }
          {
            key = "<leader>e";
            action = "<cmd>TroubleToggle workspace_diagnostics<CR>";
            mode = "n";
            options = {
              silent = true;
              desc = "Toggle workspace diagnostics";
            };
          }
          {
            key = "<leader>tq";
            action = "<cmd>TroubleToggle quickfix<CR>";
            mode = "n";
            options = {
              silent = true;
              desc = "Toggle quickfix list";
            };
          }
          {
            key = "<leader>tl";
            action = "<cmd>TroubleToggle loclist<CR>";
            mode = "n";
            options = {
              silent = true;
              desc = "Toggle loclist";
            };
          }
        ];
        plugins = {
          comment-nvim = {
            enable = true;
            ignore = "^$";
            mappings.extended = true;
          };
          cmp-buffer.enable = true;
          cmp_luasnip.enable = true;
          cmp-nvim-lsp.enable = true;
          cmp-nvim-lsp-signature-help.enable = true;
          cmp-nvim-lua.enable = true;
          cmp-path.enable = true;
          cmp-treesitter.enable = true;
          endwise.enable = true;
          flash.enable = true;
          gitsigns = {
            enable = true;
            currentLineBlame = true;
            numhl = true;
            signcolumn = false;
            trouble = true;
          };
          harpoon = {
            enable = true;
            enableTelescope = true;
            keymaps = {
              addFile = "<leader>ha";
              toggleQuickMenu = "<leader>hm";
              navFile = {
                "1" = "<C-h>";
                "2" = "<C-j>";
                "3" = "<C-k>";
                "4" = "<C-l>";
              };
            };
          };
          hmts.enable = false; # breaks with river/large strings
          illuminate = {
            enable = true;
            underCursor = false;
          };
          inc-rename.enable = true;
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
              lualine_b = ["diagnostics"];
              lualine_c = [
                {
                  name = "filename";
                  extraConfig = {
                    newfile_status = true;
                    path = 3;
                  };
                }
              ];
              lualine_x = [
                "diff"
                "branch"
              ];
              lualine_y = ["filetype"];
              lualine_z = ["location" "progress"];
            };
            extensions = [
              "fzf"
              "quickfix"
              "trouble"
            ];
          };
          luasnip = {
            enable = true;
            extraConfig = {
              enable_autosnippets = true;
              history = true;
              updateevents = ["TextChanged" "TextChangedI"];
            };
            fromVscode = [{}];
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
              templ.enable = true;
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
          lspkind.enable = true;
          neogit.enable = true;
          noice = {
            enable = true;
            lsp = {
              override = {
                "vim.lsp.util.convert_input_to_markdown_lines" = true;
                "vim.lsp.util.stylize_markdown" = true;
                "cmp.entry.get_documentation" = true;
              };
              hover = {enabled = true;};
              signature = {enabled = true;};
            };
            messages.view = "mini";
            presets = {
              bottom_search = true;
              command_palette = true;
              long_message_to_split = true;
              inc_rename = true;
              lsp_doc_border = true;
            };
            routes = [
              {
                view = "notify";
                filter = {event = "msg_showmode";};
              }
            ];
          };
          notify.enable = true;
          nvim-autopairs = {
            enable = true;
            checkTs = true;
            disableInMacro = true;
          };
          nvim-cmp = {
            enable = true;
            mappingPresets = ["insert"];
            mapping = {
              "<M-d>" = "cmp.mapping.scroll_docs(-1)";
              "<PageUp>" = "cmp.mapping.scroll_docs(-1)";
              "<M-f>" = "cmp.mapping.scroll_docs(1)";
              "<PageDown>" = "cmp.mapping.scroll_docs(1)";
              "<M-h>" = "cmp.mapping.abort()";
              "<Left>" = "cmp.mapping.abort()";
              "<M-l>" = "cmp.mapping.confirm { select = true }";
              "<Right>" = "cmp.mapping.confirm { select = true }";
              "<M-Space>" = "cmp.mapping.complete()";
              "<Down>" = {
                action = ''
                  function(fallback)
                    if cmp.visible() then
                      cmp.select_next_item()
                    elseif luasnip.expandable() then
                      luasnip.expand()
                    elseif luasnip.expand_or_jumpable() then
                      luasnip.expand_or_jump()
                    elseif check_backspace() then
                      fallback()
                    else
                      fallback()
                    end
                  end
                '';
                modes = ["i" "s"];
              };
              "<M-j>" = {
                action = ''
                  function(fallback)
                    if cmp.visible() then
                      cmp.select_next_item()
                    elseif luasnip.expandable() then
                      luasnip.expand()
                    elseif luasnip.expand_or_jumpable() then
                      luasnip.expand_or_jump()
                    elseif check_backspace() then
                      fallback()
                    else
                      fallback()
                    end
                  end
                '';
                modes = ["i" "s"];
              };
              "<Up>" = {
                action = ''
                  function(fallback)
                    if cmp.visible() then
                      cmp.select_prev_item()
                    elseif luasnip.jumpable(-1) then
                      luasnip.jump(-1)
                    else
                      fallback()
                    end
                  end
                '';
                modes = ["i" "s"];
              };
              "<M-k>" = {
                action = ''
                  function(fallback)
                    if cmp.visible() then
                      cmp.select_prev_item()
                    elseif luasnip.jumpable(-1) then
                      luasnip.jump(-1)
                    else
                      fallback()
                    end
                  end
                '';
                modes = ["i" "s"];
              };
            };
            snippet.expand = "luasnip";
            sources = [
              {name = "luasnip";}
              {name = "nvim_lsp";}
              {name = "nvim_lua";}
              {name = "nvim_lsp_signature_help";}
              {name = "path";}
              {name = "treesitter";}
              {
                name = "buffer";
                keywordLength = 5;
              }
            ];
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
          nvim-lightbulb = {
            enable = true;
            autocmd.enabled = true;
            virtualText.enabled = true;
            # number.enabled = true;
            sign.enabled = false;
          };
          rainbow-delimiters.enable = true;
          telescope = {
            enable = true;
            extensions = {
              fzf-native.enable = true;
            };
            defaults = {
              prompt_prefix = " ";
              layout_strategy = "flex";
              borderchars = ["─" "│" "─" "│" "╭" "╮" "╯" "╰"];
              vimgrep_arguments = [
                "rg"
                "--no-heading"
                "--with-filename"
                "--line-number"
                "--column"
                "--smart-case"
                "--hidden"
              ];
              mappings = {
                n = {
                  "<C-k>" = "preview_scrolling_up";
                  "<C-j>" = "preview_scrolling_down";
                };
                i = {
                  "<C-k>" = "preview_scrolling_up";
                  "<C-j>" = "preview_scrolling_down";
                  "<M-k>" = "move_selection_previous";
                  "<M-j>" = "move_selection_next";
                  "<C-u>" = false;
                  "<C-d>" = false;
                };
              };
            };
          };
          todo-comments.enable = true;
          treesitter = {
            enable = true;
            indent = true;
            nixvimInjections = true;
            incrementalSelection = {
              enable = true;
              keymaps = {
                initSelection = "<C-space>";
                nodeIncremental = "<C-space>";
                nodeDecremental = "<C-backspace>";
                scopeIncremental = "<C-s>";
              };
            };
          };
          treesitter-context = {
            enable = true;
            maxLines = 3;
          };
          treesitter-textobjects = {
            enable = true;
            lspInterop.enable = true;
            move = {
              enable = true;
              setJumps = true;
              gotoNextStart = {
                "]m" = {
                  query = "@function.outer";
                  desc = "Next function start";
                };
                "]]" = {
                  query = "@class.outer";
                  desc = "Next class start";
                };
              };
              gotoNextEnd = {
                "]M" = {
                  query = "@function.outer";
                  desc = "Next function end";
                };
                "][" = {
                  query = "@class.outer";
                  desc = "Next class end";
                };
              };
              gotoPreviousStart = {
                "[m" = {
                  query = "@function.outer";
                  desc = "Prev function start";
                };
                "[[" = {
                  query = "@class.outer";
                  desc = "Prev class start";
                };
              };
              gotoPreviousEnd = {
                "[M" = {
                  query = "@function.outer";
                  desc = "Prev function end";
                };
                "[]" = {
                  query = "@class.outer";
                  desc = "Prev class end";
                };
              };
            };
            select = {
              enable = true;
              includeSurroundingWhitespace = true;
              lookahead = true;
              keymaps = {
                "aa" = {
                  query = "@parameter.outer";
                  desc = "Select outer part of parameter";
                };
                "ia" = {
                  query = "@parameter.inner";
                  desc = "Select inner part of parameter";
                };
                "af" = {
                  query = "@function.outer";
                  desc = "Select outer part of function";
                };
                "if" = {
                  query = "@function.inner";
                  desc = "Select inner part of function";
                };
                "ac" = {
                  query = "@class.outer";
                  desc = "Select outer part of class";
                };
                "ic" = {
                  query = "@class.inner";
                  desc = "Select inner part of class";
                };
              };
            };
            swap = {
              enable = true;
              swapNext = {
                "<leader>a" = "@parameter.inner";
              };
              swapPrevious = {
                "<leader>A" = "@parameter.inner";
              };
            };
          };
          ts-autotag.enable = true;
          ts-context-commentstring.enable = true;
          trouble = {
            enable = true;
          };
          which-key.enable = true;
        };
        extraPlugins = with pkgs.vimPlugins; [
          friendly-snippets
        ];
        colorschemes = {
          tokyonight = {
            enable = true;
            style = "night";
            transparent = true;
          };
        };
      };
    };
  };
}
