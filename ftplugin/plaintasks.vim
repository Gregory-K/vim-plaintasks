"Vim filetype plugin
" Language: PlainTasks
" Maintainer: David Elentok
" ArchiveTasks() added by Nik van der Ploeg

" Only do this when not done yet for this buffer
if exists("b:did_ftplugin")
  finish
endif

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

" when pressing enter within a task it creates another task
" setlocal comments+=n:*
setlocal comments=s1:/-,mb:-,ex:-/

function! ToggleComplete()
  let line = getline('.')
  if line =~ "^\t*+"
    s/^\(\t*\)+/\1-/
    s/ *@done.*$//
  elseif line =~ "^\t*-"
    s/^\(\t*\)-/\1+/
    let text = " @done (" . strftime("%Y-%m-%d %H:%M") .")"
    exec "normal A" . text
    normal _
  endif
endfunc

function! ToggleCancel()
  let line = getline('.')
  if line =~ "^\t*x"
    s/^\(\t*\)x/\1-/
    s/ *@cancelled.*$//
  elseif line =~ "^\t*-"
    s/^\(\t*\)-/\1x/
    let text = " @cancelled (" . strftime("%Y-%m-%d %H:%M") .")"
    exec "normal A" . text
    normal _
  endif
endfunc

function! NewTask()
  let line=getline('.')
  if line =~ "^ *$"
    exec "normal A" . "\t- "
  else
    exec "normal I" . "- "
  end
endfunc

function! ArchiveTasks()
    let orig_line=line('.')
    let orig_col=col('.')
    let archive_start = search("^Archive:")
    if (archive_start == 0)
        call cursor(line('$'), 1)
        normal 2o
        normal iArchive:
        normal o＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿
        let archive_start = line('$') - 1
    endif
    call cursor(1,1)

    let found=0
    let a_reg = @a
    if search("+", "", archive_start) != 0
        call cursor(1,1)
        while search("+", "", archive_start) > 0
            if (found == 0)
                normal "add
            else
                normal "Add
            endif
            let found = found + 1
            call cursor(1,1)
        endwhile

        call cursor(archive_start + 1,1)
        normal "ap
    endif

    "clean up
    let @a = a_reg
    call cursor(orig_line, orig_col)
endfunc

function! Separator()
    let line = getline('.')
    if line =~ "^-*$"
      return "--- ✄ -----------------------"
    else
      return "--"
    end
endfunc
