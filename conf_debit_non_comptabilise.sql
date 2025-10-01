select * from fm_message
where (ide_nd_emet, ide_mess) in
(

select unique ide_poste, ide_mess from fc_ecriture
where ide_gest = '2023'
and ide_poste = '501'
and ide_mess in (
select ide_mess from fm_message
where ide_gest = '2023'
and ide_nd_emet = '501'
and libl like 'CUT%DEBIT%'
and flg_emis_recu = 'R'
and cod_typ_mess = '24'
)
and flg_cptab = 'N'
)
order by ide_mess desc
;