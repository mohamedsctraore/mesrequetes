--alter session set nls_date_format = 'DD/MM/RRRR';

declare

    cursor c_ord1 is select unique posteb v_poste, journee v_journee 
    from ORAS.T_TRANS_BIS_ORDRE_OP1_AG_N_WEB a, t_agence_oras b
    where a.emetteur = b.agcode
    and gestion = '2025'
    and statut = 'T'
    --and emetteur = '01540'
    minus
    select ide_nd_emet v_poste, to_date(substr(libl,29,8),'dd/mm/rrrr') v_journee from fm_message@ASTERWEB11G
    where ide_gest = '2025'
    and cod_typ_mess = 27
    and ide_nd_emet in (select ide_poste from rm_poste@ASTERWEB11G where ide_typ_poste = 'AACCD')
    and libl like '%ORD1'
    order by 1,2
    ;
    
    v_emetteur VARCHAR2(5 BYTE);

begin
    for param_ligne in c_ord1
        loop
            select agcode into v_emetteur from t_agence_oras where posteb = param_ligne.v_poste;
            update ORAS.T_TRANS_BIS_ORDRE_OP1_AG_N_WEB set statut = 'NT'
            where emetteur = v_emetteur
            and journee = param_ligne.v_journee
            and statut = 'T';
            
            ORAS.T29ACCD_ORDRE1_NEW_11G_WG(v_emetteur,'2025',param_ligne.v_journee);
        end loop;

end;