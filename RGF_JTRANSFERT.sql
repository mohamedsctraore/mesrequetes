select * from fc_ligne a, fc_ecriture b
where a.ide_gest = b.ide_gest
and a.ide_ecr = b.ide_ecr
and a.flg_cptab = b.flg_cptab
and a.ide_jal = b.ide_jal
and a.ide_poste = b.ide_poste
and a.ide_jal = 'JTRANSFERT'
and a.ide_gest = '2024'
and a.flg_cptab = 'N'
--and ide_nd_emet <> '896C'
and a.ide_poste = '502'
and ide_cpt not in ('39112','4663154','4751108')
--and mt <= 0
;


select * from fc_ligne a, fc_ecriture b
where a.ide_gest = b.ide_gest
and a.ide_ecr = b.ide_ecr
and a.flg_cptab = b.flg_cptab
and a.ide_jal = b.ide_jal
and a.ide_poste = b.ide_poste
and a.ide_jal = 'JTRANSFERT'
and a.ide_gest = '2024'
and a.flg_cptab = 'O'
--and ide_nd_emet <> '896C'
and a.ide_poste = '502'
and ide_nd_emet = '603C'
and mt in (25000,155650,50000)
;