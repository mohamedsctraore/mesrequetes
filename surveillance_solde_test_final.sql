drop table mohamed;

create table mohamed as 
select unique a.ide_poste,c.libn POSTE, a.ide_cpt, b.libn,a.cod_sens, sum(a.mt) DEBIT, 0 CREDIT, d.ide_poste_centra 
from fc_ligne a, fn_compte b, rm_noeud c, rm_poste d
where a.ide_cpt=b.ide_cpt
and a.ide_poste=c.ide_nd 
and a.ide_poste=d.ide_poste
and c.IDE_ND=d.ide_poste
and a.ide_cpt like '39031%'
and a.cod_sens='D'
and a.ide_poste in 
(
select ide_poste from rm_poste
)
and dat_ecr between '02/01/2021' and '30/11/2021'
group by a.ide_poste,c.libn, a.ide_cpt, b.libn,a.cod_sens,d.ide_poste_centra 
UNION
select unique a.ide_poste,c.libn POSTE, a.ide_cpt, b.libn,a.cod_sens, 0 DEBIT, sum(a.mt) CREDIT, d.ide_poste_centra 
from fc_ligne a, fn_compte b, rm_noeud c, rm_poste d
where a.ide_cpt=b.ide_cpt
and a.ide_poste=c.ide_nd
and a.ide_poste=d.ide_poste
and c.IDE_ND=d.ide_poste  
and a.ide_cpt like '39031%'
and a.cod_sens='C'
and a.ide_poste in 
(
select ide_poste from rm_poste
)
and dat_ecr between '01/01/2021' and '30/11/2021'
group by a.ide_poste,c.libn, a.ide_cpt, b.libn,a.cod_sens,d.ide_poste_centra 
;

select * from mohamed
--group by ide_poste_centra
order by ide_cpt,ide_poste,ide_poste_centra
;

select * from mohamed;


select ide_cpt,ide_poste,ide_poste_centra,sum(debit-credit) from mohamed
where ide_poste_centra not in ('501C')
group by ide_cpt,ide_poste,ide_poste_centra
order by ide_poste
;


select ide_cpt,ide_poste_centra,sum(debit-credit) from mohamed
where ide_poste_centra not in ('501C')
group by ide_cpt, ide_poste_centra
order by ide_poste_centra
;

--select ide_poste_centra from rm_poste where ide_typ_poste='TG';
--select ide_poste_centra from rm_poste where ide_poste_centra like '2%';