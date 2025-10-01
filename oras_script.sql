--select * from ORAS.T_TRANSFERT_BIS_N_WEB_BIS
update ORAS.T_TRANSFERT_BIS_N_WEB_BIS set statut = 'NT'
where journee = '06/06/2025' and emetteur = '01001';

select * from ORAS.T_TRANS_BIS_ORDRE_OP1_AG_N_WEB
--update ORAS.T_TRANS_BIS_ORDRE_OP1_AG_N_WEB set statut = 'NT'
where journee = '06/06/2025' and emetteur = '01001';

--select * from ORAS.T_TRANS_BIS_ORDRE_OP2_AG_N_WEB
update ORAS.T_TRANS_BIS_ORDRE_OP2_AG_N_WEB set statut = 'NT'
where journee = '06/06/2025' and emetteur = '01001';

--select * from ORAS.T_TRANSFERT_BIS_BANQ_N_WEB
update ORAS.T_TRANSFERT_BIS_BANQ_N_WEB set statut = 'NT'
where journee = '06/06/2025' and emetteur = '01001';

execute ORAS.T29ACCD_BANQ_NEW_11G_WG('01001','2025','06/06/2025')
execute ORAS.T29ACCD_ORDRE1_NEW_11G_WG ('01001','2025','06/06/2025')
execute ORAS.T29ACCD_ORDRE2_NEW_11G_WG('01001','2025','06/06/2025')
execute ORAS.T29ACCD_NEW_11G_WG('01001','2025','06/06/2025')

--select * from ORAS.T_LJ_OP_BQ_COMPENS_SG_WEB
update ORAS.T_LJ_OP_BQ_COMPENS_SG_WEB set statut = 'NT'
where journee = '06/06/2025';

--select * from ORAS.T_TRANS_BCEAO_BQ_SG_WEB
update ORAS.T_TRANS_BCEAO_BQ_SG_WEB set statut = 'NT'
where journee = '06/06/2025';

--select * from ORAS.T_TRANS_RTGS_BQ_SG_WEB
update ORAS.T_TRANS_RTGS_BQ_SG_WEB set statut = 'NT'
where journee = '06/06/2025';