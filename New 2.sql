DECLARE
    CURSOR c_balais is SELECT Ide_Poste, Ide_Cpt, Ide_Ref_Piece, Mt_Dev, Mt FROM Ref_pieces WHERE Ide_Poste = '405' ORDER BY 1,3;
    V_SENS_SOLDE PIAF_ADM.FC_LIGNE.COD_SENS%TYPE;
    V_SENS_CONTREPARTIE PIAF_ADM.FC_LIGNE.COD_SENS%TYPE;
    V_IDE_ECR PIAF_ADM.FC_LIGNE.IDE_ECR%TYPE;
    V_MODELE_LIGNE PIAF_ADM.FC_LIGNE.IDE_MODELE_LIG%TYPE;
    V_MODELE_LIGNE_CONTREPARTIE PIAF_ADM.FC_LIGNE.IDE_MODELE_LIG%TYPE;
    V_LIBELLE PIAF_ADM.FC_ECRITURE.LIBN%TYPE;
    V_COD_REF_PIECE PIAF_ADM.FC_REF_PIECE.COD_REF_PIECE%TYPE;
    V_DEVISE PIAF_ADM.FC_REF_PIECE.IDE_DEVISE%TYPE;
BEGIN
    FOR ligne in c_balais
        LOOP
            DBMS_OUTPUT.PUT_LINE(ligne.Ide_Poste || ' ' || ligne.Ide_Ref_Piece || ' ' || ligne.Mt);
            
            SELECT COD_SENS_SOLDE INTO V_SENS_SOLDE FROM RC_DROIT_COMPTE WHERE IDE_CPT = ligne.Ide_Cpt AND IDE_TYP_POSTE = 'P';
            SELECT MAX(IDE_ECR) + 1 INTO V_IDE_ECR FROM FC_ECRITURE WHERE IDE_POSTE = ligne.Ide_Poste AND IDE_JAL = 'A29' And Ide_Gest = '2025';
            SELECT COD_REF_PIECE, IDE_DEVISE INTO V_COD_REF_PIECE, V_DEVISE FROM FC_REF_PIECE WHERE IDE_POSTE = ligne.ide_poste AND IDE_REF_PIECE = ligne.ide_ref_piece;
            IF ligne.mt < 0 THEN
                V_LIBELLE := 'Comptabilisation des écarts negatifs sur piece ' || ligne.Ide_Ref_Piece;
                IF V_SENS_SOLDE = 'C' THEN
                    V_SENS_SOLDE := 'D';
                    V_SENS_CONTREPARTIE := 'D';
                    V_MODELE_LIGNE := 'DEBIT';
                ELSE
                    V_SENS_SOLDE := 'C';
                    V_SENS_CONTREPARTIE := 'C';
                    V_MODELE_LIGNE := 'CREDIT';
                END IF;
            --END IF;
                
                INSERT INTO FC_ECRITURE (IDE_POSTE, IDE_GEST, IDE_JAL, FLG_CPTAB, IDE_ECR, DAT_JC, VAR_CPTA, IDE_SCHEMA, LIBN, DAT_SAISIE, DAT_ECR, COD_STATUT, DAT_CRE, UTI_CRE, DAT_MAJ, UTI_MAJ, TERMINAL) VALUES
                (ligne.Ide_Poste, '2025', 'A29', 'O', V_IDE_ECR, TO_DATE('10/10/2025','DD/MM/RRRR'), 'C2020', 4, V_LIBELLE, SYSDATE, TO_DATE('10/10/2025','DD/MM/RRRR'), 'CO', SYSDATE, 'ECART', SYSDATE, 'ECART', 'ECART');
                INSERT INTO FC_LIGNE (IDE_POSTE, IDE_GEST, IDE_JAL, FLG_CPTAB, IDE_ECR, IDE_LIG, VAR_CPTA, IDE_CPT, IDE_REF_PIECE, COD_REF_PIECE, COD_SENS, MT, OBSERV, IDE_SCHEMA, COD_TYP_SCHEMA, IDE_MODELE_LIG, DAT_ECR, DAT_CRE, UTI_CRE, DAT_MAJ, UTI_MAJ, TERMINAL, FLG_ANNUL_DCST, IDE_DEVISE, MT_DEV)
                VALUES
                (ligne.Ide_Poste, '2025', 'A29', 'O', V_IDE_ECR, 1, 'C2020', ligne.ide_cpt, ligne.ide_ref_piece, V_COD_REF_PIECE, V_SENS_SOLDE, ligne.mt, 'Ecart sur piece ' || ligne.ide_ref_piece, 4, 'A', V_MODELE_LIGNE, TO_DATE('10/10/2025','DD/MM/RRRR'), SYSDATE, 'ECART', SYSDATE, 'ECART', 'ECART', 'N', V_DEVISE, 0);
                INSERT INTO FC_LIGNE (IDE_POSTE, IDE_GEST, IDE_JAL, FLG_CPTAB, IDE_ECR, IDE_LIG, VAR_CPTA, IDE_CPT, IDE_REF_PIECE, COD_REF_PIECE, COD_SENS, MT, OBSERV, IDE_SCHEMA, COD_TYP_SCHEMA, IDE_MODELE_LIG, DAT_ECR, DAT_CRE, UTI_CRE, DAT_MAJ, UTI_MAJ, TERMINAL, FLG_ANNUL_DCST, IDE_DEVISE, MT_DEV)
                VALUES
                (ligne.Ide_Poste, '2025', 'A29', 'O', V_IDE_ECR, 2, 'C2020', '3991', NULL, NULL, V_SENS_CONTREPARTIE, abs(ligne.mt), 'Ecart sur piece ' || ligne.ide_ref_piece, 4, 'A', V_MODELE_LIGNE || ' 3991', TO_DATE('10/10/2025','DD/MM/RRRR'), SYSDATE, 'ECART', SYSDATE, 'ECART', 'ECART', 'N', V_DEVISE, 0);
            ELSIF ligne.mt > 0 THEN
                V_LIBELLE := 'Comptabilisation des écarts positifs sur piece ' || ligne.Ide_Ref_Piece;
                
                IF V_SENS_SOLDE = 'C' THEN
                    V_SENS_SOLDE := 'C';
                    V_SENS_CONTREPARTIE := 'D';
                    V_MODELE_LIGNE := 'CREDIT';
                    V_MODELE_LIGNE_CONTREPARTIE := 'DEBIT 3991';    
                ELSE
                    V_SENS_SOLDE := 'D';
                    V_SENS_CONTREPARTIE := 'C';
                    V_MODELE_LIGNE := 'DEBIT';
                    V_MODELE_LIGNE_CONTREPARTIE := 'CREDIT 3991';
                END IF;
                
                INSERT INTO FC_ECRITURE (IDE_POSTE, IDE_GEST, IDE_JAL, FLG_CPTAB, IDE_ECR, DAT_JC, VAR_CPTA, IDE_SCHEMA, LIBN, DAT_SAISIE, DAT_ECR, COD_STATUT, DAT_CRE, UTI_CRE, DAT_MAJ, UTI_MAJ, TERMINAL) VALUES
                (ligne.Ide_Poste, '2025', 'A29', 'O', V_IDE_ECR, TO_DATE('10/10/2025','DD/MM/RRRR'), 'C2020', 4, V_LIBELLE, SYSDATE, TO_DATE('10/10/2025','DD/MM/RRRR'), 'CO', SYSDATE, 'ECART', SYSDATE, 'ECART', 'ECART');
                INSERT INTO FC_LIGNE (IDE_POSTE, IDE_GEST, IDE_JAL, FLG_CPTAB, IDE_ECR, IDE_LIG, VAR_CPTA, IDE_CPT, IDE_REF_PIECE, COD_REF_PIECE, COD_SENS, MT, OBSERV, IDE_SCHEMA, COD_TYP_SCHEMA, IDE_MODELE_LIG, DAT_ECR, DAT_CRE, UTI_CRE, DAT_MAJ, UTI_MAJ, TERMINAL, FLG_ANNUL_DCST, IDE_DEVISE, MT_DEV)
                VALUES
                (ligne.Ide_Poste, '2025', 'A29', 'O', V_IDE_ECR, 1, 'C2020', ligne.ide_cpt, ligne.ide_ref_piece, V_COD_REF_PIECE, V_SENS_SOLDE, ligne.mt, 'Ecart sur piece ' || ligne.ide_ref_piece, 4, 'A', V_MODELE_LIGNE, TO_DATE('10/10/2025','DD/MM/RRRR'), SYSDATE, 'ECART', SYSDATE, 'ECART', 'ECART', 'N', V_DEVISE, 0);
                INSERT INTO FC_LIGNE (IDE_POSTE, IDE_GEST, IDE_JAL, FLG_CPTAB, IDE_ECR, IDE_LIG, VAR_CPTA, IDE_CPT, IDE_REF_PIECE, COD_REF_PIECE, COD_SENS, MT, OBSERV, IDE_SCHEMA, COD_TYP_SCHEMA, IDE_MODELE_LIG, DAT_ECR, DAT_CRE, UTI_CRE, DAT_MAJ, UTI_MAJ, TERMINAL, FLG_ANNUL_DCST, IDE_DEVISE, MT_DEV)
                VALUES
                (ligne.Ide_Poste, '2025', 'A29', 'O', V_IDE_ECR, 2, 'C2020', '3991', NULL, NULL, V_SENS_CONTREPARTIE, abs(ligne.mt), 'Ecart sur piece ' || ligne.ide_ref_piece, 4, 'A', V_MODELE_LIGNE_CONTREPARTIE, TO_DATE('10/10/2025','DD/MM/RRRR'), SYSDATE, 'ECART', SYSDATE, 'ECART', 'ECART', 'N', V_DEVISE, 0);
            END IF;
            
            COMMIT;
            
        END LOOP;
        
END;