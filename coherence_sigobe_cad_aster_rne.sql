-------------- MANDAT BUDGET NON PRESENT CGE --------------------------
select poste, mandat, objet, montant_xof, devise, montant_devise from pec_mandat_rne
where (poste, mandat) in
(
select poste, mandat from pec_mandat_rne
minus
select ide_poste, ide_piece from fc_ecriture
where ide_gest = '2024'
and ide_poste in (select ide_poste from rm_poste where ide_typ_poste = 'P')
and ide_jal in ('JANN','A29','A23')
and ide_piece is not null
and ide_schema in ('CONSTAPEC','ANNULCONSTAPEC')
and dat_jc <= '31/10/2024'
)
order by poste, mandat
;

----- MANDAT CGE NON PRESENT BUDGET --------------------
select ide_poste, ide_gest, ide_jal, flg_cptab, ide_ecr, ide_piece from fc_ecriture
where (ide_poste, ide_piece) 
in
(
select ide_poste, ide_piece from fc_ecriture
where ide_gest = '2024'
and ide_poste in (select ide_poste from rm_poste where ide_typ_poste = 'P')
and ide_jal in ('JANN','A29','A23')
and ide_piece is not null
and ide_schema in ('CONSTAPEC','ANNULCONSTAPEC')
and dat_jc <= '31/10/2024'
minus
select poste, mandat from pec_mandat_rne
)
order by ide_poste, ide_piece
;

insert into pec_mandat_rne
select * from pec_mandat
inner join sigobe_rne.t_acte_rne on mandat = num_acte
;

select * from pec_mandat_rne
order by poste, mandat;

create table a as
select a.poste poste, count(mandat) nbre_mandat_sigobe, sum(montant_xof) montant_sigobe, count(ide_piece) nbre_mandat_cad, sum(mt) montant_cad
from pec_mandat_rne a
inner join fb_piece b on a.poste = b.ide_nd_emet
and a.mandat = b.ide_piece
group by a.poste
order by a.poste
;

drop table b;
create table b as
select ide_poste, count(ide_cpt) nbre_mandat_cge, sum(mt) montant_ccge
from fc_ligne
where ide_gest = '2024'
and ide_jal = 'JPECDEPBG'
and cod_sens = 'C'
and ide_cpt in ('47412','47422')
and dat_ecr <= '31/10/2024'
group by ide_poste
;

select poste, nbre_mandat_sigobe, montant_sigobe, nbre_mandat_cad, montant_cad, nbre_mandat_cge, montant_ccge montant_cge, montant_sigobe - montant_cad ecart_sigobe_cad, montant_sigobe - montant_ccge 
from a
inner join b on a.poste || 'C' = b.IDE_POSTE
order by poste;


----------------------------------------------------------------------------------------------------------------------------------------------

select ide_poste, ide_piece from fc_ecriture
    where (ide_poste, ide_piece) in
    (
        select ide_poste, ide_piece from fc_ecriture
        where ide_gest = '2024'
        and ide_poste in (select ide_poste from rm_poste where ide_typ_poste = 'P')
        and ide_jal in ('JANN','A29','A23')
        and ide_piece is not null
        and ide_schema in ('CONSTAPEC','ANNULCONSTAPEC')
        and dat_jc <= '31/10/2024'
        minus
        select poste, mandat from pec_mandat_rne
    )
minus
SELECT poste, num_acte from sigobe_rne.t_acte_rne
where (poste, num_acte)
in
(
    select ide_poste,ide_piece from fc_ecriture
    where (ide_poste, ide_piece) in
    (
        select ide_poste, ide_piece from fc_ecriture
        where ide_gest = '2024'
        and ide_poste in (select ide_poste from rm_poste where ide_typ_poste = 'P')
        and ide_jal in ('JANN','A29','A23')
        and ide_piece is not null
        and ide_schema in ('CONSTAPEC','ANNULCONSTAPEC')
        and dat_jc <= '31/10/2024'
        minus
        select poste, mandat from pec_mandat_rne
    )
)
;


select ide_piece, count(*) from fc_ecriture
    where (ide_poste, ide_piece) in
    (
        select ide_poste, ide_piece from fc_ecriture
        where ide_gest = '2024'
        and ide_poste in (select ide_poste from rm_poste where ide_typ_poste = 'P')
        and ide_jal in ('JANN','A29','A23')
        and ide_piece is not null
        and ide_schema in ('CONSTAPEC','ANNULCONSTAPEC')
        and dat_jc <= '31/10/2024'
        minus
        select poste, mandat from pec_mandat_rne
    )
group by ide_piece