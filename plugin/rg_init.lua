local data = vim.fn.stdpath("data") .. "/ripgrep.nvim"
local windows = vim.fn.has("win32") == 1

if vim.fn.isdirectory(data) == 0 then
  require("rg_setup").install_rg()
end

if vim.fn.executable("rg") == 0 then
  vim.env.PATH = vim.env.PATH .. (windows and ";" or ":") .. data
end
