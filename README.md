# vim-plaintasks

`vim-plaintasks` is a lightweight plugin for [Vim](https://www.vim.org) and [Neovim](https://neovim.io) that offers basic syntax support & task management for the [PlainTasks](https://github.com/aziz/PlainTasks) format.

This plugin is a fork of [elentok/plaintasks.vim](https://github.com/elentok/plaintasks.vim).  
The `master` branch mirrors the original repository (`elentok/plaintasks.vim`).

**The default `custom` branch provides:**

- Auto-detection for the following file extensions:  
  `*.TODO`, `TODO`, `*.todo`, `*.todolist`, `*.taskpaper`, `*.tasks`  

- Alternative symbols for task states:  
  `-` for tasks, `+` for completed, `x` for cancelled.  

- Syntax highlighting for tasks, completed tasks, cancelled tasks, tags,  
  task comments/descriptions, markdown headers.

- Highlighting for the `@spot`, `@low`, `@today`, `@high`, `@critical` tags.

- An improved approach to Archiving functionality _(see Notes)_

- No default Keybindings. User should set their own.  
  Available functions:  
  `ToggleTask()`, `ToggleTaskDone()`, `ToggleTaskCancelled()`,  
  `AddTaskNote()`, `ArchiveTasks()`, `TaskSeparator()`

GitHub: <https://github.com/Gregory-K/vim-plaintasks>  
Mod   : Gregory.K


## Notes

- The `ArchiveTasks()` function now tries to properly handle task descriptions and notes, archiving tasks with their associated notes and sorting them by completion or cancellation date. (WIP)

- vim-plaintasks requires a terminal with support for 256 colours or higher.


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

Proceed settting-up your keybindings / key-mappings.

### Manual Installation

Clone this repository into  
`.vim` / `~/.config/vim` / `~/vimfiles` _(windows)_ directory:

```sh
mkdir -p ~/.config/vim/pack/vendor/start/vim-plaintasks
cd ~/.config/vim/pack/vendor/start/vim-plaintasks
git clone https://github.com/Gregory-K/vim-plaintasks .
```

Proceed setting-up your keybindings / key-mappings.

### Keybindings / Key-Mappings

No default mappings provided. User should define their own in `.vimrc`.

**Available Functions:**

- ToggleTask() _(toggles the state of line as task or not)_
- ToggleTaskDone()
- ToggleTaskCancelled()
- AddTaskNote()
- ArchiveTasks()
- TaskSeparator()

#### Examples

Using autocommand-based mappings (recommended):

```viml
" Plaintasks
" On Unix-like systems, Alt key behavior depends on the terminal emulator
" & shell configuration.
" On Windows, Alt key combinations generally function directly for keybindings.
augroup plaintasks_mappings
  autocmd!
  autocmd FileType plaintasks call s:SetupPlainTasksMappings()
augroup END

function! s:SetupPlainTasksMappings()
  if has('unix')
    nnoremap <silent> <buffer> <Esc>t :call ToggleTask()<CR>
    vnoremap <silent> <buffer> <Esc>t :call ToggleTask()<CR>
    noremap  <silent> <buffer> <Esc>d :call ToggleTaskDone()<CR>
    noremap  <silent> <buffer> <Esc>x :call ToggleTaskCancelled()<CR>
    noremap  <silent> <buffer> <Esc>n :call AddTaskNote()<CR>
    nnoremap <silent> <buffer> <Esc>a :call ArchiveTasks()<CR>
  else  " Windows
    nnoremap <silent> <buffer> <A-t> :call ToggleTask()<CR>
    vnoremap <silent> <buffer> <A-t> :call ToggleTask()<CR>
    noremap  <silent> <buffer> <A-d> :call ToggleTaskDone()<CR>
    noremap  <silent> <buffer> <A-x> :call ToggleTaskCancelled()<CR>
    noremap  <silent> <buffer> <A-n> :call AddTaskNote()<CR>
    nnoremap <silent> <buffer> <A-a> :call ArchiveTasks()<CR>
  endif
  iabbr <buffer> -- <C-R>=TaskSeparator()<CR>
endfunction
```


## Usage

Open any supported file (`*.tasks`, `*.TODO`, etc.) in Vim or Neovim to automatically activate syntax highlighting:

```sh
vim project.tasks
```

For details on the PlainTasks format, refer to the [PlainTasks](https://github.com/aziz/PlainTasks) documentation.
