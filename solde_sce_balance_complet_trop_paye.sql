drop table flux_be;
drop table flux_gestion;
drop table flux_cumul;
drop table masse_be;
drop table masse_gest;
drop table masse_cumul;
drop table mai_cumul;
drop table mai_be;
drop table mai_gest;
drop table masse_rapport_sce_balance;
drop table flux_masse_rapport_sce_balance;
drop table rapport_sce_balance;

CREATE TABLE flux_be AS 
SELECT UNIQUE a.ide_poste,c.libn POSTE, d.ide_poste_centra, a.ide_cpt, b.libn,a.cod_sens, SUM(a.mt) DEBIT, 0 CREDIT 
FROM fc_ligne a, fn_compte b, rm_noeud c, rm_poste d
WHERE a.ide_cpt=b.ide_cpt
AND a.ide_poste=c.ide_nd 
AND a.ide_poste=d.ide_poste
AND c.ide_nd=d.ide_poste
AND a.ide_cpt in
(
'47012206',
'4701234',
'47012405',
'47012502',
'4721104'
)

AND a.cod_sens='D'
AND a.flg_cptab='O'
AND a.ide_gest='2023'
AND ide_jal = 'TREP'
--AND a.ide_poste in (SELECT ide_poste FROM rm_poste WHERE ide_poste_centra='510C' or ide_poste='510C')
AND dat_ecr <= '30/10/2023' --BETWEEN '01/01/2022' AND '31/12/2022'
GROUP BY a.ide_poste,c.libn, a.ide_cpt, b.libn,a.cod_sens,d.ide_poste_centra
UNION
SELECT UNIQUE a.ide_poste,c.libn POSTE, d.ide_poste_centra, a.ide_cpt, b.libn,a.cod_sens, 0 DEBIT, SUM(a.mt) CREDIT
FROM fc_ligne a, fn_compte b, rm_noeud c, rm_poste d
WHERE a.ide_cpt=b.ide_cpt
AND a.ide_poste=c.ide_nd 
AND a.ide_poste=d.ide_poste
AND c.ide_nd=d.ide_poste
AND a.ide_cpt in
(
'47012206',
'4701234',
'47012405',
'47012502',
'4721104'
)

AND a.cod_sens='C'
AND a.flg_cptab='O'
AND a.ide_gest='2023'
AND ide_jal = 'TREP'
--AND a.ide_poste in (SELECT ide_poste FROM rm_poste WHERE ide_poste_centra='510C' or ide_poste='510C')
AND dat_ecr <= '30/10/2023'-- BETWEEN '01/01/2022' AND '31/12/2022'
GROUP BY a.ide_poste,c.libn, a.ide_cpt, b.libn,a.cod_sens,d.ide_poste_centra
;

CREATE TABLE flux_gestion AS 
SELECT UNIQUE a.ide_poste,c.libn POSTE, d.ide_poste_centra, a.ide_cpt, b.libn,a.cod_sens, SUM(a.mt) DEBIT, 0 CREDIT 
FROM fc_ligne a, fn_compte b, rm_noeud c, rm_poste d
WHERE a.ide_cpt=b.ide_cpt
AND a.ide_poste=c.ide_nd 
AND a.ide_poste=d.ide_poste
AND c.ide_nd=d.ide_poste
AND a.ide_cpt in
(
'47012206',
'4701234',
'47012405',
'47012502',
'4721104'
)

AND a.cod_sens='D'
AND a.flg_cptab='O'
AND a.ide_gest='2023'
AND ide_jal not in ('TREP', 'REPMAN')
--AND a.ide_poste in (SELECT ide_poste FROM rm_poste WHERE ide_poste_centra='510C' or ide_poste='510C')
AND dat_ecr <= '30/10/2023' --BETWEEN '01/01/2022' AND '31/12/2022'
GROUP BY a.ide_poste,c.libn, a.ide_cpt, b.libn,a.cod_sens,d.ide_poste_centra
UNION
SELECT UNIQUE a.ide_poste,c.libn POSTE, d.ide_poste_centra, a.ide_cpt, b.libn,a.cod_sens, 0 DEBIT, SUM(a.mt) CREDIT
FROM fc_ligne a, fn_compte b, rm_noeud c, rm_poste d
WHERE a.ide_cpt=b.ide_cpt
AND a.ide_poste=c.ide_nd 
AND a.ide_poste=d.ide_poste
AND c.ide_nd=d.ide_poste
AND a.ide_cpt in
(
'47012206',
'4701234',
'47012405',
'47012502',
'4721104'
)

AND a.cod_sens='C'
AND a.flg_cptab='O'
AND a.ide_gest='2023'
AND ide_jal not in ('TREP', 'REPMAN')
--AND a.ide_poste in (SELECT ide_poste FROM rm_poste WHERE ide_poste_centra='510C' or ide_poste='510C')
AND dat_ecr <= '30/10/2023'-- BETWEEN '01/01/2022' AND '31/12/2022'
GROUP BY a.ide_poste,c.libn, a.ide_cpt, b.libn,a.cod_sens,d.ide_poste_centra
;

CREATE TABLE flux_cumul AS 
SELECT UNIQUE a.ide_poste,c.libn POSTE, d.ide_poste_centra, a.ide_cpt, b.libn,a.cod_sens, SUM(a.mt) DEBIT, 0 CREDIT 
FROM fc_ligne a, fn_compte b, rm_noeud c, rm_poste d
WHERE a.ide_cpt=b.ide_cpt
AND a.ide_poste=c.ide_nd 
AND a.ide_poste=d.ide_poste
AND c.ide_nd=d.ide_poste
AND a.ide_cpt in
(
'47012206',
'4701234',
'47012405',
'47012502',
'4721104'
)

AND a.cod_sens='D'
AND a.flg_cptab='O'
AND a.ide_gest='2023'
--AND a.ide_poste in (SELECT ide_poste FROM rm_poste WHERE ide_poste_centra='510C' or ide_poste='510C')
AND dat_ecr <= '30/10/2023' --BETWEEN '01/01/2022' AND '31/12/2022'
GROUP BY a.ide_poste,c.libn, a.ide_cpt, b.libn,a.cod_sens,d.ide_poste_centra
UNION
SELECT UNIQUE a.ide_poste,c.libn POSTE, d.ide_poste_centra, a.ide_cpt, b.libn,a.cod_sens, 0 DEBIT, SUM(a.mt) CREDIT
FROM fc_ligne a, fn_compte b, rm_noeud c, rm_poste d
WHERE a.ide_cpt=b.ide_cpt
AND a.ide_poste=c.ide_nd 
AND a.ide_poste=d.ide_poste
AND c.ide_nd=d.ide_poste
AND a.ide_cpt in
(
'47012206',
'4701234',
'47012405',
'47012502',
'4721104'
)
AND a.cod_sens='C'
AND a.flg_cptab='O'
AND a.ide_gest='2023'
--AND a.ide_poste in (SELECT ide_poste FROM rm_poste WHERE ide_poste_centra='510C' or ide_poste='510C')
AND dat_ecr <= '30/10/2023'-- BETWEEN '01/01/2022' AND '31/12/2022'
GROUP BY a.ide_poste,c.libn, a.ide_cpt, b.libn,a.cod_sens,d.ide_poste_centra
;

CREATE TABLE masse_be AS
SELECT ide_poste, poste, REPLACE(ide_poste_centra, '501C', ide_poste) IDE_POSTE_CENTRA, ide_cpt, libn, debit, credit
FROM flux_be
GROUP BY ide_poste, poste, libn, ide_cpt,ide_poste_centra, debit, credit
ORDER BY ide_poste
;

CREATE TABLE masse_gest AS
SELECT ide_poste, poste, REPLACE(ide_poste_centra, '501C', ide_poste) IDE_POSTE_CENTRA, ide_cpt, libn, debit, credit 
FROM flux_gestion
GROUP BY ide_poste, poste, libn, ide_cpt,ide_poste_centra, debit, credit
ORDER BY ide_poste
;

CREATE TABLE masse_cumul AS
SELECT ide_poste, poste, REPLACE(ide_poste_centra, '501C', ide_poste) IDE_POSTE_CENTRA, ide_cpt, libn, debit, credit
FROM flux_cumul
GROUP BY ide_poste, poste, libn, ide_cpt,ide_poste_centra, debit, credit
ORDER BY ide_poste
;

CREATE TABLE mai_be as
SELECT ide_poste, ide_cpt, libn, sum(debit) debit, sum(credit) credit
FROM masse_be
GROUP BY ide_poste, ide_cpt, libn
ORDER BY ide_poste;

CREATE TABLE mai_gest as
SELECT ide_poste, ide_cpt, libn, sum(debit) debit, sum(credit) credit
FROM masse_gest
GROUP BY ide_poste, ide_cpt, libn;

CREATE TABLE mai_cumul as
SELECT ide_poste, ide_cpt, libn, sum(debit) debit, sum(credit) credit
FROM masse_cumul
GROUP BY ide_poste, ide_cpt, libn;

create table flux_masse_rapport_sce_balance as
select ide_poste poste, ide_cpt compte, libn libelle, debit flux_debit_be, credit flux_credit_be, 0 flux_debit_gestion, 0 flux_credit_gestion , 0 flux_debit_cumul, 0 flux_credit_cumul
from mai_be
union
select ide_poste poste, ide_cpt compte, libn libelle, 0 flux_debit_be, 0 flux_credit_be, debit flux_debit_gestion, credit flux_credit_gestion , 0 flux_debit_cumul, 0 flux_credit_cumul
from mai_gest
union
select ide_poste poste, ide_cpt compte, libn libelle, 0 flux_debit_be, 0 flux_credit_be, 0 flux_debit_gestion, 0 flux_credit_gestion , debit flux_debit_cumul, credit flux_credit_cumul
from masse_cumul;

create table masse_rapport_sce_balance as
select poste, compte, libelle, sum(flux_debit_be) flux_debit_be, sum(flux_credit_be) flux_credit_be, sum(flux_debit_gestion) flux_debit_gestion, sum(flux_credit_gestion) flux_credit_gestion, 
                                sum(flux_debit_cumul) flux_debit_cumul, sum(flux_credit_cumul) flux_credit_cumul
from flux_masse_rapport_sce_balance
group by poste, compte, libelle
order by compte, poste;

create table rapport_sce_balance as
select poste, compte, libelle, flux_debit_be, flux_credit_be, sum(flux_debit_be - flux_credit_be) solde_be, flux_debit_gestion, flux_credit_gestion, sum(flux_debit_gestion - flux_credit_gestion) solde_gestion,
                                flux_debit_cumul, flux_credit_cumul, sum(flux_debit_cumul - flux_credit_cumul) solde
from masse_rapport_sce_balance
group by poste, compte, libelle, flux_debit_be, flux_credit_be, flux_debit_gestion, flux_credit_gestion, flux_debit_cumul, flux_credit_cumul
order by compte, poste;

select * 
from rapport_sce_balance;

--------------------------------------------------- -------------------------------------------------------------

SELECT POSTE, d.ide_poste_centra, b.LIBN, COMPTE, LIBELLE, FLUX_DEBIT_BE BE_DB, FLUX_CREDIT_BE BE_CR, flux_debit_gestion FLUX_DB, flux_credit_gestion FLUX_CR,
                                                                    
                                                                    CASE
                                                                        WHEN solde_gestion > 0 THEN solde_gestion
                                                                        WHEN solde_gestion < 0 THEN 0
                                                                        ELSE 0
                                                                    END as SOLDE_GES_DB,
                                                                    CASE
                                                                        WHEN solde_gestion < 0 THEN ABS(solde_gestion)
                                                                        WHEN solde_gestion > 0 THEN 0
                                                                        ELSE 0
                                                                    END as SOLDE_GES_CR,
                                                                    CASE
                                                                        WHEN solde > 0 THEN solde
                                                                        WHEN solde < 0 THEN 0
                                                                        ELSE 0
                                                                    END as SOLDE_CUM_DB,
                                                                    CASE
                                                                        WHEN solde < 0 THEN ABS(solde)
                                                                        WHEN solde > 0 THEN 0
                                                                        ELSE 0
                                                                    END as SOLDE_CUM_CR
                                                                    
                                                                    
FROM rapport_sce_balance a
INNER JOIN rm_noeud b on a.poste = b.ide_nd
INNER JOIN fn_compte c on a.compte = c.ide_cpt
INNER JOIN rm_poste d on a.poste = d.ide_poste
AND b.ide_nd = d.ide_poste
--WHERE (solde <> 0 AND (cod_sens_solde = 'D' and solde < 0 ) OR ( cod_sens_solde = 'C' and solde > 0 ) )
ORDER BY poste,ide_poste_centra,compte;


-------------------------------------------------- POUR REGROUPEMENT SELON LA CF ---------------------------------------------------------------


drop table c_c;

CREATE TABLE c_c as
SELECT POSTE, d.ide_poste_centra central, b.LIBN, COMPTE, LIBELLE, FLUX_DEBIT_BE BE_DB, FLUX_CREDIT_BE BE_CR, flux_debit_gestion FLUX_DB, flux_credit_gestion FLUX_CR,
                                                                    
                                                                    CASE
                                                                        WHEN solde_gestion > 0 THEN solde_gestion
                                                                        WHEN solde_gestion < 0 THEN 0
                                                                        ELSE 0
                                                                    END as SOLDE_GES_DB,
                                                                    CASE
                                                                        WHEN solde_gestion < 0 THEN ABS(solde_gestion)
                                                                        WHEN solde_gestion > 0 THEN 0
                                                                        ELSE 0
                                                                    END as SOLDE_GES_CR,
                                                                    CASE
                                                                        WHEN solde > 0 THEN solde
                                                                        WHEN solde < 0 THEN 0
                                                                        ELSE 0
                                                                    END as SOLDE_CUM_DB,
                                                                    CASE
                                                                        WHEN solde < 0 THEN ABS(solde)
                                                                        WHEN solde > 0 THEN 0
                                                                        ELSE 0
                                                                    END as SOLDE_CUM_CR
                                                                    
                                                                    
FROM rapport_sce_balance a
INNER JOIN rm_noeud b on a.poste = b.ide_nd
INNER JOIN fn_compte c on a.compte = c.ide_cpt
INNER JOIN rm_poste d on a.poste = d.ide_poste
AND b.ide_nd = d.ide_poste
--WHERE (solde <> 0 AND (cod_sens_solde = 'D' and solde < 0 ) OR ( cod_sens_solde = 'C' and solde > 0 ) )
ORDER BY poste,ide_poste_centra,compte;

drop table ccc_bbb;

create table ccc_bbb as
select poste, REPLACE(central, '501C', poste) centralisaeur, compte, libelle, be_db, be_cr, flux_db, flux_cr, solde_ges_db, solde_ges_cr, solde_cum_db, solde_cum_cr
from c_c;

select centralisaeur CF,poste, b.LIBN, compte, libelle, be_db, be_cr, flux_db flux_ges_db, flux_cr flux_ges_cr, solde_ges_db, solde_ges_cr, solde_cum_db, solde_cum_cr
from ccc_bbb a
INNER JOIN rm_noeud b on a.poste = b.ide_nd
order by compte,centralisaeur, poste;