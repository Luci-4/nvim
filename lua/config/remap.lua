vim.keymap.set('n', '<leader><leader>', '<C-^>')

-- Resize functions
local function increase_height() vim.cmd('resize +10') end
local function decrease_height() vim.cmd('resize -10') end
local function increase_width() vim.cmd('vertical resize +10') end
local function decrease_width() vim.cmd('vertical resize -10') end

vim.keymap.set('n', '<C-k>', increase_height)
vim.keymap.set('n', '<C-j>', decrease_height)
vim.keymap.set('n', '<C-l>', increase_width)
vim.keymap.set('n', '<C-h>', decrease_width)

-- Window navigation with Esc + hjkl
vim.keymap.set('n', '<Esc>h', '<C-w>h')
vim.keymap.set('n', '<Esc>j', '<C-w>j')
vim.keymap.set('n', '<Esc>k', '<C-w>k')
vim.keymap.set('n', '<Esc>l', '<C-w>l')

-- Scroll with Ctrl+Meta
vim.keymap.set('n', '<C-M-j>', '<C-e>')
vim.keymap.set('n', '<C-M-k>', '<C-y>')

-- Terminal mode escape
vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]])