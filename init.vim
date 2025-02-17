call plug#begin(stdpath('data') . '/plugged_debug')

Plug 'vim-denops/denops.vim'
Plug 'Shougo/ddu.vim'
Plug 'Shougo/ddu-ui-filer'
Plug 'Shougo/ddu-column-filename'
Plug 'Shougo/ddu-source-file'
Plug 'Shougo/ddu-kind-file'

call plug#end()

command! DduFilesBrowser
      \  call ddu#start(#{
      \    name: 'files-browser',
      \    resume: v:true
      \  })

nnoremap tt <Cmd>DduFilesBrowser<CR>

call ddu#custom#patch_local('files-browser', #{
      \   ui: 'filer',
      \   uiParams: #{
      \     filer: #{
      \       split: 'vertical',
      \       splitDirection: 'topleft',
      \       winWidth: 30,
      \       sort: 'filename',
      \       sortTreesFirst: v:true
      \     }
      \   },
      \   uiOptions: #{
      \     filer: #{
      \       toggle: v:true
      \     }
      \   },
      \   sources: [#{name: 'file', params: {}}],
      \   sourceOptions: #{
      \     _: #{
      \       columns: ['filename'],
      \     },
      \   },
      \   columnParams: #{
      \     filename: #{
      \       indentationWidth: 2,
      \     },
      \   },
      \   kindOptions: #{
      \     file: #{
      \       defaultAction: 'open',
      \     },
      \   },
      \   actionOptions: #{
      \     open: #{
      \       quit: v:false,
      \     },
      \   },
      \ })

autocmd FileType ddu-filer call s:ddu_my_settings()
function! s:ddu_my_settings() abort
  nnoremap <buffer><silent> <CR>
        \ <Cmd>call ddu#ui#do_action('itemAction')<CR>
  nnoremap <buffer><expr> l
        \ ddu#ui#get_item()->get('isTree', v:false) ?
        \ "<Cmd>call ddu#ui#do_action('itemAction', #{ name: 'narrow' })<CR>" :
        \ "<Cmd>call ddu#ui#do_action('itemAction', #{ name: 'open' })<CR>"
  nnoremap <buffer> h
        \ <Cmd>call ddu#ui#do_action('itemAction',
        \ #{ name: 'narrow', params: #{ path: '..' } })<CR>
  nnoremap <buffer> o
        \ <Cmd>call ddu#ui#do_action('expandItem',
        \ #{ mode: 'toggle', isGrouped: v:true, isInTree: v:false })<CR>
endfunction
