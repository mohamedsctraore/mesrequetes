drop table ctl_accd;

create table ctl_accd as
select ide_poste, ide_gest, ide_jal, flg_cptab, ide_ecr, mt, observ, spec3, dat_ecr, count(ide_ecr) nb
from fc_ligne
where (ide_poste, ide_gest, flg_cptab, ide_jal, ide_ecr) in
(select ide_poste, ide_gest, flg_cptab, ide_jal, ide_ecr
from fc_ecriture where
ide_gest = '2022'
and ide_nd_emet like '2%'
and libn like 'Centralisation %'
and ide_poste like '2%'
)
and ide_poste like '2%C'
group by ide_poste, ide_gest, ide_jal,flg_cptab, ide_ecr, mt, observ, spec3, dat_ecr
order by ide_poste, ide_ecr;

select *
from ctl_accd
where nb <> 1
and spec3 is not null;