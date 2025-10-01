--Select Ide_Poste, Substr(Cod_Ref_Piece,23,15) From Fc_Ref_Piece
Update Fc_Ref_Piece Set Ide_Piece = Substr(Cod_Ref_Piece,23,15)
Where ide_poste Like '4%'
And Ide_Gest = '2025'
--And (Cod_ref_Piece Like '%317219524100526%' Or Cod_Ref_Piece Like '%317219524100612%' Or Cod_Ref_Piece Like '%317219524100613%')
--And Ide_Gest = '2024'
And IDE_Piece Is Null
And Cod_Ref_Piece Like '%BGDEP-2025%'
;