----------- CONTROLE DE LA DEPECHE ------------------------
drop table echec_depeche;

create table echec_depeche as
select a.ide_nd_emet, b.ide_poste ide_nd_dest, a.ide_depeche, a.ide_mess, b.libn, count(b.ide_mess) nb
from fm_de_me a
left join fc_ecriture b on a.ide_nd_emet = b.ide_nd_emet
and a.ide_mess = b.ide_mess
where ide_depeche between 30448 and 30454
and a.flg_emis_recu = 'E'
group by a.ide_nd_emet, a.ide_mess, a.ide_depeche, b.ide_poste, b.libn
order by ide_nd_emet;

----------- IDENTIFICATION DES ELEMENTS QUI ONT ECHOUE -------------------
drop table centra_transf_echoue;

create table centra_transf_echoue as
select a.ide_nd_emet, a.ide_nd_dest, a.ide_depeche, a.ide_mess, b.libl, a.nb, b.nbr_piece, a.libn
from echec_depeche a
inner join fm_message b on a.ide_mess = b.ide_mess
and a.ide_nd_emet = b.ide_nd_emet
where b.libl not like 'Notification%'
order by ide_nd_emet;

select unique ide_nd_dest, ide_nd_emet, ide_depeche, ide_mess, libn, nb, nbr_piece--libl, 
from centra_transf_echoue
--where nb <> nbr_piece
where ide_nd_emet = '201C'
and ide_nd_dest = '236C'
order by ide_depeche, ide_nd_dest, ide_mess;

select unique ide_nd_dest, b.libn, ide_nd_emet, ide_depeche, ide_mess, a.libn, nb, nbr_piece--libl, 
from centra_transf_echoue a
inner join rm_noeud b on a.ide_nd_dest = b.ide_nd
--where nb <> nbr_piece
where ide_nd_emet = '201C'
order by ide_depeche, ide_nd_dest, ide_mess;

----------- IDENTIFICATION DES ELEMENTS QUI ONT ECHOUE -------------------
--drop table centra_transf_echoue;
/*
create table centra_transf_echoue as
select a.ide_nd_emet, a.ide_mess,libl,mt_cr,mt_db, nb
from echec_depeche a
inner join fm_message c on a.ide_nd_emet = c.ide_nd_emet
and a.ide_mess = c.ide_mess
and cod_typ_mess in (12, 11)
and nb = 0;

select *
from centra_transf_echoue
order by ide_nd_emet;
*/

--------- NOTIFICATION --------------
drop table depeche_notification;

create table depeche_notification as
select a.ide_nd_emet, a.ide_mess,libl,mt_cr,mt_db, nb
from echec_depeche a
inner join fm_message c on a.ide_nd_emet = c.ide_nd_emet
and a.ide_mess = c.ide_mess
and cod_typ_mess not in (12, 11)
and nb = 0;

select *
from depeche_notification;

--------------- SITUATION DES BORDEREAUX -------------------
drop table annul_bord;

create table annul_bord as
select a.ide_nd_dest, a.ide_nd_emet, a.ide_mess,mt_cr,mt_db, a.cod_statut
from fm_rnl_me a
inner join centra_transf_echoue b on a.ide_nd_emet = b.ide_nd_emet
and a.ide_mess = b.ide_mess
and flg_emis_recu = 'R';

select *
from annul_bord;

------------  ANNULATION DES BORDEREAUX VIDES ----------------
select *
from fm_rnl_me
where (ide_nd_dest, ide_nd_emet, ide_mess, cod_statut) in
(
select ide_nd_dest, ide_nd_emet, ide_mess, cod_statut
from annul_bord
)
and flg_emis_recu = 'R'
and cod_statut not in ('AN','TR')
and nbr_piece = 0;

update fm_rnl_me set cod_statut = 'AN'
where (ide_nd_dest, ide_nd_emet, ide_mess, cod_statut) in
(
select ide_nd_dest, ide_nd_emet, ide_mess, cod_statut
from annul_bord
)
and flg_emis_recu = 'R'
and cod_statut not in ('AN','TR')
and nbr_piece = 0;