select a.ide_poste, b.ide_nd_emet, b.ide_mess, a.ide_gest,a.dat_ecr,a.ide_jal,a.ide_cpt,a.cod_sens,a.mt,a.observ,a.flg_cptab,a.dat_centra,a.ide_ecr,a.ide_lig,a.var_cpta, 
a.var_bud,a.ide_lig_exec,a.ide_ordo,a.spec1,a.spec2,a.spec3,a.ide_schema,a.cod_typ_schema,a.ide_modele_lig,a.DAT_REF
from fc_ligne a, fc_ecriture b where (a.ide_poste, a.ide_gest, a.ide_jal, a.flg_cptab, a.ide_ecr)
in 
(select ide_poste, ide_gest, ide_jal, flg_cptab, ide_ecr from fc_ecriture 
where ide_poste in (select ide_poste from rm_poste where ide_poste='620C' or ide_poste_centra='620C')
and a.ide_gest='2021')
and a.ide_poste=b.ide_poste
and a.ide_gest=b.ide_gest
and a.ide_jal=b.ide_jal
and a.flg_cptab=b.flg_cptab
and a.ide_ecr=b.ide_ecr
and a.ide_gest=b.ide_gest
and a.ide_cpt like '390304111%'
and a.ide_cpt not like '39031%'
and b.ide_nd_emet in ('620')
--and a.dat_ecr='23/09/2021'
--and a.observ like '17/09/%'
order by a.ide_cpt,a.mt,a.observ,a.dat_ecr,b.ide_nd_emet,a.cod_sens
;

