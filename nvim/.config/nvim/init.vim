""" Optixal's Neovim Init.vim

""" Vim-Plug
call plug#begin()

" looks and GUI stuff
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'ryanoasis/vim-devicons'
Plug 'junegunn/rainbow_parentheses.vim'
Plug 'hzchirs/vim-material'
Plug 'junegunn/goyo.vim' " zen mode

" Functionalities
Plug 'lervag/vimtex' " latex
Plug 'ying17zi/vim-live-latex-preview'
Plug 'rhysd/vim-grammarous' " grammer checker
Plug 'neoclide/coc.nvim', {'branch': 'release'} " vscode like autocomplete
Plug 'tpope/vim-sensible' " sensible defaults
Plug 'majutsushi/tagbar' " side bar of tags
Plug 'scrooloose/nerdtree' " open folder tree
Plug 'scrooloose/nerdcommenter' " commenting shortcuts and stuff
Plug 'ervandew/supertab' " completion with tab key
Plug 'jiangmiao/auto-pairs' " auto insert other paranthesis pair
Plug 'alvan/vim-closetag' " auto close html tags
Plug 'tpope/vim-abolish' " multi word substitution
Plug 'Yggdroot/indentLine' " show indentation lines
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' } " fuzzy search integration
Plug 'junegunn/fzf.vim'
Plug 'sheerun/vim-polyglot' " many languages support
Plug 'chrisbra/Colorizer' " show actual colors of color codes
Plug 'vim-scripts/loremipsum' " dummy text generator
Plug 'SirVer/ultisnips' " snippets and shit
Plug 'honza/vim-snippets' " actual snippets
Plug 'metakirby5/codi.vim' " using pyhon as an advanced calculator
Plug 'dkarter/bullets.vim' " markdown bullet lists
Plug 'google/vim-searchindex' " add number of found matching search items
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() } } 
Plug 'makerj/vim-pdf' " preview pdf files
Plug 'lambdalisue/suda.vim' " save as sudo
Plug '907th/vim-auto-save' " auto save changes
Plug 'tpope/vim-liquid' "liquid language support
Plug 'mhinz/vim-startify' " cool start up screen

call plug#end()

""" general config
set termguicolors " Opaque Background
set mouse=a " enable mouse scrolling
set clipboard+=unnamedplus " use system clipboard by default
behave mswin " select in insert and other good stuff

""" Other Configurations
filetype plugin indent on
set tabstop=4 softtabstop=4 shiftwidth=4 expandtab smarttab autoindent
set incsearch ignorecase smartcase hlsearch
set ruler laststatus=2 showcmd showmode
set list listchars=trail:»,tab:»-
set fillchars+=vert:\ 
autocmd ColorScheme * highlight VertSplit cterm=NONE ctermfg=Green ctermbg=NONE
set wrap breakindent
set encoding=utf-8
set number
set number relativenumber
set title
set conceallevel=0

" Transparent Background (For i3 and compton)
highlight Normal guibg=NONE ctermbg=NONE
highlight LineNr guibg=NONE ctermbg=NONE

"" Python3 VirtualEnv
let g:python3_host_prog = expand('/usr/bin/python')
""" Coloring
let g:material_style='oceanic'
set background=dark
colorscheme vim-material
let g:airline_theme='material'

highlight Pmenu guibg=white guifg=black gui=bold
highlight Comment gui=bold
highlight Normal gui=none
highlight NonText guibg=none


""" Plugin Configurations
" latex
let g:tex_flavor = 'latex'
let g:vimtex_view_method = 'zathura'
let g:vimtex_quickfix_mode = 0
let g:tex_conceal='abdmg'

""" NERDTree
let NERDTreeShowHidden=1
let g:NERDTreeDirArrowExpandable = '↠'
let g:NERDTreeDirArrowCollapsible = '↡'

" Airline
let g:airline_powerline_fonts = 0
let g:airline#themes#clean#palette = 1
let g:airline_section_z = '%{strftime("%-I:%M %p")}'
let g:airline_section_warning = ''
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#fnamemod = ':t'

" Supertab
let g:SuperTabDefaultCompletionType = "<C-n>"

" Ultisnips
let g:UltiSnipsExpandTrigger="<C-Space>"
let g:UltiSnipsJumpForwardTrigger="<Tab>"
let g:UltiSnipsJumpBackwardTrigger="<C-x>"


" indentLine
let g:indentLine_char = '▏'
let g:indentLine_color_gui = '#363949'

" TagBar
let g:tagbar_width = 30
let g:tagbar_iconchars = ['↠', '↡']

" fzf-vim
let g:FZF_DEFAULT_COMMAND = 'rg --hidden --ignore .git -g ""'
let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-s': 'split',
  \ 'ctrl-v': 'vsplit' }
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
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

""" Filetype-Specific Configurations

" HTML, XML, Jinja
autocmd FileType html setlocal shiftwidth=2 tabstop=2 softtabstop=2
autocmd FileType css setlocal shiftwidth=2 tabstop=2 softtabstop=2
autocmd FileType xml setlocal shiftwidth=2 tabstop=2 softtabstop=2
autocmd FileType htmldjango setlocal shiftwidth=2 tabstop=2 softtabstop=2
autocmd FileType htmldjango inoremap {{ {{  }}<left><left><left>
autocmd FileType htmldjango inoremap {% {%  %}<left><left><left>
autocmd FileType htmldjango inoremap {# {#  #}<left><left><left>

" Markdown and Journal
autocmd FileType markdown setlocal shiftwidth=2 tabstop=2 softtabstop=2
autocmd FileType journal setlocal shiftwidth=2 tabstop=2 softtabstop=2

""" Custom Functions

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
""" Custom Mappings

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
" use a different buffer for dd (finally figured this out)
nnoremap d "_d
vnoremap d "_d 
" emulate windows copy, cut behavior
noremap <LeftRelease> "+y<LeftRelease>
noremap <C-c> "+y<CR>
noremap <C-x> "+d<CR>
