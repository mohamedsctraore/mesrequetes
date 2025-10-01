select spec3, ide_cpt, mt, observ
from fc_ligne
where (ide_poste, ide_gest, ide_jal, flg_cptab, ide_ecr)
in
(
select ide_poste, ide_gest, ide_jal, flg_cptab, ide_ecr
from fc_ecriture
where ide_gest  = '2024'
and ide_poste = '507'
and dat_jc = '25/10/2024'
)
and spec3 is not null and ide_cpt in ('39111','39112')
minus
select ide_poste, ide_cpt, mt, observ
from fc_ligne
where (ide_poste, ide_gest, ide_jal, flg_cptab, ide_ecr)
in
(
select ide_poste, ide_gest, ide_jal, flg_cptab, ide_ecr
from fc_ecriture
where ide_gest  = '2024'
and libn like 'Transfert 507 du 25/10/24'
)
and ide_cpt in ('39111','39112')
;