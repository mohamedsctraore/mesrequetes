select ide_gest, ide_poste, ide_ecr, ide_cpt, ide_tiers, cod_sens, 0 debit, mt credit, observ, dat_ecr
from fc_ligne
where ide_gest = '2024'
and cod_sens = 'C'
and ide_poste = '464'
and ide_cpt = '581122'
union
select ide_gest, ide_poste, ide_ecr, ide_cpt, ide_tiers, cod_sens, mt debit, 0 credit, observ, dat_ecr
from fc_ligne
where ide_gest = '2024'
and cod_sens = 'D'
and ide_poste = '501'
and ide_tiers like '%464%'
and ide_cpt = '581122'
union
select ide_gest, ide_poste, ide_ecr, ide_cpt, ide_tiers, cod_sens, mt debit, 0 credit, observ, dat_ecr
from fc_ligne
where ide_gest = '2024'
and cod_sens = 'D'
and ide_poste = '464'
and ide_cpt = '581122'
union
select ide_gest, ide_poste, ide_ecr, ide_cpt, ide_tiers, cod_sens, 0 debit, mt credit, observ, dat_ecr
from fc_ligne
where ide_gest = '2024'
and cod_sens = 'C'
and ide_poste = '501'
and ide_tiers like '%464%'
and ide_cpt = '581122'
order by dat_ecr
;