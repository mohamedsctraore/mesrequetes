select unique ide_poste, ide_mess, ide_nd_emet from fc_ecriture where
cod_statut='RC'
and ide_gest='2021'
order by ide_nd_emet, ide_mess
;

select * from fm_rnl_me where
(ide_nd_dest, ide_mess, ide_nd_emet) in 
(select unique ide_poste, ide_mess, ide_nd_emet from fc_ecriture where
cod_statut='RC'
and ide_gest='2021')
and flg_emis_recu='R'
order by ide_nd_emet, ide_mess
;

update fc_ecriture set cod_statut='AC' where cod_statut in
(select cod_statut from fc_ecriture where
cod_statut='RC'
and ide_gest='2021'
and flg_cptab='N')
;