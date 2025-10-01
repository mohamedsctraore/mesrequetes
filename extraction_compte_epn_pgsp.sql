DROP TABLE mohamed;
DROP TABLE centra;
DROP TABLE solde_anormal;
DROP TABLE solde_anormal_cpt;
DROP TABLE solde_poste;
DROP TABLE solde_poste_flux;
DROP TABLE ssss;

------------------------------ TABLE DES FLUX PAR POSTE ----------------------------

CREATE TABLE mohamed AS 
SELECT UNIQUE a.ide_poste,c.libn POSTE, d.ide_poste_centra, a.ide_cpt, b.libn,a.cod_sens, SUM(a.mt) DEBIT, 0 CREDIT 
FROM fc_ligne a, fn_compte b, rm_noeud c, rm_poste d
WHERE a.ide_cpt=b.ide_cpt
AND a.ide_poste=c.ide_nd 
AND a.ide_poste=d.ide_poste
AND c.ide_nd=d.ide_poste
AND substr(a.ide_cpt,1,2) = '47'
AND a.cod_sens='D'
AND a.flg_cptab='O'
AND a.ide_gest='2025'
AND a.ide_poste in (SELECT ide_poste FROM rm_poste WHERE ide_poste_centra='510C' or ide_poste='510C')
AND dat_ecr BETWEEN '01/01/2025' AND '22/09/2025'
GROUP BY a.ide_poste,c.libn, a.ide_cpt, b.libn,a.cod_sens,d.ide_poste_centra
UNION
SELECT UNIQUE a.ide_poste,c.libn POSTE, d.ide_poste_centra, a.ide_cpt, b.libn,a.cod_sens, 0 DEBIT, SUM(a.mt) CREDIT
FROM fc_ligne a, fn_compte b, rm_noeud c, rm_poste d
WHERE a.ide_cpt=b.ide_cpt
AND a.ide_poste=c.ide_nd 
AND a.ide_poste=d.ide_poste
AND c.ide_nd=d.ide_poste
AND substr(a.ide_cpt,1,2) = '47'
AND a.cod_sens='C'
AND a.flg_cptab='O'
AND a.ide_gest='2025'
AND a.ide_poste in (SELECT ide_poste FROM rm_poste WHERE ide_poste_centra='510C' or ide_poste='510C')
AND dat_ecr BETWEEN '01/01/2025' AND '22/09/2025'
GROUP BY a.ide_poste,c.libn, a.ide_cpt, b.libn,a.cod_sens,d.ide_poste_centra
;


------------------------------ TABLE DES FLUX PAR CENTRALISATEUR ----------------------------

CREATE TABLE centra AS 
SELECT ide_poste, poste, REPLACE(ide_poste_centra, '501C', ide_poste) ide_poste_centra, ide_cpt, libn, cod_sens, debit, credit 
FROM mohamed;

------------------------------ TABLE DES SOLDES PAR CENTRALISATEUR ----------------------------

CREATE TABLE solde_anormal AS
SELECT ide_poste_centra,ide_cpt, SUM(debit-credit) solde FROM centra
GROUP BY ide_poste_centra,ide_cpt
;

------------------------------ TABLE DES SOLDES PAR COMPTES ----------------------------

CREATE TABLE solde_anormal_cpt AS
SELECT ide_cpt, SUM(debit-credit) solde FROM centra
GROUP BY ide_cpt
;

CREATE TABLE vrai_solde AS
SELECT ide_cpt, SUM(debit-credit) SOLDE FROM centra
GROUP BY ide_cpt
ORDER BY ide_cpt
;

--------------------  TABLE DES SOLDES PAR POSTE COMPTABLES SUR UN COMPTE -----------

CREATE TABLE solde_poste AS
SELECT ide_poste, poste, REPLACE(ide_poste_centra, '501C', ide_poste) IDE_POSTE_CENTRA, ide_cpt, libn, SUM(debit-credit) solde FROM mohamed
GROUP BY ide_poste, poste, libn, ide_cpt,ide_poste_centra
ORDER BY ide_poste
;

CREATE TABLE solde_poste_flux AS
SELECT ide_poste, poste, REPLACE(ide_poste_centra, '501C', ide_poste) IDE_POSTE_CENTRA, ide_cpt, libn,debit,credit FROM mohamed
GROUP BY ide_poste, poste, libn, ide_cpt,ide_poste_centra,debit,credit
ORDER BY ide_poste
;

------------------------------ AFFICHAGE DES SOLDES <> 0 PAR COMPTE ----------------------------

SELECT a.ide_cpt, c.libn, CASE
                                    WHEN solde > 0 THEN solde
                                    WHEN solde < 0 THEN 0
                                  END AS DEBIT,
                                  CASE
                                    WHEN solde < 0 THEN ABS(solde)
                                    WHEN solde > 0 THEN 0
                                 END AS CREDIT, c.cod_sens_solde
FROM solde_anormal_cpt a, fn_compte c
WHERE solde <> 0
AND a.ide_cpt=c.ide_cpt
ORDER BY ide_cpt
;
------------------------------ AFFICHAGE DES SOLDES PAR POSTE SUR UN COMPTE ----------------------------------------------

SELECT ide_poste, poste, ide_poste_centra, ide_cpt, libn ,
                                                            CASE
                                                                WHEN solde > 0 THEN solde
                                                                ELSE 0
                                                            END AS "DEBIT" ,
                                                            CASE
                                                                WHEN solde < 0 THEN abs(solde)
                                                                ELSE 0
                                                            END AS "CREDIT"                                                            
FROM solde_poste
WHERE solde <> 0
order by ide_cpt, ide_poste
;


DROP TABLE MOHAMED_COMPTE2022 
;

CREATE TABLE MOHAMED_COMPTE2022 AS 
SELECT a.ide_gest,a.ide_cpt,f.libn LIBELLE_COMPTE,c.IDE_POSTE_CENTRA,d.libn,a.ide_poste,b.libn libelle ,a.ide_tiers,a.ide_ref_piece,cod_ref_piece,a.ide_ecr,a.ide_lig_exec,a.dat_ecr,a.mt DEBIT,0 CREDIT,a.cod_sens ,a.ide_jal,a.observ,e.dat_jc,e.LIBN libelle_ecr,e.IDE_ND_EMET
FROM FC_LIGNE a ,RM_NOEUD b ,RM_POSTE c,RM_NOEUD d ,FC_ECRITURE e, FN_COMPTE f  
WHERE   a.IDE_GEST in ('2025')
AND a.COD_SENS = 'D' 
AND substr(a.ide_cpt, 1, 5) = '39031'
AND a.ide_poste in (select ide_poste from rm_poste where ide_poste_centra='510C' or ide_poste='510C')
--AND a.ide_cpt in ('4701125', '47012103', '47012199')
--AND a.ide_poste = '510'
AND c.IDE_POSTE		 	=	a.ide_poste
AND a.ide_poste		 	=	b.ide_nd 
AND c.IDE_POSTE_CENTRA	=	d.ide_nd 
AND a.flg_cptab			=	e.flg_cptab
AND a.IDE_GEST 			=	e.ide_gest
AND a.ide_jal 			=	e.ide_jal
AND a.ide_poste			=	e.ide_poste 
AND a.flg_cptab			=	'O'
AND a.ide_ecr			=	e.ide_ecr
AND a.dat_ecr			=	e.dat_ecr
AND a.IDE_CPT          =   f.IDE_CPT
AND a.dat_ecr between '01/03/2025' AND '31/03/2025'
--AND a.dat_maj >= '17/11/2023'
UNION 
SELECT a.ide_gest,a.ide_cpt,f.libn LIBELLE_COMPTE,c.IDE_POSTE_CENTRA,d.libn,a.ide_poste,b.libn libelle ,a.ide_tiers,a.ide_ref_piece,cod_ref_piece,a.ide_ecr,a.ide_lig_exec,a.dat_ecr,0 DEBIT, a.mt CREDIT,a.cod_sens,a.ide_jal,a.observ,e.dat_jc,e.LIBN  libelle_ecr,e.IDE_ND_EMET
FROM FC_LIGNE a ,RM_NOEUD b ,RM_POSTE c,RM_NOEUD d,FC_ECRITURE e, FN_COMPTE f    
WHERE   a.IDE_GEST in ('2025')
AND a.COD_SENS = 'C' 
AND substr(a.ide_cpt, 1, 5) = '39031'
--AND a.ide_cpt in ('4701125', '47012103', '47012199')
--AND a.ide_poste = '510'
AND a.ide_poste in (select ide_poste from rm_poste where ide_poste_centra='510C' or ide_poste='510C')
AND c.IDE_POSTE		 	=	a.ide_poste
AND a.ide_poste		 	=	b.ide_nd 
AND c.IDE_POSTE_CENTRA	=	d.ide_nd 
AND a.flg_cptab			=	e.flg_cptab
AND a.IDE_GEST 			=	e.ide_gest
AND a.ide_jal 			=	e.ide_jal
AND a.ide_poste			=	e.ide_poste 
AND a.flg_cptab			=	'O'
AND a.ide_ecr			=	e.ide_ecr
AND a.dat_ecr			=	e.dat_ecr
AND a.IDE_CPT          =   f.IDE_CPT
AND a.dat_ecr between '01/03/2025' AND '31/03/2025'
--AND a.dat_maj >= '17/11/2023'
;

SELECT * FROM MOHAMED_COMPTE2022 ORDER BY ide_gest,ide_cpt,ABS((DEBIT + CREDIT)),dat_ecr,ide_poste,ide_tiers,ide_jal,ide_ecr
;

SELECT sum(debit), sum(credit), sum(debit) - sum(credit) FROM MOHAMED_COMPTE2022;

---------------- CUT DEVERS NON COMPTABILISE -----------------------
select a.ide_poste poste, c.libn libelle, a.ide_mess bordereau, count(a.ide_ecr) nb_ecriture_non_comptabilise, b.libl, a.cod_statut statut
from fc_ecriture a
inner join fm_message b on a.ide_poste = b.ide_nd_emet
inner join rm_noeud c on a.ide_poste = c.ide_nd
inner join fm_rnl_me d on a.ide_poste = d.ide_nd_dest
and a.ide_mess = d.ide_mess 
and b.ide_nd_emet = c.ide_nd
and a.ide_mess = b.ide_mess
and a.ide_gest='2023'
and cod_typ_mess=24
and a.flg_cptab = 'N'
--and b.libl not like '%/08/%'
and a.ide_poste like '3%'
and a.cod_statut <> 'RJ'
and d.flg_emis_recu = 'R'
and d.cod_statut not in ('AN', 'TR')
group by a.ide_poste, c.libn, a.ide_mess, b.libl, a.cod_statut
order by a.ide_poste, a.ide_mess;