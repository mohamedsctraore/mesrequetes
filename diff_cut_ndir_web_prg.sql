DECLARE
    my_table E000618.fc_ecriture_sygacut%ROWTYPE;

    CURSOR cur_fc_ecriture(v_ide_poste PIAF_ADM.FC_ECRITURE.IDE_POSTE%TYPE, v_ide_nd_emet PIAF_ADM.FC_ECRITURE.IDE_ND_EMET%TYPE, v_ide_mess PIAF_ADM.FC_ECRITURE.IDE_MESS%TYPE) is SELECT * FROM E000618.fc_ecriture_sygacut where ide_poste = v_ide_poste and ide_nd_emet = v_ide_nd_emet and ide_mess = v_ide_mess;
    
    CURSOR cur_fm_message is SELECT ide_gest, ide_nd_emet, ide_mess FROM E000618.fm_message_sygacut where ide_nd_emet <> '503';
    
    lv_ide_gest PIAF_ADM.FC_ECRITURE.IDE_GEST%TYPE;
    lv_ide_poste PIAF_ADM.FC_ECRITURE.IDE_POSTE%TYPE; 
    lv_ide_nd_emet PIAF_ADM.FC_ECRITURE.IDE_ND_EMET%TYPE; 
    lv_ide_piece PIAF_ADM.FC_ECRITURE.IDE_PIECE%TYPE; 
    lv_ide_mess PIAF_ADM.FC_ECRITURE.IDE_MESS%TYPE;
    lv_ide_mess_max PIAF_ADM.FC_ECRITURE.IDE_MESS%TYPE;
    lv_ide_ecr_max PIAF_ADM.FC_ECRITURE.IDE_ECR%TYPE; 
    lv_ide_jal PIAF_ADM.FC_ECRITURE.IDE_JAL%TYPE;    
    
BEGIN

    delete from tbl_message;
    delete from tbl_ligne;
    delete from tbl_ecriture;

    OPEN cur_fm_message;
    
    LOOP
        FETCH cur_fm_message INTO lv_ide_gest, lv_ide_nd_emet, lv_ide_mess;
        EXIT WHEN cur_fm_message%NOTFOUND;
        
        SELECT unique ide_jal INTO lv_ide_jal FROM E000618.fc_ecriture_sygacut where ide_gest = lv_ide_gest and ide_poste = lv_ide_nd_emet and ide_nd_emet = lv_ide_nd_emet and ide_mess = lv_ide_mess;
        
        SELECT max(ide_mess) + 1 INTO lv_ide_mess_max from fm_message where ide_gest = lv_ide_gest and ide_nd_emet = lv_ide_nd_emet;
        
        DBMS_OUTPUT.PUT_LINE('IDE_MESS: ' || lv_ide_mess_max || ' POSTE : ' || lv_ide_nd_emet);
        
        INSERT INTO tbl_message
        SELECT * FROM E000618.fm_message_sygacut
        WHERE ide_gest = lv_ide_gest
        and ide_nd_emet = lv_ide_nd_emet
        and ide_mess = lv_ide_mess;
        
        UPDATE tbl_message SET ide_mess = lv_ide_mess_max, ref_mess = lv_ide_mess_max
        WHERE ide_gest = lv_ide_gest
        and ide_nd_emet = lv_ide_nd_emet
        and ide_mess = lv_ide_mess;
        
        INSERT INTO PIAF_ADM.FM_MESSAGE
        SELECT * FROM tbl_message;
        
        INSERT INTO fm_rnl_me (COD_TYP_ND_EMET, IDE_ND_EMET, IDE_MESS, COD_TYP_ND_DEST, IDE_ND_DEST, FLG_EMIS_RECU, COD_STATUT, NBR_PIECE) VALUES
        ('P', lv_ide_nd_emet, lv_ide_mess_max, 'P', lv_ide_nd_emet, 'R', 'AC', 0);
        
        COMMIT;
        
        open cur_fc_ecriture(lv_ide_nd_emet, lv_ide_nd_emet, lv_ide_mess);
        
        SELECT NVL(MAX(ide_ecr) + 1000000, 1000) INTO lv_ide_ecr_max FROM fc_ecriture WHERE ide_gest = lv_ide_gest and ide_poste = lv_ide_nd_emet and flg_cptab = 'N'; --and ide_jal = lv_ide_jal; 
        
        LOOP
            FETCH cur_fc_ecriture INTO my_table;
            EXIT WHEN cur_fc_ecriture%NOTFOUND;
            
            --DBMS_OUTPUT.PUT_LINE('IDE_ECR: ' || lv_ide_ecr_max || ' POSTE : ' || lv_ide_poste);
            
            INSERT INTO tbl_ecriture (IDE_POSTE, IDE_GEST, IDE_JAL, FLG_CPTAB, IDE_ECR, DAT_JC, VAR_CPTA, IDE_SCHEMA, COD_TYP_ND, IDE_ND_EMET, IDE_MESS, FLG_EMIS_RECU, LIBN, DAT_SAISIE, DAT_ECR, COD_STATUT, IDE_TRT, COD_BUD, IDE_ORDO, IDE_PIECE, COD_TYP_PIECE, DAT_CRE, DAT_MAJ, UTI_CRE, UTI_MAJ, TERMINAL)
            SELECT IDE_POSTE, IDE_GEST, IDE_JAL, FLG_CPTAB, IDE_ECR, DAT_JC, VAR_CPTA, IDE_SCHEMA, COD_TYP_ND, IDE_ND_EMET, IDE_MESS, FLG_EMIS_RECU, LIBN, DAT_SAISIE, DAT_ECR, COD_STATUT, IDE_TRT, COD_BUD, IDE_ORDO, IDE_PIECE, COD_TYP_PIECE, DAT_CRE, DAT_MAJ, UTI_CRE, UTI_MAJ, TERMINAL FROM E000618.fc_ecriture_sygacut 
            WHERE ide_gest = my_table.ide_gest
            AND ide_poste = my_table.ide_poste
            AND ide_nd_emet = my_table.ide_nd_emet
            AND ide_mess = my_table.ide_mess
            and ide_piece = my_table.ide_piece;
            
            UPDATE tbl_ecriture SET ide_mess = lv_ide_mess_max, ide_ecr = lv_ide_ecr_max, flg_cptab = 'N', cod_statut = 'AC', dat_jc = null, dat_ecr = null
            WHERE ide_gest = my_table.ide_gest
            AND ide_poste = my_table.ide_poste
            AND ide_nd_emet = my_table.ide_nd_emet
            AND ide_mess = my_table.ide_mess
            and ide_piece = my_table.ide_piece;
            
            INSERT INTO tbl_ligne
            SELECT * FROM E000618.fc_ligne_sygacut
            WHERE (ide_gest, ide_poste, flg_cptab, ide_ecr, ide_jal) IN
            (
                SELECT ide_gest, ide_poste, flg_cptab, ide_ecr, ide_jal 
                FROM E000618.fc_ecriture_sygacut
                WHERE ide_gest = my_table.ide_gest
                AND ide_poste = my_table.ide_poste
                AND ide_nd_emet = my_table.ide_nd_emet
                AND ide_mess = my_table.ide_mess
                and ide_piece = my_table.ide_piece
            );
            
            UPDATE tbl_ligne set ide_ecr = lv_ide_ecr_max, flg_cptab = 'N', dat_ecr = null
            WHERE (ide_gest, ide_poste, flg_cptab, ide_ecr, ide_jal) IN
            (
                SELECT ide_gest, ide_poste, flg_cptab, ide_ecr, ide_jal 
                FROM E000618.fc_ecriture_sygacut
                WHERE ide_gest = my_table.ide_gest
                AND ide_poste = my_table.ide_poste
                AND ide_nd_emet = my_table.ide_nd_emet
                AND ide_mess = my_table.ide_mess
                and ide_piece = my_table.ide_piece
            );

            lv_ide_ecr_max := lv_ide_ecr_max + 1;

            END LOOP;
            
            close cur_fc_ecriture;

            DBMS_OUTPUT.PUT_LINE('POSTE: ' || lv_ide_nd_emet || 'ECRITURE : ' || lv_ide_ecr_max);
            
            INSERT INTO PIAF_ADM.FC_ECRITURE
            SELECT * FROM tbl_ecriture;
            COMMIT;
            
            INSERT INTO PIAF_ADM.FC_LIGNE
            SELECT * FROM tbl_ligne;
            COMMIT;
            
            
            delete from tbl_message;
            delete from tbl_ligne;
            delete from tbl_ecriture;
        
            COMMIT;
        
    END LOOP; 

END;