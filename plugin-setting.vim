" color-schema
    colorscheme gruvbox-material
    " colorscheme nord

" indent_guides
    let g:indent_guides_guide_size = 1
    let g:indent_guides_enable_on_vim_startup = 1

" airline
    let g:airline_theme='bubblegum'
    " let g:airline_theme='nord'
    let g:airline_powerline_fonts = 1
    let g:airline#extensions#tabline#enabled = 1
    let g:airline#extensions#tabline#formatter = 'jsformatter' 

" simpylfold
    let g:SimpylFold_docstring_preview = 1

" fzf
    nnoremap <silent> <C-f> :GFiles<CR>
    nnoremap <silent> <C-b> :Buffers<CR>
    nnoremap <silent> <C-g> :Rg<CR>
    " [Buffers] Jump to the existing window if possible
    let g:fzf_buffers_jump = 1

    " files preview
    command! -bang -nargs=? -complete=dir GFiles
      \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)

    " Note: node_modules was ignored
    command! -bang -nargs=* Rg
        \ call fzf#vim#grep(
        \   'rg --column --line-number --no-heading --color=always --smart-case --glob "!node_modules" '.shellescape(<q-args>), 1,
        \   fzf#vim#with_preview(), <bang>0)

    let g:fzf_layout = { 'window': 'call CreateCenteredFloatingWindow()' }

" nerdtree
    " How can I open NERDTree automatically when vim starts up on opening a directory?
    " Note: Executing vim ~/some-directory will open NERDTree and a new edit window. exe 'cd '.argv()[0] sets the pwd of the new edit window to ~/some-directory
    autocmd StdinReadPre * let s:std_in=1
    autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | exe 'cd '.argv()[0] | endif

    " ignore directories
    let NERDTreeIgnore = ['node_modules']

    nnoremap <silent> <Leader>e :NERDTreeToggle<CR>
    nnoremap <silent> <F4> :NERDTreeFind<CR>

" nerdcommenter
    " Add spaces after comment delimiters by default
    let g:NERDSpaceDelims = 1

" Startify
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

" Vista
    nnoremap <Leader><F6> :Vista!!<CR>      

    " default executive
    let g:vista_default_executive="coc"
    let g:vista_executive_for = {
        \ 'sh': 'ctags',
        \ 'vim': 'ctags',
        \ }

    " fzf - preview
    let g:vista_fzf_preview = ['right:50%']

" vim-javascript
    let g:javascript_plugin_jsdoc = 1

" ale
    let g:ale_sign_error = '✗'
    let g:ale_sign_warning = '⚡'
    let g:airline#extensions#ale#enabled = 1

" Coc
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
    nmap <silent> gr <Plug>(coc-references)

    " Use Prettier to format file
    nnoremap <Leader>f :CocCommand prettier.formatFile<CR>

    " Use `[g` and `]g` to navigate diagnostics
    nmap <silent> [g <Plug>(coc-diagnostic-prev)
    nmap <silent> ]g <Plug>(coc-diagnostic-next)

" vim-test
    let test#strategy = "neovim"
    nnoremap <silent> <F5> :TestFile<CR>
    nnoremap <silent> <F6> :TestNearest<CR>

" vim-quickui
    " clear all the menus
    call quickui#menu#reset()
    
    call quickui#menu#install('&Tool', [
                \ [ "&NERDTreeFind\tF4", 'NERDTreeFind' ],
                \ [ "&Startify\tF2", 'Startify' ],
                \ [ "--", '' ],
                \ [ "TestFile\tF5", 'TestFile'],
                \ [ "&TestNearest\tF6", 'TestNearest' ],
                \ [ "--", '' ],
                \ [ "&PmR", 'call PmR()' ],
                \ [ "PmR-Reset", 'call PmRReset()' ],
                \ [ "--", '' ],
                \ [ "&VistaToogle\tF6", 'Vista!!' ],
                \ [ "VistaFinder", 'Vista finder' ],
                \ ])
    
    call quickui#menu#install('&Git', [
                \ [ 'status', 'Gstatus'],
                \ [ 'commit', 'Gcommit'],
                \ [ "--", '' ],
                \ [ 'blame', 'Gblame'],
                \ [ 'diffsplit', 'Gdiffsplit'],
                \ [ 'vdiffsplit', 'Gvdiffsplit'],
                \ [ "--", '' ],
                \ [ 'read(checkout)', 'Gread'],
                \ [ 'write(add)', 'Gwrite'],
                \ ])
    
    " script inside %{...} will be evaluated and expanded in the string
    call quickui#menu#install("&Option", [
    			\ ['Set Spell %{&spell? "Off":"On"}', 'set spell!'],
    			\ ['Enable mouse', 'set mouse=a'],
    			\ ['Disable mouse', 'set mouse='],
    			\ ['Set Paste %{&paste? "Off":"On"}', 'set paste!'],
    			\ ])
    
    " register HELP menu with weight 1000
    call quickui#menu#install('&Help', [
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
    noremap <Leader><Leader> :call quickui#menu#open()<cr>

    let g:quickui_border_style = 2
    let g:quickui_color_scheme = 'gruvbox'

" vim-gitgutter
    let g:gitgutter_preview_win_floating = 1
