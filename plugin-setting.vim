" indent_guides {{{ "
    let g:indent_guides_guide_size = 1
    let g:indent_guides_enable_on_vim_startup = 1
" }}} indent_guides "

" airline {{{ "
    let g:airline_powerline_fonts = 1
    let g:airline#extensions#tabline#enabled = 1
    let g:airline#extensions#tabline#formatter = 'jsformatter' 
" }}} airline "

" simpylfold {{{ "
    let g:SimpylFold_docstring_preview = 1
" }}} simpylfold "

" fzf {{{ "
    nnoremap <silent> <M-f> :FZF<CR>
    nnoremap <silent> <C-f> :GFiles<CR>
    nnoremap <silent> <C-b> :Buffers<CR>
    nnoremap <silent> <C-g> :Rg<CR>
    " [Buffers] Jump to the existing window if possible
    let g:fzf_buffers_jump = 1

    " files preview
    command! -bang -nargs=? -complete=dir GFiles
      \ call fzf#vim#gitfiles(<q-args>, fzf#vim#with_preview(), <bang>0)

    " Note: node_modules was ignored
    command! -bang -nargs=* Rg
        \ call fzf#vim#grep(
        \   'rg --column --line-number --no-heading --color=always --smart-case --glob "!node_modules" '.shellescape(<q-args>), 1,
        \   fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}), <bang>0)

    let g:fzf_layout = { 'window': 'call CreateCenteredFloatingWindow()' }
" }}} fzf "

" nerdtree {{{ "
    " How can I open NERDTree automatically when vim starts up on opening a directory?
    " Note: Executing vim ~/some-directory will open NERDTree and a new edit window. exe 'cd '.argv()[0] sets the pwd of the new edit window to ~/some-directory
    autocmd StdinReadPre * let s:std_in=1
    autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | exe 'cd '.argv()[0] | endif

    " ignore directories
    let NERDTreeIgnore = ['node_modules']

    nnoremap <silent> <Leader>e :NERDTreeToggle<CR>
    nnoremap <silent> <F4> :NERDTreeFind<CR>
" }}} nerdtree "

" nerdcommenter {{{ "
    " Add spaces after comment delimiters by default
    let g:NERDSpaceDelims = 1
" }}} nerdcommenter "

" startify {{{ "
    nnoremap <silent> <F2> :Startify<CR>

    " When opening a file or bookmark, don't change to its directory
    let g:startify_change_to_dir = 0

    " How do I get both NERDTree and Startify working at startup?~
    autocmd VimEnter *
            \   if !argc()
            \ |   Startify
            \ |   NERDTree
            \ |   wincmd w
            \ | endif

    " change order
    let g:startify_lists = [
          \ { 'type': 'dir',       'header': ['   MRU '. getcwd()] },
          \ { 'type': 'files',     'header': ['   MRU']            },
          \ { 'type': 'sessions',  'header': ['   Sessions']       },
          \ { 'type': 'bookmarks', 'header': ['   Bookmarks']      },
          \ { 'type': 'commands',  'header': ['   Commands']       },
          \ ]

" }}} startify "

" vista {{{ "
    " default executive
    let g:vista_default_executive="coc"
    let g:vista_executive_for = {
        \ 'sh': 'ctags',
        \ 'vim': 'ctags',
        \ 'markdown': 'ctags',
        \ }
    let g:airline#extensions#vista#enabled = 0

    " fzf - preview
    let g:vista_fzf_preview = ['right:50%']

    let g:vista#renderer#icons = {
    \   "keyword": "\uf1de",
    \   "variable": "\ue79b",
    \   "value": "\uf89f",
    \   "operator": "\u03a8",
    \   "function": "\u0192",
    \   "reference": "\ufa46",
    \   "constant": "\uf8fe",
    \   "method": "\uf09a",
    \   "struct": "\ufb44",
    \   "class": "\uf0e8",
    \   "interface": "\uf417",
    \   "text": "\ue612",
    \   "enum": "\uf435",
    \   "enumMember": "\uf02b",
    \   "module": "\uf40d",
    \   "color": "\ue22b",
    \   "property": "\ue624",
    \   "field": "\uf9be",
    \   "unit": "\uf475",
    \   "event": "\ufacd",
    \   "file": "\uf723",
    \   "folder": "\uf114",
    \   "snippet": "\ue60b",
    \   "typeParameter": "\uf728",
    \   "default": "\uf29c"
    \  }
" }}} vista "

" vim-javascript {{{ "
    let g:javascript_plugin_jsdoc = 1
" }}} vim-javascript "

" ale {{{ "
    let g:ale_sign_error = '✗'
    let g:ale_sign_warning = '⚡'
    let g:airline#extensions#ale#enabled = 1
" }}} ale "

" coc.nvim {{{ "
    let g:coc_global_extensions = [
        \ 'coc-yank',
        \ 'coc-word',
        \ 'coc-spell-checker',
        \ 'coc-snippets',
        \ 'coc-prettier',
        \ 'coc-tsserver',
        \ 'coc-json',
        \ 'coc-ci',
        \ 'coc-clangd',
        \ ]

    " make snippet completion work just like VSCode
    inoremap <silent><expr> <TAB>
        \ pumvisible() ? coc#_select_confirm() :
        \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
        \ <SID>check_back_space() ? "\<TAB>" :
        \ coc#refresh()
    
    function! s:check_back_space() abort
        let col = col('.') - 1
        return !col || getline('.')[col - 1]  =~# '\s'
    endfunction

    let g:coc_snippet_next = '<Tab>'
    let g:coc_snippet_prev = '<S-Tab>'

    " Use K to show documentation in preview window
    nnoremap <silent> K :call <SID>show_documentation()<CR>

    function! s:show_documentation()
        if (index(['vim','help'], &filetype) >= 0)
            execute 'h '.expand('<cword>')
        else
            call CocAction('doHover')
        endif
    endfunction

    nmap <leader>rn <Plug>(coc-rename)

    nmap <silent> gd <Plug>(coc-definition)
    nmap <silent> gy <Plug>(coc-type-definition)
    nmap <silent> <leader>gi <Plug>(coc-implementation)
    nmap <silent> gr <Plug>(coc-references)

    nnoremap <silent> <Leader>f :call CocAction('format')<CR>

    " Highlight the symbol and its references when holding the cursor.
    autocmd CursorHold * silent call CocActionAsync('highlight')

    " Use `[g` and `]g` to navigate diagnostics
    nmap <silent> [g <Plug>(coc-diagnostic-prev)
    nmap <silent> ]g <Plug>(coc-diagnostic-next)

    " coc-ci
    nmap <silent> w <Plug>(coc-ci-w)
    nmap <silent> b <Plug>(coc-ci-b)

    augroup mygroup
        autocmd!
        " Setup formatexpr specified filetype(s).
        autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
        " Update signature help on jump placeholder.
        autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
    augroup end
" }}} coc.nvim "

" vim-test {{{ "
    let test#strategy = "neovim"
    nnoremap <silent> <F5> :TestFile<CR>
    nnoremap <silent> <F6> :TestNearest<CR>
" }}} vim-test "

" vim-quickui {{{ "
    " clear all the menus
    call quickui#menu#reset()
    
    call quickui#menu#install('&Tool', [
                \ [ "Startify\tF2", 'Startify' ],
                \ [ "&NERDTreeFind\tF4", 'NERDTreeFind' ],
                \ [ "--", '' ],
                \ [ "CloseSpecific&Buffer", 'call CloseSpecificBuffer()' ],
                \ [ "--", '' ],
                \ [ "TestFile\tF5", 'TestFile'],
                \ [ "&TestNearest\tF6", 'TestNearest' ],
                \ [ "--", '' ],
                \ [ "&PmR", 'CocList pmr' ],
                \ [ "PmR-Reset", 'CocCommand qtk.pmr.reset' ],
                \ [ "--", '' ],
                \ [ "&CpR", 'CocCommand qtk.cpr.exec' ],
                \ [ "CpR-Reset", 'CocCommand qtk.cpr.reset' ],
                \ [ "--", '' ],
                \ [ "&VistaToogle", 'Vista!!' ],
                \ [ "VistaFinder", 'Vista finder' ],
                \ [ "--", '' ],
                \ [ "&MarkdownPreview", 'MarkdownPreview' ],
                \ [ "MarkdownPreviewStop", 'MarkdownPreviewStop' ],
                \ [ "--", '' ],
                \ [ "&Switching", "CocCommand qtk.switching" ],
                \ [ "--", '' ],
                \ [ "&OR", "call CocAction('runCommand', 'editor.action.organizeImport')" ],
                \ ])
    
    call quickui#menu#install('&Git', [
                \ [ '&diffsplit', 'Gdiffsplit'],
                \ [ '&vdiffsplit', 'Gvdiffsplit'],
                \ [ '&blame', 'Gblame'],
                \ [ 'lo&g', '0Glog'],
                \ [ "--", '' ],
                \ [ '&status', 'aboveleft Gstatus'],
                \ [ '&commit', 'Gcommit'],
                \ [ "--", '' ],
                \ [ '&read(checkout)', 'Gread'],
                \ [ '&write(add)', 'Gwrite'],
                \ ])
    
    " script inside %{...} will be evaluated and expanded in the string
    call quickui#menu#install("Option", [
    			\ ['Set Spell %{&spell? "Off":"On"}', 'set spell!'],
    			\ ['Enable mouse', 'set mouse=a'],
    			\ ['Disable mouse', 'set mouse='],
    			\ ['Set Paste %{&paste? "Off":"On"}', 'set paste!'],
    			\ ])
    
    " register HELP menu with weight 1000
    call quickui#menu#install('Help', [
    			\ ["&Cheatsheet", 'help index', ''],
    			\ ['T&ips', 'help tips', ''],
    			\ ['--',''],
    			\ ["&Tutorial", 'help tutor', ''],
    			\ ['&Quick Reference', 'help quickref', ''],
    			\ ['&Summary', 'help summary', ''],
    			\ ], 10000)
    
    " enable to display tips in the cmdline
    let g:quickui_show_tip = 1
    
    " hit space twice to open menu
    noremap <silent> <Leader><Leader> :call quickui#menu#open()<cr>

    let g:quickui_border_style = 2
    let g:quickui_color_scheme = 'gruvbox'
" }}} vim-quickui "

" vim-gitgutter {{{ "
    let g:gitgutter_preview_win_floating = 1
    let g:airline#extensions#hunks#enabled = 0
" }}} vim-gitgutter "

" markdown-preview.nvim {{{ "
    let g:mkdp_auto_close = 0
" }}} markdown-preview.nvim "

" vim-floaterm {{{ "
    let g:floaterm_type = 'floating'
    let g:floaterm_position = 'bottomright'
    let g:floaterm_width = 0.99
    let g:floaterm_height = 0.5

    " This plugin leaves an empty buffer on startify window
    autocmd User Startified setlocal buflisted

    nnoremap <silent> <M-j> :FloatermToggle<CR>
    tnoremap <silent> <M-j> <C-\><C-N>:FloatermToggle<CR>
    inoremap <silent> <M-j> <Esc>:FloatermToggle<CR>
" }}} vim-floaterm "

" cycle.vim {{{ "
    let g:cycle_no_mappings = 1
    noremap <silent> <Plug>CycleFallbackNext <C-A>
    noremap <silent> <Plug>CycleFallbackPrev <C-X>
    nmap <silent> <C-a> <Plug>CycleNext
    nmap <silent> <C-x> <Plug>CyclePrev


    let g:cycle_default_groups = [
        \   [[',', '，']],
        \   [['.', '。']],
        \   [['?', '？']],
        \   [[';', '；']],
        \   [[':', '：']],
        \   [['(:)','（:）'], 'sub_pairs'],
        \   [['是', '否']],
        \   [['+', '-']],
        \   [['++', '--']],
        \   [['>', '<']],
        \   [['||', '&&']],
        \   [['===', '!==']],
        \   [['==', '!=']],
        \   [['true', 'false']],
        \   [['yes', 'no']],
        \   [['on', 'off']],
        \   [['and', 'or']],
        \   [["in", "out"]],
        \   [["increase", "decrease"]],
        \   [["up", "down"]],
        \   [["min", "max"]],
        \   [["get", "set"]],
        \   [["add", "remove"]],
        \   [["to", "from"]],
        \   [["read", "write"]],
        \   [["only", "except"]],
        \   [['without', 'with']],
        \   [["exclude", "include"]],
        \   [["asc", "desc"]],
        \   [["begin", "end"]],
        \   [["first", "last"]],
        \   [["slow", "fast"]],
        \   [["small", "large"]],
        \   [["push", "pull"]],
        \   [["before", "after"]],
        \   [["new", "delete"]],
        \   [["while", "until"]],
        \   [["left", "right"]],
        \   [["top", "bottom"]],
        \   [["one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "ten"]],
        \   [
        \       ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'],
        \       'hard_case', {'name': 'Days'}
        \   ],
        \   [
        \       ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'],
        \       'hard_case', {'name': 'Months'}
        \   ],
        \ ]
" }}} cycle.vim "

" editorconfig-vim {{{ "
    let g:EditorConfig_exclude_patterns = ['fugitive://.*']
" }}} editorconfig-vim "

" fugitive.vim {{{ "
    let g:airline#extensions#branch#enabled = 0
    let g:fugitive_pty = 0
" }}} fugitive.vim "
