select a.dap_ead_num_acte NUM_ACTE, b.ead_num_bordereau NUM_BORDEREAU, substr(a.dap_lcp_num,12,INSTR(substr(a.dap_lcp_num,12),'0',5,1)-1) NATURE_ECO, b.ead_objet, b.ead_dte_ordon DATE_ORDONN, b.ead_dte_pec DATE_PEC,
 a.dap_mnt_tre MONTANT_PEC, b.ead_dte_mis_rgl DATE_REGLEMENT, b.ead_mnt_tot_pay_tre MONTANT_PAYE, b.ead_statut STATUT, (select str_lib from sigta.t_sigfip_tiers where str_code =a.dap_str_code) beneficiaire
 from t_detail_acte_depenses a, t_entete_acte_depenses b
where a.dap_ead_num_acte=b.ead_num_acte
and b.ead_exe='2021'
and b.ead_type='M'
and b.EAD_CDE_PC_ASSI_SIG='651'
order by b.ead_dte_ordon
;