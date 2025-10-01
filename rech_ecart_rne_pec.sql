Select unique ide_nd_emet, ide_piece, mt From Fb_piece
Where ide_gest = '2025'
and ide_nd_emet like '4%'
and cod_statut = 'VI'
and type_acte = 'M'
--and ide_piece = '317216025100216'
minus
select unique ide_poste, substr(observ,-15), mt from fc_ligne
where ide_gest = '2025'
and ide_poste like '4%'
and ide_schema = 'CONSTAPEC'
and cod_sens = 'C'
--and substr(observ,-15) = '317216025100216'
;
