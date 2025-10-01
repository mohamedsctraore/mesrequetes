select mandat_code from sigob_mandat where liq_num in
(
select ead_num_acte from t_entete_acte_depenses
where EAD_CDE_PC_ASSI = '613'
and ead_dte_pec is not null
and ead_exe='2021'
--and ead_mnt_cp_tre=250000
and ead_type='L'
)

minus

select mandat_code from sigob_mandat where mandat_code in
(
select ead_num_acte from t_entete_acte_depenses
where EAD_CDE_PC_ASSI = '613'
and ead_dte_pec is not null
and ead_exe='2021'
--and ead_mnt_cp_tre=250000
and ead_type='M'
)