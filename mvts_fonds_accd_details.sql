select ide_gest, ide_poste, ide_ecr, ide_cpt, ide_tiers, cod_sens, 0 debit, mt credit, observ, dat_ecr
from fc_ligne
where ide_gest = '2024'
and cod_sens = 'C'
and ide_poste = '217'
and ide_cpt = '58112106'
and dat_ecr between '01/11/2024' and '30/11/2024'
union
select ide_gest, ide_poste, ide_ecr, ide_cpt, ide_tiers, cod_sens, mt debit, 0 credit, observ, dat_ecr
from fc_ligne
where ide_gest = '2024'
and cod_sens = 'D'
and ide_poste = '507'
and ide_tiers like '%217%'
and ide_cpt = '58112106'
and dat_ecr between '01/11/2024' and '30/11/2024'
union
select ide_gest, ide_poste, ide_ecr, ide_cpt, ide_tiers, cod_sens, mt debit, 0 credit, observ, dat_ecr
from fc_ligne
where ide_gest = '2024'
and cod_sens = 'D'
and ide_poste = '217'
and ide_cpt = '58112106'
and dat_ecr between '01/11/2024' and '30/11/2024'
union
select ide_gest, ide_poste, ide_ecr, ide_cpt, ide_tiers, cod_sens, 0 debit, mt credit, observ, dat_ecr
from fc_ligne
where ide_gest = '2024'
and cod_sens = 'C'
and ide_poste = '507'
and ide_tiers like '%217%'
and ide_cpt = '58112106'
and dat_ecr between '01/11/2024' and '30/11/2024'
order by dat_ecr
;