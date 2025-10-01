select a.ide_poste, a.ide_nd_emet, a.ide_schema, a.ide_gest, a.ide_jal, a.ide_ecr, a.dat_jc, a.ide_mess, a.libn, b.ide_cpt, b.cod_sens, b.mt, b.observ, b.ide_modele_lig
from fc_ecriture a
inner join fc_ligne b on a.ide_gest=b.ide_gest
and a.flg_cptab=b.flg_cptab
and a.ide_ecr=b.ide_ecr
and a.ide_poste=b.ide_poste
and a.dat_ecr=b.dat_ecr
and a.ide_jal=b.ide_jal
where a.ide_gest='2021'
and a.ide_poste='504'
and a.ide_mess=34118;