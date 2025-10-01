select a.libn libelle_pc, poste code_pc, a.nb_actes nombre, a.montant_xof montant, ide_nd_emet code_pc, b.nb_actes nombre, b.montant_xof montant, a.nb_actes - b.nb_actes nombre, a.montant_xof - b.montant_xof montant
from table_a a, table_b b
where poste = ide_nd_emet;

create table table_a as
select b.libn, poste, count(num_acte) NB_ACTES, sum(MONTANT_XOF) MONTANT_XOF
from sigobe_rne.t_acte_rne a, rm_noeud b
where a.poste = b.ide_nd 
and a.gestion = '2024'
and a.type_acte = 'M'
and to_date(date_ordon, 'DD/MM/RRRR') < to_date('01/09/2024')
group by b.libn, a.poste
order by a.poste;

create table table_b as
select b.libn, ide_nd_emet, count(ide_piece) NB_ACTES, sum(MT) MONTANT_XOF
from piaf_adm.fb_piece a, rm_noeud b
where a.ide_nd_emet = b.ide_nd 
and a.ide_gest = '2024'
and a.type_acte = 'M'
and ide_nd_emet in (select ide_poste from rm_poste where ide_typ_poste = 'P')
and ide_piece in
(
select unique num_acte
from sigobe_rne.t_acte_rne a, rm_noeud b
where a.poste = b.ide_nd 
and a.gestion = '2024'
and a.type_acte = 'M'
and to_date(date_ordon, 'DD/MM/RRRR') < to_date('01/09/2024')
)
group by b.libn, a.ide_nd_emet
order by ide_nd_emet;


select * from piaf_adm.fb_piece
where ide_gest = '2024'
and ide_nd_emet in (select ide_poste from rm_poste where ide_typ_poste = 'P');

1 293 361 366
1 990 233 178
