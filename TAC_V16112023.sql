SELECT b.ide_poste_centra,a.ide_poste,c.libc,MAX(a.dat_jc)
FROM piaf_adm.fc_calend_hist a, piaf_adm.rm_poste b, piaf_adm.rm_noeud c
WHERE a.ide_gest='2023' AND a.cod_ferm='C' --and a.ide_poste not like '%C' 
AND a.ide_poste NOT LIKE 'AD%'
AND a.ide_poste=b.ide_poste
AND a.ide_poste=c.ide_nd
AND a.ide_poste='501'
--AND a.ide_poste  IN  (SELECT DISTINCT ide_poste FROM fc_ecriture WHERE ide_gest=gestion AND flg_cptab='O')
--AND EXISTS  (SELECT  ide_poste FROM fc_ecriture e WHERE e.ide_gest=gestion AND e.flg_cptab='O' AND e.ide_poste=a.ide_poste  )
GROUP BY b.ide_poste_centra,a.ide_poste,c.libc;

SELECT b.ide_poste_centra,a.ide_poste,c.libc,MAX(a.dat_jc)
FROM piaf_adm.fc_calend_hist a, piaf_adm.rm_poste b, piaf_adm.rm_noeud c
WHERE a.ide_gest='2023' AND a.cod_ferm='O' --and a.ide_poste not like '%C' 
AND a.ide_poste NOT LIKE 'AD%'
AND a.ide_poste=b.ide_poste
AND a.ide_poste=c.ide_nd
AND a.ide_poste='501'
--AND a.ide_poste  in  (SELECT DISTINCT ide_poste FROM fc_ecriture WHERE ide_gest=gestion AND flg_cptab='O')
--AND EXISTS  (SELECT  ide_poste FROM fc_ecriture e WHERE e.ide_gest=gestion AND e.flg_cptab='O' AND e.ide_poste=a.ide_poste  )
GROUP BY b.ide_poste_centra,a.ide_poste,c.libc;