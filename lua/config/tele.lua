local builtin = require("telescope.builtin")

vim.keymap.set("n", "<leader>ff", builtin.find_files)
vim.keymap.set("n", "<leader>fs", builtin.live_grep)
vim.keymap.set("n", "<leader>fb", builtin.buffers)
vim.keymap.set("n", "<leader>fh", builtin.help_tags)
local actions = require("telescope.actions")
local telescope = require("telescope")

telescope.setup{
  defaults = {
    mappings = {
      i = {
        ["<M-j>"] = actions.move_selection_next,
        ["<M-k>"] = actions.move_selection_previous,
        ["<C-v>"] = actions.select_vertical,
        ["<C-h>"] = actions.select_horizontal,
        ["<C-c>"] = false,
        ["<Tab>"] = actions.select_tab,
        ["<C-g>"] = actions.move_to_top,
        ["<C-G>"] = actions.move_to_bottom,
      },
      n = {
        ["<C-v>"] = actions.select_vertical,
        ["<C-h>"] = actions.select_horizontal,
        ["<C-c>"] = false,
        ["<M-j>"] = actions.move_selection_next,
        ["<M-k>"] = actions.move_selection_previous,
        ["<Tab>"] = actions.select_tab,
        ["gg"] = actions.move_to_top,
        ["G"] = actions.move_to_bottom,
      }
    },
  }
}

vim.keymap.set("n", "<leader>*", function()
  local word = vim.fn.expand("<cword>")
  builtin.live_grep({ default_text = word })
end, { desc = "Live grep word under cursor" })
