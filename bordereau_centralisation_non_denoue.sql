select unique a.ide_poste, a.ide_mess, a.libn from fc_ecriture a, fm_rnl_me b
where ide_gest='2021'
and a.ide_mess=b.ide_mess
and a.libn like 'Centralisation % du %/06/21'
and a.flg_cptab='N'
and b.flg_emis_recu='R'
and a.cod_statut in ('AC','RC')
and b.cod_statut='AC'
order by ide_poste
;