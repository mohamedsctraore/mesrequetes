select b.ide_poste, a.libn, a.libc, b.ide_typ_poste from rm_poste b,rm_noeud a
where b.IDE_POSTE=a.IDE_ND and
a.cod_typ_nd='P'
and b.ide_poste not like '%C'
and b.ide_typ_poste not like 'ACCD' 
and b.ide_typ_poste not like 'AACCD%'
and b.ide_typ_poste not like 'TDGI' 
and b.ide_typ_poste not like 'TCDGI' 
and b.ide_typ_poste not like 'TDGD'
and b.ide_typ_poste not like 'ADMIN'
and b.ide_typ_poste not like 'EPN'
--and b.ide_typ_poste not like 'ACP'
--and b.ide_typ_poste not like 'C2D'
and b.ide_typ_poste not like 'P'
and b.ide_typ_poste not like 'RPI'
and a.libc not like 'RPD%'
order by b.ide_typ_poste
;

select * from rm_poste
where ide_poste not like '%C'
;