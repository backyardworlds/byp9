pro allwise_xmatch, zoo, allwise, m_zoo, m_allwise

  zoo = mrdfits('/project/projectdirs/cosmo/www/temp/ameisner/backyardworlds/03052017/subject_id/click_catalog.fits.gz', 1)

  allwise = $
      mrdfits('/global/cscratch1/sd/ameisner/motion_sample_redo-snr.fits',1)


  zoo.ra += (zoo.ra LT 0)*360.0d

; get rid of classifications that clicked too many things
  wgood = where(zoo.nclick LE 20)
  zoo = zoo[wgood]

  match_rad_asec = 10.0 ; ???

  spherematch, zoo.ra, zoo.dec, allwise.ra, allwise.dec, $
      match_rad_asec/3600.0, m_zoo, m_allwise

  allwise = allwise[m_allwise]
  zoo = zoo[m_zoo]

  addstr = replicate({ra_zoo: 0.0d, dec_zoo: 0.0d}, n_elements(zoo))

  addstr.ra_zoo = zoo.ra
  addstr.dec_zoo = zoo.dec

  zoo = struct_trimtags(zoo, except=['RA', 'DEC'])
  zoo = struct_addtags(zoo, addstr)

  result = struct_addtags(allwise, zoo)

end

; mwrfits, result, 'red_click_matches.fits'
