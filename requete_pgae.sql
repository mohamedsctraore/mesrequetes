select unique EXTRACT(Month from to_date(substr(libn, -9))) mois, ide_poste, count(ide_mess) nbre_transfert, flg_cptab denouees
from fc_ecriture
where ide_gest = '2024'
and ide_poste = '503'
and ide_jal = 'JTRANSFERT'
--and flg_cptab = 'O'
group by ide_poste, flg_cptab, EXTRACT(Month from to_date(substr(libn, -9)))
--order by month(to_date(substr (a.libn, -9)))
order by 1
;

select unique EXTRACT(Month from to_date(substr(libn, -9))) mois, ide_poste, ide_nd_emet emetteur, count(ide_mess) nbre_transfert, flg_cptab denouees
from fc_ecriture
where ide_gest = '2024'
and ide_poste = '503'
and ide_jal = 'JTRANSFERT'
--and flg_cptab = 'O'
group by ide_poste, flg_cptab, EXTRACT(Month from to_date(substr(libn, -9))), ide_nd_emet
--order by month(to_date(substr (a.libn, -9)))
order by 1
;

select unique EXTRACT(Month from to_date(substr(libn, -9))) mois, ide_poste, ide_mess bordereau, libn
from fc_ecriture
where ide_gest = '2024'
and ide_poste = '503'
and ide_jal = 'JTRANSFERT'
and flg_cptab = 'O'
--group by ide_poste, flg_cptab, EXTRACT(Month from to_date(substr(libn, -9))), ide_nd_emet
--order by month(to_date(substr (a.libn, -9)))
order by 1
;

select unique EXTRACT(Month from to_date(substr(libn, -9))) mois, ide_poste, ide_mess bordereau, libn
from fc_ecriture
where ide_gest = '2024'
and ide_poste = '503'
and ide_jal = 'JTRANSFERT'
and flg_cptab = 'N'
--group by ide_poste, flg_cptab, EXTRACT(Month from to_date(substr(libn, -9))), ide_nd_emet
--order by month(to_date(substr (a.libn, -9)))
order by 1
;