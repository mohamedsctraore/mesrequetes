select ide_piece from fb_ligne_piece
where ide_gest='2021'
and ide_poste='503'
and ide_cpt in ('4081')
;
--minus 
select ide_piece from fb_ligne_tiers_piece
where ide_gest='2021'
and ide_poste='503'
and ide_cpt in ('4081')
;