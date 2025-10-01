select a.ead_cde_pc_assi_sig POSTE, a.ead_num_acte NUM_ACTE,a.EAD_NUM_BORDEREAU NUM_BORDEREAU,  a.ead_objet, substr(dap_lcp_num,12,INSTR(substr(dap_lcp_num,12),'0',5,1)-1) NATURE_ECO,
(select str_lib from t_sigfip_tiers where str_code=b.dap_str_code) TIERS, a.EAD_DTE_ORDON DATE_ORDONN, a.ead_dte_pec DATE_PEC,
(a.EAD_MNT_CP_DON + a.EAD_MNT_CP_EMP + a.EAD_MNT_CP_TRE) MONTANT_PEC, b.DAP_CPT_CREDIT as "COMPTE CREDIT", b.DAP_CPT_DEBIT as "COMPTE DEBIT"
from t_entete_acte_depenses a, t_detail_acte_depenses b where
a.EAD_CDE_PC_ASSI='657'
and a.EAD_GST_ANNEE='2021'
and a.ead_num_acte=b.dap_ead_num_acte
and EAD_TYPE='M'
--and ead_dte_pec='31/12/2021'
and ead_statut in ('P1V')
order by a.ead_cde_pc_assi_sig, MONTANT_PEC
;