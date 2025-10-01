/*
drop table siege;

create table siege as
select unique a.ide_poste, a.ide_gest, a.ide_jal, a.ide_mess, a.ide_nd_emet, a.libn, b.cod_statut
from fc_ecriture a
inner join fm_rnl_me b on a.ide_poste = b.ide_nd_dest
and a.ide_mess = b.ide_mess
where ide_gest = '2022'
and ide_jal = 'JTRANSFERT'
and ide_poste = '507'
and b.cod_statut in ('AC', 'SA')
and b.FLG_EMIS_RECU = 'R'
order by a.ide_nd_emet, a.ide_mess;
*/

--select * from fm_rnl_me
update fm_rnl_me set cod_statut = 'AC'
where (ide_nd_dest, ide_mess, ide_nd_emet) in
(
select ide_poste, ide_mess, ide_nd_emet
from siege 
)
and FLG_EMIS_RECU = 'R'
and cod_statut <> 'TR'
and ide_nd_emet in ('216C','217C','218C','219C','2024C','2036C','2037C','2039C','2054C','2055C','2057C','2064C','2067C','220C','221C','222C','223C','224C','225C');