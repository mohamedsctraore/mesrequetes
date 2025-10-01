select count(*) from fc_ecriture
where cod_statut='RC'
and ide_gest='2021'
;

select * from fc_ecriture
where cod_statut='RC'
and ide_gest='2021'
;

select count(*) from fc_ecriture
where ide_gest='2021'
and ide_jal='JCENTRAL'
and cod_statut<>'CO'
;

select * from fc_ecriture
where ide_gest='2021'
and ide_jal='JCENTRAL'
and cod_statut<>'CO'
;

select count(*) from fc_ecriture
where ide_gest='2021'
and ide_jal='JTRANSFERT'
and cod_statut<>'CO'
;

select * from fc_ecriture
where ide_gest='2021'
and ide_jal='JTRANSFERT'
and cod_statut<>'CO'
;

select unique ide_poste, ide_nd_emet, ide_mess, libn from fc_ecriture
where ide_gest='2021'
and ide_jal='JCENTRAL'
and cod_statut<>'CO'
order by ide_poste
;

select unique ide_poste, ide_nd_emet, ide_mess, libn from fc_ecriture
where ide_gest='2021'
and ide_jal='JTRANSFERT'
and cod_statut<>'CO'
order by ide_poste
;