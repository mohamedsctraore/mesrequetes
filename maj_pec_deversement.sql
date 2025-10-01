--select ead_num_acte, ead_dte_pec, ead_devers_pec, ead_pec_aster, ead_journee_pec from t_entete_acte_depenses
update t_entete_acte_depenses set ead_pec_aster = 'ATT', ead_devers_pec = 'D'
where ead_num_acte in
(
'211561722100001',
'211561722100002',
'211561722100003',
'314042622100001',
'314042622100002',
'314042622100003'
)
;