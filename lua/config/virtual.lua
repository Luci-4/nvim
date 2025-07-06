local ns_id = vim.api.nvim_create_namespace("my_virtual_text")
local virt_text_visible = false

vim.api.nvim_set_hl(0, "PrintArrow", {
  fg = "#40E0D0",
  bold = true,
  underline = false,
})

vim.api.nvim_set_hl(0, "PrintHighlight", {
  fg = "#40E0D0",
  bold = true,
  underline = true,
})
vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = function()
    vim.api.nvim_set_hl(0, "PrintArrow", {
      fg = "#40E0D0",
      bold = true,
      underline = false,
    })
    vim.api.nvim_set_hl(0, "PrintHighlight", {
      fg = "#40E0D0",
      bold = true,
      underline = true,
    })
  end,
})

local function show_virtual_text()
  local buf = vim.api.nvim_get_current_buf()
  vim.api.nvim_buf_clear_namespace(buf, ns_id, 0, -1)
  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)

    for lnum, line in ipairs(lines) do
        for start_col in line:gmatch("()print") do
            vim.api.nvim_buf_set_extmark(buf, ns_id, lnum - 1, start_col - 1, {
            virt_text = {
                { "→ ", "Normal" },
                { "printing boi", "PrintHighlight" },
            },
            virt_text_pos = "eol",
            })
        end
    end
end


local function hide_virtual_text()
  vim.api.nvim_buf_clear_namespace(0, ns_id, 0, -1)
end

local function toggle_virtual_text()
  if virt_text_visible then
    hide_virtual_text()
    virt_text_visible = false
  else
    show_virtual_text()
    virt_text_visible = true
  end
end

vim.api.nvim_create_user_command("TogglePrintMarks", toggle_virtual_text, {})
