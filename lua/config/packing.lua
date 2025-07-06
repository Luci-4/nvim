vim.opt.rtp:prepend(vim.fn.stdpath("data") .. "/lazy/lazy.nvim")
require('config.env')

require("lazy").setup({
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.5",
    dependencies = { "nvim-lua/plenary.nvim" },
  },
  {
    "kjssad/quantum.vim",
  },
    {'mason-org/mason.nvim', tag = 'v1.11.0', pin = true},
  {'mason-org/mason-lspconfig.nvim', tag = 'v1.32.0', pin = true},
  {'neovim/nvim-lspconfig', tag = 'v1.8.0', pin = true},
  {'hrsh7th/cmp-nvim-lsp'},
  {'hrsh7th/nvim-cmp'},

  -- Autocompletion engine and sources
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
  },
  {
  "nvim-treesitter/nvim-treesitter",
  run = ":TSUpdate",
  config = function()
    require("nvim-treesitter.configs").setup {
      highlight = { enable = true },
      ensure_installed = { "python", "go", "c", "cpp" },
    }
  end,
},
{
  "luci-4/ai-review.nvim",
  config = function()
    require("ai_review").setup({api_key = vim.env.GROQ_API_KEY})
  end,
},
{
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
    "MunifTanjim/nui.nvim",
    -- {"3rd/image.nvim", opts = {}}, -- Optional image support in preview window: See `# Preview Mode` for more information
  },
  lazy = false, -- neo-tree will lazily load itself
  ---@module "neo-tree"
  ---@type neotree.Config?
  opts = {
    -- fill any relevant options here
    position = "right"
  },
},
{ "nvim-tree/nvim-web-devicons", lazy = true },
{
  "numToStr/Comment.nvim",
  config = function()
    require("Comment").setup({ignore = '^$'})
  end,
}
})
