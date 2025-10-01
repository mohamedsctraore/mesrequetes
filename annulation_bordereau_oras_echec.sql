--select * from fm_rnl_me
update fm_rnl_me set cod_statut = 'AN'
where (ide_nd_dest, ide_nd_emet, ide_mess, flg_emis_recu)
in
(
select a.ide_nd_dest, a.ide_nd_emet, a.ide_mess, a.flg_emis_recu from fm_rnl_me a
left join fc_ecriture b on a.ide_mess = b.ide_mess
and a.ide_nd_dest = b.ide_poste
and a.ide_nd_emet = b.ide_nd_emet
left join fm_message c on a.ide_nd_emet = c.ide_nd_emet
and a.ide_nd_dest = c.ide_nd_emet
and a.ide_mess = c.ide_mess
where b.ide_mess is null
and a.flg_emis_recu = 'R'
and a.cod_statut in ('SA','AC')
and a.ide_nd_dest in (select ide_poste from piaf_adm.rm_poste where ide_typ_poste in ('AACCD', 'ACCD'))
and c.libl like '%ORION%'
)
;

select unique a.ide_nd_dest, a.ide_nd_emet, a.ide_mess, count(a.ide_mess), a.flg_emis_recu, b.cod_statut from fm_rnl_me a
inner join fc_ecriture b on a.ide_mess = b.ide_mess
and a.ide_nd_dest = b.ide_poste
and a.ide_nd_emet = b.ide_nd_emet
inner join fm_message c on a.ide_nd_emet = c.ide_nd_emet
and a.ide_nd_dest = c.ide_nd_emet
and a.ide_mess = c.ide_mess
where (b.ide_poste, b.ide_nd_emet, b.ide_mess) in (select unique ide_poste, ide_nd_emet, ide_mess from fc_ecriture where cod_statut = 'CO' and (cod_statut <> 'AC' or cod_statut <> 'SA') )
and a.flg_emis_recu = 'R'
and a.cod_statut <> 'TR'
--and (b.cod_statut <> 'AC' AND b.cod_statut <> 'SA')
and a.ide_nd_dest in (select ide_poste from piaf_adm.rm_poste where ide_typ_poste in ('AACCD', 'ACCD'))
and c.libl like '%ORION%'
having count(a.ide_mess) = 1 and b.cod_statut = 'CO'
group by a.ide_nd_dest, a.ide_nd_emet, a.ide_mess, a.flg_emis_recu
order by 1, 5;


select ide_poste, ide_nd_emet, ide_mess from fc_ecriture where cod_statut <> 'AC' and cod_statut <> 'SA';