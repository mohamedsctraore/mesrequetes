select spec3,ide_gest,ide_cpt, mt, observ from fc_ligne where
(ide_poste,ide_gest,ide_jal,flg_cptab,ide_ecr)
in (select ide_poste, ide_gest,ide_jal,flg_cptab,ide_ecr 
from fc_ecriture where 
ide_gest in ('2021')
and ide_poste in ('226C')
)
and spec3='201C'
and flg_cptab='O'
and cod_sens='D'

minus 

select ide_poste,ide_gest,ide_cpt, mt, observ from fc_ligne where
(ide_poste,ide_gest,ide_jal,flg_cptab,ide_ecr)
in (select ide_poste, ide_gest,ide_jal,flg_cptab,ide_ecr 
from fc_ecriture where 
ide_gest in ('2021')
and ide_poste in ('201C')
and ide_nd_emet='226C'
and ide_jal='JTRANSFERT'
and cod_sens='C'
and ide_cpt='39111'
)