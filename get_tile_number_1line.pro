function get_tile_number_1line, line

  pos = strpos(line, 'Tile Number')

  if (pos EQ -1) then return, long(-1)
  pos_colon = strpos(line, ':', pos)
  pos_comma = strpos(line, ',', pos)

  tile_number_string = $
      repstr(strmid(line, pos_colon, (pos_comma-pos_colon)), '"', '')
  tile_number_string = repstr(tile_number_string, ':', '')

;  print, tile_number_string

  return, long(tile_number_string)
end

pro _test_tile_number

  lines = djs_readlines('line.txt')
  line = lines[0]

  num = get_tile_number_1line(line)
  print, num
  help, num

end

pro _test_many_tile_num, nums

  lines = $
      djs_readlines('/project/projectdirs/cosmo/www/temp/ameisner/backyardworlds/03052017/backyard-worlds-planet-9-classifications.csv')

;  lines = djs_readlines('lines.txt')

  nums = lonarr(n_elements(lines))
  for i=0L,n_elements(lines)-1 do begin
      num = get_tile_number_1line(lines[i])
      if (i MOD 25) EQ 0 then print, i, ' , tile number = ', num
      nums[i] = num
  endfor

end
