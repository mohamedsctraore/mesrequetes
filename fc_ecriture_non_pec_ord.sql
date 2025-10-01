select a.ide_piece, b.ide_cpt, mt
from fc_ecriture a
left join fc_ligne b on a.ide_poste = b.ide_poste
and a.flg_cptab = b.flg_cptab
and a.ide_gest = b.ide_gest
and a.ide_ecr = b.ide_ecr
and a.ide_jal = b.ide_jal 
where a.ide_gest='2022'
and a.ide_poste = '657C'
and a.ide_jal='JPECDEPBG'
and a.ide_piece like '3%'
and b.ide_cpt = '4082'
and a.dat_jc <= '30/04/2022'
--and b.mt = 2000000

minus

select ide_piece, ide_cpt, mt
from fb_ligne_piece
where (ide_piece, ide_poste, ide_gest) in
  (
   select ide_piece, ide_poste, ide_gest 
   from fb_piece where
   ide_gest in ('2022')
   and ide_poste = '657C'
   and ide_cpt = '4082'
   and dat_cad <= '30/04/2022'
  )