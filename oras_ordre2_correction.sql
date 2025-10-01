SELECT * FROM T_TRANSFERT_BIS_N_WEB_BIS
--UPDATE T_TRANSFERT_BIS_N_WEB_BIS SET STATUT = 'S'
WHERE JOURNEE = '&&date_oper'
and emetteur in (select AGCODE from t_agence_oras where posteb = '&&poste')
--order by 16,5
;


SELECT * FROM T_TRANSFERT_BIS_BANQ_N_WEB
--UPDATE T_TRANSFERT_BIS_BANQ_N_WEB SET STATUT = 'S'
WHERE JOURNEE = '&&date_oper'
and emetteur in (select AGCODE from t_agence_oras where posteb = '&&poste')
--order by 16,5
;


--SELECT * FROM T_TRANS_BIS_ORDRE_OP1_AG_N_WEB
UPDATE T_TRANS_BIS_ORDRE_OP1_AG_N_WEB SET STATUT = 'S'
WHERE JOURNEE = '&&date_oper'
and emetteur in (select AGCODE from t_agence_oras where posteb = '&&poste')
--order by 16,5
;


SELECT * FROM T_TRANS_BIS_ORDRE_OP2_AG_N_WEB
--UPDATE T_TRANS_BIS_ORDRE_OP2_AG_N_WEB SET STATUT = 'S'
WHERE JOURNEE = '&&date_oper'
and emetteur in (select AGCODE from t_agence_oras where posteb = '241')
--order by 16,5
;

select * from t_mvtc_oras
where mvtc_datoper = '13/09/2024'
and abs(mvtc_mntdev) = 96800;