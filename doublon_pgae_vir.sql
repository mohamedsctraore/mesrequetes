Drop Table Coherence_PGAE_PAI;

Create Table Coherence_PGAE_PAI as
Select 'S' cible, Rgl_Num, Rgl_Montant_Net
From CUT.Cut_Reglement@LkCut
Where Pc_Code = '503'
And To_Date(Rgl_Dte_Reglement, 'DD/MM/RRRR') = '23/04/2025'
And Rgl_Statut In ('V','P')
Union
Select Unique 'A' cible, Ide_Piece, Sum(Mt)
From Fc_Ligne@LkAstWeb a, Fc_Ecriture@LkAstWeb b
Where a.Ide_Gest = b.Ide_Gest
And a.Ide_Poste = b.Ide_Poste
And a.Ide_Ecr = b.Ide_Ecr
And a.Flg_Cptab = b.Flg_Cptab
And a.Ide_Jal = b.Ide_Jal
And a.Ide_Gest = '2025'
And a.Ide_Poste = '503'
And b.Ide_Mess in (Select unique ide_mess from fm_message@Lkastweb Where ide_nd_emet = '503' and cod_typ_mess = 24 and ide_gest = '2025' and libl like '%23/04/%')
And Cod_Sens = 'C'
And Length(b.Ide_Piece) > 14
Group By Ide_Piece
Order By 2,1
;

Select * From Coherence_PGAE_PAI;

Drop Table Ref_Coherence_PGAE;

Create Table Ref_Coherence_PGAE as
Select Rgl_Num, Sum(Decode(Cible, 'A', RGL_MONTANT_NET, -RGL_MONTANT_NET)) mt
From Coherence_PGAE_PAI
Group By Rgl_Num
Having Sum(Decode(Cible, 'A', RGL_MONTANT_NET, -RGL_MONTANT_NET))  <> 0
;