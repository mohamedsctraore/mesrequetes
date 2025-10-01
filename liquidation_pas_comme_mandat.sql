select * from t_entete_acte_depenses@sigta
where ead_num_acte in
(
select liq_num from sib_mandat 
where mandat_code in
(
select ead_num_acte from t_entete_acte_depenses@sigta
where ead_dte_pec='20/10/2021'
and ead_type='M'
and EAD_CDE_PC_ASSI_SIG='512'
)
MINUS
select ead_num_acte from t_entete_acte_depenses@sigta
where ead_dte_pec='20/10/2021'
and ead_type='L'
and EAD_CDE_PC_ASSI_SIG='512'
)
;

211065321100371
211065321100374
211065321100470
211065321100472
211065321100469
211065321100471
211065321100468
211117221100037
211117221100038
211117221100039