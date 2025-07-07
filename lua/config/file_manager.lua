local function my_on_attach(bufnr)
    local api = require("nvim-tree.api")

    function getDirPathAndName()

        local result = api.tree.get_node_under_cursor()
        local type = result["type"]
        local path = result["absolute_path"]
        local name = result["name"]
        local dir_path = nil
        if type == "file" then
            dir_path = path:match("(.*/)")
        end
        if type == "directory" then
            dir_path = path .. "/"
        end
        return dir_path, name
    end

    function rename()
        local dir_path, name = getDirPathAndName()
        local new_name = vim.fn.input(dir_path, name)
        vim.fn.system("mv " .. dir_path .. name .. " " .. new_name)
    end

    function create()
        local dir_path, name = getDirPathAndName()
        local new_name = vim.fn.input(dir_path, "")
        vim.fn.system("touch " .. dir_path .. new_name)
    end

    function delete()
        local dir_path, name = getDirPathAndName()
        local answer = vim.fn.input("Delete " .. dir_path .. name .. "? (y/n)", "")
        if answer == "y" then
            vim.fn.system("rm " .. dir_path .. name)
        end
    end

      local function opts(desc)
        return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
      end
    vim.api.nvim_create_user_command("Rename", rename, {})
    vim.keymap.set("n", "i", ":Rename<CR>", opts("Rename file"))

    vim.api.nvim_create_user_command("Create", create, {})
    vim.keymap.set("n", "o", ":Create<CR>", opts("Create file"))
    
    vim.api.nvim_create_user_command("Delete", delete, {})
    vim.keymap.set("n", "dd", ":Delete<CR>", opts("Delete file"))


  -- BEGIN_DEFAULT_ON_ATTACH
  -- vim.keymap.set("n", "<C-]>",          api.tree.change_root_to_node,       opts("CD"))
  -- vim.keymap.set("n", "<C-e>",          api.node.open.replace_tree_buffer,  opts("Open: In Place"))
  -- vim.keymap.set("n", "<C-k>",          api.node.show_info_popup,           opts("Info"))
  -- vim.keymap.set("n", "<C-r>",          api.fs.rename_sub,                  opts("Rename: Omit Filename"))
  -- vim.keymap.set("n", "<C-t>",          api.node.open.tab,                  opts("Open: New Tab"))
  vim.keymap.set("n", "<S-h>",          api.node.open.vertical,             opts("Open: Vertical Split"))
  -- vim.keymap.set("n", "<C-x>",          api.node.open.horizontal,           opts("Open: Horizontal Split"))
  -- vim.keymap.set("n", "<BS>",           api.node.navigate.parent_close,     opts("Close Directory"))
  vim.keymap.set("n", "<CR>",           api.node.open.edit,                 opts("Open"))
  vim.keymap.set("n", "h",           api.node.open.edit,                 opts("Open"))
  -- vim.keymap.set("n", "<Tab>",          api.node.open.preview,              opts("Open Preview"))
  -- vim.keymap.set("n", ">",              api.node.navigate.sibling.next,     opts("Next Sibling"))
  -- vim.keymap.set("n", "<",              api.node.navigate.sibling.prev,     opts("Previous Sibling"))
  -- vim.keymap.set("n", ".",              api.node.run.cmd,                   opts("Run Command"))
  -- vim.keymap.set("n", "-",              api.tree.change_root_to_parent,     opts("Up"))
  -- vim.keymap.set("n", "a",              api.fs.create,                      opts("Create File Or Directory"))
  -- vim.keymap.set("n", "bd",             api.marks.bulk.delete,              opts("Delete Bookmarked"))
  -- vim.keymap.set("n", "bt",             api.marks.bulk.trash,               opts("Trash Bookmarked"))
  -- vim.keymap.set("n", "bmv",            api.marks.bulk.move,                opts("Move Bookmarked"))
  -- vim.keymap.set("n", "B",              api.tree.toggle_no_buffer_filter,   opts("Toggle Filter: No Buffer"))
  -- vim.keymap.set("n", "c",              api.fs.copy.node,                   opts("Copy"))
  -- vim.keymap.set("n", "C",              api.tree.toggle_git_clean_filter,   opts("Toggle Filter: Git Clean"))
  -- vim.keymap.set("n", "[c",             api.node.navigate.git.prev,         opts("Prev Git"))
  -- vim.keymap.set("n", "]c",             api.node.navigate.git.next,         opts("Next Git"))
  -- vim.keymap.set("n", "d",              api.fs.remove,                      opts("Delete"))
  -- vim.keymap.set("n", "D",              api.fs.trash,                       opts("Trash"))
  -- vim.keymap.set("n", "E",              api.tree.expand_all,                opts("Expand All"))
  -- vim.keymap.set("n", "e",              api.fs.rename_basename,             opts("Rename: Basename"))
  -- vim.keymap.set("n", "]e",             api.node.navigate.diagnostics.next, opts("Next Diagnostic"))
  -- vim.keymap.set("n", "[e",             api.node.navigate.diagnostics.prev, opts("Prev Diagnostic"))
  -- vim.keymap.set("n", "F",              api.live_filter.clear,              opts("Live Filter: Clear"))
  -- vim.keymap.set("n", "f",              api.live_filter.start,              opts("Live Filter: Start"))
  -- vim.keymap.set("n", "g?",             api.tree.toggle_help,               opts("Help"))
  -- vim.keymap.set("n", "gy",             api.fs.copy.absolute_path,          opts("Copy Absolute Path"))
  -- vim.keymap.set("n", "ge",             api.fs.copy.basename,               opts("Copy Basename"))
  -- vim.keymap.set("n", "H",              api.tree.toggle_hidden_filter,      opts("Toggle Filter: Dotfiles"))
  -- vim.keymap.set("n", "I",              api.tree.toggle_gitignore_filter,   opts("Toggle Filter: Git Ignore"))
  vim.keymap.set("n", "G",              api.node.navigate.sibling.last,     opts("Last Sibling"))
  vim.keymap.set("n", "gg",              api.node.navigate.sibling.first,    opts("First Sibling"))
  -- vim.keymap.set("n", "L",              api.node.open.toggle_group_empty,   opts("Toggle Group Empty"))
  -- vim.keymap.set("n", "M",              api.tree.toggle_no_bookmark_filter, opts("Toggle Filter: No Bookmark"))
  -- vim.keymap.set("n", "m",              api.marks.toggle,                   opts("Toggle Bookmark"))
  -- vim.keymap.set("n", "<C-o>",              api.node.open.edit,                 opts("Open"))
  -- vim.keymap.set("n", "O",              api.node.open.no_window_picker,     opts("Open: No Window Picker"))
  -- vim.keymap.set("n", "p",              api.fs.paste,                       opts("Paste"))
  -- vim.keymap.set("n", "P",              api.node.navigate.parent,           opts("Parent Directory"))
  vim.keymap.set("n", "<Esc>",              api.tree.close,                     opts("Close"))
  -- vim.keymap.set("n", "r",              api.fs.rename,                      opts("Rename"))
  vim.keymap.set("n", "<C-r>",              api.tree.reload,                    opts("Refresh"))
  vim.keymap.set("n", "<C-o>",              api.node.run.system,                opts("Run System"))
  -- vim.keymap.set("n", "S",              api.tree.search_node,               opts("Search"))
  -- vim.keymap.set("n", "u",              api.fs.rename_full,                 opts("Rename: Full Path"))
  -- vim.keymap.set("n", "U",              api.tree.toggle_custom_filter,      opts("Toggle Filter: Hidden"))
  -- vim.keymap.set("n", "W",              api.tree.collapse_all,              opts("Collapse All"))
  -- vim.keymap.set("n", "x",              api.fs.cut,                         opts("Cut"))
  -- vim.keymap.set("n", "y",              api.fs.copy.filename,               opts("Copy Name"))
  -- vim.keymap.set("n", "Y",              api.fs.copy.relative_path,          opts("Copy Relative Path"))
  -- vim.keymap.set("n", "<2-LeftMouse>",  api.node.open.edit,                 opts("Open"))
  -- vim.keymap.set("n", "<2-RightMouse>", api.tree.change_root_to_node,       opts("CD"))
end

  -- pass to setup along with your other options
require("nvim-tree").setup {
    on_attach = my_on_attach,
    -- hijack_cursor = false,
    --   auto_reload_on_write = true,
    --   disable_netrw = false,
    --   hijack_netrw = true,
    --   hijack_unnamed_buffer_when_opening = false,
    --   root_dirs = {},
    --   prefer_startup_root = false,
    --   sync_root_with_cwd = false,
    --   reload_on_bufenter = false,
    --   respect_buf_cwd = false,
    --   select_prompts = false,
      sort = {
        sorter = "name",
        folders_first = true,
        files_first = false,
      },
      view = {
        -- centralize_selection = false,
        -- cursorline = true,
        -- cursorlineopt = "both",
        -- debounce_delay = 15,
        -- side = "right",
        -- preserve_window_proportions = false,
        number = false,
        relativenumber = false,
        signcolumn = "yes",
        width = 60,
        float = {
          enable = true,
          quit_on_focus_loss = true,
          open_win_config = function()
            local width = 60
            local height = 30
            local editor_width = vim.o.columns
            local editor_height = vim.o.lines

            local row = math.floor((editor_height - height) / 2 - 1)
            local col = math.floor((editor_width - width) / 2)

            return {
              relative = "editor",
              border = "rounded",
              width = width,
              height = height,
              row = row,
              col = col,
            }
          end,
        }
      },
      renderer = {
        -- add_trailing = false,
        -- group_empty = false,
        -- full_name = false,
        root_folder_label = function(path)
              return vim.fn.fnamemodify(path, ':t') .. "/"
            end,
        -- indent_width = 2,
        -- special_files = { "Cargo.toml", "Makefile", "README.md", "readme.md" },
        -- hidden_display = "none",
        -- symlink_destination = true,
        -- decorators = { "Git", "Open", "Hidden", "Modified", "Bookmark", "Diagnostics", "Copied", "Cut", },
        -- highlight_git = "none",
        -- highlight_diagnostics = "none",
        -- highlight_opened_files = "none",
        -- highlight_modified = "none",
        -- highlight_hidden = "none",
        -- highlight_bookmarks = "none",
        -- highlight_clipboard = "name",
        indent_markers = {
          enable = false,
          inline_arrows = true,
          icons = {
            corner = "└",
            edge = "│",
            item = "│",
            bottom = "─",
            none = " ",
          },
        },
        icons = {
          web_devicons = {
            file = {
              enable = true,
              color = true,
            },
            folder = {
              enable = true,
              color = true,
            },
          },
          git_placement = "before",
          modified_placement = "after",
          hidden_placement = "after",
          diagnostics_placement = "signcolumn",
          bookmarks_placement = "signcolumn",
          padding = {
            icon = " ",
            folder_arrow = " ",
          },
          symlink_arrow = " ➛ ",
          show = {
            file = true,
            folder = true,
            folder_arrow = true,
            git = true,
            modified = true,
            hidden = true,
            diagnostics = true,
            bookmarks = true,
          },
          glyphs = {
            default = "",
            symlink = "",
            bookmark = "󰆤",
            modified = "●",
            hidden = "󰜌",
            folder = {
              arrow_closed = "",
              arrow_open = "",
              default = "",
              open = "",
              empty = "",
              empty_open = "",
              symlink = "",
              symlink_open = "",
            },
            git = {
              unstaged = "✗",
              staged = "✓",
              unmerged = "",
              renamed = "➜",
              untracked = "★",
              deleted = "",
              ignored = "◌",
            },
          },
        },
      },
      -- hijack_directories = {
      --   enable = true,
      --   auto_open = true,
      -- },
      -- update_focused_file = {
      --   enable = false,
      --   update_root = {
      --     enable = false,
      --     ignore_list = {},
      --   },
      --   exclude = false,
      -- },
      system_open = {
        cmd = "",
        args = {},
      },
      git = {
        enable = false,
        show_on_dirs = true,
        show_on_open_dirs = true,
        disable_for_dirs = {},
        timeout = 400,
        cygwin_support = false,
      },
      diagnostics = {
        enable = true,
        show_on_dirs = true,
        show_on_open_dirs = true,
        debounce_delay = 500,
        severity = {
          min = vim.diagnostic.severity.HINT,
          max = vim.diagnostic.severity.ERROR,
        },
        icons = {
          hint = "",
          info = "",
          warning = "",
          error = "",
        },
      },
      modified = {
        enable = false,
        show_on_dirs = true,
        show_on_open_dirs = true,
      },
      filters = {
        enable = true,
        git_ignored = true,
        dotfiles = false,
        git_clean = false,
        no_buffer = false,
        no_bookmark = false,
        custom = {},
        exclude = {},
      },
      -- live_filter = {
      --   prefix = "[FILTER]: ",
      --   always_show_folders = true,
      -- },
      filesystem_watchers = {
        enable = true,
        debounce_delay = 50,
        ignore_dirs = {
          ".ccls-cache",
          "build",
          "node_modules",
          "target",
        },
      },
      actions = {
        use_system_clipboard = true,
        -- change_dir = {
        --   enable = true,
        --   global = false,
        --   restrict_above_cwd = false,
        -- },
        -- expand_all = {
        --   max_folder_discovery = 300,
        --   exclude = {},
        -- },
        -- file_popup = {
        --   open_win_config = {
        --     col = 1,
        --     row = 1,
        --     relative = "cursor",
        --     border = "shadow",
        --     style = "minimal",
        --   },
        -- },
        -- open_file = {
        --   quit_on_open = false,
        --   eject = true,
        --   resize_window = true,
        --   relative_path = true,
        --   window_picker = {
        --     enable = true,
        --     picker = "default",
        --     chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",
        --     exclude = {
        --       filetype = { "notify", "packer", "qf", "diff", "fugitive", "fugitiveblame" },
        --       buftype = { "nofile", "terminal", "help" },
        --     },
        --   },
        -- },
        -- remove_file = {
        --   close_window = true,
        -- },
      },
      -- trash = {
      --   cmd = "gio trash",
      -- },
      -- tab = {
      --   sync = {
      --     open = false,
      --     close = false,
      --     ignore = {},
      --   },
      -- },
      -- notify = {
      --   threshold = vim.log.levels.INFO,
      --   absolute_path = true,
      -- },
      -- help = {
      --   sort_by = "key",
      -- },
      -- ui = {
      --   confirm = {
      --     remove = true,
      --     trash = true,
      --     default_yes = false,
      --   },
      -- },
      -- experimental = {
      --   multi_instance = false,
      -- },
      -- log = {
      --   enable = false,
      --   truncate = false,
      --   types = {
      --     all = false,
      --     config = false,
      --     copy_paste = false,
      --     dev = false,
      --     diagnostics = false,
      --     git = false,
      --     profile = false,
      --     watcher = false,
      --   },
      -- },
}
vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { noremap = true, silent = true, desc = "Toggle NvimTree" })
