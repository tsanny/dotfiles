" Name:    one vim colorscheme
" Author:  Ramzi Akremi
" License: MIT
" Version: 1.1.1-pre

if exists("*<SID>X")
  delf <SID>X
  delf <SID>XAPI
  delf <SID>rgb
  delf <SID>color
  delf <SID>rgb_color
  delf <SID>rgb_level
  delf <SID>rgb_number
  delf <SID>grey_color
  delf <SID>grey_level
  delf <SID>grey_number
endif

hi clear
syntax reset
if exists('g:colors_name')
  unlet g:colors_name
endif
let g:colors_name = 'one'

if !exists('g:one_allow_italics')
  let g:one_allow_italics = 0
endif

let s:italic = ''
if g:one_allow_italics == 1
  let s:italic = 'italic'
endif

if has('gui_running') || has('termguicolors') || &t_Co == 88 || &t_Co == 256
  fun <SID>grey_number(x)
    if &t_Co == 88
      if a:x < 23
        return 0
      elseif a:x < 69
        return 1
      elseif a:x < 103
        return 2
      elseif a:x < 127
        return 3
      elseif a:x < 150
        return 4
      elseif a:x < 173
        return 5
      elseif a:x < 196
        return 6
      elseif a:x < 219
        return 7
      elseif a:x < 243
        return 8
      else
        return 9
      endif
    else
      if a:x < 14
        return 0
      else
        let l:n = (a:x - 8) / 10
        let l:m = (a:x - 8) % 10
        if l:m < 5
          return l:n
        else
          return l:n + 1
        endif
      endif
    endif
  endfun

  fun <SID>grey_level(n)
    if &t_Co == 88
      if a:n == 0
        return 0
      elseif a:n == 1
        return 46
      elseif a:n == 2
        return 92
      elseif a:n == 3
        return 115
      elseif a:n == 4
        return 139
      elseif a:n == 5
        return 162
      elseif a:n == 6
        return 185
      elseif a:n == 7
        return 208
      elseif a:n == 8
        return 231
      else
        return 255
      endif
    else
      if a:n == 0
        return 0
      else
        return 8 + (a:n * 10)
      endif
    endif
  endfun

  fun <SID>grey_color(n)
    if &t_Co == 88
      if a:n == 0
        return 16
      elseif a:n == 9
        return 79
      else
        return 79 + a:n
      endif
    else
      if a:n == 0
        return 16
      elseif a:n == 25
        return 231
      else
        return 231 + a:n
      endif
    endif
  endfun

  fun <SID>rgb_number(x)
    if &t_Co == 88
      if a:x < 69
        return 0
      elseif a:x < 172
        return 1
      elseif a:x < 230
        return 2
      else
        return 3
      endif
    else
      if a:x < 75
        return 0
      else
        let l:n = (a:x - 55) / 40
        let l:m = (a:x - 55) % 40
        if l:m < 20
          return l:n
        else
          return l:n + 1
        endif
      endif
    endif
  endfun

  fun <SID>rgb_level(n)
    if &t_Co == 88
      if a:n == 0
        return 0
      elseif a:n == 1
        return 139
      elseif a:n == 2
        return 205
      else
        return 255
      endif
    else
      if a:n == 0
        return 0
      else
        return 55 + (a:n * 40)
      endif
    endif
  endfun

  fun <SID>rgb_color(x, y, z)
    if &t_Co == 88
      return 16 + (a:x * 16) + (a:y * 4) + a:z
    else
      return 16 + (a:x * 36) + (a:y * 6) + a:z
    endif
  endfun

  fun <SID>color(r, g, b)
    let l:gx = <SID>grey_number(a:r)
    let l:gy = <SID>grey_number(a:g)
    let l:gz = <SID>grey_number(a:b)
    let l:x = <SID>rgb_number(a:r)
    let l:y = <SID>rgb_number(a:g)
    let l:z = <SID>rgb_number(a:b)

    if l:gx == l:gy && l:gy == l:gz
      let l:dgr = <SID>grey_level(l:gx) - a:r
      let l:dgg = <SID>grey_level(l:gy) - a:g
      let l:dgb = <SID>grey_level(l:gz) - a:b
      let l:dgrey = (l:dgr * l:dgr) + (l:dgg * l:dgg) + (l:dgb * l:dgb)
      let l:dr = <SID>rgb_level(l:gx) - a:r
      let l:dg = <SID>rgb_level(l:gy) - a:g
      let l:db = <SID>rgb_level(l:gz) - a:b
      let l:drgb = (l:dr * l:dr) + (l:dg * l:dg) + (l:db * l:db)
      if l:dgrey < l:drgb
        return <SID>grey_color(l:gx)
      else
        return <SID>rgb_color(l:x, l:y, l:z)
      endif
    else
      return <SID>rgb_color(l:x, l:y, l:z)
    endif
  endfun

  fun <SID>rgb(rgb)
    let l:r = ('0x' . strpart(a:rgb, 0, 2)) + 0
    let l:g = ('0x' . strpart(a:rgb, 2, 2)) + 0
    let l:b = ('0x' . strpart(a:rgb, 4, 2)) + 0
    return <SID>color(l:r, l:g, l:b)
  endfun

  fun <SID>XAPI(group, fg, bg, attr)
    let l:attr = a:attr
    if g:one_allow_italics == 0 && l:attr ==? 'italic'
      let l:attr = 'none'
    endif

    let l:bg = ""
    let l:fg = ""
    let l:decoration = ""

    if a:bg != ''
      let l:bg = " guibg=#" . a:bg . " ctermbg=" . <SID>rgb(a:bg)
    endif

    if a:fg != ''
      let l:fg = " guifg=#" . a:fg . " ctermfg=" . <SID>rgb(a:fg)
    endif

    if a:attr != ''
      let l:decoration = " gui=" . l:attr . " cterm=" . l:attr
    endif

    let l:exec = l:fg . l:bg . l:decoration
    if l:exec != ''
      exec "hi " . a:group . l:exec
    endif
  endfun

  function! <SID>X(group, fg, bg, attr, ...)
    let l:attrsp = get(a:, 1, "")
    if !empty(a:fg)
      exec "hi " . a:group . " guifg=" . a:fg[0]
      exec "hi " . a:group . " ctermfg=" . a:fg[1]
    endif
    if !empty(a:bg)
      exec "hi " . a:group . " guibg=" . a:bg[0]
      exec "hi " . a:group . " ctermbg=" . a:bg[1]
    endif
    if a:attr != ""
      exec "hi " . a:group . " gui=" . a:attr
      exec "hi " . a:group . " cterm=" . a:attr
    endif
    if !empty(l:attrsp)
      exec "hi " . a:group . " guisp=" . l:attrsp[0]
    endif
  endfunction

  let s:dark = 0
  if &background ==# 'dark'
    let s:dark = 1
    let s:mono_1 = ['#abb2bf', '145']
    let s:mono_2 = ['#828997', '102']
    let s:mono_3 = ['#5c6370', '59']
    let s:mono_4 = ['#4b5263', '59']
    let s:hue_1  = ['#56b6c2', '73']
    let s:hue_2  = ['#61afef', '75']
    let s:hue_3  = ['#c678dd', '176']
    let s:hue_4  = ['#98c379', '114']
    let s:hue_5   = ['#e06c75', '168']
    let s:hue_5_2 = ['#be5046', '130']
    let s:hue_6   = ['#d19a66', '173']
    let s:hue_6_2 = ['#e5c07b', '180']
    let s:syntax_bg     = ['#282c34', '16']
    let s:syntax_gutter = ['#636d83', '60']
    let s:syntax_cursor = ['#2c323c', '16']
    let s:syntax_accent = ['#528bff', '69']
    let s:vertsplit    = ['#181a1f', '233']
    let s:special_grey = ['#3b4048', '16']
    let s:visual_grey  = ['#3e4452', '17']
    let s:pmenu        = ['#333841', '16']
  else
    let s:mono_1 = ['#494b53', '23']
    let s:mono_2 = ['#696c77', '60']
    let s:mono_3 = ['#a0a1a7', '145']
    let s:mono_4 = ['#c2c2c3', '250']
    let s:hue_1  = ['#0184bc', '31']
    let s:hue_2  = ['#4078f2', '33']
    let s:hue_3  = ['#a626a4', '127']
    let s:hue_4  = ['#50a14f', '71']
    let s:hue_5   = ['#e45649', '166']
    let s:hue_5_2 = ['#ca1243', '160']
    let s:hue_6   = ['#986801', '94']
    let s:hue_6_2 = ['#c18401', '136']
    let s:syntax_bg     = ['#fafafa', '255']
    let s:syntax_gutter = ['#9e9e9e', '247']
    let s:syntax_cursor = ['#f0f0f0', '254']
    let s:syntax_accent = ['#526fff', '63']
    let s:syntax_accent_2 = ['#0083be', '31']
    let s:vertsplit    = ['#e7e9e1', '188']
    let s:special_grey = ['#d3d3d3', '251']
    let s:visual_grey  = ['#d0d0d0', '251']
    let s:pmenu        = ['#dfdfdf', '253']
  endif

  let s:syntax_fg = s:mono_1
  let s:syntax_fold_bg = s:mono_3

  call <sid>X('Normal',       s:syntax_fg,     s:syntax_bg,      '')
  call <sid>X('CursorLine',   '',              s:syntax_cursor,  'none')
  call <sid>X('VertSplit',    s:syntax_cursor, s:syntax_cursor,  'none')
  call <sid>X('LineNr',       s:mono_4,        '',               '')
  call <sid>X('CursorLineNr', s:syntax_fg,     s:syntax_cursor,  'none')
  call <sid>X('PMenu',        '',              s:pmenu,          '')
  call <sid>X('PMenuSel',     '',              s:mono_4,         '')
  call <sid>X('StatusLine',   s:syntax_fg,     s:syntax_cursor,  'none')
  call <sid>X('StatusLineNC', s:mono_3,        '',               '')
  call <sid>X('TabLine',      s:mono_2,        s:visual_grey,    'none')
  call <sid>X('TabLineFill',  s:mono_3,        s:visual_grey,    'none')
  call <sid>X('TabLineSel',   s:syntax_bg,     s:hue_2,          '')
  call <sid>X('Comment',        s:mono_3,        '',          s:italic)
  call <sid>X('Constant',       s:hue_4,         '',          '')
  call <sid>X('String',         s:hue_4,         '',          '')
  call <sid>X('Number',         s:hue_6,         '',          '')
  call <sid>X('Boolean',        s:hue_6,         '',          '')
  call <sid>X('Identifier',     s:hue_5,         '',          'none')
  call <sid>X('Function',       s:hue_2,         '',          '')
  call <sid>X('Statement',      s:hue_3,         '',          'none')
  call <sid>X('Keyword',        s:hue_5,         '',          '')
  call <sid>X('Type',           s:hue_6_2,       '',          'none')
  call <sid>X('Special',        s:hue_2,         '',          '')
endif

function! one#highlight(group, fg, bg, attr)
  call <sid>XAPI(a:group, a:fg, a:bg, a:attr)
endfunction

if exists('s:dark') && s:dark
  set background=dark
endif

" vim: set fdl=0 fdm=marker:
