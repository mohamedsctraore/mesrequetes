select ide_poste, ide_gest, ide_jal, ide_ecr, ide_tiers, ide_cpt, cod_sens, mt, observ, dat_ecr
from fc_ligne
where (ide_poste, ide_ecr, ide_gest, ide_jal, flg_cptab)
in
(
select ide_poste, ide_ecr, ide_gest, ide_jal, flg_cptab
from fc_ecriture where
ide_gest = '2024'
and ide_poste = '657'
and dat_jc between '01/01/2024' and '31/10/2024'
and ide_mess not in (select ide_mess from fm_message where ide_gest = '2024' and ide_nd_emet = '657' and cod_typ_mess = 24 --and libl like '%EFFECTIF%'
)
)
--and dat_ref between '01/11/2024' and '30/11/2024'
and ide_cpt in ('531122','58112103','448241','448242','4482518','4482599','474311','474312','39030202','390303011','531122','47512223')
and cod_sens = 'D'
--and flg_cptab = 'N'
--group by ide_cpt, cod_sens, flg_cptab, cod_typ_schema
order by ide_cpt
;