Drop Table Doublon_PGAE_AstWeb;

Create Table Doublon_PGAE_AstWeb as
Select Ide_Piece, Max(Ide_Ecr) Ide_Ecr From Fc_Ecriture@lkastweb
Where (ide_poste, ide_gest, flg_cptab, ide_ecr, ide_jal)
in
(select ide_poste, ide_gest, flg_cptab, ide_ecr, ide_jal
from fc_ecriture@lkastweb
where ide_gest = '2025'
and ide_poste = '503'
and ide_piece in
(
Select unique Rgl_Num From Ref_Coherence_PGAE
union
Select unique Ret_Num From Ref_Coherence_PGAE_Ret
)
)
Group By Ide_Piece
Order By ide_Piece
;

Select * From Fc_Ligne@LkAstWeb
Where (ide_poste, ide_gest, flg_cptab, ide_ecr, ide_jal)
in
(select Ide_poste, Ide_gest, Flg_Cptab, Ide_Ecr, Ide_jal
From Fc_Ecriture@LkAstWeb
Where Ide_gest = '2025'
And Ide_Poste = '503'
And (Ide_Piece,Ide_Ecr) In
(
Select Ide_Piece, Ide_Ecr From Doublon_PGAE_AstWeb
)
)
;

--Select * From Fc_Ligne@LkAstWeb
Delete From Fc_Ligne@LkAstWeb
Where (ide_poste, ide_gest, flg_cptab, ide_ecr, ide_jal)
in
(select Ide_poste, Ide_gest, Flg_Cptab, Ide_Ecr, Ide_jal
From Fc_Ecriture@LkAstWeb
Where Ide_gest = '2025'
And Ide_Poste = '503'
And (Ide_Piece,Ide_Ecr) In
(
Select Ide_Piece, Ide_Ecr From Doublon_PGAE_AstWeb
)
)
;

--Select * From Fc_Ecriture@LkAstWeb
Delete From Fc_Ecriture@LkAstWeb
Where Ide_gest = '2025'
And Ide_Poste = '503'
And (Ide_Piece,Ide_Ecr) In
(
Select Ide_Piece, Ide_Ecr From Doublon_PGAE_AstWeb
)