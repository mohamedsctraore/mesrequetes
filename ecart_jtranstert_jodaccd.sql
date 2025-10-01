select a.ide_poste, a.ide_nd_emet, sum(mt)
from fc_ecriture a
left join fc_ligne b on a.ide_poste = b.ide_poste
and a.flg_cptab = b.flg_cptab
and a.ide_gest = b.ide_gest
and a.ide_ecr = b.ide_ecr
and a.ide_jal = b.ide_jal 
where a.ide_gest='2024'
and a.ide_poste = '507'
and a.ide_jal='JTRANSFERT'
and b.ide_cpt = '4751108'
and cod_sens = 'C'
and dat_jc = '30/07/2024'
group by a.ide_poste, a.ide_nd_emet
order by ide_nd_emet
;

select a.ide_poste, substr(c.libl, -3) nd_emet, sum(mt)
from fc_ecriture a
left join fc_ligne b on a.ide_poste = b.ide_poste
left join fm_message c on a.ide_poste = c.ide_nd_emet
and a.ide_mess = c.ide_mess
and a.ide_gest = c.ide_gest
and a.flg_emis_recu = c.flg_emis_recu
and a.flg_cptab = b.flg_cptab
and a.ide_gest = b.ide_gest
and a.ide_ecr = b.ide_ecr
and a.ide_jal = b.ide_jal 
where a.ide_gest='2024'
and a.ide_poste = '507'
and a.ide_jal='JODACCD'
and b.ide_cpt = '4751108'
and cod_sens = 'D'
and dat_jc = '30/07/2024'
and c.cod_typ_mess = 8
and c.libl like '30/07/%TRANSFERT ORION ASTER%'
group by a.ide_poste, substr(c.libl, -3)
order by substr(c.libl, -3)
;