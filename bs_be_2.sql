drop table be_bs_mohamed_12;
drop table solde_bs_be_mohamed;
drop table solde_solde_be_bs;

create table be_bs_mohamed_12 as
select a.ide_poste,
                         CASE
                            WHEN a.ide_cpt=b.ide_cpt THEN a.ide_cpt
                            WHEN a.ide_cpt<>b.ide_cpt THEN b.ide_cpt
                            ELSE ' ' 
                         END as CPT,
                         CASE
                            WHEN a.ide_cpt=b.ide_cpt THEN a.debit
                            WHEN a.ide_cpt<>b.ide_cpt THEN 0
                            ELSE 0
                         END as "DEBIT_BS_2021",
                         CASE
                            WHEN a.ide_cpt=b.ide_cpt THEN a.credit
                            WHEN a.ide_cpt<>b.ide_cpt THEN 0
                            ELSE 0
                         END as "CREDIT_BS_2021",
                         CASE
                            WHEN a.ide_cpt=b.ide_cpt THEN b.debit
                            WHEN a.ide_cpt<>b.ide_cpt THEN b.debit
                            ELSE 0
                         END as "DEBIT_BE_2022",
                         CASE
                            WHEN a.ide_cpt=b.ide_cpt THEN b.credit
                            WHEN a.ide_cpt<>b.ide_cpt THEN b.credit
                            ELSE 0
                         END as "CREDIT_BE_2022"
from bs_2021_mohamed a, be_2022_mohamed b
where a.ide_poste=b.ide_poste
--and b.ide_cpt=a.ide_cpt
order by a.ide_poste, a.ide_cpt, b.ide_cpt
;

create table solde_bs_be_mohamed as
select unique ide_poste, cpt, debit_bs_2021, credit_bs_2021, debit_be_2022, credit_be_2022 from be_bs_mohamed_12
order by ide_poste, cpt;

create table solde_solde_be_bs as
select ide_poste, cpt, sum(debit_bs_2021) as "DEBIT_BS_2021", sum(credit_bs_2021) as "CREDIT_BS_2021", debit_be_2022, credit_be_2022 
from solde_bs_be_mohamed
group by ide_poste, cpt, debit_be_2022, credit_be_2022
order by ide_poste, cpt
;

select * from solde_solde_be_bs;

select ide_poste, cpt, debit_bs_2021 - debit_be_2022 debit, credit_bs_2021 - credit_be_2022 credit from solde_solde_be_bs
where debit_bs_2021 - debit_be_2022 <> 0 or credit_bs_2021 - credit_be_2022 <> 0
and cpt not like '397'
;

select unique ide_poste from solde_solde_be_bs where ide_poste not like '%C' order by ide_poste;