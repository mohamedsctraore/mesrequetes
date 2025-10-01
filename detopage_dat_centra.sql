--select * from fc_ligne a
update fc_ligne a set dat_centra=null
where (a.ide_poste, a.ide_gest, a.ide_jal, a.flg_cptab, a.ide_ecr)
in 
(select ide_poste, ide_gest, ide_jal, flg_cptab, ide_ecr from fc_ecriture 
    where ide_gest='2021'
    and ide_poste='268'
    and dat_jc='30/08/2021'
)
and ide_cpt like '390%'
and ide_cpt not like '39031%'
;