Select * From Fc_Ligne Where
(ide_gest, ide_poste, ide_jal, ide_ecr, flg_cptab)
In
(
Select ide_gest, ide_poste, ide_jal, ide_ecr, flg_cptab
From fc_ecriture
Where Ide_Gest in ('2025')
and libn like 'Comptabilisation des écarts % sur piece %'
)
Order By Dat_maj Desc, Ide_Poste, Ide_Ecr Desc, Ide_Lig
;

--drop table pieces_dev;
--drop table ref_pieces_dev;

delete from pieces_dev;
--create table pieces_dev as
insert into pieces_dev
select ide_poste, ide_cpt, ide_devise,
sum(decode(cod_sens, (select cod_sens_solde from rc_droit_compte where ide_typ_poste = 'P' and ide_cpt = a.ide_cpt), mt_dev, -mt_dev)) mt_dev, 
sum(decode(cod_sens, (select cod_sens_solde from rc_droit_compte where ide_typ_poste = 'P' and ide_cpt = a.ide_cpt), mt, -mt)) mt 
from fc_ligne a
where ide_gest = '2025'
and ide_cpt in (select ide_cpt from fn_compte where flg_justif = 'O')
and ide_poste in (select ide_poste from rm_poste where ide_typ_poste = 'P')
group by ide_poste, ide_cpt, ide_devise
having (sum(decode(cod_sens, (select cod_sens_solde from rc_droit_compte where ide_typ_poste = 'P' and ide_cpt = a.ide_cpt), mt_dev, -mt_dev)) = 0 and sum(decode(cod_sens, (select cod_sens_solde from rc_droit_compte where ide_typ_poste = 'P' and ide_cpt = a.ide_cpt), mt, -mt)) <> 0)
order by ide_poste, ide_cpt
;

------------  LES PIECES ---------------

delete from ref_pieces_dev;

--create table ref_pieces_dev as
insert into ref_pieces_dev
select ide_poste, ide_cpt, ide_ref_piece, ide_devise,
sum(decode(cod_sens, (select cod_sens_solde from rc_droit_compte where ide_typ_poste = 'P' and ide_cpt = a.ide_cpt), mt_dev, -mt_dev)) mt_dev, 
sum(decode(cod_sens, (select cod_sens_solde from rc_droit_compte where ide_typ_poste = 'P' and ide_cpt = a.ide_cpt), mt, -mt)) mt 
from fc_ligne a
where ide_gest = '2025'
and ide_cpt in (select ide_cpt from fn_compte where flg_justif = 'O')
and ide_poste in (select ide_poste from rm_poste where ide_typ_poste = 'P')
and (ide_cpt, ide_poste, ide_devise) in (select unique ide_cpt, ide_poste, ide_devise from pieces_dev)
group by ide_poste, ide_cpt, ide_ref_piece, ide_devise
having (sum(decode(cod_sens, (select cod_sens_solde from rc_droit_compte where ide_typ_poste = 'P' and ide_cpt = a.ide_cpt), mt_dev, -mt_dev)) = 0 and sum(decode(cod_sens, (select cod_sens_solde from rc_droit_compte where ide_typ_poste = 'P' and ide_cpt = a.ide_cpt), mt, -mt)) <> 0)
order by ide_poste, ide_cpt, ide_ref_piece
;

select * from pieces_dev;
select * from ref_pieces_dev;

