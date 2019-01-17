if exists('loaded_take_me_to_your_leader_plugin') | finish | endif
let loaded_take_me_to_your_leader_plugin = 1

let s:leader_begin_str = "leader.begin"
let s:leader_end_str = "leader.end"

if !exists('g:leader_location')
  let g:leader_location = $MYVIMRC
endif

if !exists('g:leader_highlight')
  let g:leader_highlight = 1
endif

if !exists('s:match_list')
  let s:match_list = []
endif

highlight LeaderTitle guifg=LightMagenta ctermfg=LightMagenta

function! RangedCommand(start, end, command)
  silent! execute a:start . "," . a:end . a:command
endfunction

function! HighlightLeaderHeaders()
  if g:leader_highlight
    let l:save_view = winsaveview()
    normal! gg
    let l:leader_begin = search(s:leader_begin_str) + 2
    let l:leader_end = search(s:leader_end_str) - 2
    let c = l:leader_begin
    while c < l:leader_end
      execute
            \ 'call add(s:match_list, matchadd("LeaderTitle", "\\%' .
            \ c .
            \ 'l^\"\\zs.\\+\\ze"))'
      let c += 1
    endwhile
    call winrestview(l:save_view)
  endif
endfunction

function! UnhighlightLeaderHeaders()
  for current_match in s:match_list
    call matchdelete(current_match)
  endfor
  let s:match_list = []
endfunction

function! SetLeaderHeaderHighlight()
  call UnhighlightLeaderHeaders()
  if g:leader_highlight
    call HighlightLeaderHeaders()
  endif
endfunction

execute
      \ "autocmd BufRead,InsertLeave,InsertChange"
      \ g:leader_location
      \ ":call SetLeaderHeaderHighlight()"

function! SortLeaderCommands()
  let l:save_view = winsaveview()
  normal! gg
  let l:leader_begin = search(s:leader_begin_str) + 2
  let l:leader_end = search(s:leader_end_str) - 2
  " sort by section header
  let l:separator = "@@@"
  call RangedCommand(
        \ l:leader_begin,
        \ l:leader_end,
        \ "substitute/\\(.\\+\\)\\n/\\1" . separator . "/")
  let l:leader_end = search(s:leader_end_str) - 1
  call RangedCommand(l:leader_begin, l:leader_end, "sort i")
  call RangedCommand(
        \ l:leader_begin,
        \ l:leader_end,
        \ "substitute/" . separator . "/\\r/g")
  let l:leader_end = search(s:leader_end_str) - 2
  " sort each section of mappings
  call setpos(".", [0, l:leader_begin, 0, 0])
  while line(".") < l:leader_end
    let l:start = search("map")
    let l:end = search("\\n\\n")
    call RangedCommand(l:start, l:end, "sort i")
    call setpos(".", [0, l:end+1, 0, 0])
  endwhile
  call winrestview(l:save_view)
endfunction

command! SortLeaderCommands call SortLeaderCommands()
