function subtile_lower_left, racen, deccen, tnum

; racen is the subtile center RA coordinate from classifications file
; deccen is the subtile center Dec coordinate from classifications file
; tnum is index into allsky-atlas (and astrom-atlas)

  cache_astrom_atlas
  COMMON ASTROM_ATLAS, astrom

  astr = astrom[tnum]

  ad2xy, racen, deccen, astr, xcen, ycen

; zero-indexed, should be an integer 0 to 7
  pos_horizontal = fix((round(xcen/128) - 1)/2.0)
; zero-indexed, should be an integer 0 to 7
  pos_vertical = fix((round(ycen/128) - 1)/2.0)

  if (pos_horizontal LT 0) OR (pos_horizontal GT 7) then stop
  if (pos_vertical LT 0) OR (pos_vertical GT 7) then stop

  x_unwise_ll = 256L*pos_horizontal
  y_unwise_ll = 256L*pos_vertical

  outstr = {x_unwise_ll: x_unwise_ll, y_unwise_ll: y_unwise_ll}
  return, outstr
end
