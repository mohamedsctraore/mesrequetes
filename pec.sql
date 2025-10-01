select sum(ead_mnt_cp_tre) from t_entete_acte_depenses a, t_detail_acte_depenses b
where ead_num_acte=dap_ead_num_acte
and ead_exe='2021'
and ead_cde_pc_assi_sig='721'
and dap_cpt_credit='47411'
and ead_dte_pec between '01/01/2021' and '31/12/2021'