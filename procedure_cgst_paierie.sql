---------------------------------------------  ---------------------
CREATE OR REPLACE PROCEDURE CGST.Prepa_Bgct_Ac_ppc (p_gestion IN NUMBER,dat_fin DATE,p_poste varchar2)  IS
-- CREATE TABLE ETAT_CGAF_BGFG_TMP AS SELECT ide_poste,ide_cpt,mt BE_D,mt BE_C,mt OA_D,mt OA_C,mt SA_D,mt SA_C,mt OFAI_D,mt OFAI_C,mt BS_D,mt BS_C FROM FC_LIGNE WHERE ide_poste='RENS'

---  CREATE TABLE ETAT_CGAF_BGFG_TMP_2003 AS SELECT * FROM ETAT_CGAF_BGFG_TMP

------------- Initialisation des tables ---------------------------------

v_gest NUMBER(4);
v_uuid VARCHAR2(50);

BEGIN

DELETE FROM ETAT_CGAF_BGFG_TMP_AC;
DELETE FROM ETAT_CGAF_BGFG_AC;
DELETE FROM ETAT_CGAF_BGCT_AC;
DELETE FROM ETAT_CGAF_CGAF_AC;


-- DELETE FROM PRE_CUMUL_GLOB_2004
-- DELETE FROM PRE_ECRITURE_GLOB_2004
-- DELETE FROM PRE_LIGNE_GLOB_2004

COMMIT;

   SELECT SYS_GUID() INTO v_uuid FROM dual;

   ------------ Calcul des Balances d'Entrée dans FC_LIGNE année courante --------------

   INSERT INTO ETAT_CGAF_BGFG_TMP_AC
   SELECT ide_cpt,SUM(mt),0,0,0,0,0,0,0,0,0,0,v_uuid FROM PIAF_ADM.FC_LIGNE
   WHERE ide_gest=TO_CHAR(p_gestion) AND ide_jal='TREP' and ide_poste=p_poste AND FLG_CPTAB = 'O' AND dat_ecr<=dat_fin AND cod_sens='D' AND ( ide_poste NOT LIKE '%C' OR 
   ide_poste='501C')
   GROUP BY  ide_cpt
   UNION
   SELECT ide_cpt,0,SUM(mt),0,0,0,0,0,0,0,0,0,v_uuid FROM PIAF_ADM.FC_LIGNE
   WHERE ide_gest=TO_CHAR(p_gestion) AND ide_jal='TREP' and ide_poste=p_poste AND FLG_CPTAB = 'O' AND dat_ecr<=dat_fin AND cod_sens='C'  AND ( ide_poste NOT LIKE '%C' OR 
   ide_poste='501C')
   GROUP BY  ide_cpt;
   COMMIT;

   --------------------------------------------------------------------------------------------------------------------------------
   -----------  Calcul des Operations de l'Année courante dans FC_CUMUL --------------------------------------------------------------------
   --------------------------------------------------------------------------------------------------------------------------------
   INSERT INTO ETAT_CGAF_BGFG_TMP_AC
   SELECT ide_cpt,0,0,SUM(mt_db),SUM(mt_cr),0,0,0,0,0,0,0,v_uuid FROM PIAF_ADM.FC_CUMUL
   WHERE ide_gest=TO_CHAR(p_gestion) AND dat_arrete<>'01/01/'||TO_CHAR(p_gestion)||''  AND dat_arrete<=dat_fin --AND ide_cpt not like '90%'
   and ide_poste=p_poste
   GROUP BY ide_cpt;
   COMMIT;

   /*--- TRAITEMENT DES 90 ----------------

   INSERT INTO ETAT_CGAF_BGFG_TMP_AC
   SELECT b.compte,0,0,SUM(a.mt),0,0,0,0,0,0,0 FROM FC_ligne a,decomp_90 b
      WHERE ide_gest=TO_CHAR(p_gestion) AND ide_jal<>'REPMAN'  AND dat_ecr<=dat_fin and flg_cptab='O' and cod_sens='D' and ide_cpt like '90%'
   and substr(a.ide_lig_exec,1,1)=b.titre  and substr(a.ide_lig_exec,13,4)=b.ligne
      GROUP BY b.compte;
   commit;

*/
---------------------------------------------------------------------------------------------------------------------------------
-----------  Regroupement des données dans les tables ETAT_CGAF_BGFG et ETAT_CGAF_BGCT ------------------------------------------
-----------  ETAT_CGAF_BGFG Balance Générale de Fin de Gestion année antérieure par poste comptable -----------------------------
-----------  ETAT_CGAF_BGCT Balance Générale de Fin de Gestion année antérieure tous postes confondus ---------------------------
---------------------------------------------------------------------------------------------------------------------------------

--iNSERT INTO ETAT_CGAF_CGAF_AC SELECT ide_cpt,SUM(BE_D),SUM(BE_C),SUM(OA_D),SUM(OA_C),SUM(SA_D),SUM(SA_C),SUM(OFAI_D),SUM(OFAI_C),SUM(BS_D),SUM(BS_C),'N'
--FROM ETAT_CGAF_BGFG_TMP_AC WHERE ide_cpt IN (SELECT ide_cpt FROM ETAT_CPT_ORD WHERE flg_cgaf='O') GROUP BY  ide_cpt ;

INSERT INTO ETAT_CGAF_BGCT_AC SELECT ide_cpt,SUM(BE_D),SUM(BE_C),SUM(OA_D),SUM(OA_C),SUM(SA_D),SUM(SA_C),SUM(OFAI_D),SUM(OFAI_C),SUM(BS_D),SUM(BS_C),'N',0, v_uuid
FROM ETAT_CGAF_BGFG_TMP_AC GROUP BY  ide_cpt ;


---------------------- calcul des regroupements ---------------------------------

INSERT INTO ETAT_CGAF_BGCT_AC
SELECT  SUBSTR(ide_cpt,1,1),SUM(BE_D),SUM(BE_C),SUM(OA_D),SUM(OA_C),SUM(SA_D),SUM(SA_C),SUM(OFAI_D),SUM(OFAI_C),SUM(BS_D),SUM(BS_C),'O',0, v_uuid
FROM  ETAT_CGAF_BGCT_AC WHERE gras='N' AND LENGTH(ide_cpt)>1
GROUP BY SUBSTR(ide_cpt,1,1)
UNION
SELECT  SUBSTR(ide_cpt,1,2),SUM(BE_D),SUM(BE_C),SUM(OA_D),SUM(OA_C),SUM(SA_D),SUM(SA_C),SUM(OFAI_D),SUM(OFAI_C),SUM(BS_D),SUM(BS_C),'O',0, v_uuid
FROM  ETAT_CGAF_BGCT_AC WHERE gras='N'  AND LENGTH(ide_cpt)>2
GROUP BY SUBSTR(ide_cpt,1,2)
UNION
SELECT  SUBSTR(ide_cpt,1,3),SUM(BE_D),SUM(BE_C),SUM(OA_D),SUM(OA_C),SUM(SA_D),SUM(SA_C),SUM(OFAI_D),SUM(OFAI_C),SUM(BS_D),SUM(BS_C),'O',0, v_uuid
FROM  ETAT_CGAF_BGCT_AC WHERE gras='N'  AND LENGTH(ide_cpt)>3
GROUP BY SUBSTR(ide_cpt,1,3)
UNION
SELECT  SUBSTR(REPLACE(ide_cpt,'.',''),1,3)||'.'||SUBSTR(REPLACE(ide_cpt,'.',''),4,2),SUM(BE_D),SUM(BE_C),SUM(OA_D),SUM(OA_C),SUM(SA_D),SUM(SA_C),SUM(OFAI_D),SUM(OFAI_C),SUM(BS_D),SUM(BS_C),'O',0, v_uuid
FROM  ETAT_CGAF_BGCT_AC WHERE gras='N' AND LENGTH(ide_cpt)>6 AND SUBSTR(REPLACE(ide_cpt,'.',''),1,5)='39030'
GROUP BY SUBSTR(REPLACE(ide_cpt,'.',''),1,3)||'.'||SUBSTR(REPLACE(ide_cpt,'.',''),4,2);
COMMIT;


---------------------------------------------------------------------------------------------------------------------------------
-----------  MAJ des soldes calculés de la balance à partir des BE et Opérations de l'Année  ---------------------------------
---------------------------------------------------------------------------------------------------------------------------------

UPDATE ETAT_CGAF_BGCT_AC SET BE_D=0,BE_C=0 WHERE BE_D=BE_C;
UPDATE ETAT_CGAF_BGCT_AC SET BE_D=BE_D-BE_C,BE_C=BE_C-BE_D WHERE BE_D<>BE_C;
UPDATE ETAT_CGAF_BGCT_AC SET BE_D=0 WHERE BE_D<0;
UPDATE ETAT_CGAF_BGCT_AC SET BE_C=0 WHERE BE_C<0;

UPDATE ETAT_CGAF_BGCT_AC SET OFAI_D=BE_D+OA_D,OFAI_C=BE_C+OA_C;
UPDATE ETAT_CGAF_BGCT_AC SET SA_D=OA_D-OA_C WHERE OA_D-OA_C>0;
UPDATE ETAT_CGAF_BGCT_AC SET SA_C=OA_C-OA_D WHERE OA_C-OA_D>0;
UPDATE ETAT_CGAF_BGCT_AC SET BS_D=OFAI_D-OFAI_C WHERE OFAI_D-OFAI_C>0;
UPDATE ETAT_CGAF_BGCT_AC SET BS_C=OFAI_C-OFAI_D WHERE OFAI_C-OFAI_D>0;

UPDATE ETAT_CGAF_BGFG_AC SET BE_D=0,BE_C=0 WHERE BE_D=BE_C;
UPDATE ETAT_CGAF_BGFG_AC SET BE_D=BE_D-BE_C,BE_C=BE_C-BE_D WHERE BE_D<>BE_C;
UPDATE ETAT_CGAF_BGFG_AC SET BE_D=0 WHERE BE_D<0;
UPDATE ETAT_CGAF_BGFG_AC SET BE_C=0 WHERE BE_C<0;

UPDATE ETAT_CGAF_BGFG_AC SET OFAI_D=BE_D+OA_D,OFAI_C=BE_C+OA_C;
UPDATE ETAT_CGAF_BGFG_AC SET SA_D=OA_D-OA_C WHERE OA_D-OA_C>0;
UPDATE ETAT_CGAF_BGFG_AC SET SA_C=OA_C-OA_D WHERE OA_C-OA_D>0;
UPDATE ETAT_CGAF_BGFG_AC SET BS_D=OFAI_D-OFAI_C WHERE OFAI_D-OFAI_C>0;
UPDATE ETAT_CGAF_BGFG_AC SET BS_C=OFAI_C-OFAI_D WHERE OFAI_C-OFAI_D>0;

COMMIT;

UPDATE ETAT_CGAF_CGAF_AC SET BE_D=0,BE_C=0 WHERE BE_D=BE_C;
UPDATE ETAT_CGAF_CGAF_AC SET BE_D=BE_D-BE_C,BE_C=BE_C-BE_D WHERE BE_D<>BE_C;
UPDATE ETAT_CGAF_CGAF_AC SET BE_D=0 WHERE BE_D<0;
UPDATE ETAT_CGAF_CGAF_AC SET BE_C=0 WHERE BE_C<0;

UPDATE ETAT_CGAF_CGAF_AC SET OFAI_D=BE_D+OA_D,OFAI_C=BE_C+OA_C;
UPDATE ETAT_CGAF_CGAF_AC SET SA_D=OA_D-OA_C WHERE OA_D-OA_C>0;
UPDATE ETAT_CGAF_CGAF_AC SET SA_C=OA_C-OA_D WHERE OA_C-OA_D>0;
UPDATE ETAT_CGAF_CGAF_AC SET BS_D=OFAI_D-OFAI_C WHERE OFAI_D-OFAI_C>0;
UPDATE ETAT_CGAF_CGAF_AC SET BS_C=OFAI_C-OFAI_D WHERE OFAI_C-OFAI_D>0;

UPDATE ETAT_CGAF_CGAF_AC SET BE_D=0,BE_C=0 WHERE BE_D=BE_C;
UPDATE ETAT_CGAF_CGAF_AC SET BE_D=BE_D-BE_C,BE_C=BE_C-BE_D WHERE BE_D<>BE_C;
UPDATE ETAT_CGAF_CGAF_AC SET BE_D=0 WHERE BE_D<0;
UPDATE ETAT_CGAF_CGAF_AC SET BE_C=0 WHERE BE_C<0;

UPDATE ETAT_CGAF_CGAF_AC SET OFAI_D=BE_D+OA_D,OFAI_C=BE_C+OA_C;
UPDATE ETAT_CGAF_CGAF_AC SET SA_D=OA_D-OA_C WHERE OA_D-OA_C>0;
UPDATE ETAT_CGAF_CGAF_AC SET SA_C=OA_C-OA_D WHERE OA_C-OA_D>0;
UPDATE ETAT_CGAF_CGAF_AC SET BS_D=OFAI_D-OFAI_C WHERE OFAI_D-OFAI_C>0;
UPDATE ETAT_CGAF_CGAF_AC SET BS_C=OFAI_C-OFAI_D WHERE OFAI_C-OFAI_D>0;

COMMIT;

---------------------- calcul du total général ----------------------------------


INSERT INTO ETAT_CGAF_BGCT_AC
SELECT  'Total General',SUM(BE_D),SUM(BE_C),SUM(OA_D),SUM(OA_C),SUM(SA_D),SUM(SA_C),SUM(OFAI_D),SUM(OFAI_C),SUM(BS_D),SUM(BS_C),'I',0, v_uuid FROM  ETAT_CGAF_BGCT_AC WHERE gras='N';
COMMIT;

END;
/
-------------------                  ------------------------------------

CREATE OR REPLACE PROCEDURE CGST.mvts_fonds
(v_uuid varchar2,
sortie out Sys_Refcursor) 
as
begin

open sortie for
select ordre ,a.ide_cpt, libl,  be_d, be_c, oa_d, oa_c, sa_d, sa_c, bs_d, bs_c,gras
from CGST.ETAT_CGAF_BGCT_AC a , piaf_adm.fn_compte b, CGST.bgfg_ord_cpt c
where uuid = v_uuid --and (gras = 'O' and length(a.ide_cpt) in (1,2,3) or gras = 'I' and a.ide_cpt ='Total General')
and gras = 'N'
and a.ide_cpt like '58%' --and a.ide_cpt <> '5'
and a.ide_cpt = b.ide_cpt(+)
and a.ide_cpt = c.ide_cpt
order by ordre;

end mvts_fonds;
/

------------------- ---------------------------------------------

CREATE OR REPLACE PROCEDURE CGST.disponibilite
(v_uuid varchar2,
sortie out Sys_Refcursor) 
as
begin

open sortie for
select ordre ,a.ide_cpt, libl,  be_d, be_c, oa_d, oa_c, sa_d, sa_c, bs_d, bs_c,gras
from CGST.ETAT_CGAF_BGCT_AC a , piaf_adm.fn_compte b, CGST.bgfg_ord_cpt c
where uuid = v_uuid --and (gras = 'O' and length(a.ide_cpt) in (1,2,3) or gras = 'I' and a.ide_cpt ='Total General')
and gras = 'N'
and a.ide_cpt like '5%' and a.ide_cpt not like '58%' and a.ide_cpt <> '5'
and a.ide_cpt = b.ide_cpt(+)
and a.ide_cpt = c.ide_cpt
order by ordre;

end disponibilite;
/

----------------------- ------------------------------------

CREATE OR REPLACE PROCEDURE CGST.cpt_operation_service
(v_uuid varchar2, 
v_poste varchar2, 
v_gest varchar2,
sortie out Sys_Refcursor) 
as
begin

INSERT INTO CGST.deleg_credit_tmp


select nom_service, a.ide_cpt, libl,  sum(mt) flux_debit,0 flux_credit, v_uuid
from piaf_adm.fc_ligne a , piaf_adm.fn_compte b, CGST.bgfg_ord_cpt c, CGST.service_paierie d
where ide_poste = v_poste and ide_gest = v_gest --and (gras = 'O' and length(a.ide_cpt) in (1,2,3) or gras = 'I' and a.ide_cpt ='Total General')
and flg_cptab = 'O' and nom_service = 'Ambassades'
and cod_sens = 'D'
and ide_jal <> 'TREP'
--and a.ide_cpt like '58%' --and a.ide_cpt <> '5'
and a.ide_cpt = b.ide_cpt(+)
and a.ide_cpt = c.ide_cpt
and a.ide_cpt = ide_cpt_debit
group by nom_service, a.ide_cpt, libl, v_uuid
--and a.ide_cpt = ide_cpt_credit

union

select nom_service, a.ide_cpt, libl,  0, sum(mt), v_uuid
from piaf_adm.fc_ligne a , piaf_adm.fn_compte b, CGST.bgfg_ord_cpt c, CGST.service_paierie d
where ide_poste = v_poste and ide_gest = v_gest
and flg_cptab = 'O' and nom_service = 'Ambassades'
and cod_sens = 'C'
and ide_jal <> 'TREP'
and a.ide_cpt = b.ide_cpt(+)
and a.ide_cpt = c.ide_cpt
and a.ide_cpt = ide_cpt_credit
and (ide_poste, ide_jal, ide_gest, flg_cptab, ide_ecr) 
in (select ide_poste, ide_jal, ide_gest, flg_cptab, ide_ecr from piaf_adm.fc_ligne a, CGST.service_paierie d where ide_poste = v_poste and ide_gest = v_gest
and flg_cptab = 'O' and nom_service = 'Ambassades'
and cod_sens = 'D'
and ide_jal <> 'TREP' and a.ide_cpt = ide_cpt_debit)
group by nom_service, a.ide_cpt, libl, v_uuid


union

select nom_service, a.ide_cpt, libl,  sum(mt) flux_debit,0 flux_credit, v_uuid
from piaf_adm.fc_ligne a , piaf_adm.fn_compte b, CGST.bgfg_ord_cpt c, CGST.service_paierie d
where ide_poste = v_poste and ide_gest = v_gest --and (gras = 'O' and length(a.ide_cpt) in (1,2,3) or gras = 'I' and a.ide_cpt ='Total General')
and flg_cptab = 'O' and nom_service = 'Commerce'
and cod_sens = 'D'
and ide_jal <> 'TREP'
--and a.ide_cpt like '58%' --and a.ide_cpt <> '5'
and a.ide_cpt = b.ide_cpt(+)
and a.ide_cpt = c.ide_cpt
and a.ide_cpt = ide_cpt_debit
group by nom_service, a.ide_cpt, libl, v_uuid
--and a.ide_cpt = ide_cpt_credit

union

select nom_service, a.ide_cpt, libl,  0, sum(mt), v_uuid
from piaf_adm.fc_ligne a , piaf_adm.fn_compte b, CGST.bgfg_ord_cpt c, CGST.service_paierie d
where ide_poste = v_poste and ide_gest = v_gest
and flg_cptab = 'O' and nom_service = 'Commerce'
and cod_sens = 'C'
and ide_jal <> 'TREP'
and a.ide_cpt = b.ide_cpt(+)
and a.ide_cpt = c.ide_cpt
and a.ide_cpt = ide_cpt_credit
and (ide_poste, ide_jal, ide_gest, flg_cptab, ide_ecr) 
in (select ide_poste, ide_jal, ide_gest, flg_cptab, ide_ecr from piaf_adm.fc_ligne a, CGST.service_paierie d where ide_poste = v_poste and ide_gest = v_gest
and flg_cptab = 'O' and nom_service = 'Commerce'
and cod_sens = 'D'
and ide_jal <> 'TREP' and a.ide_cpt = ide_cpt_debit)
group by nom_service, a.ide_cpt, libl, v_uuid

union

select nom_service, a.ide_cpt, libl,  sum(mt) flux_debit,0 flux_credit, v_uuid
from piaf_adm.fc_ligne a , piaf_adm.fn_compte b, CGST.bgfg_ord_cpt c, CGST.service_paierie d
where ide_poste = v_poste and ide_gest = v_gest --and (gras = 'O' and length(a.ide_cpt) in (1,2,3) or gras = 'I' and a.ide_cpt ='Total General')
and flg_cptab = 'O' and nom_service = 'Tourisme'
and cod_sens = 'D'
and ide_jal <> 'TREP'
--and a.ide_cpt like '58%' --and a.ide_cpt <> '5'
and a.ide_cpt = b.ide_cpt(+)
and a.ide_cpt = c.ide_cpt
and a.ide_cpt = ide_cpt_debit
group by nom_service, a.ide_cpt, libl, v_uuid
--and a.ide_cpt = ide_cpt_credit

union

select nom_service, a.ide_cpt, libl,  0, sum(mt), v_uuid
from piaf_adm.fc_ligne a , piaf_adm.fn_compte b, CGST.bgfg_ord_cpt c, CGST.service_paierie d
where ide_poste = v_poste and ide_gest = v_gest
and flg_cptab = 'O' and nom_service = 'Tourisme'
and cod_sens = 'C'
and ide_jal <> 'TREP'
and a.ide_cpt = b.ide_cpt(+)
and a.ide_cpt = c.ide_cpt
and a.ide_cpt = ide_cpt_credit
and (ide_poste, ide_jal, ide_gest, flg_cptab, ide_ecr) 
in (select ide_poste, ide_jal, ide_gest, flg_cptab, ide_ecr from piaf_adm.fc_ligne a, CGST.service_paierie d where ide_poste = v_poste and ide_gest = v_gest
and flg_cptab = 'O' and nom_service = 'Tourisme'
and cod_sens = 'D'
and ide_jal <> 'TREP' and a.ide_cpt = ide_cpt_debit)
group by nom_service, a.ide_cpt, libl, v_uuid


union

select nom_service, a.ide_cpt, libl,  sum(mt) flux_debit,0 flux_credit, v_uuid
from piaf_adm.fc_ligne a , piaf_adm.fn_compte b, CGST.bgfg_ord_cpt c, CGST.service_paierie d
where ide_poste = v_poste and ide_gest = v_gest --and (gras = 'O' and length(a.ide_cpt) in (1,2,3) or gras = 'I' and a.ide_cpt ='Total General')
and flg_cptab = 'O' and nom_service = 'Bureau_economique'
and cod_sens = 'D'
and ide_jal <> 'TREP'
--and a.ide_cpt like '58%' --and a.ide_cpt <> '5'
and a.ide_cpt = b.ide_cpt(+)
and a.ide_cpt = c.ide_cpt
and a.ide_cpt = ide_cpt_debit
group by nom_service, a.ide_cpt, libl, v_uuid
--and a.ide_cpt = ide_cpt_credit

union

select nom_service, a.ide_cpt, libl,  0, sum(mt), v_uuid
from piaf_adm.fc_ligne a , piaf_adm.fn_compte b, CGST.bgfg_ord_cpt c, CGST.service_paierie d
where ide_poste = v_poste and ide_gest = v_gest
and flg_cptab = 'O' and nom_service = 'Bureau_economique'
and cod_sens = 'C'
and ide_jal <> 'TREP'
and a.ide_cpt = b.ide_cpt(+)
and a.ide_cpt = c.ide_cpt
and a.ide_cpt = ide_cpt_credit
and (ide_poste, ide_jal, ide_gest, flg_cptab, ide_ecr) 
in (select ide_poste, ide_jal, ide_gest, flg_cptab, ide_ecr from piaf_adm.fc_ligne a, CGST.service_paierie d where ide_poste = v_poste and ide_gest = v_gest
and flg_cptab = 'O' and nom_service = 'Bureau_economique'
and cod_sens = 'D'
and ide_jal <> 'TREP' and a.ide_cpt = ide_cpt_debit)
group by nom_service, a.ide_cpt, libl, v_uuid

union

select nom_service, a.ide_cpt, libl,  sum(mt) flux_debit,0 flux_credit, v_uuid
from piaf_adm.fc_ligne a , piaf_adm.fn_compte b, CGST.bgfg_ord_cpt c, CGST.service_paierie d
where ide_poste = v_poste and ide_gest = v_gest --and (gras = 'O' and length(a.ide_cpt) in (1,2,3) or gras = 'I' and a.ide_cpt ='Total General')
and flg_cptab = 'O' and nom_service = 'Onudi_vienne'
and cod_sens = 'D'
and ide_jal <> 'TREP'
--and a.ide_cpt like '58%' --and a.ide_cpt <> '5'
and a.ide_cpt = b.ide_cpt(+)
and a.ide_cpt = c.ide_cpt
and a.ide_cpt = ide_cpt_debit
group by nom_service, a.ide_cpt, libl, v_uuid
--and a.ide_cpt = ide_cpt_credit

union

select nom_service, a.ide_cpt, libl,  0, sum(mt), v_uuid
from piaf_adm.fc_ligne a , piaf_adm.fn_compte b, CGST.bgfg_ord_cpt c, CGST.service_paierie d
where ide_poste = v_poste and ide_gest = v_gest
and flg_cptab = 'O' and nom_service = 'Onudi_vienne'
and cod_sens = 'C'
and ide_jal <> 'TREP'
and a.ide_cpt = b.ide_cpt(+)
and a.ide_cpt = c.ide_cpt
and a.ide_cpt = ide_cpt_credit
and (ide_poste, ide_jal, ide_gest, flg_cptab, ide_ecr) 
in (select ide_poste, ide_jal, ide_gest, flg_cptab, ide_ecr from piaf_adm.fc_ligne a, CGST.service_paierie d where ide_poste = v_poste and ide_gest = v_gest
and flg_cptab = 'O' and nom_service = 'Onudi_vienne'
and cod_sens = 'D'
and ide_jal <> 'TREP' and a.ide_cpt = ide_cpt_debit)
group by nom_service, a.ide_cpt, libl, v_uuid


union

select nom_service, a.ide_cpt, libl,  sum(mt) flux_debit,0 flux_credit, v_uuid
from piaf_adm.fc_ligne a , piaf_adm.fn_compte b, CGST.bgfg_ord_cpt c, CGST.service_paierie d
where ide_poste = v_poste and ide_gest = v_gest --and (gras = 'O' and length(a.ide_cpt) in (1,2,3) or gras = 'I' and a.ide_cpt ='Total General')
and flg_cptab = 'O' and nom_service = 'Defense'
and cod_sens = 'D'
and ide_jal <> 'TREP'
--and a.ide_cpt like '58%' --and a.ide_cpt <> '5'
and a.ide_cpt = b.ide_cpt(+)
and a.ide_cpt = c.ide_cpt
and a.ide_cpt = ide_cpt_debit
group by nom_service, a.ide_cpt, libl, v_uuid
--and a.ide_cpt = ide_cpt_credit

union

select nom_service, a.ide_cpt, libl,  0, sum(mt), v_uuid
from piaf_adm.fc_ligne a , piaf_adm.fn_compte b, CGST.bgfg_ord_cpt c, CGST.service_paierie d
where ide_poste = v_poste and ide_gest = v_gest
and flg_cptab = 'O' and nom_service = 'Defense'
and cod_sens = 'C'
and ide_jal <> 'TREP'
and a.ide_cpt = b.ide_cpt(+)
and a.ide_cpt = c.ide_cpt
and a.ide_cpt = ide_cpt_credit
and (ide_poste, ide_jal, ide_gest, flg_cptab, ide_ecr) 
in (select ide_poste, ide_jal, ide_gest, flg_cptab, ide_ecr from piaf_adm.fc_ligne a, CGST.service_paierie d where ide_poste = v_poste and ide_gest = v_gest
and flg_cptab = 'O' and nom_service = 'Defense'
and cod_sens = 'D'
and ide_jal <> 'TREP' and a.ide_cpt = ide_cpt_debit)
group by nom_service, a.ide_cpt, libl, v_uuid


union

select nom_service, a.ide_cpt, libl,  sum(mt) flux_debit,0 flux_credit, v_uuid
from piaf_adm.fc_ligne a , piaf_adm.fn_compte b, CGST.bgfg_ord_cpt c, CGST.service_paierie d
where ide_poste = v_poste and ide_gest = v_gest --and (gras = 'O' and length(a.ide_cpt) in (1,2,3) or gras = 'I' and a.ide_cpt ='Total General')
and flg_cptab = 'O' and nom_service = 'Securite'
and cod_sens = 'D'
and ide_jal <> 'TREP'
--and a.ide_cpt like '58%' --and a.ide_cpt <> '5'
and a.ide_cpt = b.ide_cpt(+)
and a.ide_cpt = c.ide_cpt
and a.ide_cpt = ide_cpt_debit
group by nom_service, a.ide_cpt, libl, v_uuid
--and a.ide_cpt = ide_cpt_credit

union

select nom_service, a.ide_cpt, libl,  0, sum(mt), v_uuid
from piaf_adm.fc_ligne a , piaf_adm.fn_compte b, CGST.bgfg_ord_cpt c, CGST.service_paierie d
where ide_poste = v_poste and ide_gest = v_gest
and flg_cptab = 'O' and nom_service = 'Securite'
and cod_sens = 'C'
and ide_jal <> 'TREP'
and a.ide_cpt = b.ide_cpt(+)
and a.ide_cpt = c.ide_cpt
and a.ide_cpt = ide_cpt_credit
and (ide_poste, ide_jal, ide_gest, flg_cptab, ide_ecr) 
in (select ide_poste, ide_jal, ide_gest, flg_cptab, ide_ecr from piaf_adm.fc_ligne a, CGST.service_paierie d where ide_poste = v_poste and ide_gest = v_gest
and flg_cptab = 'O' and nom_service = 'Securite'
and cod_sens = 'D'
and ide_jal <> 'TREP' and a.ide_cpt = ide_cpt_debit)
group by nom_service, a.ide_cpt, libl, v_uuid


union

select nom_service, a.ide_cpt, libl,  sum(mt) flux_debit,0 flux_credit, v_uuid
from piaf_adm.fc_ligne a , piaf_adm.fn_compte b, CGST.bgfg_ord_cpt c, CGST.service_paierie d
where ide_poste = v_poste and ide_gest = v_gest --and (gras = 'O' and length(a.ide_cpt) in (1,2,3) or gras = 'I' and a.ide_cpt ='Total General')
and flg_cptab = 'O' and nom_service = 'Organisation_inter'
and cod_sens = 'D'
and ide_jal <> 'TREP'
--and a.ide_cpt like '58%' --and a.ide_cpt <> '5'
and a.ide_cpt = b.ide_cpt(+)
and a.ide_cpt = c.ide_cpt
and a.ide_cpt = ide_cpt_debit
group by nom_service, a.ide_cpt, libl, v_uuid
--and a.ide_cpt = ide_cpt_credit

union

select nom_service, a.ide_cpt, libl,  0, sum(mt), v_uuid
from piaf_adm.fc_ligne a , piaf_adm.fn_compte b, CGST.bgfg_ord_cpt c, CGST.service_paierie d
where ide_poste = v_poste and ide_gest = v_gest
and flg_cptab = 'O' and nom_service = 'Organisation_inter'
and cod_sens = 'C'
and ide_jal <> 'TREP'
and a.ide_cpt = b.ide_cpt(+)
and a.ide_cpt = c.ide_cpt
and a.ide_cpt = ide_cpt_credit
and (ide_poste, ide_jal, ide_gest, flg_cptab, ide_ecr) 
in (select ide_poste, ide_jal, ide_gest, flg_cptab, ide_ecr from piaf_adm.fc_ligne a, CGST.service_paierie d where ide_poste = v_poste and ide_gest = v_gest
and flg_cptab = 'O' and nom_service = 'Organisation_inter'
and cod_sens = 'D'
and ide_jal <> 'TREP' and a.ide_cpt = ide_cpt_debit)
group by nom_service, a.ide_cpt, libl, v_uuid

union

select nom_service, a.ide_cpt, libl,  sum(mt) flux_debit,0 flux_credit, v_uuid
from piaf_adm.fc_ligne a , piaf_adm.fn_compte b, CGST.bgfg_ord_cpt c, CGST.service_paierie d
where ide_poste = v_poste and ide_gest = v_gest --and (gras = 'O' and length(a.ide_cpt) in (1,2,3) or gras = 'I' and a.ide_cpt ='Total General')
and flg_cptab = 'O' and nom_service = 'Service_payeur'
and cod_sens = 'D'
and ide_jal <> 'TREP'
--and a.ide_cpt like '58%' --and a.ide_cpt <> '5'
and a.ide_cpt = b.ide_cpt(+)
and a.ide_cpt = c.ide_cpt
and a.ide_cpt = ide_cpt_debit
group by nom_service, a.ide_cpt, libl, v_uuid
--and a.ide_cpt = ide_cpt_credit

union

select nom_service, a.ide_cpt, libl,  0, sum(mt), v_uuid
from piaf_adm.fc_ligne a , piaf_adm.fn_compte b, CGST.bgfg_ord_cpt c, CGST.service_paierie d
where ide_poste = v_poste and ide_gest = v_gest
and flg_cptab = 'O' and nom_service = 'Service_payeur'
and cod_sens = 'C'
and ide_jal <> 'TREP'
and a.ide_cpt = b.ide_cpt(+)
and a.ide_cpt = c.ide_cpt
and a.ide_cpt = ide_cpt_credit
and (ide_poste, ide_jal, ide_gest, flg_cptab, ide_ecr) 
in (select ide_poste, ide_jal, ide_gest, flg_cptab, ide_ecr from piaf_adm.fc_ligne a, CGST.service_paierie d where ide_poste = v_poste and ide_gest = v_gest
and flg_cptab = 'O' and nom_service = 'Service_payeur'
and cod_sens = 'D'
and ide_jal <> 'TREP' and a.ide_cpt = ide_cpt_debit)
group by nom_service, a.ide_cpt, libl, v_uuid

union

select nom_service, a.ide_cpt, libl,  sum(mt) flux_debit,0 flux_credit, v_uuid
from piaf_adm.fc_ligne a , piaf_adm.fn_compte b, CGST.bgfg_ord_cpt c, CGST.service_paierie d
where ide_poste = v_poste and ide_gest = v_gest --and (gras = 'O' and length(a.ide_cpt) in (1,2,3) or gras = 'I' and a.ide_cpt ='Total General')
and flg_cptab = 'O' and nom_service = 'Ressource_animale'
and cod_sens = 'D'
and ide_jal <> 'TREP'
--and a.ide_cpt like '58%' --and a.ide_cpt <> '5'
and a.ide_cpt = b.ide_cpt(+)
and a.ide_cpt = c.ide_cpt
and a.ide_cpt = ide_cpt_debit
group by nom_service, a.ide_cpt, libl, v_uuid
--and a.ide_cpt = ide_cpt_credit

union

select nom_service, a.ide_cpt, libl,  0, sum(mt), v_uuid
from piaf_adm.fc_ligne a , piaf_adm.fn_compte b, CGST.bgfg_ord_cpt c, CGST.service_paierie d
where ide_poste = v_poste and ide_gest = v_gest
and flg_cptab = 'O' and nom_service = 'Ressource_animale'
and cod_sens = 'C'
and ide_jal <> 'TREP'
and a.ide_cpt = b.ide_cpt(+)
and a.ide_cpt = c.ide_cpt
and a.ide_cpt = ide_cpt_credit
and (ide_poste, ide_jal, ide_gest, flg_cptab, ide_ecr) 
in (select ide_poste, ide_jal, ide_gest, flg_cptab, ide_ecr from piaf_adm.fc_ligne a, CGST.service_paierie d where ide_poste = v_poste and ide_gest = v_gest
and flg_cptab = 'O' and nom_service = 'Ressource_animale'
and cod_sens = 'D'
and ide_jal <> 'TREP' and a.ide_cpt = ide_cpt_debit)
group by nom_service, a.ide_cpt, libl, v_uuid


union

select nom_service, a.ide_cpt, libl,  sum(mt) flux_debit,0 flux_credit, v_uuid
from piaf_adm.fc_ligne a , piaf_adm.fn_compte b, CGST.bgfg_ord_cpt c, CGST.service_paierie d
where ide_poste = v_poste and ide_gest = v_gest --and (gras = 'O' and length(a.ide_cpt) in (1,2,3) or gras = 'I' and a.ide_cpt ='Total General')
and flg_cptab = 'O' and nom_service = 'Autres'
and cod_sens = 'D'
and ide_jal <> 'TREP'
--and a.ide_cpt like '58%' --and a.ide_cpt <> '5'
and a.ide_cpt = b.ide_cpt(+)
and a.ide_cpt = c.ide_cpt
and a.ide_cpt = ide_cpt_debit
group by nom_service, a.ide_cpt, libl, v_uuid
--and a.ide_cpt = ide_cpt_credit

union

select nom_service, a.ide_cpt, libl,  0, sum(mt), v_uuid
from piaf_adm.fc_ligne a , piaf_adm.fn_compte b, CGST.bgfg_ord_cpt c, CGST.service_paierie d
where ide_poste = v_poste and ide_gest = v_gest
and flg_cptab = 'O' and nom_service = 'Autres'
and cod_sens = 'C'
and ide_jal <> 'TREP'
and a.ide_cpt = b.ide_cpt(+)
and a.ide_cpt = c.ide_cpt
and a.ide_cpt = ide_cpt_credit
and (ide_poste, ide_jal, ide_gest, flg_cptab, ide_ecr) 
in (select ide_poste, ide_jal, ide_gest, flg_cptab, ide_ecr from piaf_adm.fc_ligne a, CGST.service_paierie d where ide_poste = v_poste and ide_gest = v_gest
and flg_cptab = 'O' and nom_service = 'Autres'
and cod_sens = 'D'
and ide_jal <> 'TREP' and a.ide_cpt = ide_cpt_debit)
group by nom_service, a.ide_cpt, libl, v_uuid

union

select nom_service, a.ide_cpt, libl,  sum(mt) flux_debit,0 flux_credit, v_uuid
from piaf_adm.fc_ligne a , piaf_adm.fn_compte b, CGST.bgfg_ord_cpt c, CGST.service_paierie d
where ide_poste = v_poste and ide_gest = v_gest --and (gras = 'O' and length(a.ide_cpt) in (1,2,3) or gras = 'I' and a.ide_cpt ='Total General')
and flg_cptab = 'O' and nom_service = 'Service_controleur_fin'
and cod_sens = 'D'
and ide_jal <> 'TREP'
--and a.ide_cpt like '58%' --and a.ide_cpt <> '5'
and a.ide_cpt = b.ide_cpt(+)
and a.ide_cpt = c.ide_cpt
and a.ide_cpt = ide_cpt_debit
group by nom_service, a.ide_cpt, libl, v_uuid
--and a.ide_cpt = ide_cpt_credit

union

select nom_service, a.ide_cpt, libl,  0, sum(mt), v_uuid
from piaf_adm.fc_ligne a , piaf_adm.fn_compte b, CGST.bgfg_ord_cpt c, CGST.service_paierie d
where ide_poste = v_poste and ide_gest = v_gest
and flg_cptab = 'O' and nom_service = 'Service_controleur_fin'
and cod_sens = 'C'
and ide_jal <> 'TREP'
and a.ide_cpt = b.ide_cpt(+)
and a.ide_cpt = c.ide_cpt
and a.ide_cpt = ide_cpt_credit
and (ide_poste, ide_jal, ide_gest, flg_cptab, ide_ecr) 
in (select ide_poste, ide_jal, ide_gest, flg_cptab, ide_ecr from piaf_adm.fc_ligne a, CGST.service_paierie d where ide_poste = v_poste and ide_gest = v_gest
and flg_cptab = 'O' and nom_service = 'Service_controleur_fin'
and cod_sens = 'D'
and ide_jal <> 'TREP' and a.ide_cpt = ide_cpt_debit)
group by nom_service, a.ide_cpt, libl, v_uuid


union

select nom_service, a.ide_cpt, libl,  sum(mt) flux_debit,0 flux_credit, v_uuid
from piaf_adm.fc_ligne a , piaf_adm.fn_compte b, CGST.bgfg_ord_cpt c, CGST.service_paierie d
where ide_poste = v_poste and ide_gest = v_gest --and (gras = 'O' and length(a.ide_cpt) in (1,2,3) or gras = 'I' and a.ide_cpt ='Total General')
and flg_cptab = 'O' and nom_service = 'Interpol'
and cod_sens = 'D'
and ide_jal <> 'TREP'
--and a.ide_cpt like '58%' --and a.ide_cpt <> '5'
and a.ide_cpt = b.ide_cpt(+)
and a.ide_cpt = c.ide_cpt
and a.ide_cpt = ide_cpt_debit
group by nom_service, a.ide_cpt, libl, v_uuid
--and a.ide_cpt = ide_cpt_credit

union

select nom_service, a.ide_cpt, libl,  0, sum(mt), v_uuid
from piaf_adm.fc_ligne a , piaf_adm.fn_compte b, CGST.bgfg_ord_cpt c, CGST.service_paierie d
where ide_poste = v_poste and ide_gest = v_gest
and flg_cptab = 'O' and nom_service = 'Interpol'
and cod_sens = 'C'
and ide_jal <> 'TREP'
and a.ide_cpt = b.ide_cpt(+)
and a.ide_cpt = c.ide_cpt
and a.ide_cpt = ide_cpt_credit
and (ide_poste, ide_jal, ide_gest, flg_cptab, ide_ecr) 
in (select ide_poste, ide_jal, ide_gest, flg_cptab, ide_ecr from piaf_adm.fc_ligne a, CGST.service_paierie d where ide_poste = v_poste and ide_gest = v_gest
and flg_cptab = 'O' and nom_service = 'Interpol'
and cod_sens = 'D'
and ide_jal <> 'TREP' and a.ide_cpt = ide_cpt_debit)
group by nom_service, a.ide_cpt, libl, v_uuid



union

select nom_service, a.ide_cpt, libl,  sum(mt) flux_debit,0 flux_credit, v_uuid
from piaf_adm.fc_ligne a , piaf_adm.fn_compte b, CGST.bgfg_ord_cpt c, CGST.service_paierie d
where ide_poste = v_poste and ide_gest = v_gest --and (gras = 'O' and length(a.ide_cpt) in (1,2,3) or gras = 'I' and a.ide_cpt ='Total General')
and flg_cptab = 'O' and nom_service = 'Consulat'
and cod_sens = 'D'
and ide_jal <> 'TREP'
--and a.ide_cpt like '58%' --and a.ide_cpt <> '5'
and a.ide_cpt = b.ide_cpt(+)
and a.ide_cpt = c.ide_cpt
and a.ide_cpt = ide_cpt_debit
group by nom_service, a.ide_cpt, libl, v_uuid
--and a.ide_cpt = ide_cpt_credit

union

select nom_service, a.ide_cpt, libl,  0, sum(mt), v_uuid
from piaf_adm.fc_ligne a , piaf_adm.fn_compte b, CGST.bgfg_ord_cpt c, CGST.service_paierie d
where ide_poste = v_poste and ide_gest = v_gest
and flg_cptab = 'O' and nom_service = 'Consulat'
and cod_sens = 'C'
and ide_jal <> 'TREP'
and a.ide_cpt = b.ide_cpt(+)
and a.ide_cpt = c.ide_cpt
and a.ide_cpt = ide_cpt_credit
and (ide_poste, ide_jal, ide_gest, flg_cptab, ide_ecr) 
in (select ide_poste, ide_jal, ide_gest, flg_cptab, ide_ecr from piaf_adm.fc_ligne a, CGST.service_paierie d where ide_poste = v_poste and ide_gest = v_gest
and flg_cptab = 'O' and nom_service = 'Consulat'
and cod_sens = 'D'
and ide_jal <> 'TREP' and a.ide_cpt = ide_cpt_debit)
group by nom_service, a.ide_cpt, libl, v_uuid


union

select nom_service, a.ide_cpt, libl,  sum(mt) flux_debit,0 flux_credit, v_uuid
from piaf_adm.fc_ligne a , piaf_adm.fn_compte b, CGST.bgfg_ord_cpt c, CGST.service_paierie d
where ide_poste = v_poste and ide_gest = v_gest --and (gras = 'O' and length(a.ide_cpt) in (1,2,3) or gras = 'I' and a.ide_cpt ='Total General')
and flg_cptab = 'O' and nom_service = 'Attache_culturel'
and cod_sens = 'D'
and ide_jal <> 'TREP'
--and a.ide_cpt like '58%' --and a.ide_cpt <> '5'
and a.ide_cpt = b.ide_cpt(+)
and a.ide_cpt = c.ide_cpt
and a.ide_cpt = ide_cpt_debit
group by nom_service, a.ide_cpt, libl, v_uuid
--and a.ide_cpt = ide_cpt_credit

union

select nom_service, a.ide_cpt, libl,  0, sum(mt), v_uuid
from piaf_adm.fc_ligne a , piaf_adm.fn_compte b, CGST.bgfg_ord_cpt c, CGST.service_paierie d
where ide_poste = v_poste and ide_gest = v_gest
and flg_cptab = 'O' and nom_service = 'Attache_culturel'
and cod_sens = 'C'
and ide_jal <> 'TREP'
and a.ide_cpt = b.ide_cpt(+)
and a.ide_cpt = c.ide_cpt
and a.ide_cpt = ide_cpt_credit
and (ide_poste, ide_jal, ide_gest, flg_cptab, ide_ecr) 
in (select ide_poste, ide_jal, ide_gest, flg_cptab, ide_ecr from piaf_adm.fc_ligne a, CGST.service_paierie d where ide_poste = v_poste and ide_gest = v_gest
and flg_cptab = 'O' and nom_service = 'Attache_culturel'
and cod_sens = 'D'
and ide_jal <> 'TREP' and a.ide_cpt = ide_cpt_debit)
group by nom_service, a.ide_cpt, libl, v_uuid


union

select nom_service, a.ide_cpt, libl,  sum(mt) flux_debit,0 flux_credit, v_uuid
from piaf_adm.fc_ligne a , piaf_adm.fn_compte b, CGST.bgfg_ord_cpt c, CGST.service_paierie d
where ide_poste = v_poste and ide_gest = v_gest --and (gras = 'O' and length(a.ide_cpt) in (1,2,3) or gras = 'I' and a.ide_cpt ='Total General')
and flg_cptab = 'O' and nom_service = 'Aide_indigent'
and cod_sens = 'D'
and ide_jal <> 'TREP'
--and a.ide_cpt like '58%' --and a.ide_cpt <> '5'
and a.ide_cpt = b.ide_cpt(+)
and a.ide_cpt = c.ide_cpt
and a.ide_cpt = ide_cpt_debit
group by nom_service, a.ide_cpt, libl, v_uuid
--and a.ide_cpt = ide_cpt_credit

union

select nom_service, a.ide_cpt, libl,  0, sum(mt), v_uuid
from piaf_adm.fc_ligne a , piaf_adm.fn_compte b, CGST.bgfg_ord_cpt c, CGST.service_paierie d
where ide_poste = v_poste and ide_gest = v_gest
and flg_cptab = 'O' and nom_service = 'Aide_indigent'
and cod_sens = 'C'
and ide_jal <> 'TREP'
and a.ide_cpt = b.ide_cpt(+)
and a.ide_cpt = c.ide_cpt
and a.ide_cpt = ide_cpt_credit
and (ide_poste, ide_jal, ide_gest, flg_cptab, ide_ecr) 
in (select ide_poste, ide_jal, ide_gest, flg_cptab, ide_ecr from piaf_adm.fc_ligne a, CGST.service_paierie d where ide_poste = v_poste and ide_gest = v_gest
and flg_cptab = 'O' and nom_service = 'Aide_indigent'
and cod_sens = 'D'
and ide_jal <> 'TREP' and a.ide_cpt = ide_cpt_debit)
group by nom_service, a.ide_cpt, libl, v_uuid


union

select nom_service, a.ide_cpt, libl,  sum(mt) flux_debit,0 flux_credit, v_uuid
from piaf_adm.fc_ligne a , piaf_adm.fn_compte b, CGST.bgfg_ord_cpt c, CGST.service_paierie d
where ide_poste = v_poste and ide_gest = v_gest --and (gras = 'O' and length(a.ide_cpt) in (1,2,3) or gras = 'I' and a.ide_cpt ='Total General')
and flg_cptab = 'O' and nom_service = 'Animation_cs_onu'
and cod_sens = 'D'
and ide_jal <> 'TREP'
--and a.ide_cpt like '58%' --and a.ide_cpt <> '5'
and a.ide_cpt = b.ide_cpt(+)
and a.ide_cpt = c.ide_cpt
and a.ide_cpt = ide_cpt_debit
group by nom_service, a.ide_cpt, libl, v_uuid
--and a.ide_cpt = ide_cpt_credit

union

select nom_service, a.ide_cpt, libl,  0, sum(mt), v_uuid
from piaf_adm.fc_ligne a , piaf_adm.fn_compte b, CGST.bgfg_ord_cpt c, CGST.service_paierie d
where ide_poste = v_poste and ide_gest = v_gest
and flg_cptab = 'O' and nom_service = 'Animation_cs_onu'
and cod_sens = 'C'
and ide_jal <> 'TREP'
and a.ide_cpt = b.ide_cpt(+)
and a.ide_cpt = c.ide_cpt
and a.ide_cpt = ide_cpt_credit
and (ide_poste, ide_jal, ide_gest, flg_cptab, ide_ecr) 
in (select ide_poste, ide_jal, ide_gest, flg_cptab, ide_ecr from piaf_adm.fc_ligne a, CGST.service_paierie d where ide_poste = v_poste and ide_gest = v_gest
and flg_cptab = 'O' and nom_service = 'Animation_cs_onu'
and cod_sens = 'D'
and ide_jal <> 'TREP' and a.ide_cpt = ide_cpt_debit)
group by nom_service, a.ide_cpt, libl, v_uuid;


open sortie for
select nom_service, sum(flux_debit), sum(flux_credit) 
from CGST.deleg_credit_tmp
group by nom_service, v_uuid;

end cpt_operation_service;
/

------------------------------- -------------------------------------

CREATE OR REPLACE PROCEDURE CGST.cip_recette
(v_uuid varchar2,
sortie out Sys_Refcursor) 
as
begin

open sortie for
select ordre ,a.ide_cpt, libl,  be_d, be_c, oa_d, oa_c, sa_d, sa_c, bs_d, bs_c,gras
from CGST.ETAT_CGAF_BGCT_AC a , piaf_adm.fn_compte b, CGST.bgfg_ord_cpt c
where uuid = v_uuid --and (gras = 'O' and length(a.ide_cpt) in (1,2,3) or gras = 'I' and a.ide_cpt ='Total General')
and a.ide_cpt like '475%' and gras = 'N'
and a.ide_cpt = b.ide_cpt(+)
and a.ide_cpt = c.ide_cpt
order by ordre;

end cip_recette;
/

----------------------------------- ----------------------------------

CREATE OR REPLACE PROCEDURE CGST.cip_depenses
(v_uuid varchar2,
sortie out Sys_Refcursor) 
as
begin

open sortie for
select ordre ,a.ide_cpt, libl,  be_d, be_c, oa_d, oa_c, sa_d, sa_c, bs_d, bs_c,gras
from CGST.ETAT_CGAF_BGCT_AC a , piaf_adm.fn_compte b, CGST.bgfg_ord_cpt c
where uuid = v_uuid --and (gras = 'O' and length(a.ide_cpt) in (1,2,3) or gras = 'I' and a.ide_cpt ='Total General')
and a.ide_cpt like '470%' and gras = 'N'
and a.ide_cpt = b.ide_cpt(+)
and a.ide_cpt = c.ide_cpt
order by ordre;

end cip_depenses;
/

------------------------------- ----------------------------------

CREATE OR REPLACE PROCEDURE CGST.balance_3_chiffres
(v_uuid varchar2,
sortie out Sys_Refcursor) 
as
begin

open sortie for
select ordre ,a.ide_cpt, libl,  be_d, be_c, oa_d, oa_c, sa_d, sa_c, bs_d, bs_c,gras
from CGST.ETAT_CGAF_BGCT_AC a , piaf_adm.fn_compte b, CGST.bgfg_ord_cpt c
where uuid = v_uuid and (gras = 'O' and length(a.ide_cpt) in (1,2,3) or gras = 'I' and a.ide_cpt ='Total General')
and a.ide_cpt = b.ide_cpt(+)
and a.ide_cpt = c.ide_cpt
order by ordre;

end balance_3_chiffres;
/

---------------------------------- ----------------------------------

CREATE OR REPLACE PROCEDURE CGST.balance_generale
(v_uuid varchar2,
sortie out Sys_Refcursor) 
as
begin

open sortie for
select ordre ,a.ide_cpt, libl,  be_d, be_c, oa_d, oa_c, sa_d, sa_c, bs_d, bs_c,gras
from CGST.ETAT_CGAF_BGCT_AC a , piaf_adm.fn_compte b, CGST.bgfg_ord_cpt c
where uuid = v_uuid --and (gras = 'O' and length(a.ide_cpt) in (1,2,3) or gras = 'I' and a.ide_cpt ='Total General')
and a.ide_cpt = b.ide_cpt(+)
and a.ide_cpt = c.ide_cpt
order by ordre;

end balance_generale;
/