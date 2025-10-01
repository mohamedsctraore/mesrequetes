drop table mohamed;
drop table momo_solde;

create table mohamed as 
select unique a.ide_poste,c.libn POSTE, a.ide_cpt, b.libn,a.cod_sens, sum(a.mt) DEBIT, 0 CREDIT from fc_ligne a, fn_compte b, rm_noeud c
where a.ide_cpt=b.ide_cpt
and a.ide_poste=c.ide_nd 
and a.ide_cpt in (select ide_cpt from fn_compte where cod_typ_be='P')
and a.cod_sens='D'
and a.ide_gest='2021'
--and ide_jal not in 'TREP'
and a.ide_poste in (select ide_poste from rm_poste where ide_poste_centra='507' or ide_poste='507')
and dat_ecr between '01/01/2021' and '31/12/2021'
group by a.ide_poste,c.libn, a.ide_cpt, b.libn,a.cod_sens
UNION
select unique a.ide_poste,c.libn POSTE, a.ide_cpt, b.libn,a.cod_sens, 0 DEBIT, sum(a.mt) CREDIT  from fc_ligne a, fn_compte b, rm_noeud c
where a.ide_cpt=b.ide_cpt
and a.ide_poste=c.ide_nd  
and a.ide_cpt in (select ide_cpt from fn_compte where cod_typ_be='P')
and a.cod_sens='C'
and a.ide_gest='2021'
--and ide_jal not in 'TREP'
and a.ide_poste in (select ide_poste from rm_poste where ide_poste_centra='507' or ide_poste='507')
and dat_ecr between '01/01/2021' and '31/12/2021'
group by a.ide_poste,c.libn, a.ide_cpt, b.libn,a.cod_sens
;

select * from mohamed
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

select a.ide_cpt, 
                CASE
                    WHEN solde > 0 THEN solde
                    WHEN solde < 0 THEN 0
                    ELSE 0
                END as DEBIT,
                CASE
                    WHEN solde < 0 THEN ABS(solde)
                    WHEN solde > 0 THEN 0
                    ELSE 0
                END as CREDIT,
                b.cod_sens_solde                
from momo_solde a, fn_compte b
where solde <> 0
and a.ide_cpt=b.ide_cpt
order by a.ide_cpt
;

select * from fn_compte

--select ide_poste_centra from rm_poste where ide_typ_poste='TG';
--select ide_poste_centra from rm_poste where ide_poste_centra like '2%';