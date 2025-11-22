# **42 Header**

42 (Paris)

### **Description**

42 standard header for vim and neovim editors.

![42 header](img/42header.jpg)

### **Neovim Setup with Lazy**

1. Install [Lazy.nvim](https://github.com/folke/lazy.nvim) if not already installed.

2. Add the plugin to your `~/.config/nvim/lua/plugins.lua` or equivalent:

```lua
return {
  {
    '42paris/42header',
    dir = '/home/vroque/Downloads/42header',  -- or the path to your local clone
    lazy = true,
    event = 'BufNewFile',  -- lazy load on new file creation
  },
}
```

3. Set the user and mail variables in your Neovim config (e.g., `~/.config/nvim/init.lua`):

```lua
vim.g.user42 = 'yourLogin'
vim.g.mail42 = 'yourLogin@student.42.fr'
```

### **UNIX Setup**

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
