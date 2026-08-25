# Ripgrep for Neovim

This plugin installs its pinned ripgrep release under Neovim's data directory.
It adds the managed executable to `PATH` only when `rg` is not already available.

## Usage

Install the plugin using your favorite plugin manager:

```lua
{
  'iruzo/ripgrep.nvim',
  version = '*',
  build = ':lua require("rg_setup").install_rg()'
},
```
