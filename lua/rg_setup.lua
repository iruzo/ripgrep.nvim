local M = {}

local function delete_ripgrep_directories(directory)
  local entries = vim.fn.readdir(directory)

  for _, entry in ipairs(entries) do
    local full_path = directory .. '/' .. entry
    if vim.fn.isdirectory(full_path) == 1 and entry:find("^ripgrep") then
      vim.fn.delete(full_path, "rf")
    end
  end
end

local function get_current_directory()
  local info = debug.getinfo(1, "S")
  local path = info.source
  if path:sub(1,1) == "@" then
    path = path:sub(2)
  end
  return path:match("(.*/)")
end

function M.install_rg()
  local data_path = vim.fn.stdpath('data') .. '/ripgrep.nvim'
  if vim.fn.isdirectory(data_path) == 0 then
    vim.fn.mkdir(data_path, 'p')
  end

  local current_directory = get_current_directory()
  local rg_version = vim.fn.readfile(current_directory .. '../rg_version')[1]
  local os_type = vim.loop.os_uname().sysname
  local arch_type = vim.loop.os_uname().machine
  local url, extract_cmd

  local base_url = "https://github.com/BurntSushi/ripgrep/releases/download/" .. rg_version .. "/ripgrep-" .. rg_version

  if os_type == "Windows_NT" then
    if arch_type == "x86_64" then
      url = base_url .. "-x86_64-pc-windows-msvc.zip"
      extract_cmd = "powershell.exe -command Expand-Archive -Path " .. data_path .. "\\rg.zip -DestinationPath " .. data_path
    elseif arch_type == "i686" then
      url = base_url .. "-i686-pc-windows-msvc.zip"
      extract_cmd = "powershell.exe -command Expand-Archive -Path " .. data_path .. "\\rg.zip -DestinationPath " .. data_path
    else
      error("Unsupported architecture for Windows")
    end
  elseif os_type == "Darwin" then
    if arch_type == "x86_64" then
      url = base_url .. "-x86_64-apple-darwin.tar.gz"
    elseif arch_type == "aarch64" then
      url = base_url .. "-aarch64-apple-darwin.tar.gz"
    else
      error("Unsupported architecture for MacOS")
    end
    extract_cmd = "tar -xzf " .. data_path .. "/rg.tar.gz -C " .. data_path
  else
    if arch_type == "x86_64" or arch_type == "i686" then
      local libc = "musl"
      url = base_url .. "-" .. arch_type .. "-unknown-linux-" .. libc .. ".tar.gz"
    elseif arch_type == "armv7" then
      url = base_url .. "-armv7-unknown-linux-musleabi.tar.gz"
    elseif arch_type == "armv7l" then
      url = base_url .. "-armv7-unknown-linux-musleabi.tar.gz"
    elseif arch_type == "armv7h" then
      url = base_url .. "-armv7-unknown-linux-musleabihf.tar.gz"
    elseif arch_type == "aarch64" then
      url = base_url .. "-aarch64-unknown-linux-gnu.tar.gz"
    elseif arch_type == "powerpc64" then
      url = base_url .. "-powerpc64-unknown-linux-gnu.tar.gz"
    elseif arch_type == "s390x" then
      url = base_url .. "-s390x-unknown-linux-gnu.tar.gz"
    else
      error("Unsupported architecture for Linux")
    end
    extract_cmd = "tar -xzf " .. data_path .. "/rg.tar.gz -C " .. data_path
  end

  delete_ripgrep_directories(data_path)
  vim.fn.system("curl -L " .. url .. " -o " .. data_path .. "/rg.tar.gz")
  vim.fn.system(extract_cmd)
  vim.fn.system("mv " .. data_path .. "/*/rg" .. " " .. data_path .. "/rg")
  vim.fn.system("rm " .. data_path .. "/rg.tar.gz")
  delete_ripgrep_directories(data_path)
end

return M

