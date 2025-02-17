call plug#begin(stdpath('data') . '/plugged_debug')

Plug 'vim-denops/denops.vim'
Plug 'Shougo/ddu.vim'
Plug 'Shougo/ddu-ui-filer'
Plug 'Shougo/ddu-column-filename'
Plug 'Shougo/ddu-source-file'
Plug 'Shougo/ddu-kind-file'
Plug 'Shougo/ddu-filter-matcher_hidden'
Plug 'Shougo/ddu-filter-matcher_substring'

call plug#end()

command! DduFilesBrowser
      \  call ddu#start(#{
      \    name: 'files-browser',
      \    resume: v:true
      \  })

command! DduFilesBrowserSearch
      \  call ddu#start(#{
      \    name: 'files-browser',
      \    resume: v:true,
      \    searchPath: expand('%:p')
      \  })

nnoremap tt <Cmd>DduFilesBrowser<CR>
nnoremap tf <Cmd>DduFilesBrowserSearch<CR>

call ddu#custom#action('kind', 'file', 'tabopen', { args -> execute('tabnew ' . args.items[0].action.path) })
call ddu#custom#action('kind', 'file', 'vsplit', { args -> execute('vsplit ' . args.items[0].action.path) })
call ddu#custom#action('kind', 'file', 'split', { args -> execute('split ' . args.items[0].action.path) })

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
      \       matchers: ['matcher_substring', 'matcher_hidden'],
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
      \     rename: #{
      \       quit: v:false,
      \     },
      \     newFile: #{
      \       quit: v:false,
      \     },
      \     newDirectory: #{
      \       quit: v:false,
      \     },
      \     open: #{
      \       quit: v:false,
      \     },
      \     tabopen: #{
      \       quit: v:false,
      \     },
      \     split: #{
      \       quit: v:false,
      \     },
      \     vsplit: #{
      \       quit: v:false,
      \     },
      \     paste: #{
      \       quit: v:false,
      \     },
      \     narrow: #{
      \       quit: v:false,
      \     },
      \   },
      \ })

autocmd FileType ddu-filer call s:ddu_my_settings()
function! s:ddu_my_settings() abort
  nnoremap <buffer><silent> <CR>
        \ <Cmd>call ddu#ui#do_action('itemAction')<CR>
  nnoremap <buffer><silent> dd
        \ <Cmd>call ddu#ui#do_action('itemAction',
        \ #{name: 'delete'})<CR>
  nnoremap <buffer> D
        \ <Cmd>call ddu#ui#do_action('itemAction',
        \ #{ name: 'trash' })<CR>
  nnoremap <buffer> o
        \ <Cmd>call ddu#ui#do_action('expandItem',
        \ #{ mode: 'toggle', isGrouped: v:true, isInTree: v:false })<CR>
  nnoremap <buffer> O
        \ <Cmd>call ddu#ui#do_action('expandItem',
        \ #{ maxLevel: -1 })<CR>
  nnoremap <buffer><silent> q
        \ <Cmd>call ddu#ui#do_action('quit')<CR>
  nnoremap <buffer><silent> <C-t>
        \ <Cmd>call ddu#ui#do_action('itemAction', #{
        \   name: 'tabopen',
        \   params: #{ command: 'tabedit' },
        \ })<CR>
  nnoremap <buffer><silent> <C-v>
        \ <Cmd>call ddu#ui#do_action('itemAction',
        \ #{name: 'vsplit'})<CR>
  nnoremap <buffer><silent> <C-s>
        \ <Cmd>call ddu#ui#do_action('itemAction',
        \ #{name: 'split'})<CR>
  nnoremap <buffer><silent> K
        \ <Cmd>call ddu#ui#do_action('itemAction',
        \ #{ name: 'newDirectory' })<CR>
  nnoremap <buffer><silent> %
        \ <Cmd>call ddu#ui#do_action('itemAction',
        \ #{ name: 'newFile' })<CR>
  nnoremap <buffer><silent> c
        \ <Cmd>call ddu#ui#do_action('itemAction',
        \ #{ name: 'copy' })<CR>
  nnoremap <buffer><silent> x
        \ <Cmd>call ddu#ui#do_action('itemAction',
        \ #{ name: 'move' })<CR>
  nnoremap <buffer> p
        \ <Cmd>call ddu#ui#do_action('itemAction',
        \ #{ name: 'paste' })<CR>
  nnoremap <buffer> u
        \ <Cmd>call ddu#ui#do_action('itemAction',
        \ #{ name: 'undo' })<CR>
  nnoremap <buffer> m
        \ <Cmd>call ddu#ui#do_action('itemAction',
        \ #{ name: 'move' })<CR>
  nnoremap <buffer> r
        \ <Cmd>call ddu#ui#do_action('itemAction',
        \ #{ name: 'rename' })<CR>
  nnoremap <buffer> h
        \ <Cmd>call ddu#ui#do_action('itemAction',
        \ #{ name: 'narrow', params: #{ path: '..' } })<CR>
  nnoremap <buffer><expr> l
        \ ddu#ui#get_item()->get('isTree', v:false) ?
        \ "<Cmd>call ddu#ui#do_action('itemAction', #{ name: 'narrow' })<CR>" :
        \ "<Cmd>call ddu#ui#do_action('itemAction', #{ name: 'open' })<CR>"
  nnoremap <buffer><silent> <C-r>
        \ <Cmd>call ddu#ui#do_action('redraw')<CR>
  nnoremap <buffer> .
        \ <Cmd>call ddu#ui#multi_actions([
        \   [
        \      'updateOptions', #{
        \        sourceOptions: #{
        \          file: #{
        \            matchers: ToggleHidden('file'),
        \          },
        \        },
        \      }
        \   ],
        \   [
        \      'redraw', #{ method: 'refreshItems' },
        \   ],
        \ ])<CR>
endfunction

function! ToggleHidden(name)
  return ddu#custom#get_current(b:ddu_ui_name)
        \ ->get('sourceOptions', {})
        \ ->get(a:name, {})
        \ ->get('matchers', [])
        \ ->empty() ? ['matcher_hidden'] : []
endfunction
