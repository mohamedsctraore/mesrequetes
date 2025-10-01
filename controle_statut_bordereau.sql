select unique a.ide_poste,a.ide_mess,a.dat_jc,a.cod_statut STATUT_FC_ECRITURE,b.cod_statut STATUT_FM_RNL_ME,b.nbr_piece from fc_ecriture a, fm_rnl_me b
--update fc_ecriture set cod_statut='AC'
where a.ide_gest='2021'
and a.cod_statut='CO'
and b.cod_statut='AC'
and b.ide_nd_dest=a.ide_poste
and b.ide_mess=a.ide_mess
--and b.flg_emis_recu='R'
order by a.ide_poste
;