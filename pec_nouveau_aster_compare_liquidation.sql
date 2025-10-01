select liq_num from
sibinterface.sib_mandat where mandat_code in
(
select ide_piece
from fb_ligne_piece@lkast
where (ide_piece, ide_poste, ide_gest) in
(select ide_piece, ide_poste, ide_gest 
from fb_piece@lkast where
ide_gest in ('2022')
and ide_poste = '602C'
and ide_cpt = '4081'
)
)

minus 

select ide_piece
from fb_ligne_tiers_piece@lkast
where (ide_piece, ide_poste, ide_gest) in
(select ide_piece, ide_poste, ide_gest 
from fb_piece@lkast where
ide_gest in ('2022')
and ide_poste = '602C'
and ide_cpt = '4081'
)
;