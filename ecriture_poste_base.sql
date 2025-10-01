select * from fc_ecriture where 
ide_gest='2021'
and ide_poste='270'
and dat_jc='13/09/2021'
--and ide_mess in ('132816')
;

select * from fc_ligne where (ide_poste, ide_gest, ide_jal, flg_cptab, ide_ecr)
in (select ide_poste, ide_gest, ide_jal, flg_cptab, ide_ecr from fc_ecriture where 
ide_gest='2021'
and ide_poste='270'
and dat_jc='13/09/2021'
--and ide_mess in ('9862')
--and mt=20000
)
and ide_cpt like '390%'
--and ide_cpt like '390303023'
;