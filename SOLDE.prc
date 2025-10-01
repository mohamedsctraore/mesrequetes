CREATE OR REPLACE PROCEDURE CGST.SOLDE(v_gest varchar2, v_date varchar2) IS
BEGIN

DELETE FROM CGST.BALANCE_FLUX;
DELETE FROM CGST.CENTRA;
DELETE FROM CGST.SOLDE_ANORMAL;
DELETE FROM CGST.SOLDE_ANORMAL_CPT;

------------------------------ TABLE DES FLUX PAR POSTE ----------------------------

INSERT INTO CGST.BALANCE_FLUX
SELECT UNIQUE a.ide_poste,c.libn POSTE, d.ide_poste_centra, a.ide_cpt, b.libn,a.cod_sens, SUM(a.mt) DEBIT, 0 CREDIT 
FROM fc_ligne a, fn_compte b, rm_noeud c, piaf_adm.rm_poste d
WHERE a.ide_cpt=b.ide_cpt
AND a.ide_poste=c.ide_nd 
AND a.ide_poste=d.ide_poste
AND c.ide_nd=d.ide_poste
AND a.cod_sens='D'
AND a.flg_cptab='O'
AND a.ide_gest=v_gest
AND to_date(dat_ecr, 'dd/mm/rrrr') <= v_date 
GROUP BY a.ide_poste,c.libn, a.ide_cpt, b.libn,a.cod_sens,d.ide_poste_centra
UNION
SELECT UNIQUE a.ide_poste,c.libn POSTE, d.ide_poste_centra, a.ide_cpt, b.libn,a.cod_sens, 0 DEBIT, SUM(a.mt) CREDIT
FROM fc_ligne a, fn_compte b, rm_noeud c, piaf_adm.rm_poste d
WHERE a.ide_cpt=b.ide_cpt
AND a.ide_poste=c.ide_nd 
AND a.ide_poste=d.ide_poste
AND c.ide_nd=d.ide_poste
AND a.cod_sens='C'
AND a.flg_cptab='O'
AND a.ide_gest=v_gest
AND to_date(dat_ecr, 'dd/mm/rrrr') <= v_date
GROUP BY a.ide_poste,c.libn, a.ide_cpt, b.libn,a.cod_sens,d.ide_poste_centra
;

------------------------------ TABLE DES FLUX PAR CENTRALISATEUR ----------------------------

INSERT INTO CGST.CENTRA
SELECT ide_poste, poste, REPLACE(ide_poste_centra, '501C', ide_poste) ide_poste_centra, ide_cpt, libn, cod_sens, debit, credit 
FROM CGST.BALANCE_FLUX;

------------------------------ TABLE DES SOLDES PAR CENTRALISATEUR ----------------------------

INSERT INTO CGST.SOLDE_ANORMAL
SELECT ide_poste_centra,ide_cpt, SUM(debit-credit) solde FROM CGST.CENTRA
GROUP BY ide_poste_centra,ide_cpt
;

------------------------------ TABLE DES SOLDES PAR COMPTES ----------------------------

INSERT INTO CGST.SOLDE_ANORMAL_CPT
SELECT ide_cpt, SUM(debit-credit) solde FROM CGST.CENTRA
GROUP BY ide_cpt
;

END;