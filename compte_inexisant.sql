select unique ide_cpt
from fc_ligne
where (ide_poste, ide_gest, flg_cptab, ide_ecr, flg_cptab)
in
(
select ide_poste, ide_gest, flg_cptab, ide_ecr, flg_cptab
from fc_ecriture
where ide_gest = '2024'
and ide_poste = '850C'
and ide_mess = 36779
)
and ide_cpt not in (select unique ide_cpt from rc_droit_compte where ide_typ_poste = 'TCDGD' and var_cpta = 'C2020')