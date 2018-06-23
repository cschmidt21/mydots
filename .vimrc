set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
Plugin 'junegunn/fzf'
Plugin 'junegunn/fzf.vim'
Plugin 'scrooloose/nerdcommenter'
Plugin 'mhinz/vim-signify'
Plugin 'ericcurtin/CurtineIncSw.vim'
Plugin 'lfv89/vim-interestingwords'
Plugin 'tpope/vim-fugitive'
Plugin 'Valloric/YouCompleteMe'
Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
Plugin 'Raimondi/delimitMate'
Plugin 'powerline/powerline'
Plugin 'luochen1990/rainbow'
Plugin 'joshdick/onedark.vim'
Plugin 'mkitt/tabline.vim'
Plugin 'vim-scripts/SearchComplete'
Plugin 'christophermca/meta5'
" All of your Plugins must be added before the following line
call vundle#end()            " required

filetype plugin indent on    " required
if (empty($TMUX))
  if (has("nvim"))
    "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  endif
  "For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
  "Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
  " < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
  if (has("termguicolors"))
    set termguicolors
  endif
endif

set backspace=indent,eol,start
set number
set autoread
set encoding=utf-8
set background=dark
set ic

colorscheme meta5

hi CursorLine ctermbg=yellow guibg=yellow
hi CursorColumn ctermbg=yellow guibg=yellow

" Automatically save the current session whenever vim is closed
autocmd VimLeave * mksession! ~/.vim/shutdown_session.vim

command W w
command Q q
command Wq wq
command WQ wq

nnoremap j gj
nnoremap k gk
nnoremap <leader>fn :echo @%<CR>
nnoremap <leader>b :Buffers<CR>
nnoremap <leader>l :Lines 
nnoremap <leader>a :Rg 
nnoremap <leader>f :Files<CR>
nnoremap <c-t> :tab split<CR>
nnoremap <leader>jd :YcmCompleter GoToDeclaration<CR>
nnoremap <leader>jf :YcmCompleter GoToDefinition<CR>
nmap / /\c
" <F2> removes all trailing whitespace.
nnoremap <silent> <F2> :let _s=@/ <Bar> :%s/\s\+$//e <Bar> :let @/=_s <Bar> :nohl <Bar> :unlet _s <CR>
" <F7> restores that 'shutdown session'
noremap <F7> :source ~/.vim/shutdown_session.vim<CR>
inoremap jk <ESC>

map Y y$
map ; :set cursorline<CR>:set cursorcolumn<CR>:sleep 100m<CR>:set nocursorline<CR>:set nocursorcolumn<CR>
map <F5> :call CurtineIncSw()<CR>

set listchars=tab:▸\ ,trail:·
set list
set hlsearch
set laststatus=2
set showtabline=2
set noshowmode
" show existing tab with 4 spaces width
set tabstop=4
" when indenting with '>', use 4 spaces width
set shiftwidth=4
" On pressing tab, insert 4 spaces
set expandtab

" Configure fzf
let g:fzf_layout = { 'down': '~15%' }
let g:fzf_commits_log_options = '--graph --color=always --all --pretty=tformat:"%C(auto)%h%d %s %C(green)(%ar)%Creset %C(blue)<%an>%Creset"'

let g:rainbow_active = 1
let g:onedark_termcolors=256
let g:interestingWordsTermColors = ['154', '121', '211', '137', '214', '222']

syntax on
highlight Search ctermfg=black ctermbg=white
filetype plugin indent on

augroup vimrc_autocmd
    autocmd!
    autocmd SwapExists * :let v:swapchoice = 'e'

    " Resize splits when the window is resized
    au VimResized * exe "normal! \<c-w>="
     " Return to last edit position when opening files (You want this!)
    au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
                 \ |   exe "normal! g`\""
                 \ | endif
    " Add preview functionality to fzf
    au VimEnter * command! -bang -nargs=? -complete=dir Files
                \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)

    au VimEnter * command! -bang -nargs=* Rg
                \ call fzf#vim#grep(
                \ 'rg --column --line-number --no-heading --color=always --smart-case '.shellescape(<q-args>), 1,
                \     <bang>0 ? fzf#vim#with_preview('up:60%')
                \             : fzf#vim#with_preview('right:50%'),
                \     <bang>0)

augroup END
" If you really want to, this next line should restore the shutdown session 
" automatically, whenever you start vim.  (Commented out for now, in case 
" somebody just copy/pastes this whole block)
" 
autocmd VimEnter source ~/.vim/shutdown_session.vim<CR>
" ~/.vimrc ends here
