select a.ead_cde_pc_assi TG, (select libn from rm_noeud where ide_nd = a.ead_cde_pc_assi) libelle_tg, a.ead_cde_pc_assi_sig PCR, (select libn from rm_noeud where ide_nd = a.ead_cde_pc_assi_sig) libelle_pcr, a.ead_num_acte MANDAT, a.ead_journee_pec JOURNEE_PEC, a.ead_dte_ordon JOURNEE_SIGOBE, a.ead_mnt_cp_tre MONTANT, b.statut_journ STATUT_JOURNEE
from t_entete_acte_depenses@asterwebpec a, t_journees@asterwebpec b
where a.ead_journee_pec = b.date_journ
and a.ead_cde_pc_assi_sig = b.code_pct
and a.ead_exe = '2025'
and a.ead_statut in ('PEC','MER')
and a.ead_type = 'M'
and a.EAD_DEVERS_CUT = 'ATT'
--and a.DAT_VALIC_CENTRA is null
and (a.ead_cde_pc_assi not like '5%' and a.ead_cde_pc_assi <> a.ead_cde_pc_assi_sig)
and a.ead_num_acte not in (select ide_piece from fc_ecriture where ide_gest = '2025' and ide_jal = 'JPECDEPBG')
and b.type_journ = 'P'
order by 1,3,6,5
;

select * from t_journees@asterwebpec;

select * from t_entete_acte_depenses@asterwebpec