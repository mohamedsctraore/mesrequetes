DROP VIEW CUT.CUT_VB_NEW_PECMER_MDT;

/* Formatted on 07/04/2022 12:45:25 (QP5 v5.313) */
CREATE OR REPLACE FORCE VIEW CUT.CUT_VB_NEW_PECMER_MDT
(
    GESTION,
    PCC,
    LIB_PCC,
    PCR,
    EAD_NUM_ACTE,
    EAD_STATUT,
    FOURNISSEUR,
    CHAPITRE,
    CHAPITRE_LIB,
    V_MONTANT,
    V_BR_NUM,
    DAT_PEC,
    V_BR_DTE_VISA,
    EAD_RESP_DEP,
    V_COMPTE,
    EAD_OBJET,
    MT_MANDAT
)
AS
      SELECT gestion,
             pcc,
             lib_pcc,
             pcr,
             ead_num_acte,
             ead_statut,
             fournisseur,
             chapitre,
             cut_fb_chapitre (chapitre) chapitre_lib,
             SUM (v_montant)          v_montant,
             v_br_num,
             dat_pec,
             v_br_dte_visa,
             ead_resp_dep,
             v_compte,
             ead_objet,
             mt_mandat
        FROM (SELECT gestion,
                     pcc,
                     lib_pcc,
                     pcr,
                     ead_num_acte,
                     ead_statut,
                     fournisseur,
                     dat_mer,
                     mt_mandat,
                     mnt_mer,
                     v_montant,
                     chapitre,
                     v_br_num,
                     dat_pec,
                     v_br_dte_visa,
                     ead_resp_dep,
                     v_compte,
                     ead_objet
                FROM (  SELECT ead_gst_annee
                                   gestion,
                               ead_cde_pc_assi
                                   pcc,
                               libn
                                   lib_pcc,
                               ead_cde_pc_assi_sig
                                   pcr,
                               ead_num_acte,
                               ead_statut,
                               str_lib
                                   fournisseur,
                               Ead_Journee_Pec
                                   dat_pec,
                               ead_dte_mis_rgl
                                   dat_mer,
                                 NVL (ead_mnt_cp_don, 0)
                               + NVL (ead_mnt_cp_emp, 0)
                               + NVL (ead_mnt_cp_tre, 0)
                                   mt_mandat,
                               SUM (NVL (rgl_montant, 0))
                                   mnt_mer,
                                 (  NVL (ead_mnt_cp_don, 0)
                                  + NVL (ead_mnt_cp_emp, 0)
                                  + NVL (ead_mnt_cp_tre, 0))
                               - SUM (NVL (rgl_montant, 0))
                                   v_montant,
                               SUBSTR (dap_lcp_num, 10, 4)
                                   chapitre,
                               ead_num_bordereau
                                   v_br_num,
                               ead_dte_ordon
                                   v_br_dte_visa,
                               ead_resp_dep,
                               dap_cde_cpt_bque
                                   v_compte,
                               ead_objet
                          FROM pecn.t_entete_acte_depenses@peclk,
                               pecn.t_detail_acte_depenses@peclk,
                               pecn.t_reglements@peclk,
                               pecn.t_sigfip_tiers@peclk,
                               piaf_adm.rm_noeud@peclk
                         WHERE     str_typ <> 'A'
                               AND ead_num_acte = dap_ead_num_acte
                               AND ead_num_acte = rgl_ead_num_acte(+)
                               --And Substr(Dap_Lcp_Num,10,2)='61'   --- A iniber
                               AND ead_statut = 'PEC'
                               AND ead_type = 'M'
                               AND ide_nd = ead_cde_pc_assi_sig
                               AND dap_str_code = str_code
                               AND Ead_Devers_Pec = 'D'
                               AND Hors_SIgACUT IS NULL
                               -----------
                               --AND Ead_Dte_Mis_Rgl        Is Null  --And (Sysdate - Ead_Dte_Pec) > 15  --- 90   UPDATE BY NIABA
                               --And Ead_Cde_Pc_Assi_Sig    =  '657' --Pc$Pc_Code
                               AND ead_cde_pc_assi_sig <> ead_cde_pc_assi
                               AND ead_statut IN ('PEC')
                               AND ead_type = 'M'
                               -- And Ead_Mnt_Net_A_Payer     <> 0 UPDATE BY NIABA
                               AND ead_gst_annee =
                                   TO_NUMBER (TO_CHAR (SYSDATE, 'rrrr'))
                               AND Str_Typ <> 'A'
                      ------------
                      GROUP BY ead_gst_annee,
                               ead_cde_pc_assi,
                               libn,
                               ead_cde_pc_assi_sig,
                               ead_statut,
                               ead_num_acte,
                                 NVL (ead_mnt_cp_don, 0)
                               + NVL (ead_mnt_cp_emp, 0)
                               + NVL (ead_mnt_cp_tre, 0),
                               str_lib,
                               Ead_Journee_Pec,
                               ead_objet,
                               ead_dte_mis_rgl,
                               SUBSTR (dap_lcp_num, 10, 4),
                               ead_num_bordereau,
                               ead_dte_ordon,
                               ead_resp_dep,
                               dap_cde_cpt_bque
                      UNION ALL
                        SELECT ead_gst_annee
                                   gestion,
                               ead_cde_pc_assi
                                   pcc,
                               libn
                                   lib_pcc,
                               ead_cde_pc_assi
                                   pcr,
                               --Ead_Cde_Pc_Assi_Sig Pcr,
                               ead_num_acte,
                               ead_statut,
                               str_lib
                                   fournisseur,
                               Ead_Journee_Pec
                                   dat_pec,
                               ead_dte_mis_rgl
                                   dat_mer,
                                 NVL (ead_mnt_cp_don, 0)
                               + NVL (ead_mnt_cp_emp, 0)
                               + NVL (ead_mnt_cp_tre, 0)
                                   mt_mandat,
                               SUM (NVL (rgl_montant, 0))
                                   mnt_mer,
                                 (  NVL (ead_mnt_cp_don, 0)
                                  + NVL (ead_mnt_cp_emp, 0)
                                  + NVL (ead_mnt_cp_tre, 0))
                               - SUM (NVL (rgl_montant, 0))
                                   v_montant,
                               SUBSTR (dap_lcp_num, 10, 4)
                                   chapitre,
                               ead_num_bordereau
                                   v_br_num,
                               ead_dte_ordon
                                   v_br_dte_visa,
                               ead_resp_dep,
                               dap_cde_cpt_bque
                                   v_compte,
                               ead_objet
                          FROM pecn.t_entete_acte_depenses@peclk,
                               pecn.t_detail_acte_depenses@peclk,
                               pecn.t_reglements@peclk,
                               pecn.t_sigfip_tiers@peclk,
                               piaf_adm.rm_noeud@peclk
                         WHERE     str_typ <> 'A'
                               AND ead_num_acte = dap_ead_num_acte
                               AND ead_num_acte = rgl_ead_num_acte(+)
                               --And Substr(Dap_Lcp_Num,10,2)='61'   --- A iniber
                               AND ead_statut = 'PEC'
                               AND ead_type = 'M'
                               AND ide_nd = ead_cde_pc_assi_sig
                               AND dap_str_code = str_code
                               AND Ead_Devers_Pec = 'D'
                               AND Hors_SIgACUT IS NULL
                               -----------
                               --AND Ead_Dte_Mis_Rgl        Is Null  --And (Sysdate - Ead_Dte_Pec) > 15  --- 90   UPDATE BY NIABA
                               --And Ead_Cde_Pc_Assi     =  '657' --Pc$Pc_Code
                               AND ead_cde_pc_assi_sig <> ead_cde_pc_assi
                               AND ead_statut IN ('PEC')
                               AND ead_type = 'M'
                               -- And Ead_Mnt_Net_A_Payer     <> 0 UPDATE BY NIABA
                               AND ead_gst_annee <
                                   TO_NUMBER (TO_CHAR (SYSDATE, 'rrrr'))
                               AND Str_Typ <> 'A'
                      ------------
                      GROUP BY ead_gst_annee,
                               ead_cde_pc_assi,
                               libn,
                               ead_cde_pc_assi_sig,
                               ead_statut,
                               ead_num_acte,
                                 NVL (ead_mnt_cp_don, 0)
                               + NVL (ead_mnt_cp_emp, 0)
                               + NVL (ead_mnt_cp_tre, 0),
                               str_lib,
                               ead_objet,
                               Ead_Journee_Pec,
                               ead_dte_mis_rgl,
                               SUBSTR (dap_lcp_num, 10, 4),
                               ead_num_bordereau,
                               ead_dte_ordon,
                               ead_resp_dep,
                               dap_cde_cpt_bque
                      UNION ALL
                        SELECT ead_gst_annee
                                   gestion,
                               ead_cde_pc_assi
                                   pcc,
                               libn
                                   lib_pcc,
                               ead_cde_pc_assi_sig
                                   pcr,
                               ead_num_acte,
                               ead_statut,
                               str_lib
                                   fournisseur,
                               Ead_Journee_Pec
                                   dat_pec,
                               ead_dte_mis_rgl
                                   dat_mer,
                                 NVL (ead_mnt_cp_don, 0)
                               + NVL (ead_mnt_cp_emp, 0)
                               + NVL (ead_mnt_cp_tre, 0)
                                   mt_mandat,
                               SUM (NVL (rgl_montant, 0))
                                   mnt_mer,
                                 (  NVL (ead_mnt_cp_don, 0)
                                  + NVL (ead_mnt_cp_emp, 0)
                                  + NVL (ead_mnt_cp_tre, 0))
                               - SUM (NVL (rgl_montant, 0))
                                   v_montant,
                               SUBSTR (dap_lcp_num, 10, 4)
                                   chapitre,
                               ead_num_bordereau
                                   v_br_num,
                               ead_dte_ordon
                                   v_br_dte_visa,
                               ead_resp_dep,
                               dap_cde_cpt_bque
                                   v_compte,
                               ead_objet
                          FROM pecn.t_entete_acte_depenses@peclk,
                               pecn.t_detail_acte_depenses@peclk,
                               pecn.t_reglements@peclk,
                               pecn.t_sigfip_tiers@peclk,
                               piaf_adm.rm_noeud@peclk
                         WHERE     str_typ <> 'A'
                               AND ead_num_acte = dap_ead_num_acte
                               AND ead_num_acte = rgl_ead_num_acte(+)
                               --And Substr(Dap_Lcp_Num,10,2)='61'   --- A iniber
                               AND ead_statut = 'PEC'
                               AND ead_type = 'M'
                               AND ide_nd = ead_cde_pc_assi_sig
                               AND dap_str_code = str_code
                               AND Ead_Devers_Pec = 'D'
                               AND Hors_SIgACUT IS NULL
                               -----------
                               --AND Ead_Dte_Mis_Rgl        Is Null  --And (Sysdate - Ead_Dte_Pec) > 15  --- 90   UPDATE BY NIABA
                               --And Ead_Cde_Pc_Assi_Sig    = '657' --Pc$Pc_Code
                               AND ead_cde_pc_assi_sig = ead_cde_pc_assi
                               AND ead_statut IN ('PEC')
                               AND ead_type = 'M'
                               -- And Ead_Mnt_Net_A_Payer     <> 0 UPDATE BY NIABA
                               AND ead_gst_annee <=
                                   TO_NUMBER (TO_CHAR (SYSDATE, 'rrrr'))
                               AND Str_Typ <> 'A'
                      ------------
                      GROUP BY ead_gst_annee,
                               ead_cde_pc_assi,
                               libn,
                               ead_cde_pc_assi_sig,
                               ead_statut,
                               ead_num_acte,
                                 NVL (ead_mnt_cp_don, 0)
                               + NVL (ead_mnt_cp_emp, 0)
                               + NVL (ead_mnt_cp_tre, 0),
                               str_lib,
                               Ead_Journee_Pec,
                               ead_objet,
                               ead_dte_mis_rgl,
                               SUBSTR (dap_lcp_num, 10, 4),
                               ead_num_bordereau,
                               ead_dte_ordon,
                               ead_resp_dep,
                               dap_cde_cpt_bque --Where (Pcr,Ead_Num_Acte) Not In (Select Pc_Code,Rgl_Mdt_Num From Cut_Pre_Reglement Where Pc_Code = '657' And Rgl_Mdt_Num Is Not Null)
                                               ))
       WHERE (gestion >= 2017 AND gestion < 2020)
    GROUP BY gestion,
             pcc,
             lib_pcc,
             pcr,
             ead_num_acte,
             ead_statut,
             fournisseur,
             chapitre,
             v_br_num,
             dat_pec,
             v_br_dte_visa,
             ead_resp_dep,
             v_compte,
             ead_objet,
             mt_mandat
    -----          AJOUT 2020
    UNION
      SELECT gestion,
             pcc,
             lib_pcc,
             pcr,
             ead_num_acte,
             ead_statut,
             fournisseur,
             chapitre,
             cut_fb_chapitre (chapitre) chapitre_lib,
             SUM (v_montant)          v_montant,
             v_br_num,
             dat_pec,
             v_br_dte_visa,
             ead_resp_dep,
             v_compte,
             ead_objet,
             mt_mandat
        FROM (SELECT gestion,
                     pcc,
                     lib_pcc,
                     pcr,
                     ead_num_acte,
                     ead_statut,
                     fournisseur,
                     dat_pec,
                     dat_mer,
                     mt_mandat,
                     mnt_mer,
                     v_montant,
                     chapitre,
                     v_br_num,
                     v_br_dte_visa,
                     ead_resp_dep,
                     v_compte,
                     ead_objet
                FROM (  SELECT ead_gst_annee
                                   gestion,
                               ead_cde_pc_assi
                                   pcc,
                               libn
                                   lib_pcc,
                               ead_cde_pc_assi_sig
                                   pcr,
                               ead_num_acte,
                               ead_statut,
                               str_lib
                                   fournisseur,
                               Ead_Journee_Pec
                                   dat_pec,
                               ead_dte_mis_rgl
                                   dat_mer,
                                 NVL (ead_mnt_cp_don, 0)
                               + NVL (ead_mnt_cp_emp, 0)
                               + NVL (ead_mnt_cp_tre, 0)
                                   mt_mandat,
                               SUM (NVL (rgl_montant, 0))
                                   mnt_mer,
                                 (  NVL (ead_mnt_cp_don, 0)
                                  + NVL (ead_mnt_cp_emp, 0)
                                  + NVL (ead_mnt_cp_tre, 0))
                               - SUM (NVL (rgl_montant, 0))
                                   v_montant,
                               SUBSTR (dap_lcp_num, 12, 6)
                                   chapitre,
                               ead_num_bordereau
                                   v_br_num,
                               ead_dte_ordon
                                   v_br_dte_visa,
                               ead_resp_dep,
                               dap_cde_cpt_bque
                                   v_compte,
                               ead_objet
                          FROM pecn.t_entete_acte_depenses@peclk,
                               pecn.t_detail_acte_depenses@peclk,
                               pecn.t_reglements@peclk,
                               pecn.t_sigfip_tiers@peclk,
                               piaf_adm.rm_noeud@peclk
                         WHERE     str_typ <> 'A'
                               AND ead_num_acte = dap_ead_num_acte
                               AND ead_num_acte = rgl_ead_num_acte(+)
                               --And Substr(Dap_Lcp_Num,10,2)='61'   --- A iniber
                               AND ead_statut = 'PEC'
                               AND ead_type = 'M'
                               AND ide_nd = ead_cde_pc_assi_sig
                               AND dap_str_code = str_code
                               AND Ead_Devers_Pec = 'D'
                               AND Hors_SIgACUT IS NULL
                               -----------
                               --AND Ead_Dte_Mis_Rgl        Is Null  --And (Sysdate - Ead_Dte_Pec) > 15  --- 90   UPDATE BY NIABA
                               --And Ead_Cde_Pc_Assi_Sig    =  '657' --Pc$Pc_Code
                               AND ead_cde_pc_assi_sig <> ead_cde_pc_assi
                               AND ead_statut IN ('PEC')
                               AND ead_type = 'M'
                               -- And Ead_Mnt_Net_A_Payer     <> 0 UPDATE BY NIABA
                               AND ead_gst_annee =
                                   TO_NUMBER (TO_CHAR (SYSDATE, 'rrrr'))
                      ------------
                      GROUP BY ead_gst_annee,
                               ead_cde_pc_assi,
                               libn,
                               ead_cde_pc_assi_sig,
                               ead_statut,
                               ead_num_acte,
                                 NVL (ead_mnt_cp_don, 0)
                               + NVL (ead_mnt_cp_emp, 0)
                               + NVL (ead_mnt_cp_tre, 0),
                               str_lib,
                               Ead_Journee_Pec,
                               ead_objet,
                               ead_dte_mis_rgl,
                               SUBSTR (dap_lcp_num, 12, 6),
                               ead_num_bordereau,
                               ead_dte_ordon,
                               ead_resp_dep,
                               dap_cde_cpt_bque
                      UNION ALL
                        SELECT ead_gst_annee
                                   gestion,
                               ead_cde_pc_assi
                                   pcc,
                               libn
                                   lib_pcc,
                               ead_cde_pc_assi
                                   pcr,
                               --Ead_Cde_Pc_Assi_Sig Pcr,
                               ead_num_acte,
                               ead_statut,
                               str_lib
                                   fournisseur,
                               Ead_Journee_Pec
                                   dat_pec,
                               ead_dte_mis_rgl
                                   dat_mer,
                                 NVL (ead_mnt_cp_don, 0)
                               + NVL (ead_mnt_cp_emp, 0)
                               + NVL (ead_mnt_cp_tre, 0)
                                   mt_mandat,
                               SUM (NVL (rgl_montant, 0))
                                   mnt_mer,
                                 (  NVL (ead_mnt_cp_don, 0)
                                  + NVL (ead_mnt_cp_emp, 0)
                                  + NVL (ead_mnt_cp_tre, 0))
                               - SUM (NVL (rgl_montant, 0))
                                   v_montant,
                               SUBSTR (dap_lcp_num, 12, 6)
                                   chapitre,
                               ead_num_bordereau
                                   v_br_num,
                               ead_dte_ordon
                                   v_br_dte_visa,
                               ead_resp_dep,
                               dap_cde_cpt_bque
                                   v_compte,
                               ead_objet
                          FROM pecn.t_entete_acte_depenses@peclk,
                               pecn.t_detail_acte_depenses@peclk,
                               pecn.t_reglements@peclk,
                               pecn.t_sigfip_tiers@peclk,
                               piaf_adm.rm_noeud@peclk
                         WHERE     str_typ <> 'A'
                               AND ead_num_acte = dap_ead_num_acte
                               AND ead_num_acte = rgl_ead_num_acte(+)
                               --And Substr(Dap_Lcp_Num,10,2)='61'   --- A iniber
                               AND ead_statut = 'PEC'
                               AND ead_type = 'M'
                               AND ide_nd = ead_cde_pc_assi_sig
                               AND dap_str_code = str_code
                               AND Ead_Devers_Pec = 'D'
                               AND Hors_SIgACUT IS NULL
                               -----------
                               --AND Ead_Dte_Mis_Rgl        Is Null  --And (Sysdate - Ead_Dte_Pec) > 15  --- 90   UPDATE BY NIABA
                               --And Ead_Cde_Pc_Assi     =  '657' --Pc$Pc_Code
                               AND ead_cde_pc_assi_sig <> ead_cde_pc_assi
                               AND ead_statut IN ('PEC')
                               AND ead_type = 'M'
                               -- And Ead_Mnt_Net_A_Payer     <> 0 UPDATE BY NIABA
                               AND ead_gst_annee <
                                   TO_NUMBER (TO_CHAR (SYSDATE, 'rrrr'))
                      ------------
                      GROUP BY ead_gst_annee,
                               ead_cde_pc_assi,
                               libn,
                               ead_cde_pc_assi_sig,
                               ead_statut,
                               ead_num_acte,
                                 NVL (ead_mnt_cp_don, 0)
                               + NVL (ead_mnt_cp_emp, 0)
                               + NVL (ead_mnt_cp_tre, 0),
                               str_lib,
                               ead_objet,
                               Ead_Journee_Pec,
                               ead_dte_mis_rgl,
                               SUBSTR (dap_lcp_num, 12, 6),
                               ead_num_bordereau,
                               ead_dte_ordon,
                               ead_resp_dep,
                               dap_cde_cpt_bque
                      UNION ALL
                        SELECT ead_gst_annee
                                   gestion,
                               ead_cde_pc_assi
                                   pcc,
                               libn
                                   lib_pcc,
                               ead_cde_pc_assi_sig
                                   pcr,
                               ead_num_acte,
                               ead_statut,
                               str_lib
                                   fournisseur,
                               Ead_Journee_Pec
                                   dat_pec,
                               ead_dte_mis_rgl
                                   dat_mer,
                                 NVL (ead_mnt_cp_don, 0)
                               + NVL (ead_mnt_cp_emp, 0)
                               + NVL (ead_mnt_cp_tre, 0)
                                   mt_mandat,
                               SUM (NVL (rgl_montant, 0))
                                   mnt_mer,
                                 (  NVL (ead_mnt_cp_don, 0)
                                  + NVL (ead_mnt_cp_emp, 0)
                                  + NVL (ead_mnt_cp_tre, 0))
                               - SUM (NVL (rgl_montant, 0))
                                   v_montant,
                               SUBSTR (dap_lcp_num, 12, 6)
                                   chapitre,
                               ead_num_bordereau
                                   v_br_num,
                               ead_dte_ordon
                                   v_br_dte_visa,
                               ead_resp_dep,
                               dap_cde_cpt_bque
                                   v_compte,
                               ead_objet
                          FROM pecn.t_entete_acte_depenses@peclk,
                               pecn.t_detail_acte_depenses@peclk,
                               pecn.t_reglements@peclk,
                               pecn.t_sigfip_tiers@peclk,
                               piaf_adm.rm_noeud@peclk
                         WHERE     str_typ <> 'A'
                               AND ead_num_acte = dap_ead_num_acte
                               AND ead_num_acte = rgl_ead_num_acte(+)
                               --And Substr(Dap_Lcp_Num,10,2)='61'   --- A iniber
                               AND ead_statut = 'PEC'
                               AND ead_type = 'M'
                               AND ide_nd = ead_cde_pc_assi_sig
                               AND dap_str_code = str_code
                               AND Ead_Devers_Pec = 'D'
                               AND Hors_SIgACUT IS NULL
                               -----------
                               --AND Ead_Dte_Mis_Rgl        Is Null  --And (Sysdate - Ead_Dte_Pec) > 15  --- 90   UPDATE BY NIABA
                               --And Ead_Cde_Pc_Assi_Sig    = '657' --Pc$Pc_Code
                               AND ead_cde_pc_assi_sig = ead_cde_pc_assi
                               AND ead_statut IN ('PEC')
                               AND ead_type = 'M'
                               -- And Ead_Mnt_Net_A_Payer     <> 0 UPDATE BY NIABA
                               AND ead_gst_annee <=
                                   TO_NUMBER (TO_CHAR (SYSDATE, 'rrrr'))
                      ------------
                      GROUP BY ead_gst_annee,
                               ead_cde_pc_assi,
                               libn,
                               ead_cde_pc_assi_sig,
                               ead_statut,
                               ead_num_acte,
                                 NVL (ead_mnt_cp_don, 0)
                               + NVL (ead_mnt_cp_emp, 0)
                               + NVL (ead_mnt_cp_tre, 0),
                               str_lib,
                               Ead_Journee_Pec,
                               ead_objet,
                               ead_dte_mis_rgl,
                               SUBSTR (dap_lcp_num, 12, 6),
                               ead_num_bordereau,
                               ead_dte_ordon,
                               ead_resp_dep,
                               dap_cde_cpt_bque --Where (Pcr,Ead_Num_Acte) Not In (Select Pc_Code,Rgl_Mdt_Num From Cut_Pre_Reglement Where Pc_Code = '657' And Rgl_Mdt_Num Is Not Null)
                                               ))
       WHERE (gestion >= 2020)
    GROUP BY gestion,
             pcc,
             lib_pcc,
             pcr,
             ead_num_acte,
             ead_statut,
             fournisseur,
             chapitre,
             v_br_num,
             dat_pec,
             v_br_dte_visa,
             ead_resp_dep,
             v_compte,
             ead_objet,
             mt_mandat
    ORDER BY
        gestion,
        pcc,
        lib_pcc,
        pcr,
        ead_num_acte,
        ead_statut,
        fournisseur,
        chapitre;


CREATE OR REPLACE PUBLIC SYNONYM CUT_VB_NEW_PECMER_MDT FOR CUT.CUT_VB_NEW_PECMER_MDT;