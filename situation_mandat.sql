select a.ead_num_acte NUM_ACTE,a.EAD_NUM_BORDEREAU NUM_BORDEREAU,  a.ead_objet, substr(dap_lcp_num,12,INSTR(substr(dap_lcp_num,12),'0',5,1)-1) NATURE_ECO,
(select str_lib from t_sigfip_tiers where str_code=b.dap_str_code) TIERS, a.EAD_DTE_ORDON DATE_ORDONN, a.ead_dte_pec DATE_PEC,
(a.EAD_MNT_CP_DON + a.EAD_MNT_CP_EMP + a.EAD_MNT_CP_TRE) MONTANT_PEC, a.ead_dte_mis_rgl DATE_REGLEMENT, 
(a.EAD_MNT_TOT_PAY_EMP + a.EAD_MNT_TOT_PAY_TRE + a.EAD_MNT_TOT_PAY_DON) MONTANT_MER,
a.ead_statut STATUT
from t_entete_acte_depenses a, t_detail_acte_depenses b where
a.EAD_CDE_PC_ASSI_SIG='654'
and a.EAD_GST_ANNEE='2021'
and a.ead_num_acte=b.dap_ead_num_acte
and EAD_TYPE='M'
order by a.EAD_DTE_ORDON
;

select * from t_detail_acte_depenses where dap_ead_num_acte='314078821100004';