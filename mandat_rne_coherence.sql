CREATE TABLE MANDAT_RNE_MISSION_2024 (
 MANDAT VARCHAR2(255),
 MONTANT NUMBER
);

Select Mandat, Montant From MANDAT_RNE_MISSION_2024
minus
Select Ide_Piece, Mt From Fb_Piece
Where Ide_Gest = '2024'
And Ide_Poste Like '4%C'
And Type_Acte In ('M')
And Ide_Piece Not In
(
Select Ide_Piece_Init From Fb_Piece
Where Type_Acte = 'AM'
And Ide_Gest = '2024'
And Ide_Poste Like '4%C'
)
;

Select Ide_Piece, Mt From Fb_Piece
Where Ide_Gest = '2024'
And Ide_Poste Like '4%C'
And Type_Acte In ('M')
And Ide_Piece Not In
(
Select Ide_Piece_Init From Fb_Piece
Where Type_Acte = 'AM'
And Ide_Gest = '2024'
And Ide_Poste Like '4%C'
)
;

Select Ide_Nd_Emet, B.Libn, Ide_Piece mandat_annulation, Ide_Piece_Init mandat_initial, Mt, Cod_Statut From Fb_Piece a, Rm_Noeud b
Where A.Ide_Nd_Emet = B.Ide_Nd  
And Type_Acte = 'AM'
And Ide_Gest = '2024'
And Ide_Poste Like '4%C'
Order By 1
;

Select Ide_Nd_Emet, B.Libn Paierie, Count(ide_piece) nb_tresor, Sum(Mt) From Fb_Piece a, Rm_Noeud b
Where A.Ide_Nd_Emet = B.Ide_Nd 
And Ide_Gest = '2024'
And Ide_Poste Like '4%C'
And Type_Acte In ('M')
And Ide_Piece Not In
(
Select Ide_Piece_Init From Fb_Piece
Where Type_Acte = 'AM'
And Ide_Gest = '2024'
And Ide_Poste Like '4%C'
)
Group By Ide_Nd_Emet, B.Libn
Order By 1
;