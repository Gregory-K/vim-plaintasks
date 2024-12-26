# vim-plaintasks

`vim-plaintasks` is a lightweight plugin for [Vim](https://www.vim.org) and [Neovim](https://neovim.io) that enhances task management with syntax highlighting and keyboard shortcuts tailored to the [PlainTasks](https://github.com/aziz/PlainTasks) format.

This plugin is a fork of [elentok/plaintasks.vim](https://github.com/elentok/plaintasks.vim).

The `master` branch mirrors the original repository (`elentok/plaintasks.vim`), ensuring compatibility with upstream changes.

**The `custom` branch (default) includes:**

- Auto-detection for the following file extensions:  
  `*.TODO`, `TODO`, `*.todo`, `*.todolist`, `*.taskpaper`, `*.tasks`  
- Syntax highlighting for tasks, completed tasks, cancelled tasks, and tags.

**Additional customizations:**

- Alternative symbols for task states:  
  `-` for tasks, `+` for completed, `x` for cancelled.  
- New keybindings for enhanced usability.  

GitHub: <https://github.com/Gregory-K/vim-plaintasks>  
Mod   : Gregory.K


## Installation

### Using vim-plug

REL: [vim-plug](https://github.com/junegunn/vim-plug)

Add the following line to `vimrc` or `init.vim`:

```vim
Plug 'Gregory-K/vim-plaintasks'
```

Then, install the plugin:

```vim
:PlugInstall
```

### Manual Installation

Clone this repository into  
`.vim` / `~/.config/vim` / `~/vimfiles` _(windows)_ directory:

```sh
mkdir -p ~/.config/vim/pack/vendor/start/vim-plaintasks
cd ~/.config/vim/pack/vendor/start/vim-plaintasks
git clone https://github.com/Gregory-K/vim-plaintasks .
```


## Usage

Open any supported file (`*.tasks`, `*.TODO`, etc.) in Vim or Neovim to automatically activate syntax highlighting:

```sh
vim project.tasks
```

### Keybindings / Keyboard Shorcuts

**Normal-mode / Visual-mode**

`Alt + e`   : create new task
`Alt + d`   : toggle complete
`Alt + x`   : toggle cancel
`Alt + a`   : archive tasks

**Insert-mode**

`--<space>` : insert a separator line

#### Customize

Keybindings can be modified by editing `ftplugin/plaintasks.vim`.  
The current keybindings are set as follows:

_now:_
```vim
if has('unix')
  nnoremap <silent> <buffer> <Esc>' :call NewTask()<cr>A
  vnoremap <silent> <buffer> <Esc>' :call NewTask()<cr>
  noremap <silent> <buffer> <Esc>d :call ToggleComplete()<cr>
  noremap <silent> <buffer> <Esc>x :call ToggleCancel()<cr>
  nnoremap <silent> <buffer> <Esc>a :call ArchiveTasks()<cr>
else  " Windows
  nnoremap <silent> <buffer> <A-'> :call NewTask()<cr>A
  vnoremap <silent> <buffer> <A-'> :call NewTask()<cr>
  noremap <silent> <buffer> <A-d> :call ToggleComplete()<cr>
  noremap <silent> <buffer> <A-x> :call ToggleCancel()<cr>
  nnoremap <silent> <buffer> <A-a> :call ArchiveTasks()<cr>
endif
abbr -- <c-r>=Separator()<cr>
```

_previous defaults_  
```vim
" previous defaults
nnoremap <silent> <buffer> + :call NewTask()<cr>A
vnoremap <silent> <buffer> + :call NewTask()<cr>
noremap <silent> <buffer> = :call ToggleComplete()<cr>
noremap <silent> <buffer> <C-M> :call ToggleCancel()<cr>
nnoremap <silent> <buffer> - :call ArchiveTasks()<cr>
```

> *Normal-mode / Visual-mode*  
> ```
> + - create new task
> = - toggle complete
> <C-M> - toggle cancel
> - - archive tasks
> ```
> *Insert-mode*  
> ```
> --<space> - insert a separator line
> ```
