function! RunPhplint()
  let l:filename=@%
  let l:phplint_output=system('php -l -ddisplay_errors=1 '.l:filename.'|grep -v "Errors parsing"')
  let l:phplint_list=split(l:phplint_output, "\n")
  echomsg l:phplint_output

  if v:shell_error
    cexpr l:phplint_list
    copen
    exec "nnoremap <silent> <buffer> q :ccl<CR>"
  else
    cclose
    echomsg l:phplint_list[0]
  endif
endfunction

set errorformat=%m\ in\ %f\ on\ line\ %l
command! Phplint call RunPhplint()
