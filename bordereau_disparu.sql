alter session set nls_date_format = 'DD/MM/RRRR';

select unique 'insert into fm_rnl_me values ( ''P'', '''||ide_nd_emet||''', '''||ide_mess||''', ''P'', '''||ide_poste||''', ''R'', ''AC'', ''0'', '''||sysdate||''', ''MES'', '''||sysdate||''', ''MES'', ''MES'' );'
from fc_ecriture where (ide_poste, ide_nd_emet, ide_mess)
in
(
select unique ide_poste, ide_nd_emet, ide_mess
from fc_ecriture
where ide_gest = '&&gestion'
and ide_poste = '&&poste'
and flg_cptab = 'N'
minus
select unique ide_nd_dest, ide_nd_emet, ide_mess
from fm_rnl_me
where (ide_nd_dest, ide_nd_emet, ide_mess) in
(
select ide_poste, ide_nd_emet, ide_mess
from fc_ecriture
where ide_gest = '&&gestion' 
and ide_poste = '&&poste'
and flg_cptab = 'N'
)
and flg_emis_recu = 'R'
)
--order by ide_nd_emet, ide_mess
;


------------------------------------------------------------------------------------------

select * from fm_rnl_me 
--update fm_rnl_me set cod_statut = 'AC' 
where (ide_nd_dest, ide_nd_emet, ide_mess) in
(
select ide_poste, ide_nd_emet, ide_mess from fc_ecriture 
where (ide_gest, ide_poste, ide_nd_emet, ide_mess) in
(
select ide_gest, ide_nd_emet, ide_nd_emet, ide_mess from fm_message
where ide_gest = '2025'
and cod_typ_mess = 24
)
and flg_cptab = 'N' 
)
and cod_statut in ('AN','TR')
order by 2,3
;