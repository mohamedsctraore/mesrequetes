Select * From Fc_Ligne
Where (ide_gest, ide_poste, ide_jal, ide_ecr, flg_cptab)
In
(
Select ide_gest, ide_poste, ide_jal, ide_ecr, flg_cptab
From fc_ecriture
Where Ide_Gest = '2025'
And Ide_jal = 'JTRANSFERT'
And Libn Like 'Transfert 999C du 01/08/25'
)
;

--Select * From Fc_Ecriture
--Where Ide_Gest = '2025'
--And Ide_jal = 'JTRANSFERT'
--And Libn Like 'Transfert 999C du 01/08/25'
--and Ide_poste <> '503'
--;

--Select * From Fc_Ligne
Update Fc_Ligne Set Dat_Ecr = '31/07/2025'
Where (ide_gest, ide_poste, ide_jal, ide_ecr, flg_cptab)
In
(
Select ide_gest, ide_poste, ide_jal, ide_ecr, flg_cptab
From fc_ecriture
Where Ide_Gest = '2025'
And Ide_jal = 'JTRANSFERT'
And Libn Like 'Transfert 999C du 31/07/25'
And Dat_Jc >= '01/08/2025'
and Ide_poste <> '503'
)
And Flg_Cptab = 'O'
;

--Select * From Fc_Ecriture
Update Fc_Ecriture Set Dat_Jc = '31/07/2025', Dat_Ecr = '31/07/2025'
Where Ide_Gest = '2025'
And Ide_jal = 'JTRANSFERT'
And Libn Like 'Transfert 999C du 31/07/25'
And Dat_Jc >= '01/08/2025'
and Ide_poste <> '503'
And Flg_Cptab = 'O'
;