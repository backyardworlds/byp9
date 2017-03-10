pro ingest, xvals, yvals

  fname = 'classifications.csv'

  lines = djs_readlines(fname)

  n_lines = n_elements(lines)

  ntok = lonarr(n_lines)
  xvals = fltarr(n_lines)
  yvals = fltarr(n_lines)
  for i=0L, n_lines-1 do begin
      if (i MOD 1000) EQ 0 then print, i
      line = repstr(lines[i], ',', ' , ')
      tokens = strsplit(line, ',', /extract)
      ntok[i] = n_elements(tokens)
; x is tokens[8]
; y is tokens[9[

      x_str = strtrim(tokens[8],2)
      if strlen(x_str) EQ 0 then xvals[i] = !values.f_nan else $
         xvals[i] = float(x_str)

      y_str = strtrim(tokens[9],2)
      if strlen(y_str) EQ 0 then yvals[i] = !values.f_nan else $
          yvals[i] = float(y_str)
  endfor

end

pro _2dhist, x, y, grid

  ingest, x, y
  grid = fltarr(1500, 1500)
  for ix=-500L, 999L do begin
      print, ix
      for iy=-500L, 999L do begin
          grid[ix+500,iy+500] = total((x GE (ix-0.5)) AND (x LT (ix+0.5)) AND $
                              (y GE (iy-0.5)) AND (y LT (iy+0.5)))
      endfor
  endfor

end

pro _plot, x, y

  ingest, x, y

;  plot, x, y, psym=3

  window, 0, xsize=800, ysize=800
  xtitle = 'x from classifications'
  ytitle = 'y from classifications'

  plot,x,y,psym=3,xrange=[-50,550], yrange=[-50,550],/xst,/yst, xtitle=xtitle, $
      ytitle=ytitle, charsize=1.5

  oplot,[0,532, 532, 0, 0],[0, 0, 528 , 528, 0], $
      color=djs_icolor('green'), thick=2

  oplot, [20,20],[0,528-16], color=djs_icolor('red'), thick=2
  oplot, [20,532], (528-16) + [0,0], color=djs_icolor('red'), thick=2

  bitmap = tvrd(true=1)
  write_png, 'click_xy.png', bitmap

end
