"Vim filetype plugin
" Language: PlainTasks
" Maintainer: Gregory.K
" Credits: David Elentok
" Credits: ArchiveTasks() added by Nik van der Ploeg
" Description: Syntax highlighting for PlainTasks files.
" Version: 0.2.250411a

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

function! ToggleTaskCancelled()
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

function! AddTaskNote()
    let line = getline('.')
    let indent = matchstr(line, '^\s*')
    let add_indent = "\t"  " Add 1 indent level for notes
    call append(line('.'), indent . add_indent)
    " move cursor to the new line and enter insert mode
    normal! j
    startinsert!
endfunction

function! ArchiveTasks() abort
    let orig_line = line('.')
    let orig_col = col('.')

    try
        " Find or create Archive section
        let archive_start = search('^Archive:', 'n')

        if archive_start == 0
            call append(line('$'), [
                \ '', '', '---- ✄ -----------------------',
                \ '', '', '## Archive (linear)', '', 'Archive:'
                \ ])
            let archive_start = line('$')
        endif

        " Collect all lines, stop before Archive section
        let lines = getbufline('%', 1, archive_start - 1)
        let tasks_to_archive = []
        let lines_to_delete = []
        let current_project = ''
        let current_subproject = ''
        let current_task = ''
        let task_notes = []
        let task_line_num = 0
        let i = 0

        " Parse lines
        while i < len(lines)
            let line = lines[i]
            let line_num = i + 1  " 1-based line number
            let indent = matchstr(line, '^\s*')

            " Detect project headers
            if line =~ '^[A-Z._]\+:$'
                let current_project = substitute(line, ':$', '', '')
                let current_subproject = ''

            " Detect subproject headers
            elseif line =~ '^\s\+[a-zA-Z0-9][^:]\+:$'
                let current_subproject = substitute(line, '^\s*', '', '')
                let current_subproject = substitute(current_subproject, ':$', '', '')

            " Detect tasks (done, cancelled, or active)
            elseif line =~ '^\s*[+\-x]\s'
                " Store previous task if done or cancelled
                if current_task != '' && (current_task =~ '^\s*[+x]\s')
                    let date = matchstr(current_task, '@done (\zs[^)]*\ze)')
                    if date == ''
                        let date = matchstr(current_task, '@cancelled (\zs[^)]*\ze)')
                    endif
                    call add(tasks_to_archive, {
                        \ 'project': current_project,
                        \ 'subproject': current_subproject,
                        \ 'task': current_task,
                        \ 'notes': task_notes,
                        \ 'date': date
                        \ })
                    " Delete both the task line and its notes
                    call add(lines_to_delete, task_line_num)
                    if !empty(task_notes)
                        let first_note_line = task_line_num + 1
                        let last_note_line = first_note_line + len(task_notes) - 1
                        call extend(lines_to_delete, range(first_note_line, last_note_line))
                    endif
                endif

                " Start tracking a new task
                let current_task = line
                let task_notes = []
                let task_line_num = line_num

            " Detect notes
            elseif line =~ '^\s\+[^+\-x#].*' && current_task != ''
                call add(task_notes, line)

            " Clear task on section headers or separators
            elseif line =~ '^#' || line =~ '^\s*$' || line =~ '^----'
                if current_task != '' && (current_task =~ '^\s*[+x]\s')
                    let date = matchstr(current_task, '@done (\zs[^)]*\ze)')
                    if date == ''
                        let date = matchstr(current_task, '@cancelled (\zs[^)]*\ze)')
                    endif
                    call add(tasks_to_archive, {
                        \ 'project': current_project,
                        \ 'subproject': current_subproject,
                        \ 'task': current_task,
                        \ 'notes': task_notes,
                        \ 'date': date
                        \ })
                    " Delete both the task line and its notes
                    call add(lines_to_delete, task_line_num)
                    if !empty(task_notes)
                        let first_note_line = task_line_num + 1
                        let last_note_line = first_note_line + len(task_notes) - 1
                        call extend(lines_to_delete, range(first_note_line, last_note_line))
                    endif
                endif
                let current_task = ''
                let task_notes = []
                let task_line_num = 0
                let current_subproject = ''

            endif
            let i += 1
        endwhile

        " Store last task if done or cancelled
        if current_task != '' && (current_task =~ '^\s*[+x]\s')
            let date = matchstr(current_task, '@done (\zs[^)]*\ze)')
            if date == ''
                let date = matchstr(current_task, '@cancelled (\zs[^)]*\ze)')
            endif
            call add(tasks_to_archive, {
                \ 'project': current_project,
                \ 'subproject': current_subproject,
                \ 'task': current_task,
                \ 'notes': task_notes,
                \ 'date': date
                \ })
            " Delete both the task line and its notes
            call add(lines_to_delete, task_line_num)
            if !empty(task_notes)
                let first_note_line = task_line_num + 1
                let last_note_line = first_note_line + len(task_notes) - 1
                call extend(lines_to_delete, range(first_note_line, last_note_line))
            endif
        endif

        " Delete the original task lines
        " (in reverse order to avoid line number shifts)
        if !empty(lines_to_delete)
            let lines_to_delete = uniq(sort(lines_to_delete, 'n'))
            let i = len(lines_to_delete) - 1
            while i >= 0
                execute lines_to_delete[i] . 'delete'
                let i -= 1
            endwhile
        endif

        " We need to search for the archive section again
        " since line numbers may have changed
        let archive_start = search('^Archive:', 'n')

        " Gather existing archived tasks and notes
        let archive_lines = getbufline('%', archive_start + 1, '$')
        let current_archive_task = ''
        let archive_notes = []
        for line in archive_lines
            if line =~ '^\s*[+x]\s'
                " Store previous archive task
                if current_archive_task != ''
                    let date = matchstr(current_archive_task, '@done (\zs[^)]*\ze)')
                    if date == ''
                        let date = matchstr(current_archive_task, '@cancelled (\zs[^)]*\ze)')
                    endif
                    call add(tasks_to_archive, {
                        \ 'project': '',
                        \ 'subproject': '',
                        \ 'task': current_archive_task,
                        \ 'notes': archive_notes,
                        \ 'line': 0,
                        \ 'date': date
                        \ })
                endif
                let current_archive_task = line
                let archive_notes = []
            elseif line =~ '^\s\+.*' && current_archive_task != ''
                call add(archive_notes, line)
            endif
        endfor
        " Store last archived task
        if current_archive_task != ''
            let date = matchstr(current_archive_task, '@done (\zs[^)]*\ze)')
            if date == ''
                let date = matchstr(current_archive_task, '@cancelled (\zs[^)]*\ze)')
            endif
            call add(tasks_to_archive, {
                \ 'project': '',
                \ 'subproject': '',
                \ 'task': current_archive_task,
                \ 'notes': archive_notes,
                \ 'line': 0,
                \ 'date': date
                \ })
        endif

        " Sort tasks by date (newest first)
        let tasks_to_archive = sort(tasks_to_archive, {a, b ->
            \ b.date > a.date ? 1 :
            \ b.date < a.date ? -1 : 0
            \ })

        " Prepare archive lines
        let new_archive_lines = []
        for task in tasks_to_archive
            let task_line = task.task
            let symbol = matchstr(task_line, '^[ \t]*\zs[+x]\ze\s')
            let task_content = substitute(task_line, '^[ \t]*[+x]\s*', '', '')
            let prefix = ''
            if task.project != ''
                let prefix = task.project
                if task.subproject != ''
                    let prefix .= ' / ' . task.subproject . ': '
                else
                    let prefix .= ': '
                endif
            endif

            " Exactly one tab for tasks
            call add(new_archive_lines, "\t" . symbol . ' ' . prefix . task_content)

            " Exactly two tabs for notes
            for note in task.notes
                let note_content = substitute(note, '^\s*', '', '')
                call add(new_archive_lines, "\t\t" . note_content)
            endfor
        endfor

        " Clear existing archive lines before replacing
        let archive_end = search('^## ', 'n')
        if archive_end == 0 || archive_end <= archive_start
            let archive_end = line('$') + 1
        endif
        if archive_start + 1 < archive_end
            execute (archive_start + 1) . ',' . (archive_end - 1) . 'delete _'
        endif

        " Append the new archived tasks
        call append(archive_start, new_archive_lines)

    catch
        echohl ErrorMsg
        echom 'Error in ArchiveTasks: ' . v:exception
        echohl None
    finally
        call cursor(orig_line, orig_col)
    endtry
endfunc

function! TaskSeparator()
    let line = getline('.')
    if line =~ "^-*$"
      return "---- ✄ -----------------------"
    else
      return "--"
    end
endfunc
