" LargeFile: Sets up an autocmd to make editing large files work with celerity
"   Author:		Charles E. Campbell, Jr.
"   Date:		Mar 30, 2006
"   Version:	2
" GetLatestVimScripts: 1506 1 LargeFile.vim

" Load Once: {{{1
if exists("g:loaded_LargeFile") || &cp
 finish
endif
let g:loaded_LargeFile = "v2"
let s:keepcpo          = &cpo
set cpo&vim
" ---------------------------------------------------------------------
"  Options: {{{1
if !exists("g:LargeFile")
 let g:LargeFile= 100	" in megabytes
endif

" ---------------------------------------------------------------------
"  LargeFile Autocmd: {{{1
" for large files: turns undo, syntax highlighting, undo off etc
" (based on vimtip#611)
let s:LargeFile= g:LargeFile*1024*1024
augroup LargeFile
  au BufReadPre *
  \ let f=expand("<afile>") |
  \  if getfsize(f) >= s:LargeFile |
  \  let b:eikeep= &ei |
  \  let b:ulkeep= &ul |
  \  set ei=FileType |
  \  setlocal noswf bh=unload |
  \  let f=escape(substitute(f,'\','/','g'),' ') |
  \  exe "au LargeFile BufEnter ".f." set ul=-1" |
  \  exe "au LargeFile BufLeave ".f." let &ul=".b:ulkeep."|set ei=".b:eikeep |
  \  exe "au LargeFile BufUnload ".f." au! LargeFile * ". f |
  \  echomsg "***note*** handling a large file" |
  \ endif
augroup END

" ---------------------------------------------------------------------
"  Restore: {{{1
let &cpo= s:keepcpo
unlet s:keepcpo
" vim: ts=4 fdm=marker
" HelpExtractor:
"  Author:	Charles E. Campbell, Jr.
"  Version:	3
"  Date:	May 25, 2005
"
"  History:
"    v3 May 25, 2005 : requires placement of code in plugin directory
"                      cpo is standardized during extraction
"    v2 Nov 24, 2003 : On Linux/Unix, will make a document directory
"                      if it doesn't exist yet
"
" GetLatestVimScripts: 748 1 HelpExtractor.vim
" ---------------------------------------------------------------------
set lz
let s:HelpExtractor_keepcpo= &cpo
set cpo&vim
let docdir = expand("<sfile>:r").".txt"
if docdir =~ '\<plugin\>'
 let docdir = substitute(docdir,'\<plugin[/\\].*$','doc','')
else
 if has("win32")
  echoerr expand("<sfile>:t").' should first be placed in your vimfiles\plugin directory'
 else
  echoerr expand("<sfile>:t").' should first be placed in your .vim/plugin directory'
 endif
 finish
endif
if !isdirectory(docdir)
 if has("win32")
  echoerr 'Please make '.docdir.' directory first'
  unlet docdir
  finish
 elseif !has("mac")
  exe "!mkdir ".docdir
 endif
endif

let curfile = expand("<sfile>:t:r")
let docfile = substitute(expand("<sfile>:r").".txt",'\<plugin\>','doc','')
exe "silent! 1new ".docfile
silent! %d
exe "silent! 0r ".expand("<sfile>:p")
silent! 1,/^" HelpExtractorDoc:$/d
exe 'silent! %s/%FILE%/'.curfile.'/ge'
exe 'silent! %s/%DATE%/'.strftime("%b %d, %Y").'/ge'
norm! Gdd
silent! wq!
exe "helptags ".substitute(docfile,'^\(.*doc.\).*$','\1','e')

exe "silent! 1new ".expand("<sfile>:p")
1
silent! /^" HelpExtractor:$/,$g/.*/d
silent! wq!

set nolz
unlet docdir
unlet curfile
"unlet docfile
let &cpo= s:HelpExtractor_keepcpo
unlet s:HelpExtractor_keepcpo
finish

" ---------------------------------------------------------------------
" Put the help after the HelpExtractorDoc label...
" HelpExtractorDoc:
*LargeFile.txt*	Editing Large Files Quickly			Mar 30, 2006

Author:  Charles E. Campbell, Jr.  <NdrOchip@ScampbellPfamily.AbizM>
	  (remove NOSPAM from Campbell's email first)
Copyright: (c) 2004-2006 by Charles E. Campbell, Jr.	*LargeFile-copyright*
           The VIM LICENSE applies to LargeFile.vim
           (see |copyright|) except use "LargeFile" instead of "Vim"
	   No warranty, express or implied.  Use At-Your-Own-Risk.

==============================================================================
1. Large File Plugin						*largefile*

The LargeFile plugin is fairly short -- it simply sets up an |autocmd| that
checks for large files.  There is one parameter: >
	g:LargeFile
which, by default, is 100.  Thus 100MByte files and larger are considered to
be "large files"; smaller ones aren't.  Of course, you as a user may set
g:LargeFile to whatever you want in your <.vimrc> (in units of MBytes).

Basically, this autocmd simply turns off a number of features in Vim,
including event handling, undo, and syntax highlighting, in the interest of
speed and responsiveness.

LargeFile.vim borrows from vimtip#611.

==============================================================================
vim:tw=78:ts=8:ft=help:fdm=marker:
