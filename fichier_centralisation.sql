----------------------------------------- TRAITEMENT DES MASSES --------------------------------------------------------
delete from masse_envoye;

insert into masse_envoye
select 'B' cible, a.ide_poste, ide_poste_centra, ide_cpt, sum(decode(cod_sens, 'C', mt, -mt)) mt
from fc_ligne a, piaf_adm.rm_poste b
where a.ide_poste = b.ide_poste
and ide_jal <> 'JCENTRAL'
and a.dat_ecr between '&date_debut' and '&date_fin'
and substr(ide_cpt, 1, 3) = '390'
and substr(ide_cpt, 1, 5) <> '39031'
and substr(ide_cpt, 1, 5) <> '39032'
and a.flg_cptab = 'O'
group by a.ide_poste, ide_poste_centra, ide_cpt
;

delete from masse_recu;

insert into masse_recu
select 'C' cible, a.ide_poste, ide_nd_emet, ide_cpt, sum(decode(cod_sens, 'C', mt, -mt)) mt
from fc_ecriture a
left join fc_ligne b on a.ide_poste = b.ide_poste
and a.flg_cptab = b.flg_cptab
and a.ide_gest = b.ide_gest
and a.ide_ecr = b.ide_ecr
and a.ide_jal = b.ide_jal 
where a.ide_gest='2023'
and substr(ide_cpt, 1, 3) = '390'
and substr(ide_cpt, 1, 5) <> '39031'
and substr(ide_cpt, 1, 5) <> '39032'
and a.ide_jal='JCENTRAL'
and to_date(substr (libn, -9)) between '&date_debut' and '&date_fin'
group by a.ide_poste, ide_nd_emet, ide_cpt
order by 3, 4, 5
;

delete from masse_a_traite;

insert into masse_a_traite
select a.cible cible_e, a.ide_poste poste_emet, a.ide_poste_centra, a.ide_cpt compte_envoye, a.mt mt_envoye, b.cible cible_r, b.ide_poste poste_recept, b.ide_nd_emet, b.ide_cpt compte_recu, b.mt mt_recu 
from masse_envoye a
full outer join masse_recu b on ide_poste_centra = b.ide_poste
and a.ide_poste = ide_nd_emet
and a.ide_cpt = b.ide_cpt
group by a.cible, a.ide_poste, a.ide_poste_centra, a.ide_cpt, a.mt, b.cible, b.ide_poste, b.ide_nd_emet, b.ide_cpt, b.mt
having ((abs(a.mt) <>  abs(b.mt)) or b.mt is null or a.mt is null)--/ 2    --- tous les cas d'anomalies
order by ide_poste_centra, a.ide_poste
;

----------------------------------------- RECHERCHE DES JOURNEES ----------------------------------------------------------
delete from centra_envoye;

insert into centra_envoye
select 'B' cible, a.ide_poste, ide_poste_centra, ide_cpt, dat_ecr, sum(decode(cod_sens, 'C', mt, -mt)) mt
from fc_ligne a, piaf_adm.rm_poste b
where a.ide_poste = b.ide_poste
and ide_jal <> 'JCENTRAL'
and a.dat_ecr between '&date_debut' and '&date_fin'
and substr(ide_cpt, 1, 3) = '390'
and substr(ide_cpt, 1, 5) <> '39031'
and substr(ide_cpt, 1, 5) <> '39032'
and a.flg_cptab = 'O'
group by a.ide_poste, ide_poste_centra, ide_cpt, dat_ecr
;

delete from centra_recu;

insert into centra_recu
select 'C' cible, a.ide_poste, ide_nd_emet, ide_cpt, to_date(substr (libn, -9)) dat_ecr, sum(decode(cod_sens, 'C', mt, -mt)) mt
from fc_ecriture a
left join fc_ligne b on a.ide_poste = b.ide_poste
and a.flg_cptab = b.flg_cptab
and a.ide_gest = b.ide_gest
and a.ide_ecr = b.ide_ecr
and a.ide_jal = b.ide_jal 
where a.ide_gest='2023'
and substr(ide_cpt, 1, 3) = '390'
and substr(ide_cpt, 1, 5) <> '39031'
and substr(ide_cpt, 1, 5) <> '39032'
and a.ide_jal='JCENTRAL'
and to_date(substr (libn, -9)) between '&date_debut' and '&date_fin'
group by a.ide_poste, ide_nd_emet, ide_cpt, to_date(substr (libn, -9))

order by 3, 4, 5
;

delete from a_traite;

insert into a_traite
select a.cible cible_e, a.ide_poste poste_emet, a.ide_poste_centra, a.ide_cpt compte_envoye, a.dat_ecr date_envoye, a.mt mt_envoye, b.cible cible_r, b.ide_poste poste_recept, b.ide_nd_emet, b.ide_cpt compte_recu, b.dat_ecr date_recu, b.mt mt_recu 
from centra_envoye a
full outer join centra_recu b on ide_poste_centra = b.ide_poste
and a.ide_poste = ide_nd_emet
and a.ide_cpt = b.ide_cpt
and a.dat_ecr = b.dat_ecr
group by a.cible, a.ide_poste, a.ide_poste_centra, a.ide_cpt, a.dat_ecr, a.mt, b.cible, b.ide_poste, b.ide_nd_emet, b.ide_cpt, b.dat_ecr, b.mt
having ((abs(a.mt) <>  abs(b.mt)) or b.mt is null or a.mt is null)--/ 2
order by ide_poste_centra, a.dat_ecr
;

delete from a_traiter;

insert into a_traiter
select cible_e, nvl(poste_emet, ide_nd_emet) poste_emet, nvl(ide_poste_centra, poste_recept) ide_poste_centra, compte_envoye, nvl(date_envoye, date_recu) date_envoye, mt_envoye, cible_r, poste_recept, 
ide_nd_emet, compte_recu, date_recu, mt_recu 
from a_traite;

delete from a_traite_avec_journee;

insert into a_traite_avec_journee
select unique cible_e, poste_emet, ide_poste_centra, compte_envoye, date_envoye, mt_envoye, cible_r, poste_recept, ide_nd_emet, compte_recu, date_recu, mt_recu, cod_ferm from a_traiter
inner join fc_calend_hist on date_envoye = dat_jc
and poste_emet = ide_poste
order by ide_poste_centra, poste_emet, date_envoye;

select * from a_traite_avec_journee 
where ide_poste_centra in (select unique A_RECEPTEUR from masse_a_traite)
order by ide_poste_centra, poste_emet
;