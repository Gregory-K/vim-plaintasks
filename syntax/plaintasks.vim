" Vim syntax file
" Language: PlainTasks
" Maintainer: David Elentok
" Filenames: *.TODO
"
if exists("b:current_syntax")
  finish
endif

hi def link ptTask Todo
hi def link ptCompleteTask String
hi def link ptCancelledTask Comment
hi def link ptSection Statement
hi def link ptContext Identifier
hi def link ptLine Function

syn match ptSection "^.*: *$"
syn match ptTask "^\t*-.*" contains=ptContext
syn match ptCompleteTask "^\t*+.*" contains=ptContext
syn match ptCancelledTask "^\t*x.*" contains=ptContext
syn match ptContext "@[^ ]*"
syn match ptLine "\n\n---- ✄ -----------------------\n\n\n## Archive (linear)\n\n%s\n"
