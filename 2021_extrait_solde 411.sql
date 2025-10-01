DROP TABLE mbouke.CPT_GEST_TMP;

DROP TABLE mbouke.CPT_GEST;

CREATE TABLE mbouke.CPT_GEST_TMP AS SELECT a.ide_gest,a.ide_cpt,a.ide_poste,SUM(DECODE(cod_sens,'D',mt,0)) BE_DB,SUM(DECODE(cod_sens,'C',mt,0)) BE_CR,0 FLUX_DB,0 FLUX_CR,0 SOLD_GES_DB,0 SOLD_GES_CR,0 SOLD_CUM_DB,0 SOLD_CUM_CR 
FROM fc_ligne a  WHERE ide_gest IN ('2020')
AND (a.ide_cpt LIKE '412%' OR a.ide_cpt LIKE '415%' OR a.ide_cpt LIKE '419%')
AND flg_cptab='O' 
AND ide_jal NOT IN ('TREP','REPMAN') 
----- and a.dat_ecr between '01/01/2020' and '30/09/2020'
---AND a.ide_poste='604' --- in (select ide_poste from rm_poste where ide_poste_centra LIKE '6%C' or ide_poste LIKE '6%C')
GROUP BY a.ide_gest,a.ide_cpt,a.ide_poste 
UNION 
SELECT a.ide_gest,a.ide_cpt,a.ide_poste,0,0,SUM(DECODE(cod_sens,'D',mt,0)) ,SUM(DECODE(cod_sens,'C',mt,0)) ,0 ,0 ,0,0 
FROM fc_ligne a , fc_ecriture b WHERE a.ide_gest IN ('2020')
AND (a.ide_cpt LIKE '412%' OR a.ide_cpt LIKE '415%' OR a.ide_cpt LIKE '419%')
AND a.flg_cptab='O' 
AND a.ide_jal NOT IN ('TREP','REPMAN') 
----- and a.dat_ecr between '01/01/2020' and '30/09/2020'
AND a.ide_poste=b.ide_poste
 AND a.ide_gest=b.ide_gest
 AND a.ide_jal=b.ide_jal
 AND a.ide_ecr=b.ide_ecr
 AND a.flg_cptab=b.flg_cptab
--- AND a.ide_poste='604' --- in (select ide_poste from rm_poste where ide_poste_centra LIKE '6%C' or ide_poste LIKE '6%C')
GROUP BY a.ide_gest,a.ide_cpt,a.ide_poste 
/*union
select a.ide_gest,a.ide_cpt,a.ide_poste,sum(decode(cod_sens,'D',mt,0)) BE_DB,sum(decode(cod_sens,'C',mt,0)) BE_CR,0 FLUX_DB,0 FLUX_CR,0 SOLD_GES_DB,0 SOLD_GES_CR,0 SOLD_CUM_DB,0 SOLD_CUM_CR 
from fc_ligne@asterx.world a where ide_gest between '2010' and '2011' 
and (a.ide_cpt like '411%' or a.ide_cpt like '398%') 
and flg_cptab='O' 
and ide_jal in ('TREP','REPMAN') 
and a.ide_cpt=b.ide_cpt 
group by a.ide_gest,a.ide_cpt,a.ide_poste 
union 
select a.ide_gest,a.ide_cpt,a.ide_poste,0,0,sum(decode(cod_sens,'D',mt,0)) ,sum(decode(cod_sens,'C',mt,0)) ,0 ,0 ,0,0 
from fc_ligne@asterx.world a where ide_gest between '2010' and '2011' 
and (a.ide_cpt like '411%' or a.ide_cpt like '398%') 
and flg_cptab='O' 
and ide_jal not in ('TREP','REPMAN') 
and a.ide_cpt=b.ide_cpt 
group by a.ide_gest,a.ide_cpt,a.ide_poste
union
select a.ide_gest,a.ide_cpt,a.ide_poste,sum(decode(cod_sens,'D',mt,0)) BE_DB,sum(decode(cod_sens,'C',mt,0)) BE_CR,0 FLUX_DB,0 FLUX_CR,0 SOLD_GES_DB,0 SOLD_GES_CR,0 SOLD_CUM_DB,0 SOLD_CUM_CR 
from fc_ligne@citfi.world a where ide_gest between '2003' and '2009' 
and (a.ide_cpt like '411%' or a.ide_cpt like '398%') 
and flg_cptab='O' 
and ide_jal in ('TREP','REPMAN') 
group by a.ide_gest,a.ide_cpt,a.ide_poste 
union 
select a.ide_gest,a.ide_cpt,a.ide_poste,0,0,sum(decode(cod_sens,'D',mt,0)) ,sum(decode(cod_sens,'C',mt,0)) ,0 ,0 ,0,0 
from fc_ligne@citfi.world a where ide_gest between '2003' and '2009' 
and (a.ide_cpt like '411%' or a.ide_cpt like '398%') 
and flg_cptab='O' 
and ide_jal not in ('TREP','REPMAN') 
group by a.ide_gest,a.ide_cpt,a.ide_poste*/
;

CREATE TABLE mbouke.CPT_GEST AS 
SELECT ide_gest,ide_cpt,ide_poste,SUM(BE_DB) BE_DB, 
SUM(BE_CR) BE_CR, 
SUM(flux_db) flux_db, 
SUM(flux_cr) flux_cr, 
SUM(DECODE(SIGN(flux_db-flux_cr),'1',flux_db-flux_cr,'-1',0,'0',0)) Sold_ges_db, 
SUM(DECODE(SIGN(flux_cr-flux_db),'1',flux_cr-flux_db,'-1',0,'0',0)) Sold_ges_cr 
FROM mbouke.CPT_GEST_TMP 
GROUP BY ide_gest,ide_cpt,ide_poste;


SELECT ide_gest,a.ide_cpt,b.libn,ide_poste_centra,d.libn,a.ide_poste,c.libn, BE_DB, 
 BE_CR, 
 flux_db, 
 flux_cr, 
 Sold_ges_db, 
 Sold_ges_cr, 
 DECODE(SIGN(Sold_ges_db+BE_DB -(Sold_ges_cr+BE_CR)),'1',Sold_ges_db+BE_DB -(Sold_ges_cr+BE_CR),'-1',0,'0',0) Sold_cum_DB, 
 DECODE(SIGN(Sold_ges_cr+BE_CR -(Sold_ges_db+BE_DB)),'1',Sold_ges_cr+BE_CR -(Sold_ges_db+BE_DB),'-1',0,'0',0) Sold_cum_CR 
 FROM mbouke.CPT_GEST a, FN_COMPTE b, RM_NOEUD c, rm_poste e, rm_noeud d
 WHERE a.ide_cpt=b.ide_cpt
 AND a.ide_poste=c.ide_nd
 AND ide_poste_centra=d.ide_nd
 AND a.ide_poste=e.ide_poste
 AND (DECODE(SIGN(Sold_ges_db+BE_DB -(Sold_ges_cr+BE_CR)),'1',Sold_ges_db+BE_DB -(Sold_ges_cr+BE_CR),'-1',0,'0',0)<>0
 OR DECODE(SIGN(Sold_ges_cr+BE_CR -(Sold_ges_db+BE_DB)),'1',Sold_ges_cr+BE_CR -(Sold_ges_db+BE_DB),'-1',0,'0',0)<>0)
 ORDER BY 1,2,4,6;


-------------------------


SELECT ide_gest GESTION,
c.libn CENTRALISATEUR,
d.libn "POSTE DECONCENTRE",
SUM(DECODE(ide_cpt,'390.304.111',DECODE(cod_sens,'D',mt,0),0)) "FLUX_DEBIT_390.304.111",
SUM(DECODE(ide_cpt,'390.304.112',DECODE(cod_sens,'D',mt,0),0)) "FLUX_DEBIT_390.304.112",
SUM(DECODE(ide_cpt,'390.304.121',DECODE(cod_sens,'D',mt,0),0)) "FLUX_DEBIT_390.304.121",
SUM(DECODE(ide_cpt,'390.304.122',DECODE(cod_sens,'D',mt,0),0)) "FLUX_DEBIT_390.304.122",
SUM(DECODE(ide_cpt,'476.311',DECODE(cod_sens,'C',mt,0),0)) "FLUX_CREDIT_476.311"
FROM fc_ligne a, rm_poste b, rm_noeud c, rm_noeud d
WHERE ide_gest IN ('2016','2015') AND flg_cptab='O'
AND ide_cpt IN ('390.304.111','390.304.112','476.311','390.304.121','390.304.122')
AND ide_jal <>'JCENTRAL'
AND ide_jal NOT IN ('TREP','REPMAN')
AND a.ide_poste=b.ide_poste
AND b.ide_poste_centra=c.ide_nd
AND a.ide_poste=d.ide_nd
GROUP BY  ide_gest,c.libn,d.libn
ORDER BY 1,2,3
