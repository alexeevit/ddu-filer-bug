let s:config_dir = expand('<sfile>:p:h')
execute 'set rtp+=' . s:config_dir . '/plugins/denops.vim'
execute 'set rtp+=' . s:config_dir . '/plugins/ddu.vim'
execute 'set rtp+=' . s:config_dir . '/plugins/ddu-ui-filer'
execute 'set rtp+=' . s:config_dir . '/plugins/ddu-source-file'
execute 'set rtp+=' . s:config_dir . '/plugins/ddu-kind-file'
execute 'set rtp+=' . s:config_dir . '/plugins/ddu-column-filename'

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
      \       winWidth: 40,
      \       sort: 'filename',
      \       sortTreesFirst: v:true
      \     }
      \   },
      \   sources: [#{name: 'file', params: {}}],
      \   sourceOptions: #{
      \     _: #{ columns: ['filename'], },
      \   },
      \   kindOptions: #{
      \     file: #{ defaultAction: 'open' },
      \   },
      \ })

autocmd FileType ddu-filer call s:ddu_my_settings()
function! s:ddu_my_settings() abort
  nnoremap <buffer><silent> <CR>
        \ <Cmd>call ddu#ui#do_action('itemAction')<CR>
  nnoremap <buffer><silent> dd
        \ <Cmd>call ddu#ui#do_action('itemAction', #{ name: 'delete' })<CR>
  nnoremap <buffer> o
        \ <Cmd>call ddu#ui#do_action('expandItem', #{ mode: 'toggle', isGrouped: v:true, isInTree: v:false })<CR>
  nnoremap <buffer><silent> K
        \ <Cmd>call ddu#ui#do_action('itemAction', #{ name: 'newDirectory' })<CR>
  nnoremap <buffer><silent> %
        \ <Cmd>call ddu#ui#do_action('itemAction', #{ name: 'newFile' })<CR>
  nnoremap <buffer> r
        \ <Cmd>call ddu#ui#do_action('itemAction', #{ name: 'rename' })<CR>
  nnoremap <buffer><silent> <C-r>
        \ <Cmd>call ddu#ui#do_action('redraw')<CR>
endfunction
