" ==================== 基本设置 ====================
set nocompatible              " 禁用 Vi 兼容模式
filetype plugin indent on     " 启用文件类型检测
syntax on                     " 启用语法高亮
set encoding=utf-8            " 使用 UTF-8 编码
set fileencodings=utf-8,gbk   " 文件编码检测顺序

" ==================== 界面设置 ====================
set number                    " 显示行号
"set relativenumber            " 显示相对行号
set cursorline                " 高亮当前行
set cursorcolumn              " 高亮当前列
set showcmd                   " 显示命令
set showmode                  " 显示当前模式
set title                     " 显示文件名
set laststatus=2              " 总是显示状态栏
set signcolumn=yes            " 总是显示标记栏

" 配色方案
set background=dark           " 深色背景
colorscheme desert            " 配色方案，可以根据喜好更改
" 其他可选配色: solarized, molokai, gruvbox, nord

" ==================== 编辑设置 ====================
set autoindent                " 自动缩进
set smartindent               " 智能缩进
set expandtab                 " 将 Tab 转换为空格
set tabstop=4                 " Tab 宽度为 4 个空格
set shiftwidth=4              " 自动缩进宽度为 4 个空格
set softtabstop=4             " 退格键删除 4 个空格
set smarttab                  " 智能 Tab 处理

set backspace=indent,eol,start " 退格键可以删除所有内容
set whichwrap+=<,>,h,l        " 允许光标在行首行尾时移动到上一行/下一行

" ==================== 搜索设置 ====================
set incsearch                 " 实时搜索
set hlsearch                  " 高亮搜索结果
set ignorecase                " 搜索时忽略大小写
set smartcase                 " 如果有大写字母，则区分大小写

" ==================== 文件处理 ====================
set hidden                    " 允许缓冲区隐藏而不保存
set autoread                  " 文件在外部被修改时自动重新读取
set confirm                   " 未保存时确认退出
set nobackup                  " 不创建备份文件
set nowritebackup             " 不创建写入备份
set noswapfile                " 不创建交换文件

" ==================== 性能优化 ====================
set lazyredraw                " 延迟重绘，提高性能
set ttyfast                   " 快速终端连接
set timeoutlen=500            " 映射等待时间（ms）
set ttimeoutlen=0             " 键码等待时间

" ==================== 键位映射 ====================
let mapleader = ","           " 定义 Leader 键

" 快速保存和退出
nmap <leader>w :w!<cr>
nmap <leader>q :q<cr>
nmap <leader>wq :wq<cr>

" 快速切换缓冲区
nmap <leader>bn :bnext<cr>
nmap <leader>bp :bprevious<cr>
nmap <leader>bd :bd<cr>

" 窗口导航
nmap <C-h> <C-w>h
nmap <C-j> <C-w>j
nmap <C-k> <C-w>k
nmap <C-l> <C-w>l

" 调整窗口大小
nmap <C-up> <C-w>+
nmap <C-down> <C-w>-
nmap <C-left> <C-w><
nmap <C-right> <C-w>>

" 清除搜索高亮
nmap <silent> <leader>/ :nohlsearch<CR>

" 全选
nmap <C-a> ggVG

" 复制到系统剪贴板
vmap <leader>y "+y
nmap <leader>y "+y
nmap <leader>p "+p

" ==================== 插件管理 (Vim-Plug) ====================
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

" 主题配色
Plug 'morhetz/gruvbox'
Plug 'altercation/vim-colors-solarized'
Plug 'dracula/vim', { 'as': 'dracula' }

" 文件浏览
Plug 'preservim/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'

" 状态栏增强
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" 语法高亮增强
Plug 'sheerun/vim-polyglot'

" 代码补全
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" 文件搜索
Plug 'kien/ctrlp.vim'

" 代码注释
Plug 'tpope/vim-commentary'

" 自动配对括号
Plug 'jiangmiao/auto-pairs'

" Git 集成
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

" 缩进线
Plug 'Yggdroot/indentLine'

" 启动页面
Plug 'mhinz/vim-startify'

" Markdown 支持
Plug 'plasticboy/vim-markdown'

" 快速移动
Plug 'easymotion/vim-easymotion'

call plug#end()

" ==================== 插件配置 ====================

" NERDTree 配置
map <C-n> :NERDTreeToggle<CR>
let NERDTreeShowHidden=1
let NERDTreeAutoDeleteBuffer=1
let NERDTreeMinimalUI=1
let NERDTreeDirArrows=1
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" Airline 配置
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail'
let g:airline_powerline_fonts = 1
let g:airline_theme = 'gruvbox'

" CtrlP 配置
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/]\.(git|hg|svn|node_modules)$',
  \ 'file': '\v\.(exe|so|dll|pyc)$',
  \ }

" COC.nvim 配置
" 使用 Tab 进行补全
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" 使用回车确认补全
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" GitGutter 配置
let g:gitgutter_sign_added = '++'
let g:gitgutter_sign_modified = '~~'
let g:gitgutter_sign_removed = '--'
set updatetime=100

" EasyMotion 配置
map <Leader> <Plug>(easymotion-prefix)

" ==================== 文件类型特定设置 ====================

" Python 设置
autocmd FileType python setlocal
    \ tabstop=4
    \ softtabstop=4
    \ shiftwidth=4
    \ textwidth=79
    \ expandtab
    \ autoindent
    \ fileformat=unix

" JavaScript/TypeScript 设置
autocmd FileType javascript,typescript setlocal
    \ tabstop=2
    \ softtabstop=2
    \ shiftwidth=2
    \ expandtab

" HTML/CSS 设置
autocmd FileType html,css setlocal
    \ tabstop=2
    \ softtabstop=2
    \ shiftwidth=2
    \ expandtab

" Markdown 设置
autocmd FileType markdown setlocal
    \ wrap
    \ linebreak
    \ nolist
    \ textwidth=0
    \ wrapmargin=0

" ==================== 自定义函数 ====================

" 切换相对行号
function! ToggleRelativeNumber()
    if &relativenumber
        set norelativenumber
    else
        set relativenumber
    endif
endfunction
nmap <leader>rn :call ToggleRelativeNumber()<CR>

" 删除尾部空格
function! DeleteTrailingWhitespace()
    let l:save = winsaveview()
    %s/\s\+$//e
    call winrestview(l:save)
endfunction
nmap <leader>dtw :call DeleteTrailingWhitespace()<CR>

" ==================== 自动命令 ====================

" 保存时自动删除尾部空格
autocmd BufWritePre * :call DeleteTrailingWhitespace()

" 自动切换目录到当前文件所在目录
autocmd BufEnter * silent! lcd %:p:h

" 记住上次打开的位置
autocmd BufReadPost *
    \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
    \ |   exe "normal! g`\""
    \ | endif

" ==================== 其他实用设置 ====================

" 启用鼠标支持
set mouse=a

" 命令行历史记录
set history=1000

" 命令补全
set wildmenu
set wildmode=list:longest,full

" 滚动时保留上下文行数
set scrolloff=5
set sidescrolloff=5

" 折行设置
set wrap
set linebreak
set nolist

" 高亮超过 80 列的文字
highlight ColorColumn ctermbg=darkgray
set colorcolumn=80

" 启用剪贴板支持
if has('clipboard')
    set clipboard=unnamedplus
endif

" ==================== 自定义快捷键 ====================

" 快速编辑 vimrc
nmap <leader>vc :e $MYVIMRC<CR>
nmap <leader>vr :source $MYVIMRC<CR>

" 快速打开终端
nmap <leader>t :terminal<CR>

" 重新缩进整个文件
nmap <leader>= gg=G

" 分屏打开新文件
nmap <leader>vs :vsplit<CR>
nmap <leader>hs :split<CR>

" 快速跳转到定义
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" ==================== 最后的重置 ====================
" 确保颜色主题正确应用
if exists('+termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif
