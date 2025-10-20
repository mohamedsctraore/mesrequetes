Select unique ide_poste, ide_piece from fc_reglement
where ide_gest = '2025'
and ide_poste = '423'
minus
Select unique ide_poste, substr(observ,-15) from fc_ligne
where (ide_gest, ide_poste, ide_jal, ide_ecr, flg_cptab)
In
(
Select ide_gest, ide_poste, ide_jal, ide_ecr, flg_cptab
From fc_ecriture
Where Ide_Gest in ('2025')
and ide_poste = '423'
)
--and observ like '%317109825101108%'
and upper(ide_schema) like '%MER%'
;