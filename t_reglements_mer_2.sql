select b.ead_num_acte, b.ead_objet, (b.EAD_MNT_CP_DON+b.EAD_MNT_CP_EMP+b.EAD_MNT_CP_TRE) MONTANT_PEC, sum(c.rgl_montant) MONTANT_MER
from mohamed a, t_entete_acte_depenses b, t_reglements c
where a.acte=b.ead_num_acte
and a.acte=c.rgl_ead_num_acte
group by b.ead_num_acte, b.ead_objet, (b.EAD_MNT_CP_DON+b.EAD_MNT_CP_EMP+b.EAD_MNT_CP_TRE)
;

select c.rgl_pct_code, d.pct_libelle, sum((b.EAD_MNT_CP_DON+b.EAD_MNT_CP_EMP+b.EAD_MNT_CP_TRE)) MONTANT_PEC, sum(c.rgl_montant) MONTANT_MER, sum((b.EAD_MNT_CP_DON+b.EAD_MNT_CP_EMP+b.EAD_MNT_CP_TRE)) - sum(c.rgl_montant) RESTE_A_PAYER
from mohamed a, t_entete_acte_depenses b, t_reglements c, t_poste_comptas d
where a.acte=b.ead_num_acte
and a.acte=c.rgl_ead_num_acte
and c.rgl_pct_code=d.pct_code
group by c.rgl_pct_code,d.pct_libelle
order by c.rgl_pct_code
;