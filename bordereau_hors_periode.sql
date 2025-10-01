select unique b.ide_mess from fc_ligne a, fc_ecriture b where (a.ide_poste, a.ide_gest, a.ide_jal, a.flg_cptab, a.ide_ecr)
in 
(select ide_poste, ide_gest, ide_jal, flg_cptab, ide_ecr from fc_ecriture where  
ide_gest='2021'
and ide_poste='507'
and flg_cptab='N'
and cod_statut not like 'CO'
and ide_jal='JTRANSFERT'
)
and a.ide_poste=b.ide_poste
and a.ide_gest=b.ide_gest
and a.ide_jal=b.ide_jal
and a.flg_cptab=b.flg_cptab
and a.ide_ecr=b.ide_ecr
and to_date(a.dat_ref) >= to_date('01/10/2021')
;