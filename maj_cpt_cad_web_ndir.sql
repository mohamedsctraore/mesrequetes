
--select ide_poste, ide_poste, ide_gest from fb_ligne_piece@asterv4 a
--inner join fb_ligne_piece b on a.ide_piece = b.ide_piece
update fb_ligne_piece b set ide_cpt = (select ide_cpt from fb_ligne_piece@asterv4 a where a.ide_poste = b.ide_poste and a.ide_piece = b.ide_piece and a.ide_gest = b.ide_gest)
where ide_poste in (select ide_poste from rm_poste where ide_typ_poste = 'PC')
and ide_gest = '2024'
and ide_cpt is null;


--select ide_poste, ide_poste, ide_gest from fb_ligne_tiers_piece@asterv4 a
--inner join fb_ligne_tiers_piece b on a.ide_piece = b.ide_piece
update fb_ligne_tiers_piece b set ide_cpt = (select ide_cpt from fb_ligne_tiers_piece@asterv4 a where a.ide_poste = b.ide_poste and a.ide_piece = b.ide_piece and a.ide_gest = b.ide_gest)
where ide_poste in (select ide_poste from rm_poste where ide_typ_poste = 'PC')
and ide_gest = '2024'
and ide_cpt is null;