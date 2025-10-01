--select * from fc_ecriture
update fc_ecriture set cod_statut = 'AC'
where ide_gest = '2024'
and cod_statut = 'RC'
and ide_jal in ('JCENTRAL', 'JTRANSFERT');