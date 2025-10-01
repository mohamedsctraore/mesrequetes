#######################################################################################################################################
## 
## Suppression de la Table_Temporaire
##
#######################################################################################################################################

DROP TABLE piaf_adm.AMANI_COMPTE10 

#######################################################################################################################################
## 
## Creation de la Table_Temporaire
##
#######################################################################################################################################

CREATE TABLE piaf_adm.AMANI_COMPTE10 AS 
SELECT a.ide_gest,a.ide_cpt,c.IDE_POSTE_CENTRA,d.libn,a.ide_poste,b.libn libelle ,a.ide_tiers,a.ide_ref_piece,cod_ref_piece,a.ide_ecr,a.ide_lig_exec,a.dat_ecr,a.mt DEBIT,0 CREDIT,a.cod_sens ,a.ide_jal,a.observ,e.dat_jc,e.LIBN libelle_ecr,e.IDE_ND_EMET
FROM piaf_adm.FC_LIGNE a ,piaf_adm.RM_NOEUD b ,piaf_adm.RM_POSTE c,piaf_adm.RM_NOEUD d ,piaf_adm.FC_ECRITURE e  
WHERE   a.IDE_GEST ='2021'
AND a.COD_SENS = 'D' 
AND (a.IDE_CPT LIKE  '39030301%')
----AND a.ide_cpt not in ('390.30','390.31','390.309.11')
AND a.ide_poste IN (SELECT ide_poste FROM rm_poste WHERE ide_poste_centra LIKE '623C' OR ide_poste LIKE '623C')
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
AND a.dat_ecr BETWEEN '01/01/2021' AND  '30/09/2021'
UNION 
SELECT a.ide_gest,a.ide_cpt,c.IDE_POSTE_CENTRA,d.libn,a.ide_poste,b.libn libelle ,a.ide_tiers,a.ide_ref_piece,cod_ref_piece,a.ide_ecr,a.ide_lig_exec,a.dat_ecr,0 DEBIT, a.mt CREDIT,a.cod_sens,a.ide_jal,a.observ,e.dat_jc,e.LIBN  libelle_ecr,e.IDE_ND_EMET
FROM piaf_adm.FC_LIGNE a ,piaf_adm.RM_NOEUD b ,piaf_adm.RM_POSTE c,piaf_adm.RM_NOEUD d,piaf_adm.FC_ECRITURE e    
WHERE   a.IDE_GEST ='2021'
AND a.COD_SENS = 'C' 
AND (a.IDE_CPT LIKE  '39030301%')
----AND a.ide_cpt not in ('390.30','390.31','390.309.11')
AND a.ide_poste IN (SELECT ide_poste FROM rm_poste WHERE ide_poste_centra LIKE '623C' OR ide_poste LIKE '623C')
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
AND a.dat_ecr BETWEEN '01/01/2021' AND  '30/09/2021'

#######################################################################################################################################
## 
## Affichage du contenu de la Table_Temporaire
##
#######################################################################################################################################

SELECT * FROM piaf_adm.AMANI_COMPTE10 ORDER BY ide_gest,ide_cpt,(DEBIT+CREDIT),ide_tiers,ide_jal,ide_ecr,dat_ecr




SELECT 423243-298611 FROM dual
