Rem - Extraction dans le fichier historique
Rem - de l'ancienne comptabilité (1975 à 2003)
Rem - ----------------------------------------
Rem # Auteur: BOITENIN Kouassi Raphaël
Rem # Date : le 30 mars 2006
REM
Rem  and substr(hist_dat_ecr,1,2) in ('92','93','94','95','96','97','98','99','00','01','02')

SET echo OFF
SET feedback OFF
SET pagesize 37
SET linesize 100
spool c:\52200417.txt
TTI 'EXTRACTION DE COMPTE '
col MONTANT format 999G999G999G999
SELECT hist_imp_tre "IMP. TRESOR",
       hist_imp_bud "IMP. BUD",
       hist_pc "P.C.",
       CONCAT(CONCAT(SUBSTR(hist_dat_ecr,5,2), '/'),
              CONCAT(CONCAT(SUBSTR(hist_dat_ecr,3,2), '/'),
                            SUBSTR(hist_dat_ecr,1,2)
                    )
             ) "DATE ECRITURE",
       hist_cod_sens_ecr "DEBIT OU CREDIT",
       hist_rcq "REF.CODIQUE",
       CONCAT(CONCAT(SUBSTR(hist_dat_trt,5,2), '/'),
              CONCAT(CONCAT(SUBSTR(hist_dat_trt,3,2), '/'),
                            SUBSTR(hist_dat_trt,1,2)
                    )
             ) "DATE TRAITMT.",
       hist_mt "MONTANT",
       hist_lib "LIBELLE"
FROM HIST_ECR
WHERE hist_imp_tre LIKE '411%'
AND SUBSTR(hist_dat_ecr,1,2) IN ('75','74','75','76','77','78','79','80','81','82','83','84','85','86','87','88','89','90','91','92','93','94','95','96','97','98','99','00','01','02')
/
spool OFF
Rem
SET echo ON
EXIT
