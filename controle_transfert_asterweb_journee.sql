-----------------  CREATION TABLE TRAVAIL ------------------------------
Drop Table ctl_masse_trf_web;

Create table ctl_masse_trf_web as
Select 'E' cible, spec3, ide_cpt, sum(decode(cod_sens, 'C', mt, -mt)) mt
From fc_ligne
Where (ide_poste, ide_gest, flg_cptab, ide_ecr, ide_jal)
In
(Select ide_poste, ide_gest, flg_cptab, ide_ecr, ide_jal
From fc_ecriture
Where ide_gest = '&&gestion'
And ide_poste = '&&poste'
And dat_jc = '&&journee'
)
And spec3 is not null
Group by spec3, ide_cpt
Union
Select 'R' cible, ide_poste, ide_cpt, Sum(decode(cod_sens, 'D', mt, -mt)) mt
From fc_ligne
Where (ide_poste, ide_gest, flg_cptab, ide_ecr, ide_jal)
In
(Select ide_poste, ide_gest, flg_cptab, ide_ecr, ide_jal
From fc_ecriture
Where ide_gest = '&&gestion'
And ide_jal = 'JTRANSFERT'
And libn like 'Transfert &&poste du &&journee'
)
And ide_cpt like '391%'
Group by ide_poste, ide_cpt
Order by 2,3,1
;

Select * from ctl_masse_trf_web Order By 2,3,1;

Select spec3, ide_cpt, Sum(decode(cible, 'E', mt,-mt))
From ctl_masse_trf_web
Group By spec3, ide_cpt
Having Sum(decode(cible, 'E', mt,-mt)) <> 0
Order By 1;

--------------- MAJ LIGNE FC_TRANSFERT -------------------------------

--Select * from fc_transfert
Delete from fc_transfert 
where (ide_poste, ide_gest, ide_jal, ide_ecr, ide_lig)
in
(
select ide_poste, ide_gest, ide_jal, ide_ecr, ide_lig from fc_ligne
where (ide_poste, ide_gest, flg_cptab, ide_ecr, ide_jal)
in
(select ide_poste, ide_gest, flg_cptab, ide_ecr, ide_jal
from fc_ecriture
where ide_gest = '&&gestion'
and ide_poste = '&&poste'
and dat_jc = '&&journee'
)
and (spec3,ide_cpt) in
(
select spec3, ide_cpt
from ctl_masse_trf_web
Group By spec3, ide_cpt
Having Sum(decode(cible, 'E', mt,-mt)) <> 0
)
)
;

-------------- MAJ LIGNE DATE_TRANSFERT -----------------------------
--Select * from fc_ligne
Update fc_ligne set dat_transf = null 
where (ide_poste, ide_gest, flg_cptab, ide_ecr, ide_jal)
in
(select ide_poste, ide_gest, flg_cptab, ide_ecr, ide_jal
from fc_ecriture
where ide_gest = '&&gestion'
and ide_poste = '&&poste'
and dat_jc = '&&journee'
)
and (spec3,ide_cpt) in
(
select spec3, ide_cpt
from ctl_masse_trf_web
Group By spec3, ide_cpt
Having Sum(decode(cible, 'E', mt,-mt)) <> 0
)
;