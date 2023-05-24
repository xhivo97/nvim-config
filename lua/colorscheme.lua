vim.cmd.colorscheme "catppuccin-latte"

-- Matching brackets
local bracket_hl_options = "highlight MatchParen " ..
  "gui=underline,bold guifg=green " ..
  "cterm=underline,bold ctermfg=green " ..
  "term=underline,bold"
vim.cmd(bracket_hl_options)
