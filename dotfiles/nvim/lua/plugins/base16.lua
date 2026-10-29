return {
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = function() end,
    },
  },
  {
    "RRethy/base16-nvim",
    -- enabled= false,
    config = function()
      require("matugen").setup()
      vim.g.colors_name = "matugen"
    end,
  },
}
