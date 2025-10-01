drop table nvl_ecriture;

create table nvl_ecriture as
select a.ide_poste, c.libn libl_poste, d.ide_poste_centra, a.ide_mess, a.libn libl_ecriture
from fc_ecriture a
inner join fm_rnl_me b on a.ide_poste = b.ide_nd_dest
inner join rm_noeud c on a.ide_poste = c.ide_nd
inner join rm_poste d on a.ide_poste = d.ide_poste
and a.ide_mess = b.ide_mess
and a.ide_nd_emet = b.ide_nd_emet 
where ide_gest = '2023'
and flg_cptab = 'N'
and b.flg_emis_recu = 'R'
and b.cod_statut not in ('AN','TR')
order by d.ide_poste_centra, a.ide_poste, ide_mess;


update nvl_ecriture
set ide_poste_centra = ide_poste
where ide_poste_centra = '501C';

select unique ide_poste, libl_poste, ide_poste_centra, a.ide_mess, b.libl
from nvl_ecriture a
inner join fm_message b on ide_poste = ide_nd_emet
and a.ide_mess = b.ide_mess
where ide_poste_centra in 
(
select ide_poste from rm_poste where ide_typ_poste = 'TC' 
)
order by ide_poste_centra, ide_poste;

select unique ide_poste, libl_poste, ide_poste_centra, a.ide_mess, b.libl
from nvl_ecriture a
inner join fm_message b on ide_poste = ide_nd_emet
and a.ide_mess = b.ide_mess
where ide_poste_centra in ('510C')
order by ide_poste_centra, ide_poste;

select unique ide_poste, libl_poste, ide_poste_centra, a.ide_mess, b.libl
from nvl_ecriture a
inner join fm_message b on ide_poste = ide_nd_emet
and a.ide_mess = b.ide_mess
where ide_poste in (select ide_poste from rm_poste where ide_typ_poste in ('ACCD','AACCD','AACDC'))
order by ide_poste_centra, ide_poste;