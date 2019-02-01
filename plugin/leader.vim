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

function! s:RangedCommand(start, end, command)
  silent! execute a:start . "," . a:end . a:command
endfunction

function! s:HighlightLeaderHeaders()
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
endfunction

function! s:UnhighlightLeaderHeaders()
  try
    for current_match in s:match_list
      call matchdelete(current_match)
    endfor
  catch /ID Not Found/
  endtry
  let s:match_list = []
endfunction

function! s:ResetLeaderHeaderHighlight()
  call <SID>UnhighlightLeaderHeaders()
  if g:leader_highlight
    call <SID>HighlightLeaderHeaders()
  endif
endfunction

function! s:SetLeaderHighlight()
  let g:leader_highlight = 1
  call <SID>ResetLeaderHeaderHighlight()
endfunction

function! s:SetNoLeaderHighlight()
  let g:leader_highlight = 0
  call <SID>ResetLeaderHeaderHighlight()
endfunction

execute
      \ "autocmd BufRead,TextChanged,TextChangedI," .
      \ "InsertEnter,InsertChange,InsertLeave,InsertCharPre,"
      \ g:leader_location
      \ ":call <SID>ResetLeaderHeaderHighlight()"

function! s:SortLeaderCommands()
  let l:save_view = winsaveview()
  normal! gg
  let l:leader_begin = search(s:leader_begin_str) + 2
  let l:leader_end = search(s:leader_end_str) - 2
  " sort by section header
  let l:separator = "@@@"
  call <SID>RangedCommand(
        \ l:leader_begin,
        \ l:leader_end,
        \ "substitute/\\(.\\+\\)\\n/\\1" . separator . "/")
  let l:leader_end = search(s:leader_end_str) - 1
  call <SID>RangedCommand(l:leader_begin, l:leader_end, "sort i")
  call <SID>RangedCommand(
        \ l:leader_begin,
        \ l:leader_end,
        \ "substitute/" . separator . "/\\r/g")
  let l:leader_end = search(s:leader_end_str) - 2
  " sort each section of mappings
  call setpos(".", [0, l:leader_begin, 0, 0])
  while line(".") < l:leader_end
    let l:start = search("map")
    let l:end = search("\\n\\n")
    call <SID>RangedCommand(l:start, l:end, "sort i")
    call setpos(".", [0, l:end+1, 0, 0])
  endwhile
  call winrestview(l:save_view)
endfunction

command! SortLeaderCommands call <SID>SortLeaderCommands()
command! SetLeaderHighlight call <SID>SetLeaderHighlight()
command! SetNoLeaderHighlight call <SID>SetNoLeaderHighlight()
