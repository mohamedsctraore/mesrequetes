select ide_poste, ide_gest, ide_jal, ide_ecr, ide_cpt, mt debit, 0 credit, observ, dat_ecr  from fc_ligne 
where (ide_poste, ide_gest, flg_cptab, ide_ecr, mt)
in
(
select ide_poste, ide_gest, flg_cptab, ide_ecr, mt from fc_ligne
where ide_gest = '2023'
and ide_poste = '501'
and ide_cpt = '4751108'
and cod_sens = 'C'
and upper(observ) like '%CAUT%'
)
and cod_sens = 'D'


union 

select ide_poste, ide_gest, ide_jal, ide_ecr, ide_cpt, 0 debit, mt credit, observ, dat_ecr  from fc_ligne 
where (ide_poste, ide_gest, flg_cptab, ide_ecr, mt)
in
(
select ide_poste, ide_gest, flg_cptab, ide_ecr, mt from fc_ligne
where ide_gest = '2023'
and ide_poste = '501'
and ide_cpt = '4751108'
and cod_sens = 'C'
and upper(observ) like '%CAUT%'
)
and cod_sens = 'C'

order by ide_ecr, dat_ecr
;