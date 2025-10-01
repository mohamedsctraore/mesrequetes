declare
    var_ide_poste piaf_adm.fc_ecriture.ide_poste%TYPE;
    var_ide_gest piaf_adm.fc_ecriture.ide_gest%TYPE := '2024';
    var_ide_ecr piaf_adm.fc_ecriture.ide_ecr%TYPE;
    var_ide_cpt PIAF_ADM.fc_ligne.ide_cpt%TYPE;
    var_str_code piaf_adm.fc_ligne.ide_tiers%TYPE;
    cursor c_infos is select ide_poste, ide_cpt, ide_ecr, str_code from FC_TIERS where ide_poste in (select ide_poste from rm_poste where ide_typ_poste in ('T','TP','TG'));
    
begin

    update fc_ligne set ide_modele_lig = 'DEBIT+T', ide_tiers = 'GUFH', var_tiers = 'T2012'
    where ide_poste = '889'
    and cod_typ_schema = 'T'
    and ide_cpt = '448065'
    and cod_sens = 'D'
    and flg_cptab = 'N'
    and ide_tiers is null
    and var_tiers is null
    ;

    update fc_ligne set ide_cpt = '44331', ide_modele_lig = 'D 44331'
    where ide_poste like '3%'
    and cod_typ_schema = 'T'
    and ide_cpt = '4433'
    and cod_sens = 'D'
    and flg_cptab = 'N'
    ;

    update fc_ligne set spec1 = '391311'
    where (ide_poste, ide_ecr, ide_gest, ide_jal, flg_cptab)
    in
    (
    select ide_poste, ide_ecr, ide_gest, ide_jal, flg_cptab
    from fc_ecriture where
    ide_gest = '2024'
    )
    and ide_cpt = '39051'
    and cod_typ_schema = 'T'
    and flg_cptab = 'N'
    and ide_poste in (select ide_poste from rm_poste where ide_typ_poste = 'EPN')
    and spec1 = '39112'
    ;

    update fc_ligne set ide_cpt = '39112'
    where (ide_poste, ide_ecr, ide_gest, ide_jal, flg_cptab)
    in
    (
    select ide_poste, ide_ecr, ide_gest, ide_jal, flg_cptab
    from fc_ecriture where
    ide_gest = '2024'
    )
    and ide_cpt = '391311'
    and cod_typ_schema = 'T'
    and flg_cptab = 'N'
    and spec3 = '502'
    ;
    
    update fc_ligne set ide_cpt = '39112'
    where (ide_poste, ide_gest, ide_jal, flg_cptab, ide_ecr)
    in
    (
    select ide_poste, ide_gest, ide_jal, flg_cptab, ide_ecr
    from fc_ecriture
    where ide_gest = '2024'
    and ide_poste = '502'
    and ide_nd_emet like '5%'
    and ide_jal = 'JTRANSFERT'
    and flg_cptab = 'N'
    )
    and ide_cpt = '391311'
    ;

    update fc_ligne set spec1='39111',spec2='431112',spec3='501'
    where (ide_poste, ide_ecr, ide_gest, ide_jal, flg_cptab)
    in
    (
    select ide_poste, ide_ecr, ide_gest, ide_jal, flg_cptab
    from fc_ecriture where
    ide_gest = '2024'
    )
    and ide_cpt = '390303011'
    and cod_typ_schema = 'T'
    and flg_cptab = 'N'
    and (spec1 is null or spec2 is null or spec3 is null)
    ;
    
    update fc_ligne set spec1='39111',spec2='47012106',spec3='501'
    where (ide_poste, ide_ecr, ide_gest, ide_jal, flg_cptab)
    in
    (
    select ide_poste, ide_ecr, ide_gest, ide_jal, flg_cptab
    from fc_ecriture where
    ide_gest = '2024'
    )
    and ide_cpt = '39030309'
    and cod_typ_schema = 'T'
    and flg_cptab = 'N'
    and (spec1 is null or spec2 is null or spec3 is null)
    ;
    
    update fc_ligne set ide_tiers=ide_poste
    where (ide_poste, ide_ecr, ide_gest, ide_jal, flg_cptab)
    in
    (
    select ide_poste, ide_ecr, ide_gest, ide_jal, flg_cptab
    from fc_ecriture where
    ide_gest = '2024'
    and ide_poste in (select ide_poste from rm_poste where ide_typ_poste = 'PDR')
    )
    and ide_cpt in ('4411','4414')
    and cod_typ_schema = 'T'
    and flg_cptab = 'N'
    and ide_tiers is null
    ;

    update fc_ligne set ide_tiers='501'
    where (ide_poste, ide_ecr, ide_gest, ide_jal, flg_cptab)
    in
    (
    select ide_poste, ide_ecr, ide_gest, ide_jal, flg_cptab
    from fc_ecriture where
    ide_gest = '2024'
    and ide_poste in (select ide_poste from rm_poste where ide_typ_poste in ('PDR','EPN'))
    )
    and ide_cpt = '58112103'
    and cod_typ_schema = 'T'
    and flg_cptab = 'N'
    and ide_tiers is null
    ;
    
    update fc_ligne set ide_tiers='501'
    where (ide_poste, ide_ecr, ide_gest, ide_jal, flg_cptab)
    in
    (
    select ide_poste, ide_ecr, ide_gest, ide_jal, flg_cptab
    from fc_ecriture where
    ide_gest = '2024'
    and ide_poste in (select ide_poste from rm_poste where ide_typ_poste in ('PDR','EPN'))
    )
    and ide_cpt = '58112104'
    and cod_typ_schema = 'T'
    and flg_cptab = 'N'
    and ide_tiers is null
    ;
    
    update fc_ligne set ide_modele_lig = 'C 391311', spec2 = '390313'
    where (ide_poste, ide_ecr, ide_gest, ide_jal, flg_cptab)
    in
    (
    select ide_poste, ide_ecr, ide_gest, ide_jal, flg_cptab
    from fc_ecriture where
    ide_gest = '2024'
    and ide_poste = '515'
    )
    and ide_cpt = '391311'
    and cod_typ_schema = 'T'
    and flg_cptab = 'N'
    and ide_modele_lig = 'C 39112'
    ;
    
    update fc_ligne set ide_modele_lig = 'C 39051', spec2 = '390313'
    where (ide_poste, ide_ecr, ide_gest, ide_jal, flg_cptab)
    in
    (
    select ide_poste, ide_ecr, ide_gest, ide_jal, flg_cptab
    from fc_ecriture where
    ide_gest = '2024'
    and ide_poste in (select ide_poste from rm_poste where ide_typ_poste in ('EPN'))
    )
    and ide_cpt = '39051'
    and cod_typ_schema = 'T'
    and flg_cptab = 'N'
    and ide_modele_lig = 'CREDIT+3SPEC'
    ;
    
    open c_infos;
    
    loop 
        fetch c_infos into var_ide_poste, var_ide_cpt, var_ide_ecr, var_str_code;
        exit when c_infos%NOTFOUND;
        
        update fc_ligne
        set ide_tiers = var_str_code
        where ide_poste = var_ide_poste
        and ide_gest = '2024'
        and flg_cptab = 'N'
        and ide_ecr = var_ide_ecr
        and ide_cpt = var_ide_cpt
        and ide_modele_lig = 'DEBIT+T'
        and ide_tiers is null
        ;
        
        commit;        
    end loop;
    
    update fc_ligne set ide_tiers = 'REGIE AVIP'
    where (ide_poste, ide_ecr, ide_gest, ide_jal, flg_cptab)
    in
    (
    select ide_poste, ide_ecr, ide_gest, ide_jal, flg_cptab
    from fc_ecriture where
    ide_gest = '2024'
    and ide_poste = '626'
    and flg_cptab = 'N'
    )
    and ide_cpt in ('44811','44813','44814')
    and ide_modele_lig = 'DEBIT+T'
    and ide_tiers = '626JUSTICE'
    ;

    update fc_ligne set ide_tiers = 'FAJ'
    where (ide_poste, ide_ecr, ide_gest, ide_jal, flg_cptab)
    in
    (
    select ide_poste, ide_ecr, ide_gest, ide_jal, flg_cptab
    from fc_ecriture where
    ide_gest = '2024'
    and ide_poste = '626'
    and flg_cptab = 'N'
    )
    and ide_cpt in ('44816')
    and ide_modele_lig = 'DEBIT+T'
    and ide_tiers = '626JUSTICE'
    ;

    update fc_ligne set ide_tiers = 'CHR'
    where (ide_poste, ide_ecr, ide_gest, ide_jal, flg_cptab)
    in
    (
    select ide_poste, ide_ecr, ide_gest, ide_jal, flg_cptab
    from fc_ecriture where
    ide_gest = '2024'
    and ide_poste = '626'
    and flg_cptab = 'N'
    )
    and ide_cpt in ('44801')
    and ide_modele_lig = 'DEBIT+T'
    and ide_tiers = '62601'
    ;
    
    update fc_ligne set ide_tiers = 'DU'
    where (ide_poste, ide_ecr, ide_gest, ide_jal, flg_cptab)
    in
    (
    select ide_poste, ide_ecr, ide_gest, ide_jal, flg_cptab
    from fc_ecriture where
    ide_gest = '2024'
    and ide_poste = '626'
    and flg_cptab = 'N'
    )
    and ide_cpt in ('44801')
    and ide_modele_lig = 'DEBIT+T'
    and ide_tiers = '62605'
    ;

    update fc_ligne set ide_tiers = 'REGIE AVFJ'
    where (ide_poste, ide_ecr, ide_gest, ide_jal, flg_cptab)
    in
    (
    select ide_poste, ide_ecr, ide_gest, ide_jal, flg_cptab
    from fc_ecriture where
    ide_gest = '2024'
    and ide_poste = '626'
    and flg_cptab = 'N'
    )
    and ide_cpt in ('44809')
    and ide_modele_lig = 'DEBIT+T'
    and ide_tiers = '626JUSTICE'
    ;

    update fc_ligne set ide_tiers = 'HG'
    where (ide_poste, ide_ecr, ide_gest, ide_jal, flg_cptab)
    in
    (
    select ide_poste, ide_ecr, ide_gest, ide_jal, flg_cptab
    from fc_ecriture where
    ide_gest = '2024'
    and ide_poste = '626'
    and flg_cptab = 'N'
    )
    and ide_cpt in ('44801')
    and ide_modele_lig = 'DEBIT+T'
    and ide_tiers = '62602'
    ;

    update fc_ligne set ide_tiers = 'REGIE CCGC'
    where (ide_poste, ide_ecr, ide_gest, ide_jal, flg_cptab)
    in
    (
    select ide_poste, ide_ecr, ide_gest, ide_jal, flg_cptab
    from fc_ecriture where
    ide_gest = '2024'
    and ide_poste = '626'
    and flg_cptab = 'N'
    )
    and ide_cpt in ('44817')
    and ide_modele_lig = 'DEBIT+T'
    and ide_tiers = '626JUSTICE'
    ;
    
    update fc_ligne set ide_tiers = 'HG ADJAME'
    where (ide_poste, ide_ecr, ide_gest, ide_jal, flg_cptab)
    in
    (
    select ide_poste, ide_ecr, ide_gest, ide_jal, flg_cptab
    from fc_ecriture where
    ide_gest = '2024'
    and ide_poste = '686'
    and flg_cptab = 'N'
    )
    and ide_cpt in ('44801')
    and ide_modele_lig = 'DEBIT+T'
    and ide_tiers in ('68601','68602','68603')
    ;
    
    update fc_ligne set ide_tiers = 'CSU GUIBEROUA'
    where (ide_poste, ide_ecr, ide_gest, ide_jal, flg_cptab)
    in
    (
    select ide_poste, ide_ecr, ide_gest, ide_jal, flg_cptab
    from fc_ecriture where
    ide_gest = '2024'
    and ide_poste = '658'
    and flg_cptab = 'N'
    )
    and ide_cpt in ('44801')
    and ide_modele_lig = 'DEBIT+T'
    and ide_tiers <> 'CSU GUIBEROUA'
    ;
    
    update fc_ligne set ide_tiers = 'BRIG GEND'
    where (ide_poste, ide_ecr, ide_gest, ide_jal, flg_cptab)
    in
    (
    select ide_poste, ide_ecr, ide_gest, ide_jal, flg_cptab
    from fc_ecriture where
    ide_gest = '2024'
    and ide_poste = '658'
    and flg_cptab = 'N'
    )
    and ide_cpt = '44899'
    and ide_modele_lig = 'DEBIT+T'
    and ide_tiers = '072BG'
    ;
    
    update fc_ligne set ide_tiers = 'CAIRE POLICE'
    where (ide_poste, ide_ecr, ide_gest, ide_jal, flg_cptab)
    in
    (
    select ide_poste, ide_ecr, ide_gest, ide_jal, flg_cptab
    from fc_ecriture where
    ide_gest = '2024'
    and ide_poste = '658'
    and flg_cptab = 'N'
    )
    and ide_cpt in ('44899')
    and ide_modele_lig = 'DEBIT+T'
    and ide_tiers not in ('072BG','BRIG GEND','CAIRE POLICE')
    ;
    
    update fc_ligne set ide_tiers = 'HG'
    where (ide_poste, ide_ecr, ide_gest, ide_jal, flg_cptab)
    in
    (
    select ide_poste, ide_ecr, ide_gest, ide_jal, flg_cptab
    from fc_ecriture where
    ide_gest = '2024'
    and ide_poste = '617'
    and flg_cptab = 'N'
    )
    and ide_cpt in ('44801')
    and ide_modele_lig = 'DEBIT+T'
    and ide_tiers = '000001'
    ;
    
    update fc_ligne set ide_tiers = 'HG'
    where (ide_poste, ide_ecr, ide_gest, ide_jal, flg_cptab)
    in
    (
    select ide_poste, ide_ecr, ide_gest, ide_jal, flg_cptab
    from fc_ecriture where
    ide_gest = '2024'
    and ide_poste = '648'
    and flg_cptab = 'N'
    )
    and ide_cpt in ('44801')
    and ide_modele_lig = 'DEBIT+T'
    and ide_tiers is null
    and upper(observ) like '%SALAIRE%'
    ;
    
    update fc_ligne set ide_tiers = 'CSU'
    where (ide_poste, ide_ecr, ide_gest, ide_jal, flg_cptab)
    in
    (
    select ide_poste, ide_ecr, ide_gest, ide_jal, flg_cptab
    from fc_ecriture where
    ide_gest = '2024'
    and ide_poste = '648'
    and flg_cptab = 'N'
    )
    and ide_cpt in ('44801')
    and ide_modele_lig = 'DEBIT+T'
    and ide_tiers is null
    and upper(observ) not like '%SALAIRE%'
    ;
    
    update fc_ligne set ide_tiers = 'HG'
    where (ide_poste, ide_ecr, ide_gest, ide_jal, flg_cptab)
    in
    (
    select ide_poste, ide_ecr, ide_gest, ide_jal, flg_cptab
    from fc_ecriture where
    ide_gest = '2024'
    and ide_poste = '664'
    and flg_cptab = 'N'
    )
    and ide_cpt in ('44801')
    and ide_modele_lig = 'DEBIT+T'
    and ide_tiers = 'HG BIANK'
    ;
    
    update fc_ligne set ide_tiers = 'HG TAABO'
    where (ide_poste, ide_ecr, ide_gest, ide_jal, flg_cptab)
    in
    (
    select ide_poste, ide_ecr, ide_gest, ide_jal, flg_cptab
    from fc_ecriture where
    ide_gest = '2024'
    and ide_poste = '731'
    and flg_cptab = 'N'
    )
    and ide_cpt in ('44801')
    and ide_modele_lig = 'DEBIT+T'
    and ide_tiers = 'HG TAABO2'
    ;
    
    update fc_ligne set ide_tiers = '353'
    where (ide_poste, ide_ecr, ide_gest, ide_jal, flg_cptab)
    in
    (
    select ide_poste, ide_ecr, ide_gest, ide_jal, flg_cptab
    from fc_ecriture where
    ide_gest = '2024'
    and ide_poste = '610'
    and flg_cptab = 'N'
    )
    and ide_cpt in ('4413')
    and ide_modele_lig = 'DEBIT+T'
    and ide_tiers is null
    ;
    
    update fc_ligne set ide_tiers = ide_poste, var_tiers = 'T2012'
    where (ide_poste, ide_ecr, ide_gest, ide_jal, flg_cptab)
    in
    (
    select ide_poste, ide_ecr, ide_gest, ide_jal, flg_cptab
    from fc_ecriture where
    ide_gest = '2024'
    and ide_poste in (select ide_poste from rm_poste where ide_typ_poste = 'EPN')
    and flg_cptab = 'N'
    )
    and ide_cpt = '44332'
    and ide_modele_lig = 'D 44332'
    and ide_tiers is null 
    and var_tiers is null
    ;
    
    update fc_ligne set ide_tiers = 'CSU-BINGERVILLE'
    where (ide_poste, ide_ecr, ide_gest, ide_jal, flg_cptab)
    in
    (
    select ide_poste, ide_ecr, ide_gest, ide_jal, flg_cptab
    from fc_ecriture where
    ide_gest = '2024'
    and ide_poste = '654'
    and flg_cptab = 'N'
    )
    and ide_cpt in ('44801')
    and ide_modele_lig = 'DEBIT+T'
    and ide_tiers in ('CSU GENIE 2000','0002','0134','073')
    ;
    
    update fc_ligne set ide_tiers = 'HG BINGERVILLE'
    where (ide_poste, ide_ecr, ide_gest, ide_jal, flg_cptab)
    in
    (
    select ide_poste, ide_ecr, ide_gest, ide_jal, flg_cptab
    from fc_ecriture where
    ide_gest = '2024'
    and ide_poste = '654'
    and flg_cptab = 'N'
    )
    and ide_cpt in ('44801')
    and ide_modele_lig = 'DEBIT+T'
    and ide_tiers in ('0077')
    ;
    
    update fc_ligne set ide_tiers = 'HP BINGERVILLE'
    where (ide_poste, ide_ecr, ide_gest, ide_jal, flg_cptab)
    in
    (
    select ide_poste, ide_ecr, ide_gest, ide_jal, flg_cptab
    from fc_ecriture where
    ide_gest = '2024'
    and ide_poste = '654'
    and flg_cptab = 'N'
    )
    and ide_cpt in ('44801')
    and ide_modele_lig = 'DEBIT+T'
    and ide_tiers in ('128')
    ;
    
    delete from e000618.fc_tiers;
    commit;
    
end;