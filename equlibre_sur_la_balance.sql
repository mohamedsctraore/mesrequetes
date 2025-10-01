---------- EQUILIBRE  --------------------
select sum(decode(cod_sens, 'D', mt, -mt))
from fc_ligne
where ide_gest = '2025'
and flg_cptab = 'O'
and dat_ecr <= '31/08/2025'
--having (sum(decode(cod_sens, 'D', mt, 0)) - sum(decode(cod_sens, 'C', mt, 0)) ) <> 0
; 

---------- EQUILIBRE PAR JOURNAL  --------------------
select ide_jal, sum(decode(cod_sens, 'D', mt, -mt))
from fc_ligne
where ide_gest = '2025'
and flg_cptab = 'O'
and dat_ecr <= '31/07/2025'
group by ide_jal
having (sum(decode(cod_sens, 'D', mt, 0)) - sum(decode(cod_sens, 'C', mt, 0)) ) <> 0
; 

------------- POSTE RESPONSABLE  ------------------------
select ide_poste, sum(decode(cod_sens, 'D', mt, -mt))
from fc_ligne
where ide_gest = '2025'
and flg_cptab = 'O'
and dat_ecr <= '31/07/2025'
--and ide_devise = 'EUR'
and ide_jal = 'T29ACCD'
--and ide_poste = '461'
group by ide_poste
having (sum(decode(cod_sens, 'D', mt, 0)) - sum(decode(cod_sens, 'C', mt, 0)) ) <> 0
;

--------------  POSTE RESPONSABLE SUR QUEL ECRITURE ----------------------------
select ide_poste, ide_ecr, ide_jal, sum(decode(cod_sens, 'D', mt, -mt))
from fc_ligne
where ide_gest = '2025'
and flg_cptab = 'O'
and dat_ecr <= '31/08/2025'
--and ide_devise = 'EUR'
and ide_jal = 'A29'
and ide_poste = '425'
group by ide_poste, ide_ecr, ide_jal
having (sum(decode(cod_sens, 'D', mt, 0)) - sum(decode(cod_sens, 'C', mt, 0)) ) <> 0
;

