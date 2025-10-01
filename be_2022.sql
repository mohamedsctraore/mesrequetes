drop table mohamed_be_2022;
drop table solde_mohamed_be_2022;
drop table be_2022_mohamed;

create table mohamed_be_2022 as
select ide_poste, a.ide_cpt, a.cod_sens, sum(mt) DEBIT, 0 CREDIT from fc_ligne a, fn_compte b
where ide_gest='2022'
and ide_jal='TREP'
and a.ide_cpt=b.ide_cpt
and a.ide_cpt=b.ide_cpt_be
and a.cod_sens='D'
and a.ide_poste like '4%'
group by ide_poste, a.ide_cpt, a.cod_sens
union
select ide_poste, a.ide_cpt, a.cod_sens, 0 DEBIT, sum(mt) CREDIT from fc_ligne a, fn_compte b
where ide_gest='2022'
and ide_jal='TREP'
and a.ide_cpt=b.ide_cpt
and a.ide_cpt=b.ide_cpt_be
and a.cod_sens='C'
and a.ide_poste like '4%'
group by ide_poste, a.ide_cpt, a.cod_sens

--order by ide_poste
;

select ide_poste, a.ide_cpt, sum(mt) from fc_ligne a, fn_compte b
where ide_gest='2021'
--and ide_jal='TREP'
and a.ide_cpt=b.ide_cpt
and a.ide_cpt=b.ide_cpt_be
group by ide_poste, a.ide_cpt
order by ide_poste
;

create table solde_mohamed_be_2022 as 
select ide_poste, ide_cpt, sum(debit-credit) solde from mohamed_be_2022
group by ide_poste, ide_cpt;

select * from solde_mohamed_be_2022
where solde <> 0;

select * from fn_compte
where cod_typ_be='P'
;

create table be_2022_mohamed as
select ide_poste, ide_cpt, 
                            CASE
                                WHEN solde > 0 THEN solde
                                ELSE 0
                            END as DEBIT, 
                            CASE  
                                WHEN solde < 0 THEN ABS(solde)
                                ELSE 0
                            END as CREDIT

from solde_mohamed_be_2022
where solde <> 0;

select * from be_2022_mohamed
order by ide_poste, ide_cpt
;

select unique ide_poste from be_2022_mohamed
where ide_poste not like '%C'
order by ide_poste;

