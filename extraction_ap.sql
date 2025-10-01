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
and a.flg_cptab = 'N'
and libl like 'TRANSFERT ORION ASTER DU %BQ'
and b.ide_nd_emet = '201'
--and mt between 500000000 and 30000000000
--and b.libl not like '%/07/%'
--and libl like 'TRANSFERT ORION ASTER DU %'
--and (libl like 'TRANSFERT ORION ASTER DU %ORD2' or  libl like 'TRANSFERT ORION ASTER DU %BQ')
order by a.ide_poste, a.ide_mess, ide_ecr, cod_sens;

select a.ide_poste, ide_mess, a.ide_ecr, cod_sens, b.ide_cpt, mt, observ, libn, dat_ref, a.cod_statut
from fc_ecriture a
left join fc_ligne b on a.ide_poste = b.ide_poste
and a.flg_cptab = b.flg_cptab
and a.ide_gest = b.ide_gest
and a.ide_ecr = b.ide_ecr
and a.ide_jal = b.ide_jal 
where a.ide_jal = 'JTRANSFERT'
and a.ide_gest='2022'
and a.ide_poste = '201C'
and a.cod_statut = 'AC'
and a.ide_nd_emet = '507'
--and dat_ref between '01/03/2022' and '28/03/2022'
order by dat_ref, ide_mess, a.ide_ecr, cod_sens;


-----------------------------------------------  SITUATION ECRITURE AVEC BORDEREAU  ----------------------------------------------------
select a.ide_poste poste, c.libn libelle, a.ide_mess bordereau, a.ide_ecr, d.ide_cpt, d.cod_sens, d.mt, d.observ, b.libl, a.cod_statut statut_ecriture, e.cod_statut statut_bordereau
from fc_ecriture a
inner join fm_message b on a.ide_poste = b.ide_nd_emet
inner join rm_noeud c on a.ide_poste = c.ide_nd
inner join fc_ligne d on a.ide_poste = d.ide_poste
inner join fm_rnl_me e on a.ide_poste = e.ide_nd_dest
and a.ide_mess = e.ide_mess
and b.ide_nd_emet = e.ide_nd_dest
and b.ide_mess = e.ide_mess
and c.ide_nd = e.ide_nd_dest
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
and libl like 'TRANSFERT ORION ASTER DU %/01/%'
and b.ide_nd_emet = '201'
and e.flg_emis_recu = 'R'
and e.cod_statut in ('AC','SA')
order by a.ide_poste, a.ide_mess, ide_ecr, cod_sens;


-----------------------------------------------  SITUATION BORDEREAU ----------------------------------------------------
select a.ide_poste poste, c.libn libelle, a.ide_mess bordereau, a.ide_ecr, d.ide_cpt, d.cod_sens, d.mt, d.observ, b.libl, a.cod_statut statut_ecriture, e.cod_statut statut_bordereau
from fc_ecriture a
inner join fm_message b on a.ide_poste = b.ide_nd_emet
inner join rm_noeud c on a.ide_poste = c.ide_nd
inner join fc_ligne d on a.ide_poste = d.ide_poste
inner join fm_rnl_me e on a.ide_poste = e.ide_nd_dest
and a.ide_mess = e.ide_mess
and b.ide_nd_emet = e.ide_nd_dest
and b.ide_mess = e.ide_mess
and c.ide_nd = e.ide_nd_dest
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
--and libl not like 'TRANSFERT ORION ASTER DU %/01/%'
--and libl not like '%/01/%'
and libl like '%/01/%'
and b.ide_nd_emet = '201'
and e.flg_emis_recu = 'R'
and e.cod_statut in ('AC','SA')
--and e.cod_statut in ('SA')
--and a.cod_statut in ('AC','SA')
order by a.ide_poste, a.ide_mess, ide_ecr, cod_sens;


--------------------------------------------------- BORDEREAU A FAIRE DISPARAITRE DE L'ECRAN ------------------------------------------------------
select a.ide_poste poste, c.libn libelle, a.ide_mess bordereau, a.ide_ecr, d.ide_cpt, d.cod_sens, d.mt, d.observ, b.libl, a.cod_statut statut_ecriture, e.cod_statut statut_bordereau
from fc_ecriture a
inner join fm_message b on a.ide_poste = b.ide_nd_emet
inner join rm_noeud c on a.ide_poste = c.ide_nd
inner join fc_ligne d on a.ide_poste = d.ide_poste
inner join fm_rnl_me e on a.ide_poste = e.ide_nd_dest
and a.ide_mess = e.ide_mess
and b.ide_nd_emet = e.ide_nd_dest
and b.ide_mess = e.ide_mess
and c.ide_nd = e.ide_nd_dest
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
--and libl not like 'TRANSFERT ORION ASTER DU %/01/%'
--and libl not like '%/01/%'
and libl like '%/03/%'
and b.ide_nd_emet = '201'
and e.flg_emis_recu = 'R'
and e.cod_statut in ('AC','SA')
--and e.cod_statut in ('SA')
and a.cod_statut in ('AC','SA')
order by a.ide_poste, a.ide_mess, ide_ecr, cod_sens;