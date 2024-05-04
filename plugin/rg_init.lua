local rg_setup = require('rg_setup')

local data_path = vim.fn.stdpath('data') .. '/ripgrep.nvim'
if vim.fn.isdirectory(data_path) == 0 then
  rg_setup.install_rg()
  vim.fn.mkdir(data_path, 'p')
end

if vim.fn.executable('rg') == 0 then
  local data_path = vim.fn.stdpath('data') .. '/ripgrep.nvim'
  vim.env.PATH = vim.env.PATH .. ':' .. data_path
end
