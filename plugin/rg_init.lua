local rg_setup = require('rg_setup')

if vim.fn.executable('rg') == 0 then
  rg_setup.install_rg()

  local data_path = vim.fn.stdpath('data') .. '/ripgrep.nvim'
  vim.env.PATH = vim.env.PATH .. ':' .. data_path
end
