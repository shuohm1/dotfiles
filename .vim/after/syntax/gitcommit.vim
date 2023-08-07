" a subject of a commit message is recommended to be <= 50 characters, but GitHub shows a subject without omitting its tail if it is <= 69 characters
if b:current_syntax is# "gitcommit"
  syn match gitcommitSummary "^.\{0,69\}" contained containedin=gitcommitFirstLine nextgroup=gitcommitOverflow contains=@Spell
endif
