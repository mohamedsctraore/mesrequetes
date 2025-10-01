DROP TABLE MOHAMED_COMPTE2022 
;

CREATE TABLE MOHAMED_COMPTE2022 AS 
SELECT a.ide_gest,a.ide_cpt,f.libn LIBELLE_COMPTE,c.IDE_POSTE_CENTRA,d.libn,a.ide_poste,b.libn libelle ,a.ide_tiers,a.ide_ref_piece,cod_ref_piece,a.ide_ecr,a.ide_lig_exec,a.dat_ecr,a.mt DEBIT,0 CREDIT,a.cod_sens ,a.ide_jal,a.observ,e.dat_jc,e.LIBN libelle_ecr,e.IDE_ND_EMET
FROM FC_LIGNE a ,RM_NOEUD b ,RM_POSTE c,RM_NOEUD d ,FC_ECRITURE e, FN_COMPTE f  
WHERE   a.IDE_GEST in ('2023')
AND a.COD_SENS = 'D' 
----AND a.ide_jal in ('JPECDEPBG')   -------and ide_jal='JODPGAP'
AND a.ide_cpt in ('47551')
and (ide_ref_piece, cod_ref_piece) in
(
select ide_ref_piece, cod_ref_piece
from fc_ligne
where ide_gest = '2023'
and ide_poste = '502'
and flg_cptab = 'O'
and ide_cpt = '47551'
having sum(decode(cod_sens, 'C', mt, -mt)) <> 0
group by ide_ref_piece, cod_ref_piece
--order by ide_ref_piece
)
------ and a.dat_maj like '%08/03/2021%' or a.dat_maj like '%09/03/2021%'
---and e.LIBN like '%OITH%'
---AND a.ide_lig_exec like  ('%71111%')
AND a.ide_poste in (select ide_poste from rm_poste where ide_poste_centra='502' or ide_poste='502')
---and a.ide_tiers in ('PAIMSC','253') ---- is not null
---AND a.spec2='474.3'
--AND a.spec1='7233'
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
AND a.dat_ecr between '01/01/2023' and '05/04/2023'
UNION 
SELECT a.ide_gest,a.ide_cpt,f.libn LIBELLE_COMPTE,c.IDE_POSTE_CENTRA,d.libn,a.ide_poste,b.libn libelle ,a.ide_tiers,a.ide_ref_piece,cod_ref_piece,a.ide_ecr,a.ide_lig_exec,a.dat_ecr,0 DEBIT, a.mt CREDIT,a.cod_sens,a.ide_jal,a.observ,e.dat_jc,e.LIBN  libelle_ecr,e.IDE_ND_EMET
FROM FC_LIGNE a ,RM_NOEUD b ,RM_POSTE c,RM_NOEUD d,FC_ECRITURE e, FN_COMPTE f    
WHERE   a.IDE_GEST in ('2023')
AND a.COD_SENS = 'C' 
----AND a.ide_jal in ('JPECDEPBG')   -------and ide_jal='JODPGAP'
AND a.ide_cpt in ('47551')
and (ide_ref_piece, cod_ref_piece) in
(
select ide_ref_piece, cod_ref_piece
from fc_ligne
where ide_gest = '2023'
and ide_poste = '502'
and flg_cptab = 'O'
and ide_cpt = '47551'
having sum(decode(cod_sens, 'C', mt, -mt)) <> 0
group by ide_ref_piece, cod_ref_piece
--order by ide_ref_piece
)
------ and a.dat_maj like '%08/03/2021%' or a.dat_maj like '%09/03/2021%'
---and e.LIBN like '%OITH%'
---AND a.ide_lig_exec like  ('%71111%')
--AND a.ide_poste in (select ide_poste from rm_poste where ide_poste_centra='510C' or ide_poste='510C')
---and a.ide_tiers in ('PAIMSC','253') ---- is not null
---AND a.spec2='474.3'
--AND a.spec1='7233'
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
AND a.ide_poste in (select ide_poste from rm_poste where ide_poste_centra='502' or ide_poste='502')
;

SELECT * FROM MOHAMED_COMPTE2022 ORDER BY ide_gest,ide_cpt,ABS((DEBIT+CREDIT)),dat_ecr,ide_poste,ide_tiers,ide_jal,ide_ecr
;

SELECT sum(debit), sum(credit), sum(debit) - sum(credit) FROM MOHAMED_COMPTE2022;