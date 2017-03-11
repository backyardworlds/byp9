function extract_click_xy, line

  pos = 0
  ct = 0L
  while (pos NE -1) do begin
      pos_x = strpos(line, '""x""', pos)
;      print, pos_x
      if (pos_x EQ -1) then break
      ct += 1
      pos_colon_x = strpos(line, ':', pos_x)
      pos_y = strpos(line, ',""y""', pos_x)
      x_string = strmid(line, pos_colon_x+1, pos_y-pos_colon_x-1)
      x = float(x_string)
      pos_colon_y = strpos(line, ':', pos_y)
      pos_comma = strpos(line, ',', pos_colon_y)
      y_string = strmid(line, pos_colon_y+1, pos_comma-pos_colon_y-1)
      y = float(y_string)
      pos = pos_comma ; something

      str = {x_zoo: x, y_zoo: y}
      if ~keyword_set(outstr) then outstr = str else $
          outstr = struct_append(outstr, str)
  endwhile

; no click locations recorded
  if (ct EQ 0) then return, -1

  addstr = replicate({nclick: ct}, ct)

  outstr = struct_addtags(outstr, addstr)

  return, outstr
end

pro _test_click_xy, outstr

  lines = djs_readlines('line.txt')
  line = lines[0]

outstr =  extract_click_xy(line)

end

pro _test_click_many_lines, nclick

  lines = djs_readlines('lines.txt')
 
  nclick = lonarr(n_elements(lines))
  for i=0L, n_elements(lines)-1 do begin
      if (i MOD 500) EQ 0 then print, i
      outstr = extract_click_xy(lines[i])
      nclick[i] = ((size(outstr,/type) NE 8) ? 0 : n_elements(outstr))
;      print, size(outstr,/type), ' ', n_elements(outstr)
  endfor
  

end
