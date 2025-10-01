Drop Table Pieces_Pas_Reprise;

Create Table Pieces_Pas_Reprise as
Select 'BS' cible, ide_Ref_Piece, Sum(Decode(Cod_Sens, 'D', Mt, -Mt)) Mt
From Fc_Ligne
Where (ide_poste, ide_gest, flg_cptab, ide_ecr, ide_jal)
in
(select ide_poste, ide_gest, flg_cptab, ide_ecr, ide_jal
from fc_ecriture
where ide_gest = '2024'
and ide_poste = '&&poste'
)
and ide_cpt = '&&compte'
Group By ide_Ref_Piece, Cod_ref_Piece
Having Sum(Decode(Cod_Sens, 'D', Mt, -Mt)) <> 0
Union
Select 'BE' cible, ide_Ref_Piece, Sum(Decode(Cod_Sens, 'D', Mt, -Mt)) Mt
From Fc_Ligne
Where (ide_poste, ide_gest, flg_cptab, ide_ecr, ide_jal)
in
(select ide_poste, ide_gest, flg_cptab, ide_ecr, ide_jal
from fc_ecriture
where ide_gest = '2025'
and ide_poste = '&&poste'
and ide_jal = 'TREP'
)
and ide_cpt = '&&compte'
Group By ide_Ref_Piece, Cod_ref_Piece
Having Sum(Decode(Cod_Sens, 'D', Mt, -Mt)) <> 0
Order by 2,1
;

Select Ide_Ref_Piece, Sum(Decode(Cible, 'BS', Mt, -Mt)) 
From Pieces_Pas_Reprise
Group By Ide_Ref_Piece
Having Sum(Decode(Cible, 'BS', Mt, -Mt)) <> 0
Order By 1;

Select * From Pieces_Pas_Reprise;