select ide_poste, ide_ecr, ide_jal
from fc_ligne
where ide_gest = '2024'
and flg_cptab = 'O'
and ide_jal = 'JPECDEPBG'
group by ide_poste, ide_jal, ide_ecr
having (sum(decode(cod_sens, 'D', mt, 0)) - sum(decode(cod_sens, 'C', mt, 0))) <> 0;