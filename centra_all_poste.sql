select a.ide_poste, b.dat_jc, a.IDE_JAL, a.IDE_ECR, a.VAR_CPTA, a.ide_cpt, a.cod_sens, a.spec1,a.spec2,a.spec3, a.observ, a.dat_centra, b.cod_ferm, b.dat_clot 
from fc_ligne a, fc_calend_hist b
where (a.ide_gest, a.ide_cpt, a.mt, a.observ) in
(
select a.ide_gest,a.ide_cpt,a.mt,a.observ from fc_ligne a, fc_ecriture b 
where (a.ide_poste, a.ide_gest, a.ide_jal, a.flg_cptab, a.ide_ecr)
in 
(select ide_poste, ide_gest, ide_jal, flg_cptab, ide_ecr from fc_ecriture 
where ide_poste=a.ide_poste
and a.ide_poste not like '%C'
and a.ide_gest='2021')
and a.ide_poste=b.ide_poste
and a.ide_gest=b.ide_gest
and a.ide_jal=b.ide_jal
and a.flg_cptab=b.flg_cptab
and a.ide_ecr=b.ide_ecr
and a.ide_gest=b.ide_gest
and a.flg_cptab='O'
and a.ide_cpt like '390%'
and a.ide_cpt not like '39031%'
MINUS
select a.ide_gest,a.ide_cpt,a.mt,a.observ from fc_ligne a, fc_ecriture b 
where (a.ide_poste, a.ide_gest, a.ide_jal, a.flg_cptab, a.ide_ecr)
in 
(select ide_poste, ide_gest, ide_jal, flg_cptab, ide_ecr from fc_ecriture 
where ide_poste=(select ide_poste_centra from rm_poste where ide_poste=a.ide_poste)
and a.ide_gest='2021')
--and a.ide_poste like '%C'
and a.ide_poste=b.ide_poste
and a.ide_gest=b.ide_gest
and a.ide_jal=b.ide_jal
and a.flg_cptab=b.flg_cptab
and a.ide_ecr=b.ide_ecr
and a.ide_gest=b.ide_gest
and a.ide_cpt like '390%'
and a.ide_cpt not like '39031%'
)
and a.dat_ecr=b.dat_jc
and a.ide_poste=b.ide_poste
--and b.cod_ferm not like 'O'
order by a.ide_poste,b.dat_jc
;

