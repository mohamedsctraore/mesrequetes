--select * from fm_rnl_me 
update fm_rnl_me set cod_statut = 'AC'
where (ide_nd_dest, ide_mess)
in
(
select unique ide_nd_dest, b.ide_mess from fb_piece a, fm_rnl_me b
where a.ide_mess = b.ide_mess
and b.ide_nd_dest = a.ide_poste 
and ide_gest = '2024'
and a.cod_statut = 'AC'
and type_acte = 'M'
and b.cod_statut = 'AN'
and b.flg_emis_recu = 'R'
);