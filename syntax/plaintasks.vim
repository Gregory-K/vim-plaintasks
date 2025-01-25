" Vim syntax file
" Language: PlainTasks
" Maintainer: Gregory.K
" Filenames: *.TODO
" Description: Syntax highlighting for PlainTasks files.
" Version: 0.1.250125a

if exists("b:current_syntax")
  finish
endif

" HILIGHTS "

" alter Normal to easily match task comments
hi Normal ctermfg=245 guifg=#8A8A8A
" Core
hi def ptSection ctermfg=255 ctermbg=235 guifg=#EEEEEE guibg=#262626
hi def ptTask ctermfg=187 guifg=#DFDFAF
hi def ptDoneTask ctermfg=065 guifg=#5F875F
hi def ptCancelledTask ctermfg=239 guifg=#4E4E4E
" Tags
hi def link ptTag Identifier
" Specific Tags
hi def ptTagSpot ctermfg=231 guifg=#FFFFFF
hi def ptTagLow ctermfg=066 ctermbg=233 cterm=Bold guifg=#5F5F87 guibg=#121212 gui=Bold
hi def ptTagToday ctermfg=121 ctermbg=233 cterm=Bold guifg=#87FFAF guibg=#121212 gui=Bold
hi def ptTagHigh ctermfg=226 ctermbg=233 cterm=Bold guifg=#FFFF00 guibg=#121212 gui=Bold
hi def ptTagCritical ctermfg=203 ctermbg=233 cterm=Bold guifg=#FF5F5F guibg=#121212 gui=Bold
" " tags with (<date>)
hi def link ptTagDate Identifier
" Marks/Symbols
hi def ptTaskMark ctermfg=226 cterm=Bold guifg=#FFFF00 gui=Bold
hi def ptDoneTaskMark ctermfg=121 guifg=#87FFAF
hi def ptCancelledTaskMark ctermfg=203 guifg=#FF5F5F
" Misc (HR / MD Headers)
hi def ptMdownHead ctermfg=038 guifg=#00AFD7
hi def link ptHR Comment

" SYNTAX MATCHING "

" Core
syn match ptSection "^.*: *$"
syn match ptTaskMark "^\s\+-\s" contained
syn match ptTask "^\s\+-\s.*" contains=ptTaskMark,ptTag
" " Done
syn match ptDoneTaskMark "^\s\++\s" contained
syn match ptDoneTask "^\s\++\s.*" contains=ptDoneTaskMark
" " Cancelled
syn match ptCancelledTaskMark "^\s\+x\s" contained
syn match ptCancelledTask "^\s\+x\s.*" contains=ptCancelledTaskMark
" " Specific Tags
syn match ptTagSpot "@spot" contained
syn match ptTagLow "@low" contained
syn match ptTagToday "@today" contained
syn match ptTagHigh "@high" contained
syn match ptTagCritical "@critical" contained
" " tags with (<date>)
syn match ptTagDate "(\([^)]*\))" contained
" Consolidate Tags
syn match ptTag "@[^ ]*" contains=ptTagSpot,ptTagLow,ptTagToday,ptTagHigh,ptTagCritical,ptTagDate
" Misc (HR / MD Headers)
syn match ptMdownHead "^#\+.*$"
syn match ptHR "^\(-\+ ✄ -\+\|＿\+\)"

" SYNTAX "

let b:current_syntax = "plaintasks"
