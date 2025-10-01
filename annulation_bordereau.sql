--select * from fm_rnl_me where 
update fm_rnl_me set cod_statut='TR' where
(ide_mess, ide_nd_dest, cod_statut) in
(
select unique a.ide_mess,a.ide_poste,b.cod_statut from fc_ecriture a, fm_rnl_me b
where a.ide_poste=b.ide_nd_dest
and a.ide_mess=b.ide_mess
and a.ide_gest='2021'
and a.ide_nd_emet='501C'
and a.cod_statut='AC'
and b.flg_emis_recu='R'
and b.cod_statut='AC'
)
;