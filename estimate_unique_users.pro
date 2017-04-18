pro estimate_unique_users

  fname = 'backyard-worlds-planet-9-classifications.csv'
  t0 = systime(1)
  readcol, fname, classification_id, user_name, user_id, F='A, A, A, A', $
      user_ip, /preserve_null, skipline=1
  dt = systime(1) - t0

  outstr = replicate({classification_id: '', user_name: '', $
                      user_id: '', user_ip: ''}, n_elements(user_id))

  outstr.classification_id = classification_id
  outstr.user_name = user_name
  outstr.user_id = user_id
  outstr.user_ip = user_ip

  mwrfits, outstr, 'classifications_summary.fits'

end

pro analyze_num_users

  str = mrdfits('classifications_summary.fits', 1)

  str.user_id = strtrim(str.user_id, 2)
  str.user_ip = strtrim(str.user_ip, 2)

; classifications where a registered user is logged in
  w_reg_login = where(str.user_id NE '', nw_reg_name)

  n_reg_users = n_elements(unique(str[w_reg_login].user_id))

  print, 'number of unique registered users : ', n_reg_users

  ips_reg_users = unique(str[w_reg_login].user_ip)

  print, 'number of unique IP addresses belonging to users registered and logged in : ', n_elements(ips_reg_users)

; divide number of unique IP
; addresses belonging to registered users by number of unique
; registered users to get average value of # of IP addresses per
; registered user

  avg_ips_per_user = float(n_elements(ips_reg_users))/float(n_reg_users)

  print, 'average number of IP addresses per registered user : ', avg_ips_per_user

  matchlist, ips_reg_users, str.user_ip, _, m_all

  ; m_all contains indices of all classifications that have IPs known
  ; to correspond to a registered user

 ; calculate the number of classifications performed by registered users
 ; while not logged in
  n_class_logout = n_elements(m_all) - nw_reg_name
  print, 'number of classifications performed by registered users while not logged in : ', n_class_logout

; bitmask labeling which classifications were performed by registered
; users based on IP
  reg_user_mask = bytarr(n_elements(str)) ; initialize
  reg_user_mask[m_all] = 1

  w_nonreg = where(~reg_user_mask)

; unique IPs from non-registered users
  ips_u_nonreg = unique(str[w_nonreg].user_ip)

  print, 'number of unique IPs belonging to non-registered users : ',  $
      n_elements(ips_u_nonreg)

  n_users_nonreg = float(n_elements(ips_u_nonreg))/avg_ips_per_user

  print, 'estimated number of unique non-registered users : ', n_users_nonreg

  print, 'estimated total number of unique users : ', long(n_users_nonreg + n_reg_users)

end
