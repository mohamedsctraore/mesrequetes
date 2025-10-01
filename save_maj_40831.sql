Select Ide_Poste, Ide_Cpt, Count(*) From Fc_Ligne Where (Ide_Poste, Ide_Gest, Ide_Jal, Flg_Cptab, Ide_Ecr)
In
(
    Select Ide_Poste, Ide_Gest, Ide_Jal, Flg_Cptab, Ide_Ecr From Fc_Ecriture
    Where (Ide_Poste, Ide_Gest, Ide_PIece)
    In
    (
        Select Ide_Poste, Ide_Gest, Ide_PIece From Fb_Piece
        Where Ide_Gest = '2025'
        And Ide_Poste Like '4%C'
        And TYPE_ACTE = 'M'
        And Cod_Statut = 'VI'
    )
)
And Ide_Cpt = '40831'
Group By Ide_Poste, Ide_Cpt
Having ( Mod(Count(*), 2)  <> 0 )
Order By Ide_Poste
;

Drop Table PPPZ;

Create Table PPPZ as
Select Ide_Poste, Ide_Piece, Count(Ide_Piece) PIECE_S From Fc_Ecriture
    Where (Ide_Poste, Ide_Gest, Ide_PIece)
    In
    (
        Select Ide_Poste, Ide_Gest, Ide_PIece From Fb_Piece
        Where Ide_Gest = '2025'
        And Ide_Poste Like '4%C'
        And TYPE_ACTE = 'M'
        And Cod_Statut = 'VI'
    )
Group By Ide_Poste, Ide_Piece
Having Mod(Count(Ide_Piece),2) <> 0
Order By Ide_Poste--, Ide_Piece
;

Select Unique Ide_Poste From PPPZ Order By 1;

Select * From PPPZ;