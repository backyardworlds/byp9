pro allwise_xmatch, zoo, allwise, m_zoo, m_allwise

  zoo = mrdfits('click_catalog-radec.fits', 1)

  allwise = $
      mrdfits('/global/cscratch1/sd/ameisner/motion_sample_redo-snr.fits',1)


  zoo.ra += (zoo.ra LT 0)*360.0d

; get rid of classifications that clicked too many things
  wgood = where(zoo.nclick LE 20)
  zoo = zoo[wgood]

  match_rad_asec = 10.0 ; ???

  spherematch, zoo.ra, zoo.dec, allwise.ra, allwise.dec, $
      match_rad_asec/3600.0, m_zoo, m_allwise

  

end
