return {
  {
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local harpoon = require 'harpoon'
      harpoon:setup()

      local conf = require('telescope.config').values
      local function toggle_telescope(harpoon_files)
        local file_paths = {}
        for _, item in ipairs(harpoon_files.items) do
          table.insert(file_paths, item.value)
        end

        require('telescope.pickers')
          .new({}, {
            prompt_title = 'Harpoon',
            finder = require('telescope.finders').new_table {
              results = file_paths,
            },
            previewer = conf.file_previewer {},
            sorter = conf.generic_sorter {},
          })
          :find()
      end

      vim.keymap.set('n', '<leader>hm', function()
        toggle_telescope(harpoon:list())
      end, { desc = 'Toggle Harpoon menu' })

      vim.keymap.set('n', '<leader>ha', function()
        harpoon:list():append()
      end, { desc = 'Append file to Harpoon list' })

      -- Meta for laptop/qwerty, Ctrl for corne/colemak
      vim.keymap.set('n', '<M-1>', function()
        harpoon:list():select(1)
      end)
      vim.keymap.set('n', '<C-1>', function()
        harpoon:list():select(1)
      end)

      vim.keymap.set('n', '<M-2>', function()
        harpoon:list():select(2)
      end)
      vim.keymap.set('n', '<C-2>', function()
        harpoon:list():select(2)
      end)

      vim.keymap.set('n', '<M-3>', function()
        harpoon:list():select(3)
      end)
      vim.keymap.set('n', '<C-3>', function()
        harpoon:list():select(3)
      end)

      vim.keymap.set('n', '<M-4>', function()
        harpoon:list():select(4)
      end)
      vim.keymap.set('n', '<C-4>', function()
        harpoon:list():select(4)
      end)
    end,
  },
}

-- vim: ts=2 sts=2 sw=2 et
