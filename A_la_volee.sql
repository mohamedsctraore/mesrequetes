Select * From Fc_Ecriture@LkAstWeb
Where Ide_Gest = '2024'
And ide_Poste = '644'
And Ide_Piece In
(
Select Rgl_Num
From Cut.Cut_Reglement@Lkcut
Where Pc_code = '644'
And rgl_dte_reglement like '%/24%'
And RGL_CODE_OP Like '%@Actualisation Paiement Virement%'
And RGL_MRG_CODE = '02'
Union
Select Ret_Num
From Cut.Cut_Retenue@LkCut
Where ret_dte_reglement like '%/24%'
And Ret_Rgl_Num In
(
Select Rgl_Num
From Cut.Cut_Reglement@Lkcut
Where Pc_code = '644'
And rgl_dte_reglement like '%/24%'
And RGL_CODE_OP Like '%@Actualisation Paiement Virement%'
And RGL_MRG_CODE = '02'
)
--And Ret_CODE_OP Like '%@Actualisation Paiement Virement%'
)
--And Length(Ide_Piece) < 15
;