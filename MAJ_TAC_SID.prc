CREATE OR REPLACE PROCEDURE CGST.Maj_Tac_sid (gestion VARCHAR2) IS

v_dat DATE;
v_count NUMBER(3);

CURSOR cur_poste_TAC_sid IS SELECT cod_pc,last_jc_clot FROM TAC_SID;
CURSOR cur_poste IS SELECT unique ide_poste FROM piaf_adm.fc_ecriture WHERE ide_gest='2023' and flg_cptab='O';

BEGIN

DELETE FROM TAC_SID;  	 		   		  
COMMIT;

FOR r_poste IN cur_poste LOOP

    INSERT INTO TAC_SID(PC,cod_pc,designation,last_jc_clot)		
    SELECT b.ide_poste_centra,a.ide_poste,c.libc,MAX(a.dat_jc)
    FROM piaf_adm.fc_calend_hist a, piaf_adm.rm_poste b, piaf_adm.rm_noeud c
    WHERE a.ide_gest=gestion AND a.cod_ferm='C'
    AND a.ide_poste NOT LIKE 'AD%'
    AND a.ide_poste=b.ide_poste
    AND a.ide_poste=c.ide_nd
    AND a.ide_poste=r_poste.ide_poste
    AND a.ide_poste  IN  (SELECT DISTINCT ide_poste FROM piaf_adm.fc_ecriture WHERE ide_gest=gestion AND flg_cptab='O')
    AND EXISTS  (SELECT  ide_poste FROM piaf_adm.fc_ecriture e WHERE e.ide_gest=gestion AND e.flg_cptab='O' AND e.ide_poste=a.ide_poste  )
    GROUP BY b.ide_poste_centra,a.ide_poste,c.libc;

    INSERT INTO TAC_SID(PC,cod_pc,designation,last_jc_clot,las_jc_ouv)
    SELECT b.ide_poste_centra,a.ide_poste,c.libc,'',MAX(a.dat_jc)
    FROM piaf_adm.fc_calend_hist a, piaf_adm.rm_poste b, piaf_adm.rm_noeud c
    WHERE a.ide_gest=gestion AND a.cod_ferm='O'
    AND a.ide_poste NOT LIKE 'AD%'
    AND a.ide_poste=b.ide_poste
    AND a.ide_poste=c.ide_nd
    AND a.ide_poste=r_poste.ide_poste
    GROUP BY b.ide_poste_centra,a.ide_poste,c.libc;

    FOR v_poste IN cur_poste_TAC_sid LOOP

        SELECT MAX(dat_jc) INTO v_dat FROM piaf_adm.fc_calend_hist WHERE ide_gest=gestion AND cod_ferm='O' AND ide_poste=v_poste.cod_pc;
        IF v_dat IS NOT NULL THEN
           UPDATE TAC_SID SET las_jc_ouv=v_dat WHERE cod_pc=v_poste.cod_pc;
        END IF;

        SELECT COUNT(*) INTO v_count FROM piaf_adm.fc_calend_hist WHERE ide_gest=gestion AND ide_poste=v_poste.cod_pc AND cod_ferm <>'C';
        IF v_count IS NOT NULL THEN
           UPDATE TAC_SID SET nb_jc_en_cours=v_count WHERE cod_pc=v_poste.cod_pc;
        END IF;

        IF v_poste.cod_pc LIKE '5%' THEN  -- MAJ de tolérance des CG
                          UPDATE TAC_SID SET tolerance=1,unite_tolerance='JOURNEE' WHERE cod_pc=v_poste.cod_pc;
                          v_dat:=v_poste.last_jc_clot;
                          v_count:=0;
                          WHILE v_dat<=TO_DATE(SYSDATE,'DD/MM/YYYY') LOOP
                                IF TO_CHAR(v_dat,'Dy') IN ('Sa','Di') THEN
                                   v_count:=v_count+1;
                                END IF;
                                v_dat:=v_dat+1;
                          END LOOP;
                          UPDATE TAC_SID SET retard=TO_DATE(SYSDATE,'DD/MM/YYYY')-TO_DATE(last_jc_clot,'DD/MM/YYYY')-v_count-1 WHERE cod_pc=v_poste.cod_pc;
        ELSIF v_poste.cod_pc LIKE '4%' THEN  -- MAJ de tolérance des Paieries à l'etranger
                          UPDATE TAC_SID SET tolerance=1,unite_tolerance='MOIS' WHERE cod_pc=v_poste.cod_pc;
                          UPDATE TAC_SID SET retard=SUBSTR(TO_DATE(SYSDATE,'DD/MM/YYYY'),4,2)-SUBSTR(TO_DATE(last_jc_clot,'DD/MM/YYYY'),4,2)-1 WHERE cod_pc=v_poste.cod_pc;
        ELSIF (v_poste.cod_pc NOT LIKE '5%' AND v_poste.cod_pc NOT LIKE '4%') THEN --OR v_poste.cod_pc LIKE '5%C'  THEN
            SELECT COUNT(*) INTO v_count FROM piaf_adm.rm_poste WHERE ide_poste LIKE v_poste.cod_pc||'%';
            IF v_count=2 THEN   ----------  MAJ de tolérance des TG
                         UPDATE TAC_SID SET pc=v_poste.cod_pc||'C',tolerance=1,unite_tolerance='JOURNEE' WHERE cod_pc=v_poste.cod_pc;
                         v_dat:=v_poste.last_jc_clot;
                          v_count:=0;
                          WHILE v_dat<=TO_DATE(SYSDATE,'DD/MM/YYYY') LOOP
                                IF TO_CHAR(v_dat,'Dy') IN ('Sa','Di') THEN
                                   v_count:=v_count+1;
                                END IF;
                                v_dat:=v_dat+1;
                          END LOOP;
                          UPDATE TAC_SID SET retard=TO_DATE(SYSDATE,'DD/MM/YYYY')-TO_DATE(last_jc_clot,'DD/MM/YYYY')-v_count-1 WHERE cod_pc=v_poste.cod_pc;
            END IF;
            IF v_count=1 THEN 		 		---------- MAJ de tolérance des PC RATTAC_sidHES
                         UPDATE TAC_SID SET tolerance=1,unite_tolerance='QUINZAINE' WHERE cod_pc=v_poste.cod_pc;
                         UPDATE TAC_SID SET retard=ROUND((TO_DATE(SYSDATE,'DD/MM/YYYY')-TO_DATE(last_jc_clot,'DD/MM/YYYY'))/15) WHERE cod_pc=v_poste.cod_pc;
            END IF;
        END IF;
        COMMIT;
    END LOOP;

    COMMIT;

END LOOP;

UPDATE TAC_SID SET appreciation='A JOUR' WHERE tolerance>retard;
UPDATE TAC_SID SET appreciation='RETARD TOLERE' WHERE tolerance=retard;
UPDATE TAC_SID SET appreciation='RETARD' WHERE tolerance<retard;
UPDATE TAC_SID SET pc=SUBSTR(pc,1,3);
UPDATE TAC_SID SET gras='O' WHERE pc=cod_pc;
UPDATE TAC_SID SET pc=SUBSTR(pc,1,3)||' et ses PCR' WHERE pc<>'501';
UPDATE TAC_SID SET pc='PC à la journée' WHERE pc='501';

UPDATE TAC_SID SET pc=cod_pc WHERE cod_pc LIKE '%C';

UPDATE TAC_SID SET pc=SUBSTR(pc,1,3)||'C' WHERE pc LIKE '%et ses PCR';

UPDATE TAC_SID SET pc=cod_pc WHERE pc LIKE '%PC à la journée';

DELETE FROM TAC_SID WHERE last_jc_clot is null;

COMMIT;

END Maj_TAC_sid;
/
