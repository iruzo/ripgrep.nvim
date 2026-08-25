local M = {}

local targets = {
  Darwin = {
    aarch64 = "aarch64-apple-darwin",
    arm64 = "aarch64-apple-darwin",
    x86_64 = "x86_64-apple-darwin",
  },
  Linux = {
    aarch64 = "aarch64-unknown-linux-gnu",
    armv7 = "armv7-unknown-linux-musleabi",
    armv7h = "armv7-unknown-linux-musleabihf",
    armv7l = "armv7-unknown-linux-musleabi",
    i686 = "i686-unknown-linux-gnu",
    s390x = "s390x-unknown-linux-gnu",
    x86_64 = "x86_64-unknown-linux-musl",
  },
  Windows_NT = {
    i686 = "i686-pc-windows-msvc",
    x86_64 = "x86_64-pc-windows-msvc",
  },
}

local function clean(data)
  for _, name in ipairs(vim.fn.readdir(data)) do
    local path = data .. "/" .. name
    if vim.fn.isdirectory(path) == 1 and name:find("^ripgrep") then
      vim.fn.delete(path, "rf")
    end
  end
end

function M.install_rg()
  local data = vim.fn.stdpath("data") .. "/ripgrep.nvim"
  vim.fn.mkdir(data, "p")

  local source = debug.getinfo(1, "S").source:gsub("^@", "")
  local root = vim.fn.fnamemodify(source, ":h:h")
  local version = vim.fn.readfile(root .. "/rg_version")[1]
  local uname = vim.loop.os_uname()
  local system = targets[uname.sysname] or targets.Linux

  local target = system[uname.machine]
  if not target then
    error("Unsupported architecture: " .. uname.machine)
  end

  local windows = uname.sysname == "Windows_NT"
  local extension = windows and ".zip" or ".tar.gz"
  local name = "ripgrep-" .. version .. "-" .. target
  local archive = data .. "/rg" .. extension
  local directory = data .. "/" .. name
  local executable = windows and "rg.exe" or "rg"
  local binary = directory .. "/" .. executable
  local url = "https://github.com/BurntSushi/ripgrep/releases/download/" .. version .. "/" .. name .. extension

  clean(data)
  vim.fn.system({ "curl", "-fL", url, "-o", archive })

  if windows then
    vim.fn.system({ "powershell.exe", "-NoProfile", "-Command", "Expand-Archive", "-LiteralPath", archive, "-DestinationPath", data, "-Force" })
  else
    vim.fn.system({ "tar", "-xzf", archive, "-C", data })
  end

  vim.fn.rename(binary, data .. "/" .. executable)
  vim.fn.delete(archive)
  clean(data)
end

return M
