
" ============= Vim-Plug ============== "

call plug#begin()

" ================= looks and GUI stuff ================== "

Plug 'vim-airline/vim-airline'                          " airline status bar
Plug 'vim-airline/vim-airline-themes'                   " airline themes
Plug 'ryanoasis/vim-devicons'                           " powerline like icons for NERDTree
Plug 'junegunn/rainbow_parentheses.vim'                 " rainbow paranthesis
Plug 'hzchirs/vim-material'                             " material color themes
Plug 'junegunn/goyo.vim'                                " zen mode
Plug 'amix/vim-zenroom2'                                " more focus in zen mode

" ================= Functionalities ================= "

" autocompletion using ncm2 (much lighter and faster than coc)
Plug 'ncm2/ncm2'
Plug 'roxma/nvim-yarp'
Plug 'ncm2/ncm2-bufword'
Plug 'ncm2/ncm2-path'
Plug 'filipekiss/ncm2-look.vim'
Plug 'fgrsnau/ncm-otherbuf'
Plug 'fgrsnau/ncm2-aspell'
Plug 'ncm2/ncm2-tern',  {'do': 'npm install'}
Plug 'ncm2/ncm2-pyclang'
Plug 'davidhalter/jedi-vim'
Plug 'ncm2/ncm2-jedi'
Plug 'ncm2/ncm2-vim' | Plug 'Shougo/neco-vim'
Plug 'ncm2/ncm2-ultisnips'
Plug 'ncm2/ncm2-html-subscope'
Plug 'ncm2/ncm2-markdown-subscope'

" markdown
Plug 'jkramer/vim-checkbox', { 'for': 'markdown' }
Plug 'dkarter/bullets.vim'                              " markdown bullet lists

" search
Plug 'wsdjeg/FlyGrep.vim'                               " project wide search
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'                                " fuzzy search integration

" snippets
Plug 'honza/vim-snippets'                               " actual snippets
Plug 'SirVer/ultisnips'                                 " snippets and shit

" visual
Plug 'majutsushi/tagbar'                                " side bar of tags
Plug 'scrooloose/nerdtree'                              " open folder tree
Plug 'jiangmiao/auto-pairs'                             " auto insert other paranthesis pairb
Plug 'alvan/vim-closetag'                               " auto close html tags
Plug 'Yggdroot/indentLine'                              " show indentation lines
Plug 'chrisbra/Colorizer'                               " show actual colors of color codes
Plug 'google/vim-searchindex'                           " add number of found matching search items

" languages
Plug 'sheerun/vim-polyglot'                             " many languages support
Plug 'tpope/vim-liquid'                                 " liquid language support
Plug 'harenome/vim-mipssyntax'
" other
Plug 'Chiel92/vim-autoformat'                           " an actually good and light auto formatter
Plug 'tpope/vim-commentary'                             " better commenting
Plug 'rhysd/vim-grammarous'                             " grammer checker
Plug 'tpope/vim-sensible'                               " sensible defaults
Plug 'lambdalisue/suda.vim'                             " save as sudo
Plug '907th/vim-auto-save'                              " auto save changes
Plug 'mhinz/vim-startify'                               " cool start up screen
Plug 'dense-analysis/ale'                               " powerful linter

call plug#end()

" ==================== general config ======================== "

set termguicolors                                       " Opaque Background
set mouse=a                                             " enable mouse scrolling
set clipboard+=unnamedplus                              " use system clipboard by default

" ===================== Other Configurations ===================== "

filetype plugin indent on                               " enable indentations
set tabstop=4 softtabstop=4 shiftwidth=4 expandtab smarttab autoindent              " tab key actions
set incsearch ignorecase smartcase hlsearch             " highlight text while seaching
set list listchars=trail:»,tab:»-                       " use tab to navigate in list mode
set fillchars+=vert:\▏                                  " requires a patched nerd font (try furaCode)
set wrap breakindent                                    " wrap long lines to the width sset by tw
set encoding=utf-8                                      " text encoding
set number                                              " enable numbers on the left
set number relativenumber                               " relative numbering to current line (current like is 0 )
set title                                               " tab title as file file
set conceallevel=2                                      " set this so we womt break indentation plugin
set splitright                                          " open vertical split to the right
set splitbelow                                          " open horizontal split to the bottom
set tw=80                                               " auto wrap lines that are longer than that
set emoji                                               " enable emojis
let g:indentLine_setConceal = 0                         " actually fix the annoying markdown links conversion
au BufEnter * set fo-=c fo-=r fo-=o                     " stop annying auto commenting on new lines
set undofile                                            " enable persistent undo
set undodir=~/.nvim/tmp                                 " undo temp file directory
set ttyfast                                             " faster scrolling
set lazyredraw                                          " faster scrolling
set spell                                               " enable spell check by default

" Transparent Background (For i3 and compton)
highlight Normal guibg=NONE ctermbg=NONE
highlight LineNr guibg=NONE ctermbg=NONE

" Python3 VirtualEnv
let g:python3_host_prog = expand('/usr/bin/python')

" Coloring
let g:material_style='oceanic'
set background=dark
colorscheme vim-material
let g:airline_theme='material'
highlight Pmenu guibg=white guifg=black gui=bold
highlight Comment gui=bold
highlight Normal gui=none
highlight NonText guibg=none
autocmd ColorScheme * highlight VertSplit cterm=NONE ctermfg=Green ctermbg=NONE

" ======================== Plugin Configurations ======================== "

" NerdTree
let NERDTreeShowHidden=1
let NERDTreeShowLineNumbers=0
let g:NERDTreeDirArrowExpandable = ''
let g:NERDTreeDirArrowCollapsible = ''
let NERDTreeQuitOnOpen = 1
let NERDTreeMinimalUI = 1
let NERDTreeDirArrows = 1
let g:NERDTreeIgnore = [
            \ '\.vim$',
            \ '\~$',
            \ '.git',
            \ '_site',
            \]

" Airline
let g:airline_powerline_fonts = 0
let g:airline#themes#clean#palette = 1
call airline#parts#define_raw('linenr', '%l')
call airline#parts#define_accent('linenr', 'bold')
let g:airline_section_z = airline#section#create(['%3p%%  ',
            \ g:airline_symbols.linenr .' ', 'linenr', ':%c '])
let g:airline_section_warning = ''
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#fnamemod = ':t'        " show only file name on tabs
let g:airline#extensions#ale#enabled = 1                " ALE integration

" Ultisnips
let g:UltiSnipsExpandTrigger="<C-Space>"
let g:UltiSnipsJumpForwardTrigger="<Tab>"
let g:UltiSnipsJumpBackwardTrigger="<C-x>"

" ncm2
autocmd BufEnter * call ncm2#enable_for_buffer()
set completeopt=noinsert,menuone,noselect
set shortmess+=c
inoremap <c-c> <ESC>
" Use <TAB> to select the popup menu:
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" wrap existing omnifunc

" css
call ncm2#register_source({'name' : 'css',
            \ 'priority': 9,
            \ 'subscope_enable': 1,
            \ 'scope': ['css', 'scss', 'less'],
            \ 'mark': 'css',
            \ 'word_pattern': '[\w\-]+',
            \ 'complete_pattern': ':\s*',
            \ 'on_complete': ['ncm2#on_complete#omni',
            \               'csscomplete#CompleteCSS'],
            \ })

let g:ncm2_look_enabled = 1                             " word dictionary completion
inoremap <silent> <expr> <CR> ncm2_ultisnips#expand_or("\<CR>", 'n')

" indentLine
let g:indentLine_char = '▏'
let g:indentLine_color_gui = '#363949'

" TagBar
let g:tagbar_width = 30
let g:tagbar_iconchars = ['', '']

" fzf-vim
let g:FZF_DEFAULT_COMMAND = 'rg --hidden --ignore .git -g ""'
let g:fzf_action = {
            \ 'ctrl-t': 'tab split',
            \ 'ctrl-s': 'split',
            \ 'ctrl-v': 'vsplit' }
let g:fzf_colors = {
            \ 'fg':      ['fg', 'Normal'],
            \ 'bg':      ['bg', 'Normal'],
            \ 'hl':      ['fg', 'Comment'],
            \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
            \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
            \ 'hl+':     ['fg', 'Statement'],
            \ 'info':    ['fg', 'Type'],
            \ 'border':  ['fg', 'Ignore'],
            \ 'prompt':  ['fg', 'Character'],
            \ 'pointer': ['fg', 'Exception'],
            \ 'marker':  ['fg', 'Keyword'],
            \ 'spinner': ['fg', 'Label'],
            \ 'header':  ['fg', 'Comment'] }

" startify
let g:startify_session_persistence = 1

" auto save file changes
let g:auto_save = 1                                     " enable AutoSave on Vim startup
let g:auto_save_no_updatetime = 1                       " do not change the 'updatetime' option
let g:auto_save_in_insert_mode = 0                      " do not save while in insert mode

" auto format on save
" au BufWrite * :Autoformat

" disable defualt plugins that are not being used
let g:loaded_tarPlugin = 1
let g:loaded_vimballPlugin = 1
let g:loaded_zipPlugin = 1
let g:loaded_rrhelper = 1
let g:loaded_netrwPlugin = 1
let g:loaded_gzip = 1
let g:loaded_logipat = 1
let g:loaded_2html_plugin = 1

" ======================== Filetype-Specific Configurations ============================= "


" HTML, XML, Css
autocmd FileType html setlocal shiftwidth=2 tabstop=2 softtabstop=2
autocmd FileType css setlocal shiftwidth=2 tabstop=2 softtabstop=2
autocmd FileType xml setlocal shiftwidth=2 tabstop=2 softtabstop=2

" Markdown
autocmd FileType markdown setlocal shiftwidth=2 tabstop=2 softtabstop=2
autocmd FileType markdown map <silent> <leader>m :call TerminalPreviewMarkdown()<CR>
au BufReadPost,BufNewFile *sncli*.txt set filetype=markdown " notes by sncli (simplenote cli client)

" config files
au BufReadPost,BufNewFile */polybar/* set filetype=dosini
au BufReadPost,BufNewFile */termite/* set filetype=dosini

" startify when there is no buffer (file open)
autocmd BufDelete * if empty(filter(tabpagebuflist(), '!buflisted(v:val)')) | Startify | endif

" images (use feh to open images)
autocmd BufNewFile,BufRead *.png, *.jpg, *.jpeg, *.gif :!feh % &

" auto html tags closing, enable for markdown files as well
let g:closetag_filenames = '*.html,*.xhtml,*.phtml, *.md'

" mips assembly files
autocmd BufReadPost,BufNewFile *.S set filetype=mips
" ================== Custom Functions ===================== "

" start nerd tree and startify if there is no args()
function! StartUp()
    if 0 == argc()
        Startify
        NERDTree
    end
endfunction

autocmd VimEnter * call StartUp()

" Trim Whitespaces
function! TrimWhitespace()
    let l:save = winsaveview()
    %s/\\\@<!\s\+$//e
    call winrestview(l:save)
endfunction

" markdown files preview inside (you need to install mdv)
function! TerminalPreviewMarkdown()
    vsp | terminal ! mdv %
endfu

" tabs manipulation
function! Rotate() " switch between horizontal and vertical split mode for open splits
    " save the original position, jump to the first window
    let initial = winnr()
    exe 1 . "wincmd w"

    wincmd l
    if winnr() != 1
        " succeeded moving to the right window
        wincmd J                " make it the bot window
    else
        " cannot move to the right, so we are at the top
        wincmd H                " make it the left window
    endif

    " restore cursor to the initial window
    exe initial . "wincmd w"
endfunction

nnoremap <F5> :call Rotate()<CR>

" ======================== Custom Mappings ====================== "

" the essentials
let mapleader=","
nmap \ <leader>q
map <F3> :NERDTreeToggle<CR>
map <F4> :Tagbar <CR>
nmap <leader>r :so ~/.config/nvim/init.vim<CR>
nmap <leader>t :call TrimWhitespace()<CR>
nmap <leader>q :bd<CR>
nmap <leader>w :w<CR>
nmap <leader>f :Files<CR>
nmap <leader>g :Goyo<CR>
nmap <leader>h :RainbowParentheses!!<CR>
nmap <leader>k :ColorToggle<CR>
nnoremap <leader>W <nop>
nmap <silent> <leader><leader> :noh<CR>
nmap <Tab> :bnext<CR>
nmap <S-Tab> :bprevious<CR>
noremap <leader>e :PlugInstall<CR>
noremap <C-q> :q<CR>
inoremap jj <ESC>

" use a different buffer for dd
nnoremap d "_d
vnoremap d "_d

" emulate windows copy, cut behavior
noremap <LeftRelease> "+y<LeftRelease>
noremap <C-c> "+y<CR>
noremap <C-x> "+d<CR>

" switch between splits using ctrl + {h,j,k,l}
tnoremap <C-h> <C-\><C-N><C-w>h
tnoremap <C-j> <C-\><C-N><C-w>j
tnoremap <C-k> <C-\><C-N><C-w>k
tnoremap <C-l> <C-\><C-N><C-w>l
inoremap <C-h> <C-\><C-N><C-w>h
inoremap <C-j> <C-\><C-N><C-w>j
inoremap <C-k> <C-\><C-N><C-w>k
inoremap <C-l> <C-\><C-N><C-w>l
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" select text via ctrl+shift+arrows in insert mode
inoremap <C-S-left> <esc>vb
inoremap <C-S-right> <esc>ve
