select a.ide_poste, b.dat_jc, a.IDE_JAL, a.IDE_ECR, a.VAR_CPTA, a.ide_cpt, a.cod_sens, a.mt, a.spec1,a.spec2,a.spec3, a.observ, a.dat_centra, b.cod_ferm, b.dat_clot from fc_ligne a, fc_calend_hist b
where (a.ide_gest, a.ide_cpt, a.mt, a.observ) in
(
select a.ide_gest,a.ide_cpt,a.mt,a.observ from fc_ligne a, fc_ecriture b 
where (a.ide_poste, a.ide_gest, a.ide_jal, a.flg_cptab, a.ide_ecr)
in 
(select ide_poste, ide_gest, ide_jal, flg_cptab, ide_ecr from fc_ecriture 
where ide_poste='201'
and a.ide_gest='2024')
and a.ide_poste=b.ide_poste
and a.ide_gest=b.ide_gest
and a.ide_jal=b.ide_jal
and a.flg_cptab=b.flg_cptab
and a.ide_ecr=b.ide_ecr
and a.ide_gest=b.ide_gest
and a.flg_cptab='O'
and a.ide_cpt like '390%'
and a.ide_cpt not in ('390312','39032')
MINUS
select a.ide_gest,a.ide_cpt,a.mt,a.observ from fc_ligne a, fc_ecriture b 
where (a.ide_poste, a.ide_gest, a.ide_jal, a.flg_cptab, a.ide_ecr)
in 
(select ide_poste, ide_gest, ide_jal, flg_cptab, ide_ecr from fc_ecriture 
where ide_poste='201C'
and a.ide_gest='2024')
and a.ide_poste=b.ide_poste
and a.ide_gest=b.ide_gest
and a.ide_jal=b.ide_jal
and a.flg_cptab=b.flg_cptab
and a.ide_ecr=b.ide_ecr
and a.ide_gest=b.ide_gest
and a.ide_cpt like '390%'
and a.ide_cpt not like '390312%'
)
and a.dat_ecr=b.dat_jc
and a.ide_poste=b.ide_poste
and a.ide_poste in ('201','201C')
order by dat_jc, ide_ecr
;

