DROP  TABLE niaba.CONTROL_TGAN1;

CREATE TABLE niaba.CONTROL_TGAN1 AS
SELECT a.ead_gst_annee,a.EAD_CDE_pc_ASSI_sig,a.ead_cde_pc_assi,a.EAD_NUM_BORDEREAU, a.ead_num_acte MANDAT,a.ead_dte_ordon DATE_ORDON ,a.ead_dte_pec DATE_PEC ,
a.ead_mnt_cp_don+a.ead_mnt_cp_emp+a.ead_mnt_cp_tre MONTANT_PEC ,
(a.EAD_MNT_MIS_RGL_TRE +  a.EAD_MNT_MIS_RGL_DON +  a.EAD_MNT_MIS_RGL_EMP) montant_MER, a.ead_statut STATUT ,a.ead_dte_mis_rgl DATE_MIS_RGL,
--b.dap_lcp_num,b.DAP_STR_CODE,
ead_objet OBJET--,DAP_CPT_CREDIT ,DAP_CPT_DEBIT 
--,c.rema_dest_cod,c.REMA_SCO_COD,c.REMA_SCO_LIB_LNG,d.STR_CODE,d.str_lib,e.LCP_CODE_NATURE,e.LCP_NUM, e.LCP_CDE_TITRE || c.REMA_sco_COD || b.dap_lcp_num LIGNE_BUDGETAIRE
FROM sigta.T_ENTETE_ACTE_DEPENSES a  --,sigta.T_REMANIEMENT_SIG c,sigta.T_SIGFIP_TIERS d,sigta.T_LIGNE_CPS e
WHERE a.ead_gst_annee in ('2008','2009','2010','2011','2012','2013','2014','2015','2016','2017','2018')
AND a.ead_statut  IN ('PEC','MER')
AND a.ead_num_acte NOT LIKE '3%'
--AND (a.ead_mnt_cp_don+a.ead_mnt_cp_emp+a.ead_mnt_cp_tre) >=100000000
AND a.ead_cde_pc_assi='508'
-- TO_DATE(a.ead_dte_pec)<='10/12/2012'
--AND a.EAD_NUM_ACTE= b.DAP_EAD_NUM_ACTE
ORDER BY a.EAD_NUM_ACTE;

--************************************
DROP  TABLE niaba.CONTROL_TGAN_mandat;

CREATE TABLE niaba.CONTROL_TGAN_mandat AS
SELECT a.rgl_ead_num_acte, a.rgl_montant FROM T_REGLEMENTS a WHERE
 a.rgl_ead_num_acte  IN (SELECT MANDAT FROM niaba.CONTROL_TGAN1);

-------********************************
DROP  TABLE  niaba.CONTROL_TGAN_mandat_cumul;

CREATE TABLE niaba.CONTROL_TGAN_mandat_cumul AS
SELECT rgl_ead_num_acte ,SUM(rgl_montant) montant_MER_REG FROM niaba.CONTROL_TGAN_mandat GROUP BY rgl_ead_num_acte;

--------*********************************
DROP  TABLE  niaba.CONTROL_T;

CREATE TABLE niaba.CONTROL_T AS 
SELECT a.*,b.* FROM niaba.CONTROL_TGAN1 a, niaba.CONTROL_TGAN_mandat_cumul b WHERE 
a.MANDAT=b.rgl_ead_num_acte(+);

-----------***********************
DROP TABLE niaba.CONTROL_Tmp;


CREATE TABLE niaba.CONTROL_Tmp AS
SELECT DISTINCT b.DAP_EAD_NUM_ACTE,b.dap_str_code,b.dap_cpt_debit,b.dap_cpt_credit,b.dap_cde_bque,b.dap_cde_cpt_bque  FROM sigta.T_DETAIL_ACTE_DEPENSES b WHERE 
b.DAP_EAD_NUM_ACTE IN (SELECT MANDAT FROM niaba.CONTROL_TGAN1)
ORDER BY DAP_EAD_NUM_ACTE;
----------***********************
DROP  TABLE  niaba.CONTROL_T2;

CREATE TABLE niaba.CONTROL_T2 AS 
SELECT a.*,b.* FROM niaba.CONTROL_T a, niaba.CONTROL_Tmp b WHERE 
a.MANDAT=b.DAP_EAD_NUM_ACTE(+);

----------**********************
DROP TABLE niaba.CONTROL_TGAN2;

CREATE TABLE niaba.CONTROL_TGAN2 AS
SELECT b.*,d.STR_CODE,d.str_lib FROM niaba.CONTROL_T2 b,sigta.T_SIGFIP_TIERS d
WHERE  b.DAP_STR_CODE =d.STR_CODE(+) ;
----------**************************** pause
DROP TABLE niaba.CONTROL_TGAN_2;

CREATE TABLE niaba.CONTROL_TGAN_2 AS
SELECT DISTINCT b.dap_ead_num_acte  dap_ead_num_acte2 ,c.rema_dest_cod,c.REMA_SCO_COD,c.REMA_SCO_LIB_LNG,e.LCP_CDE_TITRE TITRE,b.dap_lcp_num 
FROM sigta.T_DETAIL_ACTE_DEPENSES b,sigta.T_REMANIEMENT_SIG c,sigta.T_LIGNE_CPS e
WHERE SUBSTR(b.dap_lcp_num,0,9) =c.REMA_DEST_COD (+)
AND c.REMA_EXE IN('2009')--,'2012')
AND e.LCP_NUM=b.dap_lcp_num
AND e.lcp_exe  IN ('2008','2009','2010','2011','2012','2013','2014','2015','2016','2017','2018')--IN ('2012')
AND dap_ead_num_acte IN (SELECT MANDAT FROM niaba.CONTROL_TGAN1)
ORDER BY dap_ead_num_acte;

---***************************
DROP TABLE TABLE_TERMINALE;

CREATE TABLE TABLE_TERMINALE AS 
SELECT a.*,b.*,NVL (a.montant_mer,0) AS montant_MER_BON FROM niaba.CONTROL_TGAN2 a ,niaba.CONTROL_TGAN_2 b 
WHERE a.mandat=b.DAP_EAD_NUM_ACTE2--(+) 
--AND a.dap_cpt_credit='405.1'
ORDER BY mandat;



SELECT * FROM TABLE_TERMINALE ORDER BY ead_gst_annee ,mandat

--SELECT mandat,montant_pec,statut,objet,titre,SUBSTR(dap_lcp_num,1,3) CHAPITRE ,SUBSTR(dap_lcp_num,10,4) NATURE_ECONOMIQUE ,dap_lcp_num FROM TABLE_TERMINALE ORDER BY mandat

--SELECT b.*,d.STR_CODE,d.str_lib,montant_pec - NVL (montant_mer,0) AS RAP  FROM niaba.CONTROL_T2 b,sigta.T_SIGFIP_TIERS d
--WHERE  b.DAP_STR_CODE =d.STR_CODE(+)
--AND  b.dap_cpt_credit LIKE '40%'
--AND (statut='MER' AND montant_pec <> montant_mer )
--AND (statut='MER' AND  montant_mer=0 )
--ORDER BY b.ead_gst_annee,b.mandat ;
