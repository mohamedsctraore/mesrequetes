select unique b.ide_mess from fc_ligne a, fc_ecriture b where (a.ide_poste, a.ide_gest, a.ide_jal, a.flg_cptab, a.ide_ecr)
in (select ide_poste, ide_gest, ide_jal, flg_cptab, ide_ecr 
from fc_ecriture where 
ide_poste='850C'
and ide_gest='2021'
--and dat_jc='30/06/2021'
--and ide_mess in (133404)
)
and a.ide_poste = b.ide_poste
and a.ide_gest = b.ide_gest
and a.ide_jal = b.ide_jal
and a.flg_cptab = b.flg_cptab
and a.ide_ecr = b.ide_ecr
and (mt=211745865)
--and dat_transf is not null
--and mt in ('10400','7800') ,'20/08/2021'
--and flg_cptab='N'
--and ide_cpt like '390%'
--and ide_cpt not like '39031%'
and a.ide_ecr=2197
and a.observ like 'RD ABOISSO TVA_ETAT DU 30-06-2021'