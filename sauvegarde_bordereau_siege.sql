/*
select * from fm_rnl_me
--update fm_rnl_me set cod_statut = 'AN'
where ide_nd_emet = '507'
and ide_nd_dest = '507'
--and cod_statut <> 'TR'
--and cod_statut = 'SA'
and ide_mess between 175561 and 186422;


select unique ide_mess, cod_statut
from fc_ecriture
where ide_gest = '2022'
and ide_jal = 'JTRANSFERT'
and ide_poste in ('507')
and ide_nd_emet = '201C'
and cod_statut <> 'CO';

*/

--select * from fm_rnl_me 
update fm_rnl_me set cod_statut = 'AC'
where ide_nd_emet = '201C' and ide_nd_dest = '507' and flg_emis_recu = 'R'
and ide_mess in
('89843',
'90759',
'92846',
'92880',
'87636',
'88178',
'88610',
'88686',
'88882',
'89031',
'89115',
'89332',
'89380',
'90834',
'92504',
'88518',
'87103',
'88855',
'88998',
'90448',
'89889',
'90697',
'92444',
'92268',
'92650',
'92803',
'87239',
'88455',
'89416',
'90158',
'90798',
'93104',
'93701',
'89146',
'89077',
'89252',
'90054',
'90883',
'90939',
'92713',
'92746',
'93127',
'86795',
'90097',
'90130',
'93303',
'88014',
'87975',
'88943',
'88944',
'88975',
'89203',
'90725',
'92537',
'92604',
'86865',
'87015',
'88924',
'89466',
'89557',
'90012',
'90731',
'92106',
'92051',
'92391',
'92689',
'87895',
'88928',
'88994',
'90514',
'89056',
'89275',
'89597')