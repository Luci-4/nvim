local has_telescope, telescope = pcall(require, "telescope")
if not has_telescope then return end

local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

--- Generalized picker function
--- @param opts table:
---   - title: string, prompt title
---   - items: table of strings to display
---   - mappings: table where keys are mode ('i', 'n') and values are tables of key -> function(prompt_bufnr)
local function create_picker(opts)
  local title = opts.title or "Picker"
  local items = opts.items or {}
  local mappings = opts.mappings or {}

  pickers.new({}, {
    prompt_title = title,
    finder = finders.new_table { results = items },
    sorter = conf.generic_sorter({}),
    attach_mappings = function(prompt_bufnr, map)
      -- Setup all mappings
      for mode, keymaps in pairs(mappings) do
        for key, func in pairs(keymaps) do
          map(mode, key, function()
            func(prompt_bufnr)
          end)
        end
      end
      return true
    end,
  }):find()
end

--- Helper action to yank selected line
local function yank_selected_line(prompt_bufnr)
  local entry = action_state.get_selected_entry()
  if entry then
    vim.fn.setreg('"', entry[1])
    print("Yanked: " .. entry[1])
  end
  actions.close(prompt_bufnr)
end

--- Helper action to open selected file (used for git files or any file list)
local function open_selected_file(prompt_bufnr)
  local entry = action_state.get_selected_entry()
  if entry then
    actions.close(prompt_bufnr)
    -- Open file in current window
    vim.cmd("edit " .. entry[1])
  end
end

--- Example usage: messages picker
local function messages_picker()
  local msgs = vim.api.nvim_exec("messages", true)
  local lines = {}
  for line in msgs:gmatch("[^\r\n]+") do
    table.insert(lines, line)
  end

  create_picker {
    title = "Neovim Messages",
    items = lines,
    mappings = {
      i = { y = yank_selected_line, ["<CR>"] = actions.select_default },
      n = { y = yank_selected_line, ["<CR>"] = actions.select_default },
    }
  }
end

--- Example usage: git changed files picker
local function git_changed_files_picker()
  -- Get changed files from git command
  local git_status = vim.fn.systemlist("git diff --name-only")
  create_picker {
    title = "Git Changed Files",
    items = git_status,
    mappings = {
      i = { ["<CR>"] = open_selected_file },
      n = { ["<CR>"] = open_selected_file },
    }
  }
end

-- Commands for testing
vim.api.nvim_create_user_command("Messages", messages_picker, {})
vim.api.nvim_create_user_command("GitChangedFiles", git_changed_files_picker, {})