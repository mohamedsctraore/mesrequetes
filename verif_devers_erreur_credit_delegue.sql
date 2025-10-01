select a.ide_poste, a.ide_piece, b.ide_cpt, mt, observ
from fc_ecriture a
left join fc_ligne b on a.ide_poste = b.ide_poste
and a.flg_cptab = b.flg_cptab
and a.ide_gest = b.ide_gest
and a.ide_ecr = b.ide_ecr
and a.ide_jal = b.ide_jal 
where a.ide_gest='2024'
and b.ide_cpt = '474311'
and a.flg_cptab = 'N'
and cod_sens = 'C'
and cod_typ_schema = 'T'
;