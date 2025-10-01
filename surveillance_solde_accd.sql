drop table mohamed;
drop table momo_solde;
drop table m_solde;
drop table momo_solde_m;

create table mohamed as 
select unique a.ide_poste,c.libn POSTE, a.ide_cpt, b.libn,a.cod_sens, sum(a.mt) DEBIT, 0 CREDIT from fc_ligne a, fn_compte b, rm_noeud c
where a.ide_cpt=b.ide_cpt
and a.ide_poste=c.ide_nd 
--and a.ide_cpt like '47052071'
and a.cod_sens='D'
and a.ide_gest='2023'
--and ide_jal in 'TREP'
and a.ide_poste in (select ide_poste from piaf_adm.rm_poste where ide_typ_poste in ('AACCD', 'AACDC', 'ACCD'))
and a.flg_cptab = 'O'
and a.dat_ecr <= '31/10/2023' --between '01/01/2021' and '31/12/2021'
group by a.ide_poste,c.libn, a.ide_cpt, b.libn,a.cod_sens
UNION
select unique a.ide_poste,c.libn POSTE, a.ide_cpt, b.libn,a.cod_sens, 0 DEBIT, sum(a.mt) CREDIT  from fc_ligne a, fn_compte b, rm_noeud c
where a.ide_cpt=b.ide_cpt
and a.ide_poste=c.ide_nd  
--and a.ide_cpt like '47052071'
and a.cod_sens='C'
and a.ide_gest='2023'
--and ide_jal in 'TREP'
and a.flg_cptab = 'O'
and a.ide_poste in (select ide_poste from piaf_adm.rm_poste where ide_typ_poste in ('AACCD', 'AACDC', 'ACCD'))
and a.dat_ecr <= '31/10/2023' --between '01/01/2021' and '31/12/2021'
group by a.ide_poste,c.libn, a.ide_cpt, b.libn,a.cod_sens
;

select * from mohamed
order by ide_cpt
;

create table m_solde as
select ide_poste, poste, ide_cpt, libn, sum(debit) debit , sum(credit) credit from mohamed
group by ide_poste, poste, ide_cpt, libn
;

select *
from m_solde
where (debit - credit) <> 0;

create table momo_solde_m as
select ide_poste, poste, ide_cpt, libn, sum(debit-credit) solde from m_solde
group by ide_poste, poste, ide_cpt, libn
;

select a.ide_poste, a.poste, a.ide_cpt, a.libn,
                CASE
                    WHEN solde > 0 THEN solde
                    WHEN solde < 0 THEN 0
                    ELSE 0
                END as DEBIT,
                CASE
                    WHEN solde < 0 THEN ABS(solde)
                    WHEN solde > 0 THEN 0
                    ELSE 0
                END as CREDIT, cod_sens_solde               
from momo_solde_m a, fn_compte b
where a.ide_cpt=b.ide_cpt
--and b.COD_TYP_BE='P'
--and solde <> 0
order by ide_cpt
;

select ide_poste, poste, ide_cpt, libn, sum(debit-credit) from mohamed
group by ide_poste, poste, libn, ide_cpt
order by ide_poste
;

create table momo_solde as
select ide_cpt, sum(debit-credit) solde from mohamed
group by ide_cpt
;

select a.ide_cpt, libn,
                CASE
                    WHEN solde > 0 THEN solde
                    WHEN solde < 0 THEN 0
                    ELSE 0
                END as DEBIT,
                CASE
                    WHEN solde < 0 THEN ABS(solde)
                    WHEN solde > 0 THEN 0
                    ELSE 0
                END as CREDIT, cod_sens_solde               
from momo_solde a, fn_compte b
where a.ide_cpt=b.ide_cpt
--and b.COD_TYP_BE='P'
--and solde <> 0
order by ide_cpt
;

------------------------------ TABLE DES FLUX PAR CENTRALISATEUR ----------------------------

CREATE TABLE centra_accd AS 
SELECT ide_poste, poste, REPLACE(ide_poste_centra, '501C', ide_poste) ide_poste_centra, ide_cpt, libn, cod_sens, debit, credit 
FROM mohamed;

------------------------------ TABLE DES SOLDES PAR CENTRALISATEUR ----------------------------

CREATE TABLE solde_anormal_accd AS
SELECT ide_poste_centra,ide_cpt, SUM(debit-credit) solde FROM centra
GROUP BY ide_poste_centra,ide_cpt
;

------------------------------ TABLE DES SOLDES PAR COMPTES ----------------------------

CREATE TABLE solde_anormal_cpt_accd AS
SELECT ide_cpt, SUM(debit-credit) solde FROM centra
GROUP BY ide_cpt
;

CREATE TABLE solde_poste_accd AS
SELECT ide_poste, poste, REPLACE(ide_poste_centra, '501C', ide_poste) IDE_POSTE_CENTRA, ide_cpt, libn, SUM(debit-credit) solde FROM mohamed
GROUP BY ide_poste, poste, libn, ide_cpt,ide_poste_centra
ORDER BY ide_poste
;

CREATE TABLE solde_poste_flux_accd AS
SELECT ide_poste, poste, REPLACE(ide_poste_centra, '501C', ide_poste) IDE_POSTE_CENTRA, ide_cpt, libn,debit,credit FROM mohamed
GROUP BY ide_poste, poste, libn, ide_cpt,ide_poste_centra,debit,credit
ORDER BY ide_poste
;

SELECT a.ide_cpt, c.libn compte,ide_poste_centra,b.libn poste, CASE
                                    WHEN solde > 0 THEN solde
                                    ELSE 0
                                  END AS DEBIT,
                                  CASE
                                    WHEN solde < 0 THEN ABS(solde)
                                    ELSE 0
                                 END AS CREDIT, c.cod_sens_solde
FROM solde_anormal_accd a, rm_noeud b, fn_compte c
WHERE solde <> 0
AND a.ide_poste_centra=b.ide_nd
AND a.ide_cpt=c.ide_cpt
AND substr(a.ide_cpt,1,3) = '478'
ORDER BY a.ide_cpt, a.ide_poste_centra
;


select * from fn_compte
--select ide_poste_centra from rm_poste where ide_typ_poste='TG';
--select ide_poste_centra from rm_poste where ide_poste_centra like '2%';