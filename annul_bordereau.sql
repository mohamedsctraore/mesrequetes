--select * from fm_rnl_me
update fm_rnl_me set cod_statut='TR'
where ide_nd_dest in ('510')
and ide_nd_emet='510'
and ide_mess in (14212,14215,14216,14217,14223,14226,14227,14228,14231,14234,14235,14236,14242,14245,14248,14251,14252,14253,14256,14257,14258,14261)
--and dat_cre like '12/03/%'
--and nbr_piece=0
--and cod_statut in ('AC','SA')
and flg_emis_recu='R'