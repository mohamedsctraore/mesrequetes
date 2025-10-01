select * from fc_ligne
--update fc_ligne set ide_modele_lig = 'D 4433'
--update fc_ligne set ide_modele_lig = 'CREDIT+T'
--update fc_ligne set ide_modele_lig = 'DEBIT'
--update fc_ligne set ide_modele_lig = 'C 475131'
where (ide_poste, ide_gest, flg_cptab, ide_jal, ide_ecr) in
(select ide_poste, ide_gest, flg_cptab, ide_jal, ide_ecr
from fc_ecriture where
ide_gest in ('2022')
and (ide_poste, ide_mess, ide_gest) in
(
select ide_nd_emet,ide_mess, ide_gest
from fm_message
where ide_gest='2022'
--and ide_nd_emet not like '3%'
and ide_nd_emet like '3%'
and cod_typ_mess=24
--and libl like 'CUT-CONFIRMATION DEPOTS DU %%'
--and libl like 'CUT-PAIEMENT EFFECTIF DU %/07/%'
--and libl like 'CUT-RETOUR DE FDS REJET VIREMENT DU %%'
and libl like 'CUT-REGUL DE REJET VIREMENT DU %'
)
)
and flg_cptab = 'N'
and cod_typ_schema = 'T'
--and ide_cpt = '4433'
--and ide_modele_lig = 'DEBIT'
--and ide_cpt like '5811%'
--and ide_cpt like '531%'
--and ide_modele_lig like 'C 5811%'
--and ide_modele_lig like 'D 531%'
--and ide_cpt like '475%'
--and ide_modele_lig = 'CREDIT'
;

/*
select unique a.ide_poste poste, d.libn libelle, a.ide_mess bordereau, c.libl libl, a.cod_statut statut
from fc_ecriture a
left join fc_ligne b on a.ide_poste = b.ide_poste
and a.flg_cptab = b.flg_cptab
and a.ide_gest = b.ide_gest
and a.ide_ecr = b.ide_ecr
and a.ide_jal = b.ide_jal
inner join fm_message c on a.ide_poste = c.ide_nd_emet
and a.ide_mess = c.ide_mess
and a.ide_gest = b.ide_gest
and b.ide_poste = c.ide_nd_emet
and b.ide_gest = c.ide_gest
inner join rm_noeud d on a.ide_poste = d.ide_nd 
and b.ide_poste = d.ide_nd
and c.ide_nd_emet = d.ide_nd 
where a.ide_gest='2022'
--and ide_nd_emet not like '3%'
--and c.ide_nd_emet like '3%'
and c.cod_typ_mess=24
--and libl like 'CUT-CONFIRMATION DEPOTS DU %/06/%'
--and c.libl like 'CUT-PAIEMENT EFFECTIF DU %/06/%'
--and libl like 'CUT-RETOUR DE FDS REJET VIREMENT DU %/07/%'
and libl not like '%/07/%'
and b.flg_cptab = 'N'
and b.cod_typ_schema = 'T'
order by a.ide_poste, a.ide_mess
*/
