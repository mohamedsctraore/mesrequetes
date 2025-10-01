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
AND a.ide_cpt in ('47516091')
AND a.cod_sens='D'
AND a.flg_cptab='O'
AND a.ide_gest='2023'
--AND a.ide_poste = '510C'
--AND a.ide_poste in (SELECT ide_poste FROM rm_poste WHERE ide_poste_centra='510C' or ide_poste='510C')
AND dat_ecr <= '31/03/2023' --BETWEEN '01/01/2022' AND '31/12/2022'
GROUP BY a.ide_poste,c.libn, a.ide_cpt, b.libn,a.cod_sens,d.ide_poste_centra
UNION
SELECT UNIQUE a.ide_poste,c.libn POSTE, d.ide_poste_centra, a.ide_cpt, b.libn,a.cod_sens, 0 DEBIT, SUM(a.mt) CREDIT
FROM fc_ligne a, fn_compte b, rm_noeud c, rm_poste d
WHERE a.ide_cpt=b.ide_cpt
AND a.ide_poste=c.ide_nd 
AND a.ide_poste=d.ide_poste
AND c.ide_nd=d.ide_poste
AND a.ide_cpt in ('47516091')
AND a.cod_sens='C'
AND a.flg_cptab='O'
AND a.ide_gest='2023'
--AND a.ide_poste = '510C'
--AND a.ide_poste in (SELECT ide_poste FROM rm_poste WHERE ide_poste_centra='510C' or ide_poste='510C')
AND dat_ecr <= '31/03/2023'-- BETWEEN '01/01/2022' AND '31/12/2022'
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

------------------------------ AFFICHAGE DES POSTES RESPONSABLES DU SOLDE <> 0 ----------------------------
drop table solde390xx;

create table solde390xx as
SELECT a.ide_cpt, c.libn compte,ide_poste_centra,b.libn poste, CASE
                                    WHEN solde > 0 THEN solde
                                    WHEN solde < 0 THEN 0
                                  END AS DEBIT,
                                  CASE
                                    WHEN solde < 0 THEN ABS(solde)
                                    WHEN solde > 0 THEN 0
                                 END AS CREDIT, c.cod_sens_solde
FROM solde_anormal a, rm_noeud b, fn_compte c
WHERE solde <> 0
AND a.ide_poste_centra=b.ide_nd
AND a.ide_cpt=c.ide_cpt
ORDER BY a.ide_cpt, a.ide_poste_centra
;

select *
from solde390xx;

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
order by ide_cpt, ide_poste
;


-------------------------- AFFICHAGE SOLDE ANORMAUX -------------------------------------

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
AND ( (cod_sens_solde = 'D' and solde < 0 ) OR ( cod_sens_solde = 'C' and solde > 0 ) )
ORDER BY ide_cpt
;

------------------------------ AFFICHAGE DES POSTES RESPONSABLES DU SOLDE ANORMAL <> 0 ----------------------------

SELECT a.ide_cpt, c.libn,ide_poste_centra,b.libn, CASE
                                    WHEN solde > 0 THEN solde
                                    WHEN solde < 0 THEN 0
                                  END AS DEBIT,
                                  CASE
                                    WHEN solde < 0 THEN ABS(solde)
                                    WHEN solde > 0 THEN 0
                                 END AS CREDIT, c.cod_sens_solde
FROM solde_anormal a, rm_noeud b, fn_compte c
WHERE solde <> 0
AND a.ide_poste_centra=b.ide_nd
AND a.ide_cpt=c.ide_cpt
AND ( (cod_sens_solde = 'D' and solde < 0 ) OR ( cod_sens_solde = 'C' and solde > 0 ) )
--AND IDE_POSTE_CENTRA = '201C'
ORDER BY a.ide_cpt, a.ide_poste_centra;

----------------------------------------------  AFFICHAGE DES FLUX PAR POSTE ET PAR COMPTE ------------------------------------------------------------------------------

SELECT * FROM mohamed
ORDER BY ide_cpt
;

SELECT ide_poste_centra centra, ide_poste base, poste, ide_cpt compte, libn, debit, credit
FROM solde_poste_flux
ORDER BY ide_poste_centra, ide_poste;

---------------------------------------------------------------------------------------------------------------------------------------------------------------

SELECT * FROM centra
ORDER BY ide_poste_centra,ide_cpt
;

SELECT ide_poste_centra,ide_cpt, SUM(debit-credit) FROM centra
GROUP BY ide_poste_centra,ide_cpt
ORDER BY ide_poste_centra, ide_cpt
;

SELECT * FROM solde_anormal
WHERE solde <> 0
ORDER BY ide_poste_centra, ide_cpt
;

SELECT * FROM solde_anormal
WHERE solde <> 0
ORDER BY ide_cpt, ide_poste_centra
;

SELECT * FROM vrai_solde
WHERE solde <> 0
;


--------------------------------------------- TABLE DES PROJECTIONS DES SOLDES APRES DENOUEMENTS DES OPERATIONS ---------------------------------------------------------------------
drop table projection390xxx;

create table projection390xxx as
select a.ide_cpt cpt, compte, ide_poste_centra, poste, a.debit debit_actuel, a.credit credit_actuel, cod_sens_solde sens_normal_compte, ide_poste, b.ide_cpt, b.debit debit_a_denouer, b.credit credit_a_denouer, 
       a.debit-b.credit debit_apres_compta, a.credit-b.debit credit_apres_compta
from solde390xx a
left join mt_a_denouer b on a.ide_cpt = b.ide_cpt
and ide_poste_centra = ide_poste
order by a.ide_cpt, ide_poste_centra;


select * from projection390xxx;
-------------------------------------- TABLE DES SOLDES DES COMPTES EN ATTENDANT LES OPERATIONS NON ENCORE REMONTEES ----------------------------------------------------------------
select cpt, compte, poste, debit_actuel, credit_actuel, sens_normal_compte sens, debit_a_den, 
       credit_a_den, debit_apres_compta, credit_apres_compta, b.debit debit_a_remonter, b.credit credit_a_remonter, debit_apres_compta-b.debit diff_debit, credit_apres_compta-b.credit diff_credit
from projection390xxx a
left join a_remonter b on ide_poste_centra = central
and cpt = b.ide_cpt
where cpt not in ('39031','39032');
-------------------------------------- AFFICHAGE DES CENTRALISATIONS A DENOUER PAR LES POSTES  ---------------------------------

select * 
from centra_a_denouer;

--------------------------------------- TABLE DES MONTANTS CONTENUS DANS LES BORDEREAUX DE CENTRALISATION NON DENOUES -----------------------------------
drop table mt_a_denouer;

create table mt_a_denouer as
select a.ide_poste, a.ide_cpt, sum(mt) credit, 0 debit
from fc_ligne a
inner join fc_ecriture b on a.ide_poste = b.ide_poste
inner join centra_a_denouer c on a.ide_poste = poste
and b.ide_mess = bordereau
and a.ide_gest = b.ide_gest
and a.flg_cptab = b.flg_cptab
and a.ide_jal = b.ide_jal
and a.ide_ecr = b.ide_ecr
and b.ide_poste = poste
and a.ide_gest = '2022'
and cod_sens = 'C'
and ide_cpt like '390%'
and a.flg_cptab = 'N'
group by a.ide_poste, a.ide_cpt

union

select a.ide_poste, a.ide_cpt, 0 credit, sum(mt) debit
from fc_ligne a
inner join fc_ecriture b on a.ide_poste = b.ide_poste
inner join centra_a_denouer c on a.ide_poste = poste
and b.ide_mess = bordereau
and a.ide_gest = b.ide_gest
and a.flg_cptab = b.flg_cptab
and a.ide_jal = b.ide_jal
and a.ide_ecr = b.ide_ecr
and b.ide_poste = poste
and a.ide_gest = '2022'
and cod_sens = 'D'
and ide_cpt like '390%'
and a.flg_cptab = 'N'
group by a.ide_poste, a.ide_cpt

order by ide_poste
;

------------------------------------ TABLE DES MONTANTS QUI DOIVENT REMONTER PAR POSTE DE BASE -------------------------------------------
drop table montant_a_remonter;

create table montant_a_remonter as
select b.ide_cpt,ide_poste_centra central,a.ide_poste, sum(mt) debit, 0 credit
from fc_ecriture a
inner join fc_ligne b on a.ide_poste = b.ide_poste
inner join rm_poste c on a.ide_poste = c.ide_poste
and b.ide_poste = c.ide_poste
and a.flg_cptab = b.flg_cptab
and a.ide_gest = b.ide_gest
and a.ide_ecr = b.ide_ecr
and a.ide_jal = b.ide_jal 
where a.ide_gest='2023'
and b.ide_cpt = '475131'
--and b.ide_cpt not in ('39031','39032')
and b.flg_cptab = 'O'
and b.cod_sens = 'D'
and a.ide_jal <> 'JCENTRAL'
and dat_centra is null
and a.dat_jc <= '30/06/2022'
group by a.ide_poste, b.ide_cpt, ide_poste_centra

union 

select b.ide_cpt,ide_poste_centra central,a.ide_poste, 0 debit, sum(mt) credit
from fc_ecriture a
inner join fc_ligne b on a.ide_poste = b.ide_poste
inner join rm_poste c on a.ide_poste = c.ide_poste
and b.ide_poste = c.ide_poste
and a.flg_cptab = b.flg_cptab
and a.ide_gest = b.ide_gest
and a.ide_ecr = b.ide_ecr
and a.ide_jal = b.ide_jal 
where a.ide_gest='2022'
and b.ide_cpt like '390%'
and b.ide_cpt not in ('39031','39032')
and b.flg_cptab = 'O'
and b.cod_sens = 'C'
and a.ide_jal <> 'JCENTRAL'
and dat_centra is null
and a.dat_jc <= '30/06/2022'
group by a.ide_poste, b.ide_cpt, ide_poste_centra

order by ide_cpt,central,ide_poste;

-------------------------------------------- TABLE DES MONTANTS QUI DOIVENT REMONTER PAR CENTRALISATEUR ---------------------------------

drop table a_remonter;

create table a_remonter as
select ide_cpt, central, sum(debit) debit , sum(credit) credit
from montant_a_remonter
group by ide_cpt, central
order by ide_cpt, central;

select *
from a_remonter;

select *
from solde_poste_flux
order by ide_poste_centra;

create table ssss as
select ide_poste, poste, ide_poste_centra, ide_cpt, libn, sum(debit-credit) solde
from solde_poste_flux
group by ide_poste, poste, ide_poste_centra, ide_cpt, libn
order by ide_poste_centra, ide_poste;

select ide_poste, poste, ide_poste_centra, ide_cpt, libn, CASE
                                        WHEN solde > 0 THEN solde
                                        WHEN solde < 0 THEN 0
                                        END AS DEBIT,
                                    CASE
                                    WHEN solde < 0 THEN ABS(solde)
                                    WHEN solde > 0 THEN 0
                                    END AS CREDIT
from ssss
where solde <> 0
order by ide_cpt, ide_poste_centra, ide_poste;