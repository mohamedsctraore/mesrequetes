select dat_ecr, sum(mt) 
from fc_ligne where (ide_poste, ide_gest, ide_jal, flg_cptab, ide_ecr)
in (select ide_poste, ide_gest, ide_jal, flg_cptab, ide_ecr 
from fc_ecriture where ide_poste in 
(select ide_poste from rm_poste where ide_poste='201C' or ide_poste_centra='201C')
and ide_gest='2021'
)
and cod_sens='D'
and ide_cpt like '390%'
and ide_cpt not like '39031%'
and FLG_CPTAB='O'
group by dat_ecr
order by dat_ecr
;