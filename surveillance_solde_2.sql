drop table mohamed;

create table mohamed as 
select unique a.ide_poste,c.libn POSTE, a.ide_cpt, b.libn,a.cod_sens, sum(a.mt) DEBIT, 0 CREDIT from fc_ligne a, fn_compte b, rm_noeud c
where a.ide_cpt=b.ide_cpt
and a.ide_poste=c.ide_nd 
and a.ide_cpt like '390%'
and a.cod_sens='D'
and a.ide_poste in 
(
select ide_poste from rm_poste where ide_poste_centra in 
(
select ide_poste_centra from rm_poste
where ide_poste like '2%'
and ide_poste not like '2%C'
and ide_typ_poste like 'AAC%'
)
or ide_poste in
(
select ide_poste_centra from rm_poste
where ide_poste like '2%'
and ide_poste not like '2%C'
and ide_typ_poste like 'AAC%'
)
)
and dat_ecr between '02/01/2021' and '30/09/2021'
group by a.ide_poste,c.libn, a.ide_cpt, b.libn,a.cod_sens
UNION
select unique a.ide_poste,c.libn POSTE, a.ide_cpt, b.libn,a.cod_sens, 0 DEBIT, sum(a.mt) CREDIT  from fc_ligne a, fn_compte b, rm_noeud c
where a.ide_cpt=b.ide_cpt
and a.ide_poste=c.ide_nd  
and a.ide_cpt like '390%'
and a.cod_sens='C'
and a.ide_poste in 
(
select ide_poste from rm_poste where ide_poste_centra in
(
(
select ide_poste_centra from rm_poste
where ide_poste like '2%'
and ide_poste not like '2%C'
and ide_typ_poste like 'AAC%'
)
)
or ide_poste
in
(
(
select ide_poste_centra from rm_poste
where ide_poste like '2%'
and ide_poste not like '2%C'
and ide_typ_poste like 'AAC%'
)
)
)
and dat_ecr between '01/01/2021' and '30/09/2021'
group by a.ide_poste,c.libn, a.ide_cpt, b.libn,a.cod_sens
;

select * from mohamed
order by ide_poste,ide_cpt
;

select TRIM('C' from ide_poste), ide_cpt, sum(debit-credit) from mohamed
group by TRIM('C' from ide_poste),ide_cpt
order by TRIM('C' from ide_poste)
;

select TRIM('C' from ide_poste) IDE_POSTE, ide_cpt CPT, sum(debit-credit) from mohamed
group by TRIM('C' from ide_poste),ide_cpt
order by TRIM('C' from ide_poste)
;

select ide_poste_centra from rm_poste where ide_typ_poste='TG';
select ide_poste_centra from rm_poste where ide_poste_centra like '2%';