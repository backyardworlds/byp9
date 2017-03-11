pro check_subtile_centers, x_cen, y_cen

  str = mrdfits('radec_tnum.fits', 1)

  n_class = n_elements(str)

; read in astrom-atlas.fits

  astrom = mrdfits('$SCRATCH/astrom-atlas.fits', 1)

  x_cen = fltarr(n_class)
  y_cen = fltarr(n_class)
  for i=0L, n_class-1 do begin
      if (i MOD 1000) EQ 0 then print, i
      astr = astrom[str[i].tnum]
      ad2xy, str[i].ra, str[i].dec, astr, x, y
      x_cen[i] = x
      y_cen[i] = y
  endfor

end
