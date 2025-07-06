---@type neotree.Config.Base
local config = {
  close_if_last_window = true,
  enable_git_status = true,
  enable_diagnostics = false,
  sources = {
    "filesystem",
    "buffers",
    "git_status",
  },
  filesystem = {
    filtered_items = {
      visible = true,
      show_hidden_count = true,
      hide_dotfiles = false,
      hide_gitignored = false,
    },
    follow_current_file = {
      enabled = true,
    },
    use_libuv_file_watcher = true,
  },
  default_component_configs = {
    indent = {
      with_markers = true,
      indent_size = 2,
    },
  },
  window = {
    width = 30,
    position = "right",
    mappings = {
    ["<M-j>"] = "next",
      ["j"] = "next",
      ["<M-k>"] = "prev",
      ["k"] = "prev",
      ["<M-l>"] = "parent_or_close",

      -- Actions
      ["<cr>"] = "open",
      ["<S-h>"] = "open_vsplit",
      ["o"] = "add",
      ["i"] = "rename",
      ["<c-r>"] = "refresh",
      ["de"] = "delete",
      ["dd"] = "cut",
      ["p"] = "paste",
      ["<c-o>"] = "system_open",
    },
  },
}

require("neo-tree").setup(config)
vim.api.nvim_set_keymap(
  'n',           -- normal mode
  '<leader>e',   -- keybinding
  ':Neotree toggle<CR>', -- command to toggle Neo-tree
  { noremap = true, silent = true }
)
