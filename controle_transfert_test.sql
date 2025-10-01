select ide_poste,IDE_JAL, IDE_ECR, VAR_CPTA, ide_cpt, cod_sens,spec1,spec2,spec3,observ,dat_centra 
from fc_ligne
where (mt,observ) in (
select mt, observ from fc_ligne
where ide_poste='620C'
and spec3='503'
and ide_gest='2021'
and dat_transf is not null
minus
select mt, observ from fc_ligne
where ide_poste='503'
and ide_gest='2021'
)