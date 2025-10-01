select * from fc_ligne 
--update fc_ligne set ide_cpt = '573', ide_modele_lig = 'C 573'
where (ide_poste, ide_gest, flg_cptab, ide_jal, ide_ecr) in
(select ide_poste, ide_gest, flg_cptab, ide_jal, ide_ecr
from fc_ecriture where
ide_gest = '2022'
and ide_poste like '3%'
and flg_cptab = 'N'
and ide_jal = 'T29EPN'
--and dat_maj like '03/08/22%'
and ide_mess in 
(
   select ide_mess from fm_message
   where --commentaire is not null
   ide_gest = '2022'
   and cod_typ_mess = '24'
   and ide_nd_emet like '3%'
   and libl like '%CUT%/%/2022%'
)
)
and ide_cpt = '572'
--and cod_sens = 'C'