function scrape_class_csv, lines, nrow_max=nrow_max

  if ~keyword_set(nrow_max) then nrow_max = 5000000L

  outstr = replicate({racen_subt: 0.0d, deccen_subt: 0.0d, tnum: 0L, $
                      class_id: 0L, $
                      x_zoo: 0.0, y_zoo: 0.0, nclick: 0L, $
                      x_unwise_ll: 0L, y_unwise_ll: 0L, $
                      x_subtile: 0.0, y_subtile: 0.0, $
                      x_unwise: 0.0, y_unwise: 0.0, $
                      ra: 0.0d, dec: 0.0d}, nrow_max)

  ct = 0L
  for i=0L, n_elements(lines)-1 do begin
      if (i MOD 500) EQ 0 then print, i
      line = lines[i]

; first find out if there are any clicks
      clicks = extract_click_xy(line)
      if (size(clicks, /type) NE 8) then continue
      nclicks = n_elements(clicks)

      radec = get_subtile_radec(line)
      if (size(radec,/type) NE 8) then continue

      num = get_tile_number_1line(line)
      if (num EQ -1) then continue

      addstr = $
    replicate({racen_subt: radec.ra, deccen_subt: radec.dec, $
               tnum: long(num), class_id: long(i)}, nclicks)
      clicks = struct_addtags(addstr, clicks)

; add columns giving, for each click, the coordinates of the relevant
; subtile's lower left corner within the full unWISE coadd
      ll_unwise_coords = subtile_lower_left(radec.ra, radec.dec, num)
      addstr = replicate(ll_unwise_coords, nclicks)
      clicks = struct_addtags(clicks, addstr)

; add columns giving each click's pixel coordinates within its subtile
; i.e. values that should be roughly between 0 and 255 along each axis
      subtile_coords = zoo2subtile(clicks.x_zoo, clicks.y_zoo)
      clicks = struct_addtags(clicks, subtile_coords)

; now get the (x,y) coordinates w/in full unWISE tile
      x_unwise = ll_unwise_coords.x_unwise_ll + subtile_coords.x_subtile
      y_unwise = ll_unwise_coords.y_unwise_ll + subtile_coords.y_subtile
      addstr = replicate({x_unwise: 0.0, y_unwise: 0.0}, nclicks)
      addstr.x_unwise = x_unwise
      addstr.y_unwise = y_unwise
      clicks = struct_addtags(clicks, addstr)

;;; now conver to ra,dec
      cache_astrom_atlas
      COMMON ASTROM_ATLAS, astrom
      astr = astrom[num]
      xy2ad, x_unwise, y_unwise, astr, ra, dec
      addstr = replicate({ra: 0.0d, dec: 0.0d}, nclicks)
      addstr.ra = ra
      addstr.dec = dec
      clicks = struct_addtags(clicks, addstr)
;;;

;help,clicks,/st
;help,outstr,/st
      outstr[ct:(ct+nclicks-1)] = clicks
      ct += nclicks
  endfor

  outstr = outstr[0:(ct-1)]
  return, outstr
end

pro __test, outstr

  lines = djs_readlines('/project/projectdirs/cosmo/www/temp/ameisner/backyardworlds/03052017/backyard-worlds-planet-9-classifications.csv')

  outstr = scrape_class_csv(lines)

end
