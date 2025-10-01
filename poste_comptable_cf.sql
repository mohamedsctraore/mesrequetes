select a.ide_poste, b.LIBC, b.LIBN, a.ide_poste_centra from rm_poste a, rm_noeud b
where a.ide_poste=a.ide_poste
and a.ide_poste=b.ide_nd
and ide_poste_centra in (
    select ide_poste_centra from rm_poste
    where ide_typ_poste='TG'
)
order by a.ide_poste_centra
;
