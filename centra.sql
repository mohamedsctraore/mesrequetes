select a.ide_gest,a.ide_cpt,a.mt,a.observ from fc_ligne a, fc_ecriture b 
where (a.ide_poste, a.ide_gest, a.flg_cptab, a.ide_ecr)
in 
(select ide_poste, ide_gest, ide_jal, flg_cptab, ide_ecr from fc_ecriture 
where ide_poste='684'
and a.ide_gest='2021')
and a.ide_poste=b.ide_poste
and a.ide_gest=b.ide_gest
and a.ide_jal=b.ide_jal
and a.flg_cptab=b.flg_cptab
and a.ide_ecr=b.ide_ecr
and a.ide_gest=b.ide_gest
and a.flg_cptab='O'
and a.ide_cpt like '390%'
and a.ide_cpt not like '39031%'
MINUS
select a.ide_gest,a.ide_cpt,a.mt,a.observ from fc_ligne a, fc_ecriture b 
where (a.ide_poste, a.ide_gest, a.flg_cptab, a.ide_ecr)
in 
(select ide_poste, ide_gest, ide_jal, flg_cptab, ide_ecr from fc_ecriture 
where ide_poste='603C'
and a.ide_gest='2021')
and a.ide_poste=b.ide_poste
and a.ide_gest=b.ide_gest
and a.ide_jal=b.ide_jal
and a.flg_cptab=b.flg_cptab
and a.ide_ecr=b.ide_ecr
and a.ide_gest=b.ide_gest
and a.ide_cpt like '390%'
and a.ide_cpt not like '39031%'
;

