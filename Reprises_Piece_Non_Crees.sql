Declare
    Cursor c_ref_piece is Select Ide_Gest, Ide_Poste, Ide_Jal, Ide_Ecr, Ide_Lig, Mt, Var_Tiers, Ide_Tiers, Ide_Ref_Piece, Cod_Ref_Piece, Dat_Ecr, Cod_Sens From Fc_Ligne
    Where Ide_Gest = '2024'
    and Ide_Poste = '502'
    And Ide_Ref_Piece in (
                            46499,
                            47765,
                            47814,
                            47815,
                            47816,
                            48215
                            );

Begin
    For Param_Ligne In c_ref_piece
        Loop
            IF Param_Ligne.Cod_Sens = 'D' Then
                Insert into PIAF_ADM.FC_REF_PIECE
                   (IDE_POSTE, IDE_REF_PIECE, COD_REF_PIECE, VAR_TIERS, IDE_TIERS, 
                    IDE_GEST, FLG_CPTAB, MT_DB, MT_CR, DAT_DER_MVT, 
                    FLG_SOLDE, IDE_JAL, IDE_ECR, IDE_LIG, DAT_CRE, 
                    UTI_CRE, DAT_MAJ, UTI_MAJ, TERMINAL, MT_DEV)
                Values
                   (Param_Ligne.Ide_Poste, Param_Ligne.Ide_Ref_Piece, Param_Ligne.Cod_Ref_Piece, Param_Ligne.Var_Tiers, Param_Ligne.Ide_Tiers, 
                    Param_Ligne.Ide_Gest, 'O', Param_Ligne.Mt, 0, TO_DATE(Param_Ligne.Dat_Ecr, 'DD/MM/YYYY'), 
                    'N', Param_Ligne.Ide_Jal, Param_Ligne.Ide_Ecr, Param_Ligne.Ide_Lig, TO_DATE('03/09/2020 08:40:12', 'DD/MM/YYYY HH24:MI:SS'), 
                    'PIAF_ADM', TO_DATE('03/09/2020 08:40:12', 'DD/MM/YYYY HH24:MI:SS'), 'PIAF_ADM', 'DSI0214B', Param_Ligne.Mt)
                ;
            
            ELSE
                Insert into PIAF_ADM.FC_REF_PIECE
                   (IDE_POSTE, IDE_REF_PIECE, COD_REF_PIECE, VAR_TIERS, IDE_TIERS, 
                    IDE_GEST, FLG_CPTAB, MT_DB, MT_CR, DAT_DER_MVT, 
                    FLG_SOLDE, IDE_JAL, IDE_ECR, IDE_LIG, DAT_CRE, 
                    UTI_CRE, DAT_MAJ, UTI_MAJ, TERMINAL, MT_DEV)
                Values
                   (Param_Ligne.Ide_Poste, Param_Ligne.Ide_Ref_Piece, Param_Ligne.Cod_Ref_Piece, Param_Ligne.Var_Tiers, Param_Ligne.Ide_Tiers, 
                    Param_Ligne.Ide_Gest, 'O', 0, Param_Ligne.Mt, TO_DATE(Param_Ligne.Dat_Ecr, 'DD/MM/YYYY'), 
                    'N', Param_Ligne.Ide_Jal, Param_Ligne.Ide_Ecr, Param_Ligne.Ide_Lig, TO_DATE('03/09/2020 08:40:12', 'DD/MM/YYYY HH24:MI:SS'), 
                    'PIAF_ADM', TO_DATE('03/09/2020 08:40:12', 'DD/MM/YYYY HH24:MI:SS'), 'PIAF_ADM', 'DSI0214B', Param_Ligne.Mt)
                ;
            END IF;
        End Loop;

End;