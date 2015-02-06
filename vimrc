let use_0x = 1
" Bundle {
" set nocompatible               " be iMproved
" filetype off                   " required!
" 
" set rtp+=~/.vim/bundle/vundle/
" call vundle#rc()
" 
" " let Vundle manage Vundle
" " required! 
" Bundle 'gmarik/vundle'
" Bundle 'Valloric/YouCompleteMe'
" 
" filetype plugin indent on     " required!
" "
" " Brief help
" " :BundleList          - list configured bundles
" " :BundleInstall(!)    - install(update) bundles
" " :BundleSearch(!) foo - search(or refresh cache first) for foo
" " :BundleClean(!)      - confirm(or auto-approve) removal of unused bundles
" "
" " see :h vundle for more details or wiki for FAQ
" " NOTE: comments after Bundle command are not allowed..
" filetype on
" }

" General options {
set nocompatible
set autoindent
set smartindent
set expandtab
set shiftwidth=4
set tabstop=4
set softtabstop=4
set number
set showcmd
set whichwrap+=h,l
set matchpairs+=<:>
set mouse=a
set complete-=i
set hlsearch
set ruler
set wildmenu
set splitright
set splitbelow
syntax on
set backspace=indent,eol,start
" }

" Autocomlpletion {
autocmd BufWritePost * exec system("make_abbr < " . bufname("%"))
autocmd FileReadPost * exec system("make_abbr < " . bufname("%"))
" }

" YouCompleteMe {
let g:ycm_seed_identifiers_with_syntax = 1
set completeopt-=preview
let g:ycm_key_list_select_completion = ['<TAB>', '<Down>', '<Enter>']
let g:ycm_confirm_extra_conf = 0
" }

" Bad formatting highlight {
" highlight LONG_LINES ctermbg=Red
" autocmd Syntax cpp syntax match LONG_LINES /.\{81\}/ containedin=ALL

let g:c_space_errors = 1
" }


" General mappings {
imap jj <Esc>
map s :s/
map <C-J> 5j
map <C-K> 5k
" }

" Compilation functions {
func! CompileC()
    :!gcc -std=c99 -Wall -Wextra -O2 -o %< % -lpthread -lrt
endf
func! CompileCPP()
    let CXX_FLAGS = "-DHOME -Wno-unused-result -Wall -Wextra -O2 -Wno-char-subscripts "

    if g:use_0x == "1"
        let CXX_FLAGS .= " -std=c++0x"
    endif
    exec "!g++ " . CXX_FLAGS . " -o %< %"
"     exec "!mpic++ " . CXX_FLAGS . " -o %< % -lrt"
endf
func! CompileJava()
    exec "!javac %"
endf
func! CompileTeX()
    :!pdflatex %
endf
func! CompileFlex()
    :!flex % && g++ -std=c++0x -Wall -O2 lex.yy.c -o %<
endf

func! Compile()
    :write
    if &filetype == "cpp"
        call CompileCPP()
    elseif &filetype == "c"
        call CompileC()
    elseif &filetype == "java"
        call CompileJava()
    elseif &filetype == "tex"
        call CompileTeX()
    elseif &filetype == "lex"
        call CompileFlex()
    else
        echo "Not appropriate file type"
    endif
endf
" }

" Running functions {
func! RunTeX()
    :!evince %<.pdf
endf
" TODO: replace these functions with one: RunCommand(cmd_name)
func! RunPerl()
    :!perl %
endf
func! RunPython()
    :!python %
endf
func! RunBash()
    :!bash %
endf
func! RunLua()
    :!lua %
endf
func! RunRuby()
    :!ruby %
endf
func! RunJava()
    :!java %<
endf
func! RunThis()
    :write
    :!./%
endf

func! Run()
    :write
    if &filetype == "python"
        call RunPython()
    elseif &filetype == "perl"
        call RunPerl()
    elseif &filetype == "tex"
        call RunTeX()
    elseif &filetype == "sh" || &filetype == "bash"
        call RunBash()
    elseif &filetype == "lua"
        call RunLua()
    elseif &filetype == "ruby"
        call RunRuby()
    elseif &filetype == "java"
        call RunJava()
    elseif &filetype == "text"
        write
        wincmd w
        call Run()
        wincmd w
    else
"         :!mpirun -np 2 %<
        :!./%<
    endif
endf
func! RunWithArgs()
    " For basic Run() only!
    :!xargs -L 1 ./%<
endf
" }

" Run/compile mappings {
map <F9> :call Compile()<Enter>
imap <F9> <Esc>:call Compile()<Enter>
map <F5> :call Run()<Enter>
imap <F5> <Esc>:call Run()<Enter>
map <F6> :call RunWithArgs()<Enter>
imap <F6> :call RunWithArgs()<Enter>
map <F3> :call RunThis()<Enter>
imap <F3> <Esc> :call RunThis()<Enter>

" }

" Makefile support on <F8> & <F7> {
map <F10> :w<Enter>:!make<CR>
imap <F10> <Esc> :w<Enter>:!make<CR>
map <F7> :!./main<CR>
imap <F7> <Esc> :!./main<CR>
" }

" Comments {
func! GetCommentString()
    let str = "#"
    if &filetype == "cpp" || &filetype == "c" || &filetype == "html" || &filetype == "java"
        let str = "//"
    elseif &filetype == "vim"
        let str = "\""
    elseif &filetype == "tex"
        let str = "%"
    endif
    return str . " "
endf
func! AddComment()
    let str = GetCommentString()
    call setline(".", str . getline("."))
    let move_cnt = len(str)
    while move_cnt > 0
        normal l
        let move_cnt -= 1
    endwhile
endf
func! RemoveComment()
    " ISSUE: works bad on multiline comments and when line is a comment only
    " with no leading whitespace
    let str = GetCommentString()
    let old = getline(".")
    let new = substitute(old, "^" . str, "", "")
    if old == new
        let str = str[:-2]
        let new = substitute(old, "^" . str, "", "")
    endif
    let move_cnt = len(old) - len(new)
    while move_cnt > 0
"         normal h
        let move_cnt -= 1
    endwhile
    call setline(".", new)
endf
map gc :call AddComment()<Enter>
map gu :call RemoveComment()<Enter>
" }

" Folding {
map gz V/{<Enter>%zf:let @/=""<Enter>
" }}

" TODO: FoldFunction() function (2 paren types) // DONE
" TODO (think): /* */ C++ comment for multi-line commenting
" TODO (later): how to work with tabs and use <F4> to switch a.h[pp]/a.cpp

" C // comments
" map gc :s:^\([ <Tab>]*\):\1//:<Enter>`'ll
" map gu :s:^\([ <Tab>]*\)//:\1:e<Enter>`'hh
" map gc m':s:^\([ <Tab>]*\):\1//:<Enter>`'ll
" set timeoutlen=300
set timeoutlen=300


" put English active vocabulary files in a proper form {
func! ParseAV()
    :%s/^\(E.g.\|syn\).*\n//ge
    :%s/ - .*$//ge
    :%s:/.*/$::ge
    :%s/^[1-9][0-9]*. //ge
endf
" }

" Git {
map gA :!git add %<Enter>
map gB :!tig blame %<Enter>
map gC :!git commit<Enter>
map gD :!git df %<Enter>
map gS :!git s<Enter>
" }

func! Switch(insert)
    echo a:insert
    echo "h: highlight"
    echo "p: paste"
    echo "c: copy (numbers & mouse)"
    echo ""
    let c = nr2char(getchar())
    if c == 'h'
        set hlsearch!
    elseif c == 'p'
        set paste!
    elseif c == 'c'
        if &mouse == 'a'
            set mouse=
        else
            set mouse=a
        endif
        set number!
    else
        echo "fail"
    endif
    if a:insert == 1
        normal l
        startinsert
    endif
endf

map <F8> :call Switch(0)<Enter>
imap <F8> <Esc>:call Switch(1)<Enter>

map L $
map H ^

iab uns using namespace std

set list
set listchars=tab:>-
