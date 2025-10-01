--select * from fc_ligne
--update fc_ligne set spec3 = '503'
update fc_ligne set ide_cpt = '448242', spec1=null,spec2=null,spec3=null, ide_modele_lig='DEBIT'
--, var_tiers = null, ide_tiers = null
where (ide_poste,ide_gest,ide_jal,flg_cptab,ide_ecr)
in (select ide_poste, ide_gest,ide_jal,flg_cptab,ide_ecr
from fc_ecriture where 
ide_gest = '2023'
and ide_poste = '626'
and ide_mess in (16919,16920)
--and ide_ecr between 28596 and 28892
)
--and flg_cptab = 'N'
and ide_cpt = '390303021'
--and ide_ecr between 29181 and 29183
--and spec3 = '@PC'
;