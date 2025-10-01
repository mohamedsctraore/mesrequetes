--Select * From Fc_Ligne
Update Fc_Ligne Set Mt_Dev = Mt, val_taux = 1
Where (ide_gest, ide_poste, ide_jal, ide_ecr, flg_cptab)
In
(
Select ide_gest, ide_poste, ide_jal, ide_ecr, flg_cptab
From fc_ecriture
Where Ide_Gest = '2025'
And Ide_Poste Like '510'
and flg_cptab = 'O'
--and ide_jal <> 'TREP'
)
And (mt_dev <> mt or (mt_dev is null and mt is not null))
and ide_cpt <> '397';