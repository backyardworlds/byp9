; extract subtile ra and dec from one line of Zooniverse
; classification CSV output

function get_subtile_radec, line

  pos = strpos(line, 'subtile center')

  if (pos EQ -1) then return, -1 ; sometimes this happens ...

;print, pos

  pos_equ_sign_ra = strpos(line, '=', pos)
  pos_dec = strpos(line, 'dec', pos)

  ra_string = strmid(line, pos_equ_sign_ra + 1, pos_dec-pos_equ_sign_ra-1) 
  ra_string = strtrim(ra_string, 2) ; get rid of any whitespace


  pos_equ_sign_dec = strpos(line, '=', pos_dec)
  pos_quote_end_dec = strpos(line, '"', pos_equ_sign_dec)

;  print, ra_string

  dec_string = $
      strmid(line, pos_equ_sign_dec+1, pos_quote_end_dec-pos_equ_sign_dec-1)
  dec_string = strtrim(dec_string, 2)

  outstr = {ra : double(ra_string), dec: double(dec_string)}

  return, outstr

end

pro _test_subtile_center

  lines = djs_readlines('line.txt')
  line = lines[0]

  outstr = get_subtile_radec(line)
  help, outstr,/st

end

pro _test_many_subtile_center, outstr

  lines = djs_readlines('lines.txt')

  outstr = replicate({ra: 0.0d, dec: 0.0d}, n_elements(lines))

  ct = 0L
  for i=0L, n_elements(lines)-1 do begin
      str = get_subtile_radec(lines[i])
      if (i MOD 500) EQ 0 then print, i, ' ', size(str, /type)
      if (size(str, /type) NE 8) then continue
      outstr[ct] = str
      ct += 1
  endfor

  outstr = outstr[0:(ct-1)]

end
