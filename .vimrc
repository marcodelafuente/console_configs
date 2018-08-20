inoremap jk <ESC>

let mapleader="<SPACE>"

let g:netrw_browse_split = 4

let g:deoplete#enable_at_startup = 1

let g:syntastic_loc_list_height=3

autocmd VimEnter * NERDTree
autocmd VimEnter * TagbarToggle

set listchars=eol:$,tab:>-,trail:~,extends:>,precedes:<
set list
set mouse=a
set encoding=UTF-8
set number

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

map <C-H> <Plug>(wintabs_previous)
map <C-L> <Plug>(wintabs_next)
map <C-X>c <Plug>(wintabs_close)
map <C-X>u <Plug>(wintabs_undo)
map <C-X>o <Plug>(wintabs_only)
map <C-W>c <Plug>(wintabs_close_window)
map <C-W>o <Plug>(wintabs_only_window)
command! Tabc WintabsCloseVimtab
command! Tabo WintabsOnlyVimtab

nmap <F8> :TagbarToggle<CR>
