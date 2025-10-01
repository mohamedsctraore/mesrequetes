select * from fc_ligne where
(mt, observ, ide_cpt)
in
(
select mt, observ, ide_cpt from fc_ligne
where (ide_poste, ide_ecr, ide_gest, ide_jal, flg_cptab)
in
(
select ide_poste, ide_ecr, ide_gest, ide_jal, flg_cptab
from fc_ecriture where
ide_poste in (select ide_poste from rm_poste where ide_poste='603C' or ide_poste_centra='603C')
and ide_gest = '2024'
and dat_jc between '01/02/2024' and '29/02/2024'
and ide_jal <> 'JCENTRAL'
)
and ide_cpt in 
(
'390303011'
)

minus 

select mt, observ, ide_cpt from fc_ligne
where (ide_poste, ide_ecr, ide_gest, ide_jal, flg_cptab)
in
(
select ide_poste, ide_ecr, ide_gest, ide_jal, flg_cptab
from fc_ecriture where
ide_poste in (select ide_poste from rm_poste where ide_poste='603C' or ide_poste_centra='603C')
and ide_gest = '2024'
and dat_jc between '01/02/2024' and '29/02/2024'
and ide_jal = 'JCENTRAL'
)
and ide_cpt in 
(
'390303011'
)
)
and ide_poste = '603C'
and ide_gest = '2024'
;
