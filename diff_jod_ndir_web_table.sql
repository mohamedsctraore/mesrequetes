delete from e000618.fc_ecriture_jodxxx;
delete from e000618.fc_ligne_jodxxx;
delete from e000618.fc_message_jodxxx;

insert into e000618.fc_ecriture_jodxxx
select * from fc_ecriture@asterv4
where ide_gest = '2024'
and ide_poste = '&&poste'
and dat_jc between '&&date_deb' and '&&dat_fin'
and ide_jal = upper('&&journal')
;

insert into e000618.fc_ligne_jodxxx
select * from fc_ligne@asterv4
where (ide_gest, ide_poste, ide_jal, ide_ecr, flg_cptab) in
(
select ide_gest, ide_poste, ide_jal, ide_ecr, flg_cptab from
fc_ecriture_jodxxx
);

insert into e000618.fc_message_jodxxx
select * from fm_message@asterv4
where (ide_gest, ide_mess, ide_nd_emet, ide_nd_emet, flg_emis_recu)
in
(
select ide_gest, ide_mess, ide_poste, ide_nd_emet, flg_emis_recu
from e000618.fc_ecriture_jodxxx
)
;