if has('win32') || has('win64')
  let g:plugged_home = '~/AppData/Local/nvim/plugged'
else
  let g:plugged_home = '~/.vim/plugged'
endif
" If installed using git
set rtp+=~/.fzf
" Plugins List
call plug#begin(g:plugged_home)
  " UI related
  Plug 'chriskempson/base16-vim'
  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'
  " Better Visual Guide
  Plug 'Yggdroot/indentLine'
  " syntax check
  Plug 'w0rp/ale'
  " Autocomplete
  Plug 'ncm2/ncm2'
  Plug 'roxma/nvim-yarp'
  Plug 'ncm2/ncm2-bufword'
  Plug 'ncm2/ncm2-path'
  Plug 'ncm2/ncm2-jedi'
  " Formater
  Plug 'Chiel92/vim-autoformat'
  Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }
  Plug 'scrooloose/nerdtree'
  Plug 'cespare/vim-toml'
"  Plug 'kien/ctrlp.vim'
  Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
  Plug 'junegunn/fzf.vim'
  Plug 'fatih/vim-go'
call plug#end()
filetype plugin indent on

let g:go_def_mode='gopls'
let g:go_info_mode='gopls'

" Configurations Part
" UI configuration
syntax on
syntax enable
" colorscheme
let base16colorspace=256
colorscheme base16-atelier-dune
set background=dark
" True Color Support if it's avaiable in terminal
if has("termguicolors")
    set termguicolors
endif
if has("gui_running")
  set guicursor=n-v-c-sm:block,i-ci-ve:block,r-cr-o:blocks
endif
set number
set relativenumber
set hidden
set mouse=a
set noshowmode
set noshowmatch
set nolazyredraw
" Turn off backup
set nobackup
set noswapfile
set nowritebackup
" Search configuration
set ignorecase                    " ignore case when searching
set smartcase                     " turn on smartcase
" Tab and Indent configuration
set expandtab
set tabstop=4
set shiftwidth=4
" vim-autoformat
noremap <F3> :Autoformat<CR>
" NCM2
augroup NCM2
  autocmd!
  " enable ncm2 for all buffers
  autocmd BufEnter * call ncm2#enable_for_buffer()
  " :help Ncm2PopupOpen for more information
  set completeopt=noinsert,menuone,noselect
  " When the <Enter> key is pressed while the popup menu is visible, it only
  " hides the menu. Use this mapping to close the menu and also start a new line.
  autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif
  " inoremap <expr> <CR> (pumvisible() ? "\<c-y>\<cr>" : "\<CR>")
  " uncomment this block if you use vimtex for LaTex
  " autocmd Filetype tex call ncm2#register_source({
  "           \ 'name': 'vimtex',
  "           \ 'priority': 8,
  "           \ 'scope': ['tex'],
  "           \ 'mark': 'tex',
  "           \ 'word_pattern': '\w+',
  "           \ 'complete_pattern': g:vimtex#re#ncm2,
  "           \ 'on_complete': ['ncm2#on_complete#omni', 'vimtex#complete#omnifunc'],
  "           \ })
augroup END
" Ale
let g:ale_lint_on_enter = 0
let g:ale_lint_on_text_changed = 'never'
let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
let g:ale_linters = {'python': ['flake8'], 'go': ['gopls']}
" Airline
let g:airline_left_sep  = ''
let g:airline_right_sep = ''
let g:airline#extensions#ale#enabled = 1
let airline#extensions#ale#error_symbol = 'E:'
let airline#extensions#ale#warning_symbol = 'W:'

" Required for operations modifying multiple buffers like rename.
set hidden

let g:LanguageClient_serverCommands = {
    \ 'rust': ['~/.cargo/bin/rustup', 'run', 'stable', 'rls'],
    \ 'javascript': ['/usr/local/bin/javascript-typescript-stdio'],
    \ 'javascript.jsx': ['tcp://127.0.0.1:2089'],
    \ 'python': ['pyls'],
    \ 'ruby': ['~/.rbenv/shims/solargraph', 'stdio'],
    \ 'go': ['gopls'],
    \ }
let g:LanguageClient_useVirtualText = 0

nnoremap <silent> K :call LanguageClient#textDocument_hover()<CR>
nnoremap <silent> gd :call LanguageClient#textDocument_definition()<CR>
nnoremap <silent> <F2> :call LanguageClient#textDocument_rename()<CR>

nnoremap <silent> <C-n> :NERDTreeToggle<CR>

" Use The Silver Searcher https://github.com/ggreer/the_silver_searcher
if executable('ag')
  " Use Ag over Grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in fzf for listing files. Lightning fast and respects .gitignore
  let $FZF_DEFAULT_COMMAND = 'ag --literal --files-with-matches --nocolor --hidden -g "" --ignore __pycache__ --ignore .git --ignore *.egg*'

  if !exists(":Ag")
    command -nargs=+ -complete=file -bar Ag silent! grep! <args>|cwindow|redraw!
    nnoremap <c-f> :Ag<SPACE>
  endif
endif
command! -bang -nargs=* Ag call fzf#vim#ag(<q-args>, {'options': '--delimiter : --nth 4..'}, <bang>0)
" Map Ctrl + p to open fuzzy find (FZF)
nnoremap <c-p> :Files<cr>

" Open new split panes to right and bottom, which feels more natural
set splitbelow
set splitright

map <esc> :noh<cr>

" put this in your .vimrc
set wildignore+=*.pyc,*.o,*.obj,*.svn,*.swp,*.class,*.hg,*.DS_Store,*.min.*,*.egg*,__pycache__

" Nerdtree config for wildignore
let NERDTreeRespectWildIgnore=1

set clipboard=unnamedplus
noremap <Leader>y *y
noremap <Leader>p *p
noremap <Leader>Y +y
noremap <Leader>P +p

let g:NERDTreeWinPos = "right"
