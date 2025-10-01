drop table mohamed_bs_2021;
drop table solde_mohamed_bs_2021;
drop table bs_2021_mohamed;

create table mohamed_bs_2021 as
select ide_poste, a.ide_cpt, a.cod_sens, sum(mt) DEBIT, 0 CREDIT from fc_ligne a, fn_compte b
where ide_gest='2021'
--and ide_jal='TREP'
and a.ide_cpt=b.ide_cpt
and a.ide_cpt=b.ide_cpt_be
and a.cod_sens='D'
and b.COD_TYP_BE='P'
--and a.ide_poste like '4%'
group by ide_poste, a.ide_cpt, a.cod_sens
union
select ide_poste, a.ide_cpt, a.cod_sens, 0 DEBIT, sum(mt) CREDIT from fc_ligne a, fn_compte b
where ide_gest='2021'
--and ide_jal='TREP'
and a.ide_cpt=b.ide_cpt
and a.ide_cpt=b.ide_cpt_be
and a.cod_sens='C'
and b.COD_TYP_BE='P'
--and a.ide_poste like '4%'
group by ide_poste, a.ide_cpt, a.cod_sens
;

create table solde_mohamed_bs_2021 as
select ide_poste, ide_cpt, sum(debit-credit) solde from mohamed_bs_2021
group by ide_poste, ide_cpt;

select * from solde_mohamed_bs_2021
where solde <> 0;

create table bs_2021_mohamed as
select ide_poste, ide_cpt, 
                            CASE
                                WHEN solde > 0 THEN solde
                                ELSE 0
                            END as DEBIT, 
                            CASE  
                                WHEN solde < 0 THEN ABS(solde)
                                ELSE 0
                            END as CREDIT

from solde_mohamed_bs_2021
where solde <> 0;

select * from bs_2021_mohamed
order by ide_poste, ide_cpt
;

select unique ide_poste from bs_2021_mohamed
where ide_poste not like '%C'
order by ide_poste;

