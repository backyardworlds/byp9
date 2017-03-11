function scrape_class_csv, lines

  outstr = replicate({ra: 0.0d, dec: 0.0d, tnum: 0L}, n_elements(lines))

  ct = 0L
  for i=0L, n_elements(lines)-1 do begin
      if (i MOD 500) EQ 0 then print, i
      line = lines[i]
      radec = get_subtile_radec(line)
      num = get_tile_number_1line(line)
      if (size(radec,/type) NE 8) OR (num EQ -1) then continue
      str = {ra: radec.ra, dec: radec.dec, tnum: long(num)}
      outstr[ct] = str
      ct += 1
  endfor

  outstr = outstr[0:(ct-1)]
  return, outstr
end

pro __test, outstr

  lines = djs_readlines('/project/projectdirs/cosmo/www/temp/ameisner/backyardworlds/03052017/backyard-worlds-planet-9-classifications.csv')

  outstr = scrape_class_csv(lines)

end
