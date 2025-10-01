DECLARE
    CURSOR cur_poste IS SELECT ide_poste FROM rm_poste WHERE ide_poste_centra = '2020' OR ide_poste = '2020';
    --CURSOR cur_poste IS SELECT ide_poste FROM rm_poste;
    v_poste PIAF_ADM.FC_LIGNE.IDE_POSTE%TYPE;
    v_ide_util PIAF_ADM.FH_UTIL.IDE_UTIL%TYPE;
    v_cod_util PIAF_ADM.FH_UTIL.COD_UTIL%TYPE;
    v_nom PIAF_ADM.FH_UTIL.NOM%TYPE;
    v_prenom PIAF_ADM.FH_UTIL.PRENOM%TYPE;
    v_fonction varchar2(25);
    sql_create_user varchar2(255);
    sql_default_tablespace varchar2(255);
    sql_temp_table_space varchar2(255);
    sql_profile_default varchar2(255);
    sql_account_unlock varchar2(255);
    sql_grant_role varchar2(255);
    sql_alter_user varchar2(255);
    sql_alter_user_tablespace varchar2(255);
    sql_alter_iser_pwd varchar2(255);
    sql_cursor INTEGER;
    exception1 EXCEPTION;
    
BEGIN
    Execute Immediate 'alter session set nls_date_format = ''DD/MM/RRRR''';
    
    v_fonction := 'P';
    v_cod_util := 'Y451047';
    v_nom := 'COULIBALY';
    v_prenom := 'ATTOBAN TOUSSAINT MICHEL';
    sql_create_user := 'CREATE USER ' || v_cod_util ||  ' IDENTIFIED BY a';
    sql_default_tablespace := 'DEFAULT TABLESPACE ASTER_DATA';
    sql_temp_table_space := 'TEMPORARY TABLESPACE TEMP';
    sql_profile_default := 'PROFILE DEFAULT';
    sql_account_unlock := 'ACCOUNT UNLOCK';
    sql_grant_role := 'GRANT PIAF_UTIL TO ' || v_cod_util;
    sql_alter_user := 'ALTER USER ' || v_cod_util || ' DEFAULT ROLE ALL';
    sql_alter_user_tablespace := 'ALTER USER ' || v_cod_util || 'QUOTA UNLIMITED ON ASTER_DATA';
    sql_alter_iser_pwd := 'ALTER USER ' || v_cod_util || 'IDENTIFIED BY a';
    
    SELECT NVL((SELECT ide_util FROM fh_util WHERE cod_util = v_cod_util),0) INTO v_ide_util FROM dual;
    
    IF v_ide_util = 0 THEN
        SELECT MAX(ide_util) INTO v_ide_util FROM fh_util;
        v_ide_util := v_ide_util + 1;
        INSERT INTO fh_util (IDE_SITE, IDE_UTIL, COD_UTIL, NOM, PRENOM, DAT_PWD, PWD) VALUES ('CITFI', v_ide_util, v_cod_util, v_nom, v_prenom, ADD_MONTHS(SYSDATE,-4), '.');
        
        sql_cursor := DBMS_SQL.OPEN_CURSOR;
        DBMS_SQL.PARSE(sql_cursor, sql_create_user, DBMS_SQL.NATIVE);
        DBMS_SQL.PARSE(sql_cursor, sql_default_tablespace, DBMS_SQL.NATIVE);
        DBMS_SQL.PARSE(sql_cursor, sql_temp_table_space, DBMS_SQL.NATIVE);
        DBMS_SQL.PARSE(sql_cursor, sql_profile_default, DBMS_SQL.NATIVE);
        DBMS_SQL.PARSE(sql_cursor, sql_account_unlock, DBMS_SQL.NATIVE);
        DBMS_SQL.PARSE(sql_cursor, sql_grant_role, DBMS_SQL.NATIVE);
        DBMS_SQL.PARSE(sql_cursor, sql_alter_user, DBMS_SQL.NATIVE);
        DBMS_SQL.PARSE(sql_cursor, sql_alter_user_tablespace, DBMS_SQL.NATIVE);
        DBMS_SQL.PARSE(sql_cursor, sql_alter_iser_pwd, DBMS_SQL.NATIVE);
        DBMS_SQL.CLOSE_CURSOR(sql_cursor);
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('IDE_UTIL : ' || v_ide_util || ' - POSTE : ' || v_poste);
    
    OPEN cur_poste;
    
    LOOP
        FETCH cur_poste into v_poste;
        EXIT WHEN cur_poste%NOTFOUND;
        
        DELETE FROM FH_UT_PU WHERE ide_util = v_ide_util and ide_poste = v_poste;

        IF v_fonction = 'A' THEN
            INSERT into fh_ut_pu (ide_site, ide_util, ide_profil, ide_poste, dat_dval) VALUES ('CITFI', v_ide_util, 12, v_poste, TO_DATE(SYSDATE,'DD/MM/RRRR'));
            INSERT into fh_ut_pu (ide_site, ide_util, ide_profil, ide_poste, dat_dval) VALUES ('CITFI', v_ide_util, 3, v_poste, TO_DATE(SYSDATE,'DD/MM/RRRR'));
            INSERT into fh_ut_pu (ide_site, ide_util, ide_profil, ide_poste, dat_dval) VALUES ('CITFI', v_ide_util, 110, v_poste, TO_DATE(SYSDATE,'DD/MM/RRRR'));
            
        ELSIF v_fonction = 'P' THEN
            INSERT into fh_ut_pu (ide_site, ide_util, ide_profil, ide_poste, dat_dval) VALUES ('CITFI', v_ide_util, 12, v_poste, TO_DATE(SYSDATE,'DD/MM/RRRR'));
            INSERT into fh_ut_pu (ide_site, ide_util, ide_profil, ide_poste, dat_dval) VALUES ('CITFI', v_ide_util, 17, v_poste, TO_DATE(SYSDATE,'DD/MM/RRRR'));
            INSERT into fh_ut_pu (ide_site, ide_util, ide_profil, ide_poste, dat_dval) VALUES ('CITFI', v_ide_util, 110, v_poste, TO_DATE(SYSDATE,'DD/MM/RRRR'));
                
        ELSIF v_fonction = 'C' THEN
            INSERT into fh_ut_pu (ide_site, ide_util, ide_profil, ide_poste, dat_dval) VALUES ('CITFI', v_ide_util, 12, v_poste, TO_DATE(SYSDATE,'DD/MM/RRRR'));
            INSERT into fh_ut_pu (ide_site, ide_util, ide_profil, ide_poste, dat_dval) VALUES ('CITFI', v_ide_util, 40, v_poste, TO_DATE(SYSDATE,'DD/MM/RRRR'));
            INSERT into fh_ut_pu (ide_site, ide_util, ide_profil, ide_poste, dat_dval) VALUES ('CITFI', v_ide_util, 110, v_poste, TO_DATE(SYSDATE,'DD/MM/RRRR'));
                
        ELSIF v_fonction = 'PE' THEN
            INSERT into fh_ut_pu (ide_site, ide_util, ide_profil, ide_poste, dat_dval) VALUES ('CITFI', v_ide_util, 12, v_poste, TO_DATE(SYSDATE,'DD/MM/RRRR'));
            INSERT into fh_ut_pu (ide_site, ide_util, ide_profil, ide_poste, dat_dval) VALUES ('CITFI', v_ide_util, 13, v_poste, TO_DATE(SYSDATE,'DD/MM/RRRR'));
            INSERT into fh_ut_pu (ide_site, ide_util, ide_profil, ide_poste, dat_dval) VALUES ('CITFI', v_ide_util, 17, v_poste, TO_DATE(SYSDATE,'DD/MM/RRRR'));
            INSERT into fh_ut_pu (ide_site, ide_util, ide_profil, ide_poste, dat_dval) VALUES ('CITFI', v_ide_util, 110, v_poste, TO_DATE(SYSDATE,'DD/MM/RRRR'));
        END IF;

    END LOOP;
    
EXCEPTION 
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('Une exception a été traité');
END;