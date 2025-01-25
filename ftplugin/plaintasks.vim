"Vim filetype plugin
" Language: PlainTasks
" Maintainer: Gregory.K
" Credits: David Elentok
" Credits: ArchiveTasks() added by Nik van der Ploeg
" Description: Syntax highlighting for PlainTasks files.
" Version: 0.1.250125a

" Only do this when not done yet for this buffer
if exists("b:did_ftplugin")
    finish
endif

" helps initial tasks overview
setlocal nowrap

" when pressing enter within a task it creates another task
" setlocal comments+=n:*
setlocal comments=s1:/-,mb:-,ex:-/

function! ToggleTaskDone()
    let line = getline('.')
    let indent = matchstr(line, '^\s*')
    if line =~ '^\s*+'
        exec 'substitute/^' . indent . '+/' . indent . '-/'
        substitute/ *@done.*$//
    elseif line =~ '^\s*-'
        exec 'substitute/^' . indent . '-/' . indent . '+/'
        let text = " @done (" . strftime("%Y-%m-%d %H:%M") .")"
        exec "normal A" . text
        normal _
    endif
endfunc

function! ToggleTaskCancel()
    let line = getline('.')
    let indent = matchstr(line, '^\s*')
    if line =~ '^\s*x'
        exec 'substitute/^' . indent . 'x/' . indent . '-/'
        substitute/ *@cancelled.*$//
    elseif line =~ '^\s*-'
        exec 'substitute/^' . indent . '-/' . indent . 'x/'
        let text = " @cancelled (" . strftime("%Y-%m-%d %H:%M") .")"
        exec "normal A" . text
        normal _
    endif
endfunc

function! ToggleTask()
    let line = getline('.')
    let indent = matchstr(line, '^\s*')
    if line =~ '^\s*-'
        let trimmed_line = substitute(line, '^\s*-\s*', indent, '')
        call setline('.', trimmed_line)
    else
        exec "normal I- "
    endif
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

function! TaskSeparator()
    let line = getline('.')
    if line =~ "^-*$"
      return "---- ✄ -----------------------"
    else
      return "--"
    end
endfunc
