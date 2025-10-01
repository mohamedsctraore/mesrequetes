select * from t_entete_acte_depenses@sigta
where ead_exe='2021'
and EAD_CDE_PC_ASSI_SIG='750'
and ead_type='M'
and ead_statut not like 'MER'
order by ead_num_acte
;