delete from E000618.fc_ecriture_sygacut;
delete from E000618.fc_ligne_sygacut;
delete from E000618.fm_message_sygacut;

insert into E000618.fc_ecriture_sygacut
select *
from fc_ecriture@asterv4
where (ide_gest, ide_poste, ide_nd_emet, ide_piece)
in
(
select ide_gest, ide_poste, ide_nd_emet, ide_piece from fc_ecriture@asterv4
where ide_gest = '2024'
and (ide_poste, ide_nd_emet, ide_mess) in (select ide_poste, ide_nd_emet, ide_mess from fm_message@asterv4 where cod_typ_mess=24 and ide_gest='2024')
and libn like 'CUT%'
minus
select ide_gest, ide_poste, ide_nd_emet, ide_piece from fc_ecriture
where ide_gest = '2024'
and (ide_gest,ide_poste, ide_nd_emet, ide_mess) in (select ide_gest,ide_poste, ide_nd_emet, ide_mess from fm_message where cod_typ_mess=24 and ide_gest='2024')
and libn like 'CUT%'
)
;

insert into E000618.fc_ligne_sygacut
select * from fc_ligne@asterv4
where (ide_poste, ide_gest, ide_jal, flg_cptab, ide_ecr)
in
(
select ide_poste, ide_gest, ide_jal, flg_cptab, ide_ecr from E000618.fc_ecriture_sygacut
)
;

insert into E000618.fm_message_sygacut
select * from fm_message@asterv4
where (ide_gest, ide_nd_emet, ide_nd_emet, ide_mess)
in
(
select ide_gest, ide_poste, ide_nd_emet, ide_mess from E000618.fc_ecriture_sygacut
)
;