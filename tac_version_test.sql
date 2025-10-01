drop table taco;
drop table tacc;

create table tacc as
select a.ide_poste, c.libn, ide_typ_poste, b.ide_poste_centra, max(dat_jc) etat_cloture, max(0) etat_ouvert
from fc_calend_hist a, rm_poste b, rm_noeud c
where a.ide_poste = b.ide_poste 
and a.ide_poste = c.ide_nd 
and ide_gest = '2023'
and cod_ferm = 'C'
and a.ide_poste in (select ide_poste from piaf_adm.rm_poste where ide_typ_poste in ('AACCD', 'AACDC', 'ACCD'))
group by a.ide_poste, c.libn, ide_typ_poste,  b.ide_poste_centra;


create table taco as
select a.ide_poste, c.libn, ide_typ_poste, b.ide_poste_centra, max(0) etat_cloture, max(dat_jc) etat_ouvert
from fc_calend_hist a, rm_poste b, rm_noeud c
where a.ide_poste = b.ide_poste
and a.ide_poste = c.ide_nd 
and ide_gest = '2023'
and cod_ferm = 'O'
and a.ide_poste in (select ide_poste from piaf_adm.rm_poste where ide_typ_poste in ('AACCD', 'AACDC', 'ACCD'))
group by a.ide_poste, c.libn, ide_typ_poste,  b.ide_poste_centra;

select * from taco;
select * from tacc;

select a.libn, a.etat_cloture etat_cloture, b.etat_ouvert etat_ouvert 
from tacc a
left join taco b on a.ide_poste = b.ide_poste
order by a.ide_poste;