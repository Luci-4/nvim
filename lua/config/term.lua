local function open_or_reuse_terminal()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.bo[buf].buftype == "terminal" then
      for _, win in ipairs(vim.api.nvim_list_wins()) do
        if vim.api.nvim_win_get_buf(win) == buf then
          return buf, win
        end
      end
    end
  end

  vim.cmd("botright split | terminal")
  local term_win = vim.api.nvim_get_current_win()
  local term_buf = vim.api.nvim_get_current_buf()
  return term_buf, term_win
end

local run_commands = {
  python = function(filename) return "python \"" .. filename .. "\"\n" end,
  lua = function(filename) return "lua \"" .. filename .. "\"\n" end,
  javascript = function(filename) return "node \"" .. filename .. "\"\n" end,
  typescript = function(filename) return "ts-node \"" .. filename .. "\"\n" end,
  sh = function(filename) return "bash \"" .. filename .. "\"\n" end,
  go = function(filename) return "go run \"" .. filename .. "\"\n" end,
}


local function run_file()
  local filetype = vim.bo.filetype
  local filename = vim.fn.expand("%:p")

  if filename == "" then
    print("No file to run.")
    return
  end

  local runner = run_commands[filetype]
  if not runner then
    print("No run command configured for filetype: " .. filetype)
    return
  end

  local term_buf, term_win = open_or_reuse_terminal()
  local chan = vim.b.terminal_job_id or vim.api.nvim_buf_get_var(term_buf, "terminal_job_id")

  if chan then
    vim.api.nvim_set_current_win(term_win)
    vim.fn.chansend(chan, runner(filename))
    vim.cmd("startinsert")
  else
    print("Error: terminal job not found")
  end
end

local uv = vim.loop

local project_build_commands = {
  go = function()
    return "go build ."
  end,

  cpp = function()
    local cwd = vim.fn.getcwd()
    local build_dir = cwd .. "/build"

    local function exists(path)
      local stat = uv.fs_stat(path)
      return stat and stat.type or false
    end

    local cmd = {}

    -- If build/ doesn't exist, initialize CMake
    if not exists(build_dir) then
      table.insert(cmd, "mkdir build")
      table.insert(cmd, "cd build")
      table.insert(cmd, 'cmake .. -G "MinGW Makefiles" -DCMAKE_EXPORT_COMPILE_COMMANDS=1')
      table.insert(cmd, "cd ..")
    end

    -- Always build
    table.insert(cmd, "cmake --build ./build")

    return table.concat(cmd, " && ")
  end,
}

local function detect_project_type()
  local cwd = vim.fn.getcwd()
  local function exists(path)
    local stat = uv.fs_stat(path)
    return stat and stat.type or false
  end

  if exists(cwd .. "/go.mod") then
    return "go"
  elseif exists(cwd .. "/CMakeLists.txt") then
    return "cpp"
  else
    return nil
  end
end

local function get_build_command()
  local project_type = detect_project_type()
  if not project_type then
    return nil, "Unknown project type or no build config found."
  end

  local command_func = project_build_commands[project_type]
  if not command_func then
    return nil, "No build command defined for project type: " .. project_type
  end

  return command_func(), nil
end

local function run_project()
    local command = get_build_command()

  local term_buf, term_win = open_or_reuse_terminal()
  local chan = vim.b.terminal_job_id or vim.api.nvim_buf_get_var(term_buf, "terminal_job_id")

  if chan then
    vim.api.nvim_set_current_win(term_win)
    vim.fn.chansend(chan, command)
    vim.cmd("startinsert")
  else
    print("Error: terminal job not found")
  end
end


vim.api.nvim_create_user_command("RunFile", run_file, {})
vim.api.nvim_create_user_command("RunProject", run_project, {})


vim.keymap.set("n", "<leader><CR>", ":RunFile<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>1", ":RunProject<CR>", { noremap = true, silent = true })



local function toggle_terminal()
  local term_buf, term_win

  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.bo[buf].buftype == "terminal" then
      for _, win in ipairs(vim.api.nvim_list_wins()) do
        if vim.api.nvim_win_get_buf(win) == buf then
          term_buf = buf
          term_win = win
          break
        end
      end
      if term_win then break end
    end
  end

  if term_win and vim.api.nvim_win_is_valid(term_win) then
    if vim.api.nvim_win_get_height(term_win) > 0 then
      vim.api.nvim_win_close(term_win, true)
    else
      vim.api.nvim_set_current_win(term_win)
    end
  else
    vim.cmd("botright split | terminal")
  end
end

vim.keymap.set("n", "<leader>t", toggle_terminal, { noremap = true, silent = true })
