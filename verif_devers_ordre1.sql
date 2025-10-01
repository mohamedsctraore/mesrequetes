select unique posteb, journee from ORAS.T_TRANS_BIS_ORDRE_OP1_AG_N_WEB a, t_agence_oras b
--update ORAS.T_TRANS_BIS_ORDRE_OP1_AG_N_WEB set statut = 'NT'
where a.emetteur = b.agcode
and gestion = '2025'
--and emetteur = '01503'
and statut = 'T'
--order by posteb, journee
minus
select ide_nd_emet, to_date(substr(libl,29,8),'dd/mm/rrrr') from fm_message@ASTERWEB11G
where ide_gest = '2025'
and cod_typ_mess = 27
and ide_nd_emet in (select ide_poste from rm_poste@ASTERWEB11G where ide_typ_poste = 'AACCD')
and libl like '%ORD1'
--order by ide_nd_emet, ide_mess
order by 1,2
;


execute ORAS.T29ACCD_ORDRE1_NEW_11G_WG('01533','2025','03/01/2025');