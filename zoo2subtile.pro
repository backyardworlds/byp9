; convert from the units of click x,y reported by Zooniverse
; to pixel coordinates within Marc's subtile

function zoo2subtile, x_zoo, y_zoo

  ncoord = n_elements(x_zoo)
  if (n_elements(x_zoo) NE n_elements(y_zoo)) then stop

  x_subtile = (x_zoo - 20.0)*0.5
  y_subtile = 256.0 - 0.5*y_zoo

  outstr = replicate({x_subtile: 0.0, y_subtile: 0.0}, ncoord)
  outstr.x_subtile = x_subtile
  outstr.y_subtile = y_subtile

  return, outstr
end
