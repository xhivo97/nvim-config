require("lazy").setup({
  { "catppuccin/nvim", name = "catppuccin" },
  { "neovim/nvim-lspconfig", name = "lspconfig" },
  { "m4xshen/smartcolumn.nvim", name = "smartcolumn", opts = {} },
  {
    "folke/which-key.nvim",
    config = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 75
      require("which-key").setup({
      })
    end,
  },
})

