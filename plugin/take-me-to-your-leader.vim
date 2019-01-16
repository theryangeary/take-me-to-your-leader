
highlight LeaderTitle guifg=LightMagenta ctermfg=LightMagenta

function! RangedCommand(start, end, command)
  silent! execute a:start . "," . a:end . a:command
endfunction

function! HighlightLeaderHeaders()
  normal! gg
  let l:leader_begin = search("leader#begin") + 2
  let l:leader_end = search("leader#end") - 2
  let c = l:leader_begin
  while c < l:leader_end
    execute 'call matchadd("LeaderTitle", "\\%' . c . 'l^\"\\zs.\\+\\ze")'
    let c += 1
  endwhile
endfunction

function! SortLeaderCommands()
  " save to return later
  let l:save_view = winsaveview()
  " find leader command boundaries for file
  normal! gg
  let l:leader_begin = search("leader#begin") + 2
  let l:leader_end = search("leader#end") - 2
  " separated unlikely to appear in maps
  let l:separator = "@@@"
  " turn each section into one line, condense to one paragraph
  call RangedCommand(l:leader_begin, l:leader_end, "substitute/\\(.\\+\\)\\n/\\1" . separator . "/")
  " get new end boundary
  let l:leader_end = search("leader#end") - 1
  " sort sections
  call RangedCommand(l:leader_begin, l:leader_end, "sort i")
  " split back to individual commands
  call RangedCommand(l:leader_begin, l:leader_end, "substitute/" . separator . "/\\r/g")
  let l:leader_end = search("leader#end") - 2
  " Now sort within each section
  call setpos(".", [0, l:leader_begin, 0, 0])
  while line(".") < l:leader_end
    let l:start = search("map")
    let l:end = search("\\n\\n")
    call RangedCommand(l:start, l:end, "sort i")
    call setpos(".", [0, l:end+1, 0, 0])
  endwhile
  " Restore view
  call winrestview(l:save_view)
endfunction

