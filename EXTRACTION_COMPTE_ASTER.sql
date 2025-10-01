create table ext as
SELECT a.ide_gest,a.ide_cpt,f.libn LIBELLE_COMPTE,c.IDE_POSTE_CENTRA,d.libn,a.ide_poste,b.libn libelle ,a.ide_tiers,a.ide_ref_piece,cod_ref_piece,a.ide_ecr,a.ide_lig_exec,a.dat_ecr,a.mt DEBIT,0 CREDIT,a.cod_sens ,a.ide_jal,a.observ,e.dat_jc,e.LIBN libelle_ecr,e.IDE_ND_EMET,spec3
FROM FC_LIGNE a ,RM_NOEUD b ,RM_POSTE c,RM_NOEUD d ,FC_ECRITURE e, FN_COMPTE f  
WHERE   a.IDE_GEST between '2020' and '2023'
AND a.COD_SENS = 'D' 
and a.ide_jal = 'JODACCT'
AND a.ide_cpt like '39112'
and 
(
observ like '%QUOT%' or observ like '%QPI%'
)
and spec3 in (select ide_poste from rm_poste where ide_typ_poste = 'TC')
AND c.IDE_POSTE		 	=	a.ide_poste
AND a.ide_poste		 	=	b.ide_nd 
AND c.IDE_POSTE_CENTRA	=	d.ide_nd 
AND a.flg_cptab			=	e.flg_cptab
AND a.IDE_GEST 			=	e.ide_gest
AND a.ide_jal 			=	e.ide_jal
AND a.ide_poste			=	e.ide_poste 
AND a.flg_cptab			=	'O'
AND a.ide_ecr			=	e.ide_ecr
AND a.dat_ecr			=	e.dat_ecr
AND a.IDE_CPT          =   f.IDE_CPT
AND a.dat_ecr between '01/01/2020' and '31/12/2023'
UNION 
SELECT a.ide_gest,a.ide_cpt,f.libn LIBELLE_COMPTE,c.IDE_POSTE_CENTRA,d.libn,a.ide_poste,b.libn libelle ,a.ide_tiers,a.ide_ref_piece,cod_ref_piece,a.ide_ecr,a.ide_lig_exec,a.dat_ecr,0 DEBIT, a.mt CREDIT,a.cod_sens,a.ide_jal,a.observ,e.dat_jc,e.LIBN  libelle_ecr,e.IDE_ND_EMET,spec3
FROM FC_LIGNE a ,RM_NOEUD b ,RM_POSTE c,RM_NOEUD d,FC_ECRITURE e, FN_COMPTE f    
WHERE   a.IDE_GEST between '2020' and '2023'
AND a.COD_SENS = 'C' 
and a.ide_jal = 'JODACCT'
AND a.ide_cpt like '39112'
and 
(
observ like '%QUOT%' or observ like '%QPI%'
)
and spec3 in (select ide_poste from rm_poste where ide_typ_poste = 'TC')
AND c.IDE_POSTE		 	=	a.ide_poste
AND a.ide_poste		 	=	b.ide_nd 
AND c.IDE_POSTE_CENTRA	=	d.ide_nd 
AND a.flg_cptab			=	e.flg_cptab
AND a.IDE_GEST 			=	e.ide_gest
AND a.ide_jal 			=	e.ide_jal
AND a.ide_poste			=	e.ide_poste 
AND a.flg_cptab			=	'O'
AND a.ide_ecr			=	e.ide_ecr
AND a.dat_ecr			=	e.dat_ecr
AND a.IDE_CPT          =   f.IDE_CPT
AND a.dat_ecr between '01/01/2020' and '31/12/2023'
--order by spec3, e.dat_jc
;

select * from ext order by spec3, observ, dat_jc;