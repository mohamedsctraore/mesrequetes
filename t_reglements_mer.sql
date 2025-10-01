select a.rgl_ead_num_acte, c.EAD_DTE_ORDON, a.rgl_dte_reglement,(c.EAD_MNT_CP_TRE+c.ead_mnt_cp_don+c.EAD_MNT_CP_EMP) MONTANT, sum(a.RGL_MONTANT), a.RGL_PCT_CODE, d.PCT_LIBELLE 
from t_reglements a, mohamed b, t_entete_acte_depenses c, t_poste_comptas d
where a.rgl_ead_num_acte=b.acte
and a.rgl_ead_num_acte=c.ead_num_acte
and b.acte=c.ead_num_acte
and a.RGL_PCT_CODE=d.pct_code
group by a.rgl_ead_num_acte, c.EAD_DTE_ORDON, a.rgl_dte_reglement,(c.EAD_MNT_CP_TRE+c.ead_mnt_cp_don+c.EAD_MNT_CP_EMP), a.RGL_PCT_CODE, d.PCT_LIBELLE
order by a.rgl_ead_num_acte
;