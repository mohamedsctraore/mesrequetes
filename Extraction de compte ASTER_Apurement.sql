DROP TABLE MOHAMED_COMPTE2023 
;

CREATE TABLE MOHAMED_COMPTE2023 AS 
SELECT a.ide_gest, e.ide_mess bordereau , a.ide_cpt,f.libn LIBELLE_COMPTE,c.IDE_POSTE_CENTRA,d.libn,a.ide_poste,b.libn libelle ,a.ide_tiers,a.ide_ref_piece,cod_ref_piece,a.ide_ecr,a.ide_lig_exec,a.dat_ecr,a.mt DEBIT,0 CREDIT,a.cod_sens ,a.ide_jal,a.observ,e.dat_jc,e.LIBN libelle_ecr,e.IDE_ND_EMET
FROM FC_LIGNE a ,RM_NOEUD b ,RM_POSTE c,RM_NOEUD d ,FC_ECRITURE e, FN_COMPTE f  
WHERE   a.IDE_GEST in ('2024')
AND a.COD_SENS = 'D' 
AND e.ide_mess in (39976,39977)
AND a.ide_poste in (select ide_poste from rm_poste where ide_poste_centra='657' or ide_poste='657')
AND c.IDE_POSTE		 	=	a.ide_poste
AND a.ide_poste		 	=	b.ide_nd 
AND c.IDE_POSTE_CENTRA	=	d.ide_nd 
AND a.flg_cptab			=	e.flg_cptab
AND a.IDE_GEST 			=	e.ide_gest
AND a.ide_jal 			=	e.ide_jal
AND a.ide_poste			=	e.ide_poste 
AND a.ide_ecr			=	e.ide_ecr
AND a.IDE_CPT          =   f.IDE_CPT
UNION ALL
SELECT a.ide_gest, e.ide_mess, a.ide_cpt,f.libn LIBELLE_COMPTE,c.IDE_POSTE_CENTRA,d.libn,a.ide_poste,b.libn libelle ,a.ide_tiers,a.ide_ref_piece,cod_ref_piece,a.ide_ecr,a.ide_lig_exec,a.dat_ecr,0 DEBIT, a.mt CREDIT,a.cod_sens,a.ide_jal,a.observ,e.dat_jc,e.LIBN  libelle_ecr,e.IDE_ND_EMET
FROM FC_LIGNE a ,RM_NOEUD b ,RM_POSTE c,RM_NOEUD d,FC_ECRITURE e, FN_COMPTE f    
WHERE   a.IDE_GEST = '2024'
AND a.COD_SENS = 'C'
AND e.ide_mess in (39976,39977)
AND a.ide_poste in (select ide_poste from rm_poste where ide_poste_centra='657' or ide_poste='657')
AND c.IDE_POSTE		 	=	a.ide_poste
AND a.ide_poste		 	=	b.ide_nd 
AND c.IDE_POSTE_CENTRA	=	d.ide_nd 
AND a.flg_cptab			=	e.flg_cptab
AND a.IDE_GEST 			=	e.ide_gest
AND a.ide_jal 			=	e.ide_jal
AND a.ide_poste			=	e.ide_poste 
AND a.ide_ecr			=	e.ide_ecr
AND a.IDE_CPT          =   f.IDE_CPT
;

SELECT * FROM MOHAMED_COMPTE2023 ORDER BY ide_cpt,ide_gest,ABS((DEBIT+CREDIT)),dat_ecr,ide_poste,ide_tiers,ide_jal,ide_ecr;

SELECT * FROM MOHAMED_COMPTE2023 ORDER BY ide_cpt,ide_gest,dat_ecr,ide_poste,ide_tiers,ide_jal,ide_ecr;

SELECT * FROM MOHAMED_COMPTE2023 ORDER BY ide_gest,ide_poste,bordereau,ide_jal,ide_ecr;