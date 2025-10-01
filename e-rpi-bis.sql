--Select * From Fc_Ligne
Update Fc_Ligne Set Dat_Ecr = '31/07/2025'
Where (ide_gest, ide_poste, ide_jal, ide_ecr, flg_cptab)
In
(
Select ide_gest, ide_poste, ide_jal, ide_ecr, flg_cptab
From fc_ecriture
Where Ide_Gest = '2025'
And Ide_Poste = '999'
And Ide_Ecr In
(
122,
121,
120,
119,
118,
117,
116,
115,
114,
113,
112,
111,
110,
109,
108
)

)

;

--Select * From Fc_Ecriture
Update Fc_Ecriture Set Dat_Jc = '31/07/2025', Dat_Ecr = '31/07/2025'
Where Ide_Gest = '2025'
And Ide_Poste = '999'
--And Dat_Jc = '01/08/2025'
And Ide_Ecr In
(
122,
121,
120,
119,
118,
117,
116,
115,
114,
113,
112,
111,
110,
109,
108
)
;

--Select * From Fc_Ligne
Update Fc_Ligne Set Dat_ecr = '31/07/2025'
Where (ide_gest, ide_poste, ide_jal, ide_ecr, flg_cptab)
In
(
Select ide_gest, ide_poste, ide_jal, ide_ecr, flg_cptab
From fc_ecriture
Where Ide_Gest = '2025'
And Ide_Poste = '999C'
And Libn Like 'Centralisation 999 du 01/08/25'
And Ide_Ecr In
(
87,89,90,91,92,93,94,95,96,97,98,99,100,101,102
)
)
;

--Select * From Fc_Ecriture
Update Fc_Ecriture Set Dat_Ecr = '31/07/2025', Dat_Jc = '31/07/2025', Libn = 'Centralisation 999 du 31/07/25'
Where Ide_Gest = '2025'
And Ide_Poste = '999C'
--And Libn Like 'Centralisation 999 du 01/08/25'
And Ide_Ecr In
(
87,89,90,91,92,93,94,95,96,97,98,99,100,101,102
)
;