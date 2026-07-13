-- ターミナル(Ghostty)のパレットをそのまま使う
vim.opt.termguicolors = false
vim.opt.background = "light"

vim.opt.number = true
vim.opt.wrap = false
vim.opt.list = true
vim.opt.listchars = {
  tab = ">-",
  trail = "~",
  extends = ">",
  precedes = "<",
  nbsp = ".",
}
vim.opt.clipboard = "unnamedplus"
