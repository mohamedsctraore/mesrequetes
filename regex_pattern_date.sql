select a.ide_nd_emet emetteur, a.ide_poste recepteur, ide_mess
from fc_ecriture a
--and a.flg_cptab = 'O'
where a.ide_gest='2023'
and a.ide_jal='JTRANSFERT'
--and regexp_like (substr(libn, -8), '[^[:digit:]]')
and not regexp_like (substr(libn, -8), '^[0-9]{2}\/[0-9]{2}\/[0-9]{2}$')
--and (a.ide_poste like '2%C' or a.ide_poste = '507')
--and a.ide_poste in (select ide_poste from piaf_adm.rm_poste where ide_poste_centra = '501C')
--group by a.ide_nd_emet, a.ide_poste, b.ide_cpt
;