Drop Table Coherence_PGAE;

Create Table Coherence_PGAE as
Select 'S' cible, Ret_Num, Ret_Montant
From CUT.Cut_Retenue@LkCut
Where Pc_Code = '503'
And To_Date(Ret_Dte_Reglement, 'DD/MM/RRRR') = '23/04/2025'
And Ret_Statut In ('V','P')
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
And Length(b.Ide_Piece) <= 14
Group By Ide_Piece
Order By 2,1
;

Select * From Coherence_PGAE;

Drop Table Ref_Coherence_PGAE_Ret;

Create Table Ref_Coherence_PGAE_Ret As
Select Ret_Num, Sum(Decode(Cible, 'A', Ret_Montant, -Ret_Montant)) mt
From Coherence_PGAE
Group By Ret_Num
Having Sum(Decode(Cible, 'A', Ret_Montant, -(Ret_Montant*2)))  <> 0
;