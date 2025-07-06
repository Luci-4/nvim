vim.g.mapleader = ' '
require('config.remap')
require('config.packing')
require('config.tele')
require('config.tele_abstr')
require('config.lsp')
require('config.term')
require('config.neo_tree')
require('config.comments')
-- require('config.virtual')



vim.o.hlsearch = false
vim.o.clipboard = "unnamed"
vim.o.number = true
vim.cmd("syntax on")
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.o.wrap = false
vim.o.swapfile = false
vim.o.ruler = true
vim.o.showmatch = true
vim.o.completeopt = "menu,menuone,noselect"
vim.o.complete = ".,w,b,u,t,i,d"
vim.o.mouse = "a"
vim.o.encoding = "utf-8"
vim.o.termguicolors = true

local function system_trimmed(cmd)
  local output = vim.fn.systemlist(cmd)
  if vim.v.shell_error ~= 0 or #output == 0 then return nil end
  return output[1]
end

local function get_title_string()
  local cwd = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
  local repo = system_trimmed("git rev-parse --show-toplevel")
  local repo_name = repo and vim.fn.fnamemodify(repo, ":t") or nil
  local branch = system_trimmed("git rev-parse --abbrev-ref HEAD")

  local parts = { cwd }
  if repo_name then table.insert(parts, repo_name) end
  if branch then table.insert(parts, branch) end
  return table.concat(parts, " | ")
end


local function set_terminal_title()
  local title = get_title_string()
  local esc_seq = string.format("\27]0;%s\7", title)
  io.write(esc_seq)
  io.flush()
end

vim.api.nvim_create_autocmd({ "VimEnter", "DirChanged", "BufEnter" }, {
  callback = set_terminal_title,
})


-- Reload config
vim.keymap.set('n', '<leader>rr', function()
  vim.cmd('source ' .. vim.fn.stdpath('config') .. '/init.lua')
end)



vim.tbl_islist = vim.tbl_islist or vim.tbl_islist
vim.cmd([[colorscheme quantum]])

local message_mappings = {}

function OpenVerticalInfoBuffer(messages, source_bufnr)
  vim.cmd('vsplit')

  local info_buf = vim.api.nvim_create_buf(false, true)
  if not info_buf then
    print("Failed to create buffer")
    return
  end

  vim.api.nvim_win_set_buf(0, info_buf)

  local lines = {}
  local current_line_index = 1

  for _, msg in ipairs(messages) do
    -- Split the message into lines
    local message_lines = {}
    for line in msg.message:gmatch("([^\n]*)\n?") do
      table.insert(message_lines, line)
    end

    -- Add a prefix to the first line
    if #message_lines > 0 then
      message_lines[1] = string.format("[line %d] %s", msg.line, message_lines[1])
    end

    -- Insert into buffer and map each line to the source location
    for _, l in ipairs(message_lines) do
      table.insert(lines, l)
      message_mappings[current_line_index] = { line = msg.line, bufnr = source_bufnr }
      current_line_index = current_line_index + 1
    end
  end

  vim.api.nvim_buf_set_lines(info_buf, 0, -1, false, lines)

  -- Buffer options
  vim.bo[info_buf].buftype = 'nofile'
  vim.bo[info_buf].bufhidden = 'wipe'
  vim.bo[info_buf].swapfile = false
  vim.bo[info_buf].modifiable = false
  vim.bo[info_buf].readonly = true

  vim.api.nvim_buf_set_keymap(info_buf, 'n', '<leader>j', '', {
    noremap = true,
    silent = true,
    callback = function()
      local cursor = vim.api.nvim_win_get_cursor(0)
      local row = cursor[1]
      local target = message_mappings[row]
      if target then
        local win_found = nil
        for _, win in ipairs(vim.api.nvim_list_wins()) do
          if vim.api.nvim_win_get_buf(win) == target.bufnr then
            win_found = win
            break
          end
        end
        if win_found then
          vim.api.nvim_set_current_win(win_found)
          vim.api.nvim_win_set_cursor(win_found, { target.line, 0 })
        else
          print("Target buffer not visible in any window")
        end
      else
        print("No jump target for this line")
      end
    end
  })
end



vim.api.nvim_create_user_command("TestOpenVerticalInfoBuffer", function()
  local current_buf = vim.api.nvim_get_current_buf()
  local total_lines = vim.api.nvim_buf_line_count(current_buf)
  
  local json_messages = {
    { line = 2, message = "Something went wrong in the parser.\nidk what but here is the second line" },
    { line = 12, message = "Deprecated function usage." },
  }

  OpenVerticalInfoBuffer(json_messages, current_buf)
end, { desc = "Test OpenVerticalInfoBuffer on current buffer lines" })

require("nvim-web-devicons").setup {
  -- override = {
  --   zsh = {
  --     icon = "",
  --     color = "#428850",
  --     cterm_color = "65",
  --     name = "Zsh"
  --   }
  -- },
  default = true,
}
vim.o.cmdheight = 2
print(require('nvim-web-devicons').get_icon("lua", "lua"))
