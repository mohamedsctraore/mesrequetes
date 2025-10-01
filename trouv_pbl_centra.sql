select unique ide_poste, dat_centra, dat_ecr, dat_maj from fc_ligne where
(ide_poste, ide_gest, ide_jal, flg_cptab, ide_ecr) in
(
select ide_poste, ide_gest, ide_jal, flg_cptab, ide_ecr
from fc_ecriture where 
ide_gest='2023'
and dat_jc between '01/04/2023' and '07/05/2023'
and ide_poste in (select ide_poste from piaf_adm.rm_poste where ide_poste_centra = '649C')
)
and ide_cpt like '390%'
and ide_cpt <> '390311'
order by ide_poste, dat_ecr;
