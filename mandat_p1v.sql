select ead_cde_pc_assi POSTE, (select pct_libelle from t_poste_comptas where pct_code=ead_cde_pc_assi) LIBELLE, count(*) as "TOTAL MANDAT",
sum(ead_mnt_cp_don + ead_mnt_cp_emp + ead_mnt_cp_tre) as "MANDAT TOTAL"
from t_entete_acte_depenses
where ead_statut not in ('ANN')
and ead_type='M'
and ead_exe='2021'
group by ead_cde_pc_assi
order by ead_cde_pc_assi
;


select * from t_entete_acte_depenses;

select ead_cde_pc_assi POSTE,(select pct_libelle from t_poste_comptas where pct_code=ead_cde_pc_assi) LIBELLE, count(*) as "TOTAL MANDAT" ,
sum(ead_mnt_cp_don + ead_mnt_cp_emp + ead_mnt_cp_tre) as "MANDAT TOTAL"
from t_entete_acte_depenses
where ead_statut in ('P1V')
and ead_type='M'
and ead_exe='2021'
group by ead_cde_pc_assi
order by ead_cde_pc_assi
;

select count(*) from t_entete_acte_depenses
where ead_statut in ('P1V')
and ead_type='M'
and ead_exe='2021'
;

select * from t_entete_acte_depenses
where ead_type='M'
and ead_exe='2021'
and ead_cde_pc_assi='503'
order by dat_maj desc
;