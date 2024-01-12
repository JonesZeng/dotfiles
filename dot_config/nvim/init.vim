" __  ____   __  _   ___     _____ __  __ ____   ____
"|  \/  \ \ / / | \ | \ \   / /_ _|  \/  |  _ \ / ___|
"| |\/| |\ V /  |  \| |\ \ / / | || |\/| | |_) | |
"| |  | | | |   | |\  | \ V /  | || |  | |  _ <| |___
"|_|  |_| |_|   |_| \_|  \_/  |___|_|  |_|_| \_\\____|

" Author: @JonesZeng (Based on theniceboy)
"
" Checkout-list
" vim-esearch
" fmoralesc/worldslice
" SidOfc/mkdx

" ===
" === Auto load for first time uses
" ===
if empty(glob('~/.config/nvim/autoload/plug.vim'))
	silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
				\ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif


" ===
" === Create a _machine_specific.vim file to adjust machine specific stuff, like python interpreter location
" ===
let has_machine_specific_file = 1
if empty(glob('~/.config/nvim/_machine_specific.vim'))
	let has_machine_specific_file = 0
	silent! exec "!cp ~/.config/nvim/default_configs/_machine_specific_default.vim ~/.config/nvim/_machine_specific.vim"
endif
source ~/.config/nvim/_machine_specific.vim


" ====================
" === Editor Setup ===
" ====================
" === check vscode
"exists('g:vscode')
" ===
" === System
" ===
"set clipboard=unnamedplus
let &t_ut=''
set autochdir

" ===
" === Chinese input
" ===
set encoding=UTF-8
set langmenu=zh_CN.UTF-8
language message zh_CN.UTF-8
"set fileencodings=ucs-bom,utf-8,cp936,gb18030,big5,euc-jp,euc-kr,latin1 #这一句可以不加
set fileencoding=utf-8


" ===
" === Editor behavior
" ===
set number
set relativenumber
set cursorline
set noexpandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4
set autoindent
set list
set listchars=tab:\|\ ,trail:▫
set scrolloff=4
set ttimeoutlen=0
set notimeout
set viewoptions=cursor,folds,slash,unix
set wrap
set tw=0
set indentexpr=
set foldmethod=indent
set foldlevel=99
set foldenable
set formatoptions-=tc
set splitright
set splitbelow
set noshowmode
set showcmd
set wildmenu
set ignorecase
set smartcase
set shortmess+=c
set inccommand=split
set completeopt=longest,noinsert,menuone,noselect,preview
set ttyfast "should make scrolling faster
set lazyredraw "same as above
set visualbell
silent !mkdir -p ~/.config/nvim/tmp/backup
silent !mkdir -p ~/.config/nvim/tmp/undo
silent !mkdir -p ~/.config/nvim/tmp/sessions
set backupdir=~/.config/nvim/tmp/backup,.
set directory=~/.config/nvim/tmp/backup,.
if has('persistent_undo')
	set undofile
	set undodir=~/.config/nvim/tmp/undo,.
endif
set colorcolumn=80
set updatetime=1000
set virtualedit=block
" set g:powerline_pycmd to "py3"
" ===
" === Fix Chinese Display
" ===
set fileencodings=utf-8,ucs-bom,gb18030,gbk,gb2312,cp936
set termencoding=utf-8
set encoding=utf-8

" ===
" === CapsLock map
" ===
au VimEnter * silent! !xmodmap -e 'clear Lock' -e 'keycode 0x42 = Escape'
au VimEnter * silent! !xmodmap -e 'clear Lock' -e 'keycode 0x42 = Escape'

au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif


" ===
" === Terminal Behaviors
" ===
let g:neoterm_autoscroll = 1
autocmd TermOpen term://* startinsert
tnoremap <C-N> <C-\><C-N>
tnoremap <C-O> <C-\><C-N><C-O>
let g:terminal_color_0  = '#000000'
let g:terminal_color_1  = '#FF5555'
let g:terminal_color_2  = '#50FA7B'
let g:terminal_color_3  = '#F1FA8C'
let g:terminal_color_4  = '#BD93F9'
let g:terminal_color_5  = '#FF79C6'
let g:terminal_color_6  = '#8BE9FD'
let g:terminal_color_7  = '#BFBFBF'
let g:terminal_color_8  = '#4D4D4D'
let g:terminal_color_9  = '#FF6E67'
let g:terminal_color_10 = '#5AF78E'
let g:terminal_color_11 = '#F4F99D'
let g:terminal_color_12 = '#CAA9FA'
let g:terminal_color_13 = '#FF92D0'
let g:terminal_color_14 = '#9AEDFE'
augroup TermHandling
  autocmd!
  " Turn off line numbers, listchars, auto enter insert mode and map esc to
  " exit insert mode
  autocmd TermOpen * setlocal listchars= nonumber norelativenumber
    \ | startinsert
    \ | tnoremap <Esc> <c-c>
  autocmd FileType fzf call LayoutTerm(0.6, 'horizontal')
augroup END

function! LayoutTerm(size, orientation) abort
  let timeout = 16.0
  let animation_total = 120.0
  let timer = {
    \ 'size': a:size,
    \ 'step': 1,
    \ 'steps': animation_total / timeout
  \}

  if a:orientation == 'horizontal'
    resize 1
    function! timer.f(timer)
      execute 'resize ' . string(&lines * self.size * (self.step / self.steps))
      let self.step += 1
    endfunction
  else
    vertical resize 1
    function! timer.f(timer)
      execute 'vertical resize ' . string(&columns * self.size * (self.step / self.steps))
      let self.step += 1
    endfunction
  endif
  call timer_start(float2nr(timeout), timer.f, {'repeat': float2nr(timer.steps)})
endfunction

" Open autoclosing terminal, with optional size and orientation
function! OpenTerm(cmd, ...) abort
  let orientation = get(a:, 2, 'horizontal')
  if orientation == 'horizontal'
    new | wincmd J
  else
    vnew | wincmd L
  endif
  call LayoutTerm(get(a:, 1, 0.5), orientation)
  call termopen(a:cmd, {'on_exit': {j,c,e -> execute('if c == 0 | close | endif')}})
endfunction
" }}}
" vim:fdm=marker


" ===
" === Basic Mappings
" ===
" Set <LEADER> as <SPACE>, ; as :
let mapleader=" "
noremap ; :

" Save & quit
noremap Q :q<CR>
noremap <C-q> :qa<CR>
noremap S :w<CR>
noremap <LEADER>ld :so ~/.config/nvim/init.vim<CR>


" Open the vimrc file anytime
noremap <LEADER>rc :e ~/.config/nvim/init.vim<CR>
noremap <LEADER>smd :e ~/.config/nvim/md-snippets.vim<CR>
noremap <LEADER>ra :e ~/.config/ranger/rc.conf<CR>
noremap <LEADER>ssr :e ~/.config/ranger/scope.sh<CR>
noremap <LEADER>i3 :e ~/.i3/config<CR>
noremap <LEADER>zsh :e ~/.zshrc<CR>
noremap <LEADER>tmn :e ~\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json<CR>
noremap <LEADER>ps :e ~/Documents/WindowsPowerShell/Microsoft.PowerShell_profile.ps1<CR>
noremap <LEADER>tex :e ~/.config/nvim/plugged/vimtex/ftplugin/tex.vim<CR>
noremap <LEADER>bib:e ~/.config/nvim/plugged/vimtex/ftplugin/bib.vim<CR>


" Open Startify
"noremap <LEADER>st :Startify<CR>

" Undo operations
" noremap l u

" Insert Key
noremap h i
noremap H I

" make Y to copy till the end of the line
nnoremap Y y$

" Copy to system clipboard
vnoremap Y "+y

" Indentation
nnoremap < <<
nnoremap > >>

" Search
noremap <LEADER><CR> :nohlsearch<CR>

" Adjacent duplicate words
noremap <LEADER>dw /\(\<\w\+\>\)\_s*\1

" Space to Tab
nnoremap <LEADER>tt :%s/    /\t/g
vnoremap <LEADER>tt :s/    /\t/g

" Folding
"noremap <silent> <LEADER>o za

" Open up lazygit
noremap \g :term lazygit<CR>
noremap <c-g> :tabe<CR>:term lazygit<CR>

" Open up pudb
noremap <c-d> :tab sp<CR>:term python3 -m pudb %<CR>
"noremap <f5> :tab sp<CR>:term python3 -m pudb %<CR>

"===
"=== Text Selection
"===


" ===
" === Cursor Movement
" ===
" New cursor movement (the default arrow keys are used for resizing windows)
"     ^
"     i
" < j   l >
"     k
"     v
noremap <silent> j h
noremap <silent> k j
noremap <silent> i k

" U/E keys for 5 times u/e (faster navigation)
noremap <silent> I 6k
noremap <silent> K 6j
noremap  <silent>J 7h
noremap <silent> L 7l

" N key: go to the start of the line
noremap <silent> 9 0
" I key: go to the end of the line
noremap <silent> 0 $

" Faster in-line navigation
noremap W 5w
noremap E 5e
noremap B 5b


" Ctrl + U or E will move up/down the view port without moving the cursor
noremap <c-i> <C-e>
noremap <C-I> 5<c-e>
noremap <c-k> <C-y>
noremap <C-K> 5<c-y>

" ===
" === Insert Mode Cursor Movement
" ===
inoremap <C-a> <ESC>A
inoremap <C-l> <ESC>ea
inoremap <C-j> <ESC>bi
inoremap <C-L> <ESC>5ea
inoremap <C-J> <ESC>5bi
inoremap <C-i> <ESC>ka
inoremap <C-k> <ESC>ja
inoremap <c-I> <ESC>5ka
inoremap <C-K> <ESC>5ja


" ===
" === Command Mode Cursor Movement
" ===
cnoremap <C-a> <Home>
cnoremap <c-k> <End>
cnoremap <c-l> <Up>
cnoremap <C-k> <Down>
cnoremap <C-j> <Left>
cnoremap <C-l> <Right>
cnoremap <M-b> <S-Left>
cnoremap <M-w> <S-Right>


" ===
" === Window management
" ===
" Use <space> + new arrow keys for moving the cursor around windows
noremap <LEADER><++>w <C-w>w
noremap <LEADER>i <C-w>k
noremap <LEADER>k <C-w>j
noremap <LEADER>j <C-w>h
noremap <LEADER>l <C-w>l

" Disable the default s key
noremap s <nop>

" split the screens to up (horizontal), down (horizontal), left (vertical), right (vertical)
noremap si :set nosplitbelow<CR>:split<CR>:set splitbelow<CR>
noremap sk :set splitbelow<CR>:split<CR>
noremap sj :set nosplitright<CR>:vsplit<CR>:set splitright<CR>
noremap sl :set splitright<CR>:vsplit<CR>

" Resize splits with arrow keys
noremap <up> :res +5<CR>
noremap <down> :res -5<CR>
noremap <left> :vertical resize-5<CR>
noremap <right> :vertical resize+5<CR>

" Place the two screens up and down
noremap sh <C-w>t<C-w>K
" Place the two screens side by side
noremap sv <C-w>t<C-w>H

" Rotate Screens
noremap srh <C-w>b<C-w>K
noremap srv <C-w>b<C-w>H

" Press <SPACE> + q to close the window below the current window
noremap <LEADER>q <C-w>j:q<CR>

" Window Zoom
function! Zoom ()
    " check if is the zoomed state (tabnumber > 1 && window == 1)
    if tabpagenr('$') > 1 && tabpagewinnr(tabpagenr(), '$') == 1
        let l:cur_winview = winsaveview()
        let l:cur_bufname = bufname('')
        tabclose

        " restore the view
        if l:cur_bufname == bufname('')
            call winrestview(cur_winview)
        endif
    else
        tab split
    endif
endfunction

nmap <leader>zz :call Zoom()<CR>

" ===
" === Tab management
" ===
" Create a new tab with tu
noremap tu :tabe<CR>
" Move around tabs with tn and ti
noremap tj :-tabnext<CR>
noremap tl :+tabnext<CR>
" Move the tabs with tmn and tmi
noremap tmj :-tabmove<CR>
noremap tml :+tabmove<CR>


" ===
" === Markdown Settings
" ===
" Snippets
source ~/.config/nvim/md-snippets.vim
" auto spell
autocmd BufRead,BufNewFile *.md setlocal spell


" ===
" === Other useful stuff
" ===
" Move the next character to the end of the line with ctrl+9
inoremap <c-l>gg <ESC>lx$p

" Opening a terminal window
noremap <LEADER>/ :term<CR>

" Press space twice to jump to the next '<++>' and edit it
noremap <LEADER><LEADER> <Esc>/<++><CR>:nohlsearch<CR>c4l

" Spelling Check with <space>sc
noremap <LEADER>sc :set spell!<CR>

" Press ` to change case (instead of ~)
noremap ` ~

noremap <C-c> zz

" Auto change directory to current dir
autocmd BufEnter * silent! lcd %:p:h

" Call figlet
noremap tx :r !figlet

noremap <LEADER>- :lN<CR>
noremap <LEADER>= :lne<CR>

" find and replace
noremap \s :%s//g<left><left>

" Ctags & Cscope
noremap gt :call GenTags()<CR>
func! GenTags()
	if &filetype == 'c' || $filetype == 'cpp'
		exec "!ctags --extras=+q --fields=+Saim --c++-kinds=+lpx --c-kinds=+lpx -R ."
	elseif $filetype == 'java'
		exec "!ctags --java-kinds=+l -R ."
	endif
endfunc

" Compile function
noremap rr :call CompileRunGcc()<CR>
func! CompileRunGcc()
	exec "w"
	if &filetype == 'c'
		exec "!g++ % -o %<"
		exec "!time ./%<"
	elseif &filetype == 'cpp'
		set splitbelow
		"exec "!g++ -std=c++11 % -Wall -o %<"
		exec "!g++ `pkg-config opencv --cflags --libs` % post_process.cpp -Wall -o %<"
		"exec "!g++ `pkg-config opencv --cflags --libs` % -Wall -o %<"
		:sp
		:res -15
		:term ./%<
	elseif &filetype == 'java'
		exec "!javac %"
		exec "!time java %<"
	elseif &filetype == 'sh'
		:!time bash %
	elseif &filetype == 'python'
		set splitbelow
		:sp
		:term python3 %
	elseif &filetype == 'html'
		silent! exec "!".g:mkdp_browser." % &"
	elseif &filetype == 'markdown'
		exec "MarkdownPreview"
		:MarkdownPreview
	elseif &filetype == 'md'
		"exec "MarkdownPreview"
		:MarkdownPreview
	elseif &filetype == 'tex'
		silent! exec "VimtexStop"
		silent! exec "VimtexCompile"
	elseif &filetype == 'go'
		set splitbelow
		:sp
		:term go run %
	endif
endfunc

" ===
" === Install Plugins with Vim-Plug
" ===
" 替换函数。参数说明：
" confirm：是否替换前逐一确认
" wholeword：是否整词匹配
" replace：被替换字符串
function! Replace(confirm, wholeword, replace)
    wa
    let flag = ''
    if a:confirm
        let flag .= 'gec'
    else
        let flag .= 'ge'
    endif
    let search = ''
    if a:wholeword
        let search .= '\<' . escape(expand('<cword>'), '/\.*$^~[') . '\>'
    else
        let search .= expand('<cword>')
    endif
    let replace = escape(a:replace, '/\&~')
    execute 'argdo %s/' . search . '/' . replace . '/' . flag . '| update'
endfunction
" 不确认、非整词
nnoremap <Leader>R :call Replace(0, 0, input('Replace '.expand('<cword>').' with: '))<CR>
" 不确认、整词
nnoremap <Leader>rw :call Replace(0, 1, input('Replace '.expand('<cword>').' with: '))<CR>
" 确认、非整词
nnoremap <Leader>rh :call Replace(1, 0, input('Replace '.expand('<cword>').' with: '))<CR>
" 确认、整词
nnoremap <Leader>rhw :call Replace(1, 1, input('Replace '.expand('<cword>').' with: '))<CR>
nnoremap <Leader>rwc :call Replace(1, 1, input('Replace '.expand('<cword>').' with: '))<CR>

call plug#begin('~/.config/nvim/plugged')



" Testing my own plugin
Plug 'theniceboy/vim-calc'

" Pretty Dress
"Plug 'theniceboy/eleline.vim'
Plug 'bling/vim-bufferline'
Plug 'liuchengxu/space-vim-theme'
Plug 'morhetz/gruvbox'
Plug 'ayu-theme/ayu-vim'
Plug 'rakr/vim-one'
Plug 'mhartington/oceanic-next'
Plug 'kristijanhusak/vim-hybrid-material'
Plug 'ajmwagar/vim-deus'
Plug 'arzg/vim-colors-xcode'

" Genreal Highlighter
Plug 'jaxbot/semantic-highlight.vim'
Plug 'chrisbra/Colorizer' " Show colors with :ColorHighlight

" File navigation
"Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
"Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'junegunn/fzf.vim'
"Plug 'yuki-ycino/fzf-preview.vim'
Plug 'junegunn/fzf', {'dir': '~/.fzf', 'do': './install --all'}
"Plug 'junegunn/fzf'
Plug 'francoiscabrol/ranger.vim'

" Taglist
Plug 'liuchengxu/vista.vim'

" Debugger
Plug 'puremourning/vimspector', {'do': './install_gadget.py --enable-c --enable-python'}

" REPL
Plug 'rhysd/reply.vim'

" Error checking, handled by coc

" Auto Complete
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Explorer
Plug 'justinmk/vim-dirvish'

" Snippets
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

" Undo Tree
Plug 'mbbill/undotree'

" Git
Plug 'theniceboy/vim-gitignore', { 'for': ['gitignore', 'vim-plug'] }
Plug 'fszymanski/fzf-gitignore', { 'do': ':UpdateRemotePlugins' }
"Plug 'mhinz/vim-signify'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'

" Tex
Plug 'lervag/vimtex'

" CSharp
Plug 'OmniSharp/omnisharp-vim'
Plug 'ctrlpvim/ctrlp.vim' , { 'for': ['cs', 'vim-plug'] } " omnisharp-vim dependency

" HTML, CSS, JavaScript, PHP, JSON, etc.
Plug 'elzr/vim-json'
Plug 'hail2u/vim-css3-syntax', { 'for': ['vim-plug', 'php', 'html', 'javascript', 'css', 'less'] }
Plug 'spf13/PIV', { 'for' :['php', 'vim-plug'] }
Plug 'pangloss/vim-javascript', { 'for': ['vim-plug', 'php', 'html', 'javascript', 'css', 'less'] }
Plug 'yuezk/vim-js', { 'for': ['vim-plug', 'php', 'html', 'javascript', 'css', 'less'] }
Plug 'MaxMEllon/vim-jsx-pretty', { 'for': ['vim-plug', 'php', 'html', 'javascript', 'css', 'less'] }
Plug 'jelera/vim-javascript-syntax', { 'for': ['vim-plug', 'php', 'html', 'javascript', 'css', 'less'] }
"Plug 'jaxbot/browserlink.vim'

" Go
Plug 'fatih/vim-go' , { 'for': ['go', 'vim-plug'], 'tag': '*' }

" C/C++
Plug 'octol/vim-cpp-enhanced-highlight' , { 'for': ['c', 'cpp', 'vim-plug'], 'tag': '*' }
Plug 'dense-analysis/ale', { 'for': ['c', 'cpp', 'python', 'vim-plug'] }

" LLVM IR
Plug 'rhysd/vim-llvm', { 'for': [ 'll', 'td', 'vim-plug' ] }

" Sourcetrail-vim
"Plug 'CoatiSoftware/vim-sourcetrail'

" Gen Tag
Plug 'ludovicchabant/vim-gutentags', { 'for' : ['c', 'cpp', 'vim-plug'] }

" Python
Plug 'tmhedberg/SimpylFold', { 'for' :['python', 'vim-plug'] }
Plug 'Vimjas/vim-python-pep8-indent', { 'for' :['python', 'vim-plug'] }
Plug 'numirias/semshi', { 'do': ':UpdateRemotePlugins', 'for' :['python', 'vim-plug'] }
"Plug 'davidhalter/jedi-vim', {'for' :['python', 'vim-plug']}
"Plug 'vim-scripts/indentpython.vim', { 'for' :['python', 'vim-plug'] }
"Plug 'plytophogy/vim-virtualenv', { 'for' :['python', 'vim-plug'] }
Plug 'tweekmonster/braceless.vim'

" Markdown
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install_sync() }, 'for' :['markdown', 'vim-plug'] }
Plug 'dhruvasagar/vim-table-mode', { 'on': 'TableModeToggle' }
Plug 'theniceboy/bullets.vim'
Plug 'mzlogin/vim-markdown-toc'

" Wiki
Plug 'vimwiki/vimwiki'

" Other filetypes
Plug 'jceb/vim-orgmode', {'for': ['vim-plug', 'org']}

" Editor Enhancement
"Plug 'Raimondi/delimitMate'
Plug 'jiangmiao/auto-pairs'
Plug 'terryma/vim-multiple-cursors'
Plug 'scrooloose/nerdcommenter' " in <space>cn to comment a line
Plug 'AndrewRadev/switch.vim' " gs to switch
Plug 'tpope/vim-surround' " type yskw' to wrap the word with '' or type cs'` to change 'word' to `word`
Plug 'gcmt/wildfire.vim' " in Visual mode, type k' to select all text in '', or type k) k] k} kp
Plug 'junegunn/vim-after-object' " da= to delete what's after =
Plug 'junegunn/vim-easy-align' " gaip= to align the = in paragraph,
Plug 'tpope/vim-capslock'	" Ctrl+L (insert) to toggle capslock
Plug 'easymotion/vim-easymotion'
Plug 'Konfekt/FastFold'
Plug 'junegunn/vim-peekaboo'
Plug 'bkad/CamelCaseMotion'
Plug 'andymass/vim-matchup'
"Plug 'wellle/context.vim'

" Input Method Autoswitch
"Plug 'rlue/vim-barbaric' " slowing down vim-multiple-cursors

" Formatter
Plug 'Chiel92/vim-autoformat'
Plug 'rhysd/vim-clang-format'
Plug 'kana/vim-operator-user'

" For general writing
Plug 'junegunn/goyo.vim'
"Plug 'reedes/vim-wordy'
"Plug 'ron89/thesaurus_query.vim'

" Bookmarks
"Plug 'kshenoy/vim-signature'
Plug 'MattesGroeger/vim-bookmarks'

" Find & Replace
Plug 'brooth/far.vim', { 'on': ['F', 'Far', 'Fardo'] }
Plug 'osyo-manga/vim-anzu'

" Documentation
"Plug 'KabbAmine/zeavim.vim' " <LEADER>z to find doc

" Mini Vim-APP
"Plug 'voldikss/vim-floaterm'
"Plug 'liuchengxu/vim-clap'
"Plug 'jceb/vim-orgmode'
"Plug 'mhinz/vim-startify'
Plug 'theniceboy/vim-leader-mapper'

" Vim Applications
Plug 'itchyny/calendar.vim'

" Vim Diff
Plug 'will133/vim-dirdiff'
Plug 'chrisbra/vim-diff-enhanced'

" Other visual enhancement
Plug 'ryanoasis/vim-devicons'
Plug 'luochen1990/rainbow'
Plug 'mg979/vim-xtabline'
Plug 'wincent/terminus'

" Other useful utilities
Plug 'lambdalisue/suda.vim' " do stuff like :SudoWrite
Plug 'makerj/vim-pdf'
"Plug 'xolox/vim-session'
"Plug 'xolox/vim-misc' " vim-session dep
Plug 'semanser/vim-outdated-plugins'

" Dependencies
Plug 'MarcWeber/vim-addon-mw-utils'
Plug 'kana/vim-textobj-user'
Plug 'roxma/nvim-yarp'
Plug 'rbgrouleff/bclose.vim' " For ranger.vim

" SourceGraph
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.4' }
" or                                , { 'branch': '0.1.x' }
Plug 'sourcegraph/sg.nvim', { 'do': 'nvim -l build/init.lua' }

call plug#end()

" experimental
set lazyredraw
"set regexpengine=1


" ===
" === Dress up my vim
" ===
set termguicolors	" enable true colors support
let $NVIM_TUI_ENABLE_TRUE_COLOR=1
set background=dark
"let ayucolor="mirage"
"let g:oceanic_next_terminal_bold = 1
"let g:oceanic_next_terminal_italic = 1
"let g:one_allow_italics = 1

"color dracula
color deus
"color one
"color gruvbox
"let ayucolor="light"
"color ayu
"set background=light
"color xcodedark

hi NonText ctermfg=gray guifg=grey10
"hi SpecialKey ctermfg=blue guifg=grey70

" ===================== Start of Plugin Settings =====================


" ===
" === eleline.vim
" ===
let g:airline_powerline_fonts = 0

" ===
" === Vim Diff
" ===
"nnoremap <leader>kk :diffsplit<CR>
"nnoremap <leader>kl :vert diffsplit<CR>


" ==
" == GitGutter
" ==
let g:gitgutter_signs = 0
let g:gitgutter_map_keys = 0
let g:gitgutter_override_sign_column_highlight = 0
let g:gitgutter_preview_win_floating = 1
autocmd BufWritePost * GitGutter
nnoremap <LEADER>gf :GitGutterFold<CR>
nnoremap M :GitGutterPreviewHunk<CR>
nnoremap <LEADER>g- :GitGutterPrevHunk<CR>
nnoremap <LEADER>g= :GitGutterNextHunk<CR>

" ===
" === SourceGraph
" ===

" Example mapping for doing searches from within neovim (may change) using telescope.
" (requires telescope.nvim to be installed)
nnoremap <leader>ss <cmd>lua require('sg.extensions.telescope').fuzzy_search_results()<CR>


" " ===
" === coc
" ===
" fix the most annoying bug that coc has
"silent! au BufEnter,BufRead,BufNewFile * silent! unmap if
"commet  oc-translator
let g:coc_global_extensions = [ 'coc-python', 'coc-vimlsp', 'coc-html', 'coc-json', 'coc-css', 'coc-tsserver', 'coc-yank', 'coc-lists', 'coc-gitignore', 'coc-vimlsp', 'coc-tailwindcss', 'coc-stylelint', 'coc-tslint', 'coc-lists', 'coc-git', 'coc-explorer', 'coc-pyright', 'coc-cmake', 'coc-actions', 'coc-clangd', 'coc-texlab', 'coc-todolist', 'coc-tasks', 'coc-snippets', 'coc-translator' ]

" Formatting selected code.
xmap <leader>,cf  <Plug>(coc-format-selected)
nmap <leader>,cf  <Plug>(coc-format-selected)

"set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}
"nmap <silent> <TAB> <Plug>(coc-range-select)
"xmap <silent> <TAB> <Plug>(coc-range-select)
" use <tab> for trigger completion and navigate to the next complete item
function! s:check_back_space() abort
	let col = col('.') - 1
	return !col || getline('.')[col - 1]	=~ '\s'
endfunction

inoremap <silent><expr> <Tab>
			\ pumvisible() ? "\<C-n>" :
			\ <SID>check_back_space() ? "\<Tab>" :
			\ coc#refresh()
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

function! s:check_back_space() abort
	let col = col('.') - 1
	return !col || getline('.')[col - 1]  =~# '\s'
endfunction
" use ctrl-a to trigger completion
inoremap <silent><expr> <c-a> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
" position. Coc only does snippet and additional edit on confirm.
" <cr> could be remapped by other vim plugin, try `:verbose imap <CR>`.
if exists('*complete_info')
  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" Use K to show documentation in preview window.
nnoremap <silent> <leader>h :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Open up coc-commands
nnoremap <c-c> :CocCommand<CR>
" Text Objects
xmap kf <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap kf <Plug>(coc-funcobj-i)
omap af <Plug>(coc-funcobj-a)
" Useful commands
nnoremap <silent> <space>y :<C-u>CocList -A --normal yank<cr>
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nmap <silent> <leader>rn <Plug>(coc-rename)
"nmap tt :CocCommand explorer<CR>
" coc-translator
"nmap ts <Plug>(coc-translator-p)
" Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Explorer
nmap tt :Dirvish <CR>
set noautochdir

" ==! Markmap CocCommand markmap.create


" ===
" === MarkdownPreview
" ===
let g:mkdp_auto_start = 0
let g:mkdp_auto_close = 1
let g:mkdp_refresh_slow = 0
let g:mkdp_command_for_global = 0
let g:mkdp_open_to_the_world = 0
let g:mkdp_open_ip = ''
let g:mkdp_echo_preview_url = 0
let g:mkdp_browserfunc = ''
let g:mkdp_preview_options = {
			\ 'mkit': {},
			\ 'katex': {},
			\ 'uml': {},
			\ 'maid': {},
			\ 'disable_sync_scroll': 0,
			\ 'sync_scroll_type': 'middle',
			\ 'hide_yaml_meta': 1
			\ }
let g:mkdp_markdown_css = ''
let g:mkdp_highlight_css = ''
let g:mkdp_port = ''
let g:mkdp_page_title = '「${name}」'

" ===
" === Vim Wiki
" ===
let g:vimwiki_list = [{'path': '~/Documents/Vimwiki/',
			\ 'syntax': 'markdown', 'ext': '.md'}]

" ===
" === Gen Tags
" ===
" gutentags 搜索工程目录的标志，碰到这些文件/目录名就停止向上一级目录递归
let g:gutentags_project_root = ['.root', '.svn', '.git', '.hg', '.project']

" 所生成的数据文件的名称
let g:gutentags_ctags_tagfile = '.tags'

" 将自动生成的 tags 文件全部放入 ~/.cache/tags 目录中，避免污染工程目录
let s:vim_tags = expand('~/.cache/tags')
let g:gutentags_cache_dir = s:vim_tags

" 配置 ctags 的参数
let g:gutentags_ctags_extra_args = ['--fields=+niazS', '--extra=+q']
let g:gutentags_ctags_extra_args += ['--c++-kinds=+px']
let g:gutentags_ctags_extra_args += ['--c-kinds=+px']


" ===
" === Python-syntax
" ===
let g:python_highlight_all = 1
" let g:python_slow_sync = 0

" ===
" === Python-Complition
" ===
"let g:jedi#goto_command = "<leader>d"
"let g:jedi#goto_assignments_command = "<leader>g"
"let g:jedi#goto_stubs_command = "<leader>s"
"let g:jedi#goto_definitions_command = ""
"let g:jedi#documentation_command = "<leader>D"
"let g:jedi#usages_command = "<leader>n"
"let g:jedi#completions_command = "<C-Space>"
"let g:jedi#rename_command = "<leader>r"

" ===
" === C/Cpp-Syntax
" ===
let g:cpp_class_scope_highlight = 1
let g:cpp_member_variable_highlight = 1
let g:cpp_class_decl_highlight = 1
let g:cpp_posix_standard = 1
let g:cpp_concepts_highlight = 1
" Simple Template
let g:cpp_experimental_simple_template_highlight = 1

" ===
" === Ctags/Cscope
" ===
set tag=./tags,./TAGS,tags;~,TAGS;~

"set cscopetag
"set csto=0

if filereadable("cscope.out")
   cs add cscope.out
elseif $CSCOPE_DB != ""
    cs add $CSCOPE_DB
endif
"set cscopeverbose

nmap zs :cs find s <C-R>=expand("<cword>")<CR><CR>
nmap zg :cs find g <C-R>=expand("<cword>")<CR><CR>
nmap zc :cs find c <C-R>=expand("<cword>")<CR><CR>
nmap zt :cs find t <C-R>=expand("<cword>")<CR><CR>
nmap ze :cs find e <C-R>=expand("<cword>")<CR><CR>
nmap zf :cs find f <C-R>=expand("<cfile>")<CR><CR>
nmap zi :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
nmap zd :cs find d <C-R>=expand("<cword>")<CR><CR>

" ===
" === vim-table-mode
" ===
noremap <LEADER>tm :TableModeToggle<CR>
"let g:table_mode_disable_mappings = 1
let g:table_mode_cell_text_object_i_map = 'k<Bar>'


" ===
" === FZF
" ===
set rtp+=/usr/local/opt/fzf
"set rtp+=/home/linuxbrew/.linuxbrew/opt/fzf
noremap <C-p> :FZF<CR>
noremap <C-f> :Ag<CR>
noremap <C-h> :MRU<CR>
noremap <C-t> :BTags<CR>
noremap <C-s> :LinesWithPreview<CR>
noremap <C-w> :Buffers<CR>
"noremap ; :History:<CR>

autocmd! FileType fzf
autocmd  FileType fzf set laststatus=0 noruler
  \| autocmd BufLeave <buffer> set laststatus=2 ruler

command! -bang -nargs=* Buffers
  \ call fzf#vim#buffers(
  \   '',
  \   <bang>0 ? fzf#vim#with_preview('up:60%')
  \           : fzf#vim#with_preview('right:0%', '?'),
  \   <bang>0)


command! -bang -nargs=* LinesWithPreview
    \ call fzf#vim#grep(
    \   'rg --with-filename --column --line-number --no-heading --color=always --smart-case . '.fnameescape(expand('%')), 1,
    \   fzf#vim#with_preview({}, 'up:50%', '?'),
    \   1)

command! -bang -nargs=* Ag
  \ call fzf#vim#ag(
  \   '',
  \   <bang>0 ? fzf#vim#with_preview('up:60%')
  \           : fzf#vim#with_preview('right:50%', '?'),
  \   <bang>0)


command! -bang -nargs=* MRU call fzf#vim#history(fzf#vim#with_preview())

command! -bang BTags
  \ call fzf#vim#buffer_tags('', {
  \     'down': '40%',
  \     'options': '--with-nth 1
  \                 --reverse
  \                 --prompt "> "
  \                 --preview-window="70%"
  \                 --preview "
  \                     tail -n +\$(echo {3} | tr -d \";\\\"\") {2} |
  \                     head -n 16"'
  \ })


"" ===
"" === fzf-preview.vim
"" ===
"noremap <C-w> :BuffersPreview<CR>
"let g:fzf_preview_default_key_bindings = 'ctrl-e:down,ctrl-u:up'
"let g:fzf_preview_layout = 'belowright split new'
"let g:fzf_preview_rate = 0.4
"let g:fzf_full_preview_toggle_key = '<C-f>'
"let g:fzf_preview_command = 'ccat --color=always {-1}'
"let g:fzf_binary_preview_command = 'echo "It is a binary file"'


" ===
" === CTRLP (Dependency for omnisharp)
" ===
let g:ctrlp_map = ''
let g:ctrlp_cmd = 'CtrlP'



" ===
" === vim-bookmarks
" ===
let g:bookmark_no_default_key_mappings = 1
nmap mt <Plug>BookmarkToggle
nmap ma <Plug>BookmarkAnnotate
nmap ml <Plug>BookmarkShowAll
nmap ml <Plug>BookmarkNext
nmap mj <Plug>BookmarkPrev
nmap mC <Plug>BookmarkClear
nmap mX <Plug>BookmarkClearAll
nmap mi <Plug>BookmarkMoveUp
nmap mk <Plug>BookmarkMoveDown
nmap <Leader>g <Plug>BookmarkMoveToLine
let g:bookmark_save_per_working_dir = 1
let g:bookmark_auto_save = 1
let g:bookmark_highlight_lines = 1
let g:bookmark_manage_per_buffer = 1
let g:bookmark_save_per_working_dir = 1
let g:bookmark_center = 1
let g:bookmark_auto_close = 1
let g:bookmark_location_list = 1


" ===
" === Undotree
" ===
noremap U :UndotreeToggle<CR>
let g:undotree_DiffAutoOpen = 1
let g:undotree_SetFocusWhenToggle = 1
let g:undotree_ShortIndicators = 1
let g:undotree_WindowLayout = 2
let g:undotree_DiffpanelHeight = 8
let g:undotree_SplitWidth = 24
function g:Undotree_CustomMap()
	nmap <buffer> k <plug>UndotreeNextState
	nmap <buffer> i <plug>UndotreePreviousState
	nmap <buffer> K 5<plug>UndotreeNextState
	nmap <buffer> I 5<plug>UndotreePreviousState
endfunc


" ==
" == vim-multiple-cursor
" ==
let g:multi_cursor_use_default_mapping = 0
let g:multi_cursor_start_word_key = '<c-k>'
let g:multi_cursor_select_all_word_key = '<a-k>'
let g:multi_cursor_start_key = 'g<c-k>'
let g:multi_cursor_select_all_key = 'g<a-k>'
let g:multi_cursor_next_key = '<c-k>'
let g:multi_cursor_prev_key = '<c-p>'
let g:multi_cursor_skip_key = '<C-s>'
let g:multi_cursor_quit_key = '<Esc>'


" ===
" === Far.vim
" ===
noremap <LEADER>f :F  %<left><left>


" ===
" === vim-calc
" ===
"noremap <LEADER>a :call Calc()<CR>
" Testing
"if !empty(glob('~/Github/vim-calc/vim-calc.vim'))
"source ~/Github/vim-calc/vim-calc.vim
"endif


" ===
" === Bullets.vim
" ===
"let g:bullets_set_mappings = 0
let g:bullets_enabled_file_types = [
			\ 'markdown',
			\ 'text',
			\ 'gitcommit',
			\ 'scratch'
			\]


" ===
" === Vista.vim
" ===
noremap <silent> T :Vista!!<CR>
let g:vista_icon_indent = ["╰─▸ ", "├─▸ "]
let g:vista_default_executive = 'ctags'
let g:vista_fzf_preview = ['right:50%']
let g:vista#renderer#enable_icon = 1
let g:vista#renderer#icons = {
\   "function": "\uf794",
\   "variable": "\uf71b",
\  }
function! NearestMethodOrFunction() abort
	return get(b:, 'vista_nearest_method_or_function', '')
endfunction
set statusline+=%{NearestMethodOrFunction()}
autocmd VimEnter * call vista#RunForNearestMethodOrFunction()


" ===
" === Ranger.vim
" ===
nnoremap R :Ranger<CR>
let g:ranger_map_keys = 0


" ===
" === fzf-gitignore
" ===
noremap <LEADER>gi :FzfGitignore<CR>


" ===
" === Ultisnips
" ===
let g:tex_flavor = "latex"
inoremap <c-n> <nop>
let g:UltiSnipsExpandTrigger="<c-k>g"
let g:UltiSnipsJumpForwardTrigger="<c-k>g"
let g:UltiSnipsJumpBackwardTrigger="<c-n>"
let g:UltiSnipsSnippetDirectories = [$HOME.'/AppData/Local/nvim/Ultisnips/', 'UltiSnips']
silent! au BufEnter,BufRead,BufNewFile * silent! unmap <c-r>


" ===
" === vimtex
" ===
"let g:vimtex_view_method = ''
let g:vimtex_view_general_viewer = 'llpp'
let g:vimtex_mappings_enabled = 0
let g:vimtex_text_obj_enabled = 0
let g:vimtex_motion_enabled = 0
let maplocalleader='\'


" ===
" === vim-calendar
" ===
"noremap \c :Calendar -position=here<CR>
noremap \\ :Calendar -view=clock -position=here<CR>
let g:calendar_google_calendar = 1
let g:calendar_google_task = 1
augroup calendar-mappings
	autocmd!
	" diamond cursor
	autocmd FileType calendar nmap <buffer> i <Plug>(calendar_up)
	autocmd FileType calendar nmap <buffer> j <Plug>(calendar_left)
	autocmd FileType calendar nmap <buffer> k <Plug>(calendar_down)
	autocmd FileType calendar nmap <buffer> l <Plug>(calendar_right)
	autocmd FileType calendar nmap <buffer> <c-l>g <Plug>(calendar_move_up)
	autocmd FileType calendar nmap <buffer> <c-j> <Plug>(calendar_move_left)
	autocmd FileType calendar nmap <buffer> <c-k> <Plug>(calendar_move_down)
	autocmd FileType calendar nmap <buffer> <c-l> <Plug>(calendar_move_right)
	autocmd FileType calendar nmap <buffer> h <Plug>(calendar_start_insert)
	autocmd FileType calendar nmap <buffer> H <Plug>(calendar_start_insert_head)
	" unmap <C-j>g, <C-p> for other plugins
	autocmd FileType calendar nunmap <buffer> <C-j>g
	autocmd FileType calendar nunmap <buffer> <C-p>
augroup END


" ===
" === Anzu
" ===
set statusline=%{anzu#search_status()}
nnoremap = n
nnoremap - N


" ===
" === vim-go
" ===
let g:go_def_mapping_enabled = 0
let g:go_template_autocreate = 0
let g:go_textobj_enabled = 0
let g:go_auto_type_info = 1
let g:go_def_mapping_enabled = 0
let g:go_highlight_array_whitespace_error = 1
let g:go_highlight_build_constraints = 1
let g:go_highlight_chan_whitespace_error = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_format_strings = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_function_parameters = 1
let g:go_highlight_functions = 1
let g:go_highlight_generate_tags = 1
let g:go_highlight_methods = 1
let g:go_highlight_operators = 1
let g:go_highlight_space_tab_error = 1
let g:go_highlight_string_spellcheck = 1
let g:go_highlight_structs = 1
let g:go_highlight_trailing_whitespace_error = 1
let g:go_highlight_types = 1
let g:go_highlight_variable_assignments = 0
let g:go_highlight_variable_declarations = 0


" ===
" === AutoFormat
" ===
nnoremap \f :Autoformat<CR>

" ===
" === vim-clang-format
" ===
let g:clang_format#auto_format=0
let g:clang_format#style_options = {
        \ "Language" : "Cpp",
        \ "BasedOnStyle" : "LLVM",
        \ "AccessModifierOffset" : -1,
        \ "AlignAfterOpenBracket" : "true",
        \ "AlignEscapedNewlinesLeft" : "true",
        \ "AlignOperands" : "true",
        \ "AlignTrailingComments" : "true",
        \ "AllowAllParametersOfDeclarationOnNextLine" : "true",
        \ "AllowShortBlocksOnASingleLine" : "false",
        \ "AllowShortCaseLabelsOnASingleLine" : "false",
        \ "AllowShortIfStatementsOnASingleLine" : "true",
        \ "AllowShortLoopsOnASingleLine" : "true",
        \ "AllowShortFunctionsOnASingleLine" : "All",
        \ "AlwaysBreakAfterDefinitionReturnType" : "false",
        \ "AlwaysBreakTemplateDeclarations" : "true",
        \ "AlwaysBreakBeforeMultilineStrings" : "true",
        \ "BreakBeforeBinaryOperators" : "None",
        \ "BreakBeforeTernaryOperators" : "true",
        \ "BreakConstructorInitializersBeforeComma" : "false",
        \ "BinPackParameters" : "true",
        \ "BinPackArguments" : "true",
        \ "ColumnLimit" : 80,
        \ "ConstructorInitializerAllOnOneLineOrOnePerLine" : "true",
        \ "ConstructorInitializerIndentWidth" : 4,
        \ "DerivePointerAlignment" : "true",
        \ "ExperimentalAutoDetectBinPacking" : "false",
        \ "IndentCaseLabels" : "true",
        \ "IndentWrappedFunctionNames" : "false",
        \ "IndentFunctionDeclarationAfterType" : "false",
        \ "MaxEmptyLinesToKeep" : 1,
        \ "KeepEmptyLinesAtTheStartOfBlocks" : "false",
        \ "NamespaceIndentation" : "None",
        \ "ObjCBlockIndentWidth" : 2,
        \ "ObjCSpaceAfterProperty" : "false",
        \ "ObjCSpaceBeforeProtocolList" : "false",
        \ "PenaltyBreakBeforeFirstCallParameter" : 1,
        \ "PenaltyBreakComment" : 300,
        \ "PenaltyBreakString" : 1000,
        \ "PenaltyBreakFirstLessLess" : 120,
        \ "PenaltyExcessCharacter" : 1000000,
        \ "PenaltyReturnTypeOnItsOwnLine" : 200,
        \ "PointerAlignment" : "Left",
        \ "SpacesBeforeTrailingComments" : 2,
        \ "Cpp11BracedListStyle" : "true",
        \ "Standard" : "Auto",
        \ "IndentWidth" : 2,
        \ "TabWidth" : 8,
        \ "UseTab" : "Never",
        \ "BreakBeforeBraces" : "Attach",
        \ "SpacesInParentheses" : "false",
        \ "SpacesInSquareBrackets" : "false",
        \ "SpacesInAngles" : "false",
        \ "SpaceInEmptyParentheses" : "false",
        \ "SpacesInCStyleCastParentheses" : "false",
        \ "SpaceAfterCStyleCast" : "false",
        \ "SpacesInContainerLiterals" : "true",
        \ "SpaceBeforeAssignmentOperators" : "true",
        \ "ContinuationIndentWidth" : 4 }


" map to <Leader>cf in C++ code
autocmd FileType h,c,cpp,objc nnoremap <buffer><Leader>,fc :<C-u>ClangFormat<CR>
autocmd FileType h,c,cpp,objc vnoremap <buffer><Leader>,fc :ClangFormat<CR>
" if you install vim-operator-user
autocmd FileType h,c,cpp,objc map <buffer><Leader>x <Plug>(operator-clang-format)<CR>
" Toggle auto formatting:
nmap <Leader>C :ClangFormatAutoToggle<CR>


" ===
" === OmniSharp
" ===
let g:OmniSharp_typeLookupInPreview = 1
let g:omnicomplete_fetch_full_documentation = 1

let g:OmniSharp_server_use_mono = 1
let g:OmniSharp_server_stdio = 1
let g:OmniSharp_highlight_types = 2
let g:OmniSharp_selector_ui = 'ctrlp'

autocmd Filetype cs nnoremap <buffer> gd :OmniSharpPreviewDefinition<CR>
autocmd Filetype cs nnoremap <buffer> gr :OmniSharpFindUsages<CR>
autocmd Filetype cs nnoremap <buffer> gy :OmniSharpTypeLookup<CR>
autocmd Filetype cs nnoremap <buffer> ga :OmniSharpGetCodeActions<CR>
autocmd Filetype cs nnoremap <buffer> <LEADER>rn :OmniSharpRename<CR><C-N>:res +5<CR>

sign define OmniSharpCodeActions text=💡

augroup OSCountCodeActions
	autocmd!
	autocmd FileType cs set signcolumn=yes
	autocmd CursorHold *.cs call OSCountCodeActions()
augroup END

function! OSCountCodeActions() abort
	if bufname('%') ==# '' || OmniSharp#FugitiveCheck() | return | endif
	if !OmniSharp#IsServerRunning() | return | endif
	let opts = {
				\ 'CallbackCount': function('s:CBReturnCount'),
				\ 'CallbackCleanup': {-> execute('sign unplace 99')}
				\}
	call OmniSharp#CountCodeActions(opts)
endfunction

function! s:CBReturnCount(count) abort
	if a:count
		let l = getpos('.')[1]
		let f = expand('%:p')
		execute ':sign place 99 line='.l.' name=OmniSharpCodeActions file='.f
	endif
endfunction


" ===
" === Colorizer
" ===
let g:colorizer_syntax = 1


" ===
" === vim-floaterm
" ===
"nnoremap ? :FloatermToggle<CR>
"let g:floaterm_position = 'center'
"let g:floaterm_winblend = 20
"let g:floaterm_height = winheight(0)/3*2
"let g:floaterm_width = &columns/3*2


" ===
" === vim-easymotion
" ===
let g:EasyMotion_do_mapping = 0
let g:EasyMotion_do_shade = 0
let g:EasyMotion_smartcase = 1
map ' <Plug>(easymotion-bd-f)
nmap ' <Plug>(easymotion-bd-f)
"map E <Plug>(easymotion-j)
"map U <Plug>(easymotion-k)
"nmap f <Plug>(easymotion-overwin-f)
"map \; <Plug>(easymotion-prefix)
"nmap ' <Plug>(easymotion-overwin-f2)
"map 'l <Plug>(easymotion-bd-jk)
"nmap 'l <Plug>(easymotion-overwin-line)
"map  'w <Plug>(easymotion-bd-w)
"nmap 'w <Plug>(easymotion-overwin-w)


" ===
" === goyo
" ===
map <LEADER>gy :Goyo<CR>


" ===
" === jsx
" ===
let g:vim_jsx_pretty_colorful_config = 1


" ===
" === FASTFOLD
" ===
nmap zuz <Plug>(FastFoldUpdate)
let g:fastfold_savehook = 1
let g:fastfold_fold_command_suffixes =  ['x','X','a','A','o','O','c','C']
let g:fastfold_fold_movement_commands = [']z', '[z', 'ze', 'zu']
let g:markdown_folding = 1
let g:tex_fold_enabled = 1
let g:vimsyn_folding = 'af'
let g:xml_syntax_folding = 1
let g:javaScript_fold = 1
let g:sh_fold_enabled= 7
let g:ruby_fold = 1
let g:perl_fold = 1
let g:perl_fold_blocks = 1
let g:r_syntax_folding = 1
let g:rust_fold = 1
let g:php_folding = 1


" ===
" === vim-easy-align
" ===
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)


" ===
" === vim-after-object
" ===
autocmd VimEnter * call after_object#enable('=', ':', '-', '#', ' ')


" ===
" === vim-map-leader
" ===
let g:leaderMenu = {'name':  "Shortcut Menu",
\'SPC f':  ['Advanced find'],
\'SPC rc': ['Edit nvim config'],
\'SPC Enter':  ['Clear search'],
\'SPC dw':  ['Remove adj. dup. words'],
\'SPC tt':  ['spc to tabs'],
\'SPC o':  ['Open folds'],
\'SPC q':  ['Close win below'],
\'SPC /':  ['Open terminal'],
\'SPC <SPC>':  ['Find <++>'],
\'SPC sc':  ['Toggle spell-check'],
\'SPC gf':  ['Fold unchanged'],
\'SPC g-':  ['Previous hunk'],
\'SPC g=':  ['Next Hunk'],
\'SPC rn':  ['Rename variable'],
\'SPC tm':  ['Toggle table-mode'],
\'SPC a':  ['Calculate equation'],
\'SPC gi':  ['New .gitignore'],
\'SPC gy':  ['Toggle focus mode'],
\}
nnoremap <silent> ? :call leaderMapper#start() "<Space>"<CR>
let g:leaderMapperWidth = 80


" ===
" === rainbow
" ===
let g:rainbow_active = 1


" ===
" === xtabline
" ===
let g:xtabline_settings = {}
let g:xtabline_settings.enable_mappings = 0
let g:xtabline_settings.tabline_modes = ['tabs', 'buffers']
let g:xtabline_settings.enable_persistance = 0
let g:xtabline_settings.last_open_first = 1
noremap to :XTabCycleMode<CR>
noremap \p :XTabInfo<CR>


" ===
" === vim session
" ===
let g:session_directory = $HOME."/AppData/Local/nvim/tmp/sessions"
let g:session_autosave = 'no'
let g:session_autoload = 'no'
"let g:session_autosave_periodic = 1
"let g:session_autosave_silent = 1
set sessionoptions-=buffers
set sessionoptions-=options
noremap so :OpenSession<CR>
noremap ss :SaveSession<CR>
noremap sc :CloseSession<CR>
noremap sD :DeleteSession<CR>
noremap sA :AppendTabSession<CR>


" ===
" === context.vim
" ===
let g:context_add_mappings = 0
noremap <leader>ct :ContextToggle<CR>


" ===
" === suda.vim
" ===
cnoreabbrev sudowrite w suda://%
cnoreabbrev sudoedit e suda://%


" ===
" === vimspector
" ===
let g:vimspector_enable_mappings = 'HUMAN'
function! s:read_template_into_buffer(template)
	" has to be a function to avoid the extra space fzf#run insers otherwise
	execute '0r ~/.config/nvim/sample_vimspector_json/'.a:template
endfunction
command! -bang -nargs=* LoadVimSpectorJsonTemplate call fzf#run({
			\   'source': 'ls -1 ~/.config/nvim/sample_vimspector_json',
			\   'down': 20,
			\   'sink': function('<sid>read_template_into_buffer')
			\ })
noremap <leader>vs :tabe .vimspector.json<CR>:LoadVimSpectorJsonTemplate<CR>




" ===
" === reply.vim
" ===
noremap <LEADER>rp :w<CR>:Repl<CR><C-\><C-N><C-w><C-h>
noremap <LEADER>rs :ReplSend<CR><C-w><C-l>a<CR><C-\><C-N><C-w><C-h>
noremap <LEADER>rt :ReplStop<CR>


" ===================== End of Plugin Settings =====================


" ===
" === Necessary Commands to Execute
" ===
exec "nohlsearch"


" Open the _machine_specific.vim file if it has just been created
if has_machine_specific_file == 0
	exec "e ~/.config/nvim/_machine_specific.vim"
endif


