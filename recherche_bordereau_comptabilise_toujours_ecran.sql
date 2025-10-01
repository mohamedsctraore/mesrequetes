select ide_poste, ide_gest, ide_mess, ide_ecr, cod_statut from fc_ecriture where (ide_poste, ide_nd_emet, ide_mess) in
( 

select ide_nd_dest POSTE_RECEPTEUR,ide_nd_emet POSTE_EMETTEUR,ide_mess NUM_BORDEREAU from fm_rnl_me where (ide_mess, ide_nd_emet)
in
(
select unique b.ide_mess, b.ide_nd_emet from fc_ligne a, fc_ecriture b where (a.ide_poste, a.ide_gest, a.ide_jal, a.flg_cptab, a.ide_ecr)
in 
(select ide_poste, ide_gest, ide_jal, flg_cptab, ide_ecr from fc_ecriture where  
ide_gest in ('2020','2021')
--and ide_poste='507'
and flg_cptab='O'
and flg_cptab <> 'N'
and cod_statut not in ('AC','SA')
and cod_statut = 'CO'
--and ide_jal='JTRANSFERT'
)
and a.ide_poste=b.ide_poste
and a.ide_gest=b.ide_gest
and a.ide_jal=b.ide_jal
and a.flg_cptab=b.flg_cptab
and a.ide_ecr=b.ide_ecr
and to_date(a.dat_ecr) between '01/01/2020' and '31/12/2021'
)
and flg_emis_recu='R'
and cod_statut <> 'TR'
--order by ide_nd_dest,ide_mess
)
;