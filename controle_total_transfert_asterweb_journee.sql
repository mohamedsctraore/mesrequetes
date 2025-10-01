Drop Table Table_Transfert_2025;

Create Table Table_Transfert_2025 as
Select 'E' cible, a.ide_poste, spec3, ide_cpt, sum(decode(cod_sens, 'C', mt, -mt)) mt, to_date(b.dat_jc,'dd/mm/rrrr') dat_jc
From fc_ligne a, Fc_Ecriture b
Where a.Ide_Ecr = b.Ide_Ecr And a.ide_Poste = b.Ide_Poste And a.Ide_Gest = b.ide_Gest And a.Flg_Cptab = b.Flg_Cptab And a.Ide_Jal = b.Ide_Jal
And spec3 is not null
And a.Ide_Jal <> 'JTRANSFERT'
And a.Ide_Gest = '2025'
And a.Flg_Cptab = 'O'
And Ide_Cpt like '391%'
--And b.Dat_Jc between '01/01/2025' and '28/02/2025'
Group by a.ide_poste, spec3, ide_cpt, to_date(b.dat_jc,'dd/mm/rrrr')
Union
Select 'R' cible, ide_nd_emet, a.ide_poste, ide_cpt, Sum(decode(cod_sens, 'D', mt, -mt)) mt, to_date(substr(libn, -8), 'dd/mm/rrrr') dat_jc
From fc_ligne a, Fc_Ecriture b
Where a.Ide_Ecr = b.Ide_Ecr And a.ide_Poste = b.Ide_Poste And a.Ide_Gest = b.ide_Gest And a.Flg_Cptab = b.Flg_Cptab And a.Ide_Jal = b.Ide_Jal
And a.Ide_Jal = 'JTRANSFERT'
And ide_cpt like '391%'
And a.Ide_Gest = '2025'
And regexp_like (substr(libn, -8), '^[0-9]{2}\/[0-9]{2}\/[0-9]{2}$')
Group by ide_nd_emet, a.ide_poste, ide_cpt, to_date(substr(libn, -8), 'dd/mm/rrrr')
Order by 2,4,6,1
;

------------------------  MAJ DAT TRANSF DANS FC_LIGNE -----------------------------------------

Select ide_poste, spec3, ide_cpt, dat_jc, Sum(decode(cible, 'E', mt,-mt))
From Table_Transfert_2025
--Where spec3 in (Select ide_Poste From Rm_Poste Where Ide_Typ_Poste in ('AACDC','ACCD'))
Where Spec3 Like '2039C'
--Where spec3 in (Select ide_Poste From Rm_Poste Where Ide_Typ_Poste in ('TCDGI'))
--And Dat_Jc Between '06/05/2025' And '06/05/2025'
--And Ide_Poste In (Select ide_Poste From Rm_Poste Where Ide_Typ_Poste in ('TCDGI'))
--And Ide_Poste = '225C'
Group By ide_poste, spec3, ide_cpt, dat_jc
Having Sum(decode(cible, 'E', mt,-mt)) <> 0
Order By 2,1,4,3;

Select * From Table_Transfert_2025 
Where Spec3 = '21'
And Dat_jc = '05/02/2025'
--Where ide_poste = '507' 
--And Spec3= '242C' 
Order By 2,3,4,6,1;

--Select * from fc_ligne
Update fc_ligne set dat_transf = dat_cre
Where (ide_poste, ide_gest, ide_jal, flg_cptab, ide_ecr) in
(
Select ide_poste, ide_gest, ide_jal, flg_cptab, ide_ecr from fc_transfert where (ide_poste, ide_gest, ide_jal, flg_cptab, ide_ecr) in
(
Select ide_poste, ide_gest, ide_jal, flg_cptab, ide_ecr from fc_ligne
Where (ide_poste, ide_gest, ide_jal, flg_cptab, ide_ecr)
In
(
Select ide_poste, ide_gest, ide_jal, flg_cptab, ide_ecr
From fc_ecriture
Where ide_gest = '2024' 
And ide_poste = '903C'
And dat_jc = '31/12/2024'
And ide_jal = 'JCENTRAL'
)
--and spec3 = '503'
And ide_cpt like '391%'
)
)
And ide_cpt like '391%'
And dat_transf is null
;