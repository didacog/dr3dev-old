" My ViM config file
"
" GO setup
" https://gist.github.com/joshuarubin/5d1f7c279160c4769feca8a6000b6da3

" Neovim vim runtime
set rtp^=/usr/share/vim/vimfiles/

" Vi Mproved
set nocompatible
" Setting dark mode
set background=dark

" Auto plugin update and 1st time install plugin manager Vim Plug

if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
	\  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
" autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

"autocmd vimenter * NERDTree

"
"let g:auto_type_info=0

" Vim plug
"
call plug#begin('~/.vim/plugged')

" gruvbox plugin 
Plug 'morhetz/gruvbox'
"lightline plugin
Plug 'itchyny/lightline.vim'
"Plug 'itchyny/lightline-powerful'
" Improved netrw with vim vinegar plugin
"Plug 'tpope/vim-vinegar'
" ctrlp.vim
"Plug 'ctrlpvim/ctrlp.vim'
" Surround plugin
Plug 'tpope/vim-surround'
" fugitive.vim
Plug 'tpope/vim-fugitive'
" git glutter vim
Plug 'airblade/vim-gitgutter'
" Language Server Client
"Plug 'autozimu/LanguageClient-neovim', {
"    \ 'branch': 'next',
"    \ 'do': 'bash install.sh',
"    \ }
" (Optional) Multi-entry selection UI.
"Plug 'junegunn/fzf'
" vim-go plugin
Plug 'fatih/vim-go'
"Plug 'fatih/vim-go', { 'do': ':GoInstallBinaries' }
" deoplete autocompletion
"if has('nvim')
"  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
"else
"  Plug 'Shougo/deoplete.nvim'
"  Plug 'roxma/nvim-yarp'
"  Plug 'roxma/vim-hug-neovim-rpc'
"endif
" Deoplete GO
"Plug 'zchee/deoplete-go', { 'do': 'make' }
" Neomake
Plug 'neomake/neomake'
" Bash support
"Plug 'vim-scripts/bash-support.vim'
" makes the autoread option and FocusGained and FocusLost work properly for terminal vim
Plug 'tmux-plugins/vim-tmux-focus-events'
" automatically copy yanked text into tmux's clipboard, and copy tmux's clipboard content into vim's quote(") registe
Plug 'roxma/vim-tmux-clipboard'
" NERDtree plugin
Plug 'scrooloose/nerdtree'
" NERDtree git plugin
Plug 'Xuyuanp/nerdtree-git-plugin'
" NERDtree syntax hghlght
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
" NERDCommenter plugin
Plug 'scrooloose/nerdcommenter'
" Vim Devicons plugin
Plug 'ryanoasis/vim-devicons'
" coc.nvim
Plug 'neoclide/coc.nvim', {'tag': '*', 'do': 'yarn install'}
call plug#end()

" enable syntax
syntax on
set synmaxcol=1024
" enable mouse
set mouse=a
" set filetype
filetype plugin indent on
" set previous regexp engine 
set regexpengine=1
" Change directory to the current buffer when opening files.
"set autochdir
" show numbers
set number
set linespace=0                 " No extra spaces between rows
" no line wrapping
set nowrap
set sidescroll=0
set sidescrolloff=999
" History
set history=1000
" stop unnecessary rendering
set lazyredraw
" adjust scroll redraw
"set ttyscroll=5
" Disable show mode under statusline
set noshowmode
" highlight cursor
set cursorline
"set cursorcolumn
" Enable Tab line when more than one
set showtabline=1
" Configure PATH to find recursively (fuzzy find)
set path+=**
" lazy file name tab completion
set wildmode=longest,list,full
set wildmenu
set wildignorecase
" enable autoread
set autoread
" show matching brackets and parens
set showmatch
" do not make backup/swap files
set nobackup
set noswapfile
set nowritebackup
" set character encoding to UTF-8
set encoding=utf-8
" show 10 lines above or below cursor when scrolling
set scrolloff=10
" show insert, replace, or visual mode in last line
"set showmode
" show command in last line
set showcmd
" flash screen on bell
"set visualbell
" assumes fast connection
set ttyfast
" show line and column number
set ruler
" every window gets a status line
set laststatus=2
" set tab size
set tabstop=4 
set softtabstop=4 
set shiftwidth=4 
set noexpandtab 
" enable auto indentation
set autoindent
" not show spaces and tabs; to turn on, use `:set list`
set nolist
set listchars=tab:→\ ,space:·,trail:·,extends:»,precedes:«,nbsp:⣿
" switch off search pattern highlighting
set hlsearch
set incsearch
" case insensitive search
set ignorecase
set smartcase
set infercase
" make backspace behave in a sane manner
set backspace=indent,eol,start
" Folding lines
"set foldmethod=indent  
" hide buffers, not close them
set hidden
" decrease updatetime 
set updatetime=300
" Better display for messages
set cmdheight=2
" don't give |ins-completion-menu| messages.
set shortmess+=c
" always show signcolumns
set signcolumn=yes
" Theming
if &term =~ '256color'
	" disable Background Color Erase (BCE) so that color schemes
	" render properly when inside 256-color tmux and GNU screen.
	" see also http://sunaku.github.io/vim-256color-bce.html
	set t_ut=
endif
" set Vim-specific sequences for RGB colors
if has("termguicolors")
	let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
	let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
	set termguicolors
endif
"set t_8f=^[[38;2;%lu;%lu;%lum        " set foreground color
"set t_8b=^[[48;2;%lu;%lu;%lum        " set background color
" solve italics on terminal
let &t_ZH="\e[3m"
let &t_ZR="\e[23m"
" colorscheme
let g:gruvbox_italic=1
colorscheme gruvbox
" term
"set term=xterm-256color
set t_Co=256
"set t_8f=\[[38;2;%lu;%lu;%lum
"set t_8b=\[[48;2;%lu;%lu;%lum
"set termguicolors
" gui
"set guifont=Hack-Regular:h9
"set guioptions-=L

" lightline options
"      \ 'colorscheme': 'wombat',
let g:lightline = {
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'cocstatus', 'gitbranch', 'readonly', 'filename' ] ]
      \ },
      \ 'component_function': {
      \   'mode': 'lightline#mode',
      \   'gitbranch': 'GitBranch',
      \   'filename': 'LightLineFilename',
      \   'filetype': 'MyFiletype',
      \   'fileformat': 'MyFileformat',
      \   'cocstatus': 'coc#status',
      \ },
      \ 'component_expand': {
      \   'table_mode': 'LightlineTableModeModifier',
      \ },
      \   'separator': { 'left': '', 'right': '' },
      \   'subseparator': { 'left': '', 'right': '' },
       \ }
"      \   'subseparator': { 'left': '❭', 'right': '❬' },

function! GitBranch()
	let gitsmbl = "\uf126" 
	let oksmbl = "\u2772\u2713\u2773" 
	let kosmbl = "\u2772\u2717\u2773" 
	let branch = fugitive#head()
	if branch == "" 
		let result = ""
	else
		let status = system('echo -n $(git status -sb|grep -v "^##"|wc -l)')
		if status == 0
			let result = gitsmbl . ' ' . branch . ' ' . oksmbl
		else
			let result = gitsmbl . ' ' . branch . ' ' . kosmbl
		endif
	endif
	return result
endfunction	

function! LightLineFilename()
	let name = ""
	let subs = split(expand('%:p'), "/") 
	let i = 1
	for s in subs
		let parent = name
		if  i == len(subs)
			let name = parent . '/' . s
		elseif i == 1
			let name = s
		else
			let name = parent . '/' . strpart(s, 0, 5)
		endif
		let i += 1
	endfor
	let modified = &modified ? ' +' : ''	
	if name == ""
		let name = "[NO NAME]"
	endif
	return name . modified 
endfunction

function! MyFiletype()
	return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype . ' ' . WebDevIconsGetFileTypeSymbol() : 'no ft') : ''
endfunction

function! MyFileformat()
	return winwidth(0) > 70 ? (&fileformat . ' ' . WebDevIconsGetFileFormatSymbol()) : ''
endfunction

function! LightlineTableModeModifier()
	return get(g:lightline, 'table_active') ? 'TABLE' : ''
endfunction

" NERDTree config
"
" NERDTree Git
let g:NERDTreeShowIgnoredStatus = 1  "enables ignored highlighting
let g:NERDTreeGitStatusNodeColorization = 1  "enables colorization
let g:NERDTreeGitStatusWithFlags = 1  "enables flags, (may be default), required for colorization

"highlight link NERDTreeDir Question  "custom color
"highlight link NERDTreeGitStatusIgnored Comment  "custom color
"highlight link NERDTreeGitStatusModified cssURL  "custom color

" NERDTree
"
map <C-n> :NERDTreeToggle<CR>
let g:NERDTreeHighlightCursorline = 0
let g:NERDTreeHighlightFolders = 1 " folder icon highlighting using exact match
let g:NERDTreeHighlightFoldersFullName = 1 " highlights the folder name
"let g:NERDTreeDisablePatternMatchHighlight = 1
"let g:NERDTreeLimitedSyntax = 1
let g:NERDTreeSyntaxEnabledExtensions = ['json', 'js', 'sh', 'go', 'php', 'html', 'js', 'css', 'markdown', 'md', 'rst', 'vim', 'sql', 'yaml', 'yml', 'py', 'pl', 'conf', 'config' ]
let NERDTreeShowHidden=1
let g:NERDTreeFileExtensionHighlightFullName = 1
let g:NERDTreeExactMatchHighlightFullName = 1
let g:NERDTreePatternMatchHighlightFullName = 1
"let g:NERDTreeDirArrowExpandable = nr2char(8200)  "sets expandable character
"let g:NERDTreeDirArrowCollapsible = nr2char(8200)  "sets collapsible character
"let g:WebDevIconsNerdTreeAfterGlyphPadding = ''  "removes padding after devicon glyph
let g:WebDevIconsUnicodeDecorateFolderNodes = 1  "enables decorating folder nodes
let g:DevIconsEnableFoldersOpenClose = 1

autocmd FileType nerdtree setlocal nolist  "if you show hidden characters, this hides them in NERDTree

let g:NERDTreeIndicatorMapCustom = {
    \ 'Modified'  : '✱',
    \ 'Staged'    : '✚',
    \ 'Untracked' : '‼',
    \ 'Renamed'   : '➔',
    \ 'Unmerged'  : '=',
    \ 'Deleted'   : '✖',
    \ 'Dirty'     : '✗',
    \ 'Clean'     : '✔︎',
    \ 'Ignored'   : '☒',
    \ 'Unknown'   : '⁇'
    \ }

"Gitglutter config
"
" speed optimizations
let g:gitgutter_realtime = 1
let g:gitgutter_eager = 1
let g:gitgutter_max_signs = 1500
let g:gitgutter_diff_args = '-w'
"let g:gitgutter_terminal_reports_focus=0
" custom symbols
"let g:gitgutter_sign_added = '+'
"let g:gitgutter_sign_modified = '~'
"let g:gitgutter_sign_removed = '-'
"let g:gitgutter_sign_removed_first_line = '^'
"let g:gitgutter_sign_modified_removed = ':'
" color overrrides
"highlight clear SignColumn
"highlight GitGutterAdd ctermfg=green ctermbg=234
"highlight GitGutterChange ctermfg=yellow ctermbg=234
"highlight GitGutterDelete ctermfg=red ctermbg=234
"highlight GitGutterChangeDelete ctermfg=red ctermbg=234

" netrw config
"
"let g:netrw_liststyle = 3
"let g:netrw_browse_split = 4
"let g:netrw_altv = 1
"let g:netrw_winsize = 25
"let g:netrw_banner = 0
""let g:netrw_list_hide = &wildignore
""Toggle Vexplore with Ctrl-E
"function! ToggleVExplorer()
"	if exists("t:expl_buf_num")
"		let expl_win_num = bufwinnr(t:expl_buf_num)
"		if expl_win_num != -1
"			let cur_win_nr = winnr()
"			exec expl_win_num . 'wincmd w'
"			close
"			exec cur_win_nr . 'wincmd w'
"			unlet t:expl_buf_num
"		else
"			unlet t:expl_buf_num
"		endif
"	else
"		exec '1wincmd w'
"		Vexplore
"		let t:expl_buf_num = bufnr("%")
"	endif
"endfunction
"
"map <silent> <C-E> :call ToggleVExplorer()<CR>

" Go files
" use real tabs in .go files, not spaces
autocmd FileType go setlocal shiftwidth=4 tabstop=4 softtabstop=4 noexpandtab
" vim-go
"
let g:go_highlight_build_constraints = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1
let g:go_highlight_operators = 1
let g:go_fold_enable = ['block', 'import', 'varconst', 'package_comment', 'comment']
let g:go_def_mode = 'guru'
"let g:go_def_mapping_enabled = 0
let g:go_fmt_command = 'goimports'
"let g:go_fmt_fail_silently = 1
let g:go_term_enabled = 1
let g:go_auto_sameids = 1
let g:go_auto_type_info = 1

" Deoplete 
" 
"set completeopt=longest,menuone " auto complete setting
"let g:deoplete#enable_at_startup = 1
"let g:deoplete#enable_smart_case = 1
"let g:deoplete#auto_complete_start_length = 1
"let g:deoplete#keyword_patterns = {}
"let g:deoplete#keyword_patterns['default'] = '\h\w*'
"let g:deoplete#omni#input_patterns = {}
"let g:deoplete#sources#go#sort_class = ['package', 'func', 'type', 'var', 'const']
"let g:deoplete#sources#go#align_class = 1

" neomake
"
autocmd BufWritePost * Neomake
let g:neomake_error_sign   = {'text': '✖', 'texthl': 'NeomakeErrorSign'}
let g:neomake_warning_sign = {'text': '∆', 'texthl': 'NeomakeWarningSign'}
let g:neomake_message_sign = {'text': '➤', 'texthl': 'NeomakeMessageSign'}
let g:neomake_info_sign    = {'text': 'ℹ', 'texthl': 'NeomakeInfoSign'}
let g:neomake_go_enabled_makers = [ 'go', 'gometalinter' ]
let g:neomake_go_gometalinter_maker = {
  \ 'args': [
  \   '--tests',
  \   '--enable-gc',
  \   '--concurrency=3',
  \   '--fast',
  \   '-D', 'aligncheck',
  \   '-D', 'dupl',
  \   '-D', 'gocyclo',
  \   '-D', 'gotype',
  \   '-E', 'errcheck',
  \   '-E', 'misspell',
  \   '-E', 'unused',
  \   '%:p:h',
  \ ],
  \ 'append_file': 0,
  \ 'errorformat':
  \   '%E%f:%l:%c:%trror: %m,' .
  \   '%W%f:%l:%c:%tarning: %m,' .
  \   '%E%f:%l::%trror: %m,' .
  \   '%W%f:%l::%tarning: %m'
  \ }

" Language server client
"let g:LanguageClient_serverCommands = {
"	\ 'go': ['go-langserver'],
"	\ 'sh': ['bash-language-server', 'start']
"    \ }
"    \ 'javascript': ['/usr/local/bin/javascript-typescript-stdio'],
"    \ 'javascript.jsx': ['tcp://127.0.0.1:2089'],
"    \ 'python': ['/usr/local/bin/pyls'],

" DeVicons solve resource vimrc issues
"if exists("g:loaded_webdevicons")
"  call webdevicons#refresh()
"endif

""""" coc.nvim config
" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> for trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> for confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" Use `[c` and `]c` for navigate diagnostics
nmap <silent> [c <Plug>(coc-diagnostic-prev)
nmap <silent> ]c <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K for show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if &filetype == 'vim'
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

" Remap for format selected region
vmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json,go,sh setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
vmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap for do codeAction of current line
nmap <leader>ac  <Plug>(coc-codeaction)
" Fix autofix problem of current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Use `:Format` for format current buffer
command! -nargs=0 Format :call CocAction('format')

" Use `:Fold` for fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Using CocList
" Show all diagnostics
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent> <space>p  :<C-u>CocListResume<CR>
