return {
  "nyoom-engineering/oxocarbon.nvim",
  config = function()
    vim.opt.background = "dark" -- Set to "dark" or "light"
    vim.cmd("colorscheme oxocarbon") -- Load colorscheme for stable
    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
  end,
}
