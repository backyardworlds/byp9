function get_subject_id_1line, line

  pos = strpos(line, 'subject_id')

  if (pos EQ -1) then return, long(-1)
  pos_colon = strpos(line, ':', pos)
  pos_comma = strpos(line, ',', pos)

  subject_id_string = $
      repstr(strmid(line, pos_colon, (pos_comma-pos_colon)), '"', '')
  subject_id_string = repstr(subject_id_string, ':', '')

  if strtrim(string(long(subject_id_string)),2) NE subject_id_string then stop

  return, long(subject_id_string)
end

pro _test_subject_id

  lines = djs_readlines('line.txt')
  line = lines[0]

  id = get_subject_id_1line(line)
  print, id
  help, id

end

pro _test_many_subject_id, ids

  lines = $
      djs_readlines('/project/projectdirs/cosmo/www/temp/ameisner/backyardworlds/03052017/backyard-worlds-planet-9-classifications.csv')

;  lines = djs_readlines('lines.txt')

  ids = lonarr(n_elements(lines)-1) ; ignoring first line

; start at i=1 since first line is not real output (column headers i think)
  for i=1L,n_elements(lines)-1 do begin
      id = get_subject_id_1line(lines[i])
      if (i MOD 25) EQ 0 then print, i, ' , subject_id = ', id
      ids[i-1] = id
  endfor

end
