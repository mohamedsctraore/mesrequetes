select spec3, mt, observ
from fc_ligne
where (ide_poste, ide_ecr, ide_gest, ide_jal, flg_cptab)
in
(
select ide_poste, ide_ecr, ide_gest, ide_jal, flg_cptab
from fc_ecriture where
ide_gest = '2024'
and ide_poste = '507'
and dat_jc = '19/08/2024'
)
and ide_cpt in ('39111','39112')
and spec3 is not null

minus

select ide_poste, mt, observ
from fc_ligne
where (ide_poste, ide_ecr, ide_gest, ide_jal, flg_cptab)
in
(
select ide_poste, ide_ecr, ide_gest, ide_jal, flg_cptab
from fc_ecriture where
ide_gest = '2024'
and ide_nd_emet = '507'
and libn like 'Transfert 507 du 19/08/24'
)
and ide_cpt in ('39111','39112')
;
