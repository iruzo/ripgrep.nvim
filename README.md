# Ripgrep for Neovim

This plugin is a ripgrep manager for Neovim.
It will only install ripgrep locally as another Neovim plugin and keep it up to date with the last version.
It will also load ripgrep to be available for all your plugins while using Neovim if it is not already present in your system.

## Usage

Install the plugin using your favourite plugin manager:
```lua
{
  'iruzo/ripgrep.nvim',
  version = '*',
  build = ':lua require("rg_setup").install_rg()'
},
```
