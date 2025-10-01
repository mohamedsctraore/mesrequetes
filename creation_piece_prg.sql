declare
    cursor c_ref_piece is select IDE_POSTE v_ide_poste, IDE_ORDO v_ide_ordo, COD_BUD v_cod_bud, 
        COD_REF_PIECE v_cod_ref_piece, VAR_TIERS v_var_tiers, IDE_TIERS v_ide_tiers, IDE_GEST v_ide_gest, 
        FLG_CPTAB v_flg_cptab, IDE_JAL v_ide_jal, IDE_ECR v_ide_ecr, IDE_LIG v_ide_lig, DAT_CRE v_dat_cre, UTI_CRE v_uti_cre, 
        DAT_MAJ v_dat_maj, UTI_MAJ v_uti_maj, TERMINAL v_terminal, DAT_ECR v_dat_ecr, MT v_mt from fc_ligne
        where (ide_poste, ide_gest, ide_jal, flg_cptab, ide_ecr)
        in
        (
            select ide_poste, ide_gest, ide_jal, flg_cptab, ide_ecr
            from fc_ecriture
            where ide_gest = '2024'
            and ide_poste = '514'
            and flg_cptab = 'O'
        )
        and ide_cpt = '47012199'
        and cod_sens = 'D'
        and ide_cpt in (select ide_cpt from fn_compte where flg_justif = 'O')
        --and cod_ref_piece = 'CHQ     BBG      N°4818167      10/12/2024'
        and ide_ref_piece is null
--        and ide_tiers not in
--            (
--            '004413W',
--            '0204320K',
--            '1003432',
--            '1105992R',
--            '600960F',
--            '9800844R'
--            )
        ;
    
    v_ide_ref_piece PIAF_ADM.FC_REF_PIECE.IDE_REF_PIECE%TYPE;

begin
    for param_ligne in c_ref_piece
       loop
            SELECT PIAF_ADM.CAL_Next_Ide_Ref_Piece(param_ligne.v_IDE_POSTE) into v_ide_ref_piece from dual;
            DBMS_OUTPUT.PUT_LINE(param_ligne.v_ide_ecr ||  ' ' || param_ligne.v_ide_lig ||  ' ' || param_ligne.v_mt);
            
            UPDATE FC_LIGNE SET ide_ref_piece = v_ide_ref_piece
            where (ide_poste, ide_gest, ide_jal, flg_cptab, ide_ecr)
            in
            (
                select ide_poste, ide_gest, ide_jal, flg_cptab, ide_ecr
                from fc_ecriture
                where ide_gest = '2024'
                and ide_poste = '514'
                and flg_cptab = 'O'
            )
            and ide_cpt = '47012199'
            and cod_sens = 'D'
            and ide_cpt in (select ide_cpt from fn_compte where flg_justif = 'O')
            and ide_ref_piece is null
            and cod_ref_piece = param_ligne.v_cod_ref_piece
            and ide_tiers = param_ligne.v_ide_tiers
            and mt = param_ligne.v_mt
            and ide_ecr = param_ligne.v_ide_ecr
            and ide_lig = param_ligne.v_ide_lig
            ;
            
            Insert into FC_REF_PIECE
                (IDE_POSTE, IDE_REF_PIECE, IDE_ORDO, COD_BUD, COD_TYP_PIECE, 
                IDE_PIECE, COD_REF_PIECE, VAR_TIERS, IDE_TIERS, IDE_GEST, 
                FLG_CPTAB, MT_DB, MT_CR, DAT_DER_MVT, FLG_SOLDE, 
                IDE_JAL, IDE_ECR, IDE_LIG, DAT_CRE, UTI_CRE, 
                DAT_MAJ, UTI_MAJ, TERMINAL, IDE_PLAN_AUX, IDE_CPT_AUX, 
                IDE_DEVISE, VAL_TAUX, MT_DEV, NUM_LIG_TIERS)
            Values
                (param_ligne.v_IDE_POSTE, v_ide_ref_piece, NULL, NULL, NULL, 
                NULL, param_ligne.v_COD_REF_PIECE, param_ligne.v_VAR_TIERS, param_ligne.v_IDE_TIERS, param_ligne.v_IDE_GEST, 
                param_ligne.v_FLG_CPTAB, 0, param_ligne.v_MT, TO_DATE(param_ligne.v_DAT_ECR, 'DD/MM/YYYY'), 'N', 
                param_ligne.v_IDE_JAL, param_ligne.v_IDE_ECR, param_ligne.v_IDE_LIG, TO_DATE(sysdate, 'DD/MM/YYYY HH24:MI:SS'), param_ligne.v_UTI_CRE, 
                TO_DATE(sysdate, 'DD/MM/YYYY HH24:MI:SS'), param_ligne.v_DAT_MAJ, param_ligne.v_TERMINAL, NULL, NULL, 
                NULL, NULL, param_ligne.v_MT, NULL)
            ;
            COMMIT;
       end loop;
       
        EXCEPTION
        WHEN NO_DATA_FOUND THEN
        NULL;
        WHEN OTHERS THEN
       -- Consider logging the error and then re-raise
        RAISE;
end;