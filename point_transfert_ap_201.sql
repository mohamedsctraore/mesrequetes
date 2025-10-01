select a.ide_nd_emet emetteur, a.ide_gest, a.ide_jal, a.ide_mess, b.ide_ecr, a.ide_schema, a.libn,b.ide_cpt, b.cod_sens, b.mt, b.observ,a.dat_jc, b.dat_ecr, a.cod_statut
from fc_ecriture a
inner join fc_ligne b on a.ide_poste=b.ide_poste
and a.ide_gest=b.ide_gest
and a.ide_jal=b.ide_jal
and a.ide_ecr=b.ide_ecr
and a.flg_cptab=b.flg_cptab
where a.ide_gest='2022'
and a.ide_poste='201C'
and a.ide_jal='JTRANSFERT'
and a.ide_mess in (175698)
--and a.dat_cre like '14/04%'
--and a.flg_cptab='N'
order by a.ide_nd_emet, a.ide_mess, a.ide_ecr, b.cod_sens;


select a.ide_poste poste, c.libn libelle, a.ide_mess bordereau, a.ide_ecr, d.ide_cpt, d.cod_sens, d.mt, d.observ, b.libl, a.cod_statut statut
from fc_ecriture a
inner join fm_message b on a.ide_poste = b.ide_nd_emet
inner join rm_noeud c on a.ide_poste = c.ide_nd
inner join fc_ligne d on a.ide_poste = d.ide_poste
and a.ide_ecr = d.ide_ecr
and a.flg_cptab = d.flg_cptab
and a.ide_jal = d.ide_jal
and a.ide_gest = d.ide_gest
and b.ide_nd_emet = c.ide_nd
and a.ide_mess = b.ide_mess
and b.ide_nd_emet = d.ide_poste
and c.ide_nd = d.ide_poste
and a.ide_gest='2022'
and cod_typ_mess=8
--and a.flg_cptab = 'N'
and libl like 'TRANSFERT ORION ASTER DU 05/08/%ORD2'
and b.ide_nd_emet = '201'
order by a.ide_poste, a.ide_mess, a.ide_ecr, d.cod_sens;