local undo_dir = vim.fn.expand("~/.config/nvim/undo")
if vim.fn.isdirectory(undo_dir) == 0 then
  vim.fn.mkdir(undo_dir, "p")
end
vim.opt.history = 100
vim.opt.undolevels = 1000
vim.opt.undofile = true
vim.opt.undodir = undo_dir
