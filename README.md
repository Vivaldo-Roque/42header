# **42 Header**

42 (Paris)

### **Description**

42 standard header for vim and neovim editors.

![42 header](img/42header.jpg)

### **UNIX Neovim Setup with Lazy**

1. Install [Lazy.nvim](https://github.com/folke/lazy.nvim) if not already installed.

2. Clone this repository into your Neovim plugins directory:

```bash
git clone https://github.com/42paris/42header ~/.config/nvim/lua/plugins/42header
```

3. Modify your Neovim config file (e.g., `~/.config/nvim/lua/config/init.lua`) to add the plugin to your Lazy setup:

```lua
require("lazy").setup({
  spec = {
    -- add LazyVim and import its plugins
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },
    -- import/override with your plugins
    { import = "plugins" },
    -- START the 42header plugin here.
    {
      dir = vim.fn.stdpath("config") .. "/lua/plugins/42header",
      name = "42header",
      config = function()
        -- Try loading without setup() first.
        local ok, plugin = pcall(require, "42header")
        if not ok then
          vim.notify("Erro while loading 42header: " .. plugin, vim.log.levels.ERROR)
        else
          -- Call setup() only if it exists.
          if plugin.setup then
            plugin.setup()
          end
        end
      end,
    },
    -- END the 42header plugin here.
  },
})
```

4. Set the user and mail variables in your Neovim config (e.g., `~/.config/nvim/init.lua`):

```lua
vim.g.user42 = 'yourLogin'
vim.g.mail42 = 'yourLogin@student.42.fr'
```

### **UNIX Vim Setup**

Copy `stdheader.vim` in your `~/.vim/plugin`, or use your favorite plugin
manager. Then set the user and mail variables as explained below.

#### Option 1: export USER and MAIL in your shell configuration file

Add in `~/.zshrc` your:

+ `USER`
+ `MAIL`

#### Option 2: set user and mail values directly in your vimrc

```vim
let g:user42 = 'yourLogin'
let g:mail42 = 'yourLogin@student.42.fr'
```

### **Usage**

In **NORMAL** mode you can use `:Stdheader` or simply press the shortcut <kbd>F1</kbd>.

Under **Linux** you eventually need to disable the **help** shortcut of your **terminal** :

For **Terminator**, right click -> Preferences -> Shortcuts -> change help with something other than <kbd>F1</kbd>

### **Note**

Inside the **42 clusters** you can easily run:

`$ ./set_header.sh`

### **Credits**

[@zazard](https://github.com/zazard) - creator
[@alexandregv](https://github.com/alexandregv) - contributor
[@mjacq42](https://github.com/mjacq42) - contributor
[@sungmcho](https://github.com/lordtomi0325) - contributor
[@fclivaz42](https://github.com/fclivaz42) - contributor

### **License**

This work is published under the terms of **[42 Unlicense](https://github.com/gcamerli/42unlicense)**.
