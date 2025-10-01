select ide_poste, ide_gest, ide_ecr, ide_cpt from fc_ligne
where (ide_poste, ide_gest, ide_ecr)
in
(
select ide_poste, '2024', ide_ecr from FC_TIERS
where ide_cpt = '4413'
and str_code is not null
)
and ide_tiers is null
and flg_cptab = 'N'
and ide_modele_lig = 'DEBIT+T'
and ide_poste in (select ide_poste from rm_poste where ide_typ_poste in ('T','TP','TG'))
;

select ide_poste, ide_cpt, ide_ecr, str_code from FC_TIERS where ide_poste in (select ide_poste from rm_poste where ide_typ_poste in ('T','TP','TG'));


--select * from fc_ligne
update fc_ligne set ide_tiers = '323'
where (ide_poste, ide_ecr, ide_gest, ide_jal, flg_cptab)
in
(
select ide_poste, ide_ecr, ide_gest, ide_jal, flg_cptab
from fc_ecriture where
ide_poste = '612'
and ide_gest = '2024'
and ide_mess in (16940)
--and ide_ecr in (2814)
and ide_ecr between 2068 and 2110
)
and ide_cpt = '4413'
and cod_typ_schema = 'T'
and flg_cptab = 'N'
--and ide_tiers is null
--and dat_ref = '28/05/2024'
;


--select * from fc_ligne
update fc_ligne set spec1='39111',spec2='431112',spec3='501'
where (ide_poste, ide_ecr, ide_gest, ide_jal, flg_cptab)
in
(
select ide_poste, ide_ecr, ide_gest, ide_jal, flg_cptab
from fc_ecriture where
ide_gest = '2024'
--and ide_mess in (6213)
--and ide_ecr in (2814)
)
and ide_cpt = '390303011'
and cod_typ_schema = 'T'
and flg_cptab = 'N'
and (spec1 is null or spec2 is null or spec3 is null)
;


--select * from fc_ligne
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

--select * from fc_ligne
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

--select * from fc_ligne
update fc_ligne set ide_tiers = null, var_tiers = null, ide_cpt = '4482515', ide_modele_lig = 'DEBIT'
where (ide_poste, ide_ecr, ide_gest, ide_jal, flg_cptab)
in
(
select ide_poste, ide_ecr, ide_gest, ide_jal, flg_cptab
from fc_ecriture where
ide_poste = '610'
and ide_gest = '2024'
and ide_mess in (2786)
and ide_ecr in (79,80,81,87,88,89,90,91,83,84,85,93,94,96,97)
)
and ide_cpt = '44801'
and cod_typ_schema = 'T'
and flg_cptab = 'N'
--and ide_tiers is null
--and dat_ref = '28/05/2024'
;

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


declare
    var_ide_poste piaf_adm.fc_ecriture.ide_poste%TYPE;
    var_ide_gest piaf_adm.fc_ecriture.ide_gest%TYPE := '2024';
    var_ide_ecr piaf_adm.fc_ecriture.ide_ecr%TYPE;
    var_ide_cpt PIAF_ADM.fc_ligne.ide_cpt%TYPE;
    var_str_code piaf_adm.fc_ligne.ide_tiers%TYPE;
    cursor c_infos is select ide_poste, ide_cpt, ide_ecr, str_code from FC_TIERS where ide_poste in (select ide_poste from rm_poste where ide_typ_poste in ('T','TP','TG'))
    ;
begin

    update fc_ligne set spec1='39111',spec2='431112',spec3='501'
    where (ide_poste, ide_ecr, ide_gest, ide_jal, flg_cptab)
    in
    (
    select ide_poste, ide_ecr, ide_gest, ide_jal, flg_cptab
    from fc_ecriture where
    ide_gest = '2024'
    --and ide_mess in (6213)
    --and ide_ecr in (2814)
    )
    and ide_cpt = '390303011'
    and cod_typ_schema = 'T'
    and flg_cptab = 'N'
    and (spec1 is null or spec2 is null or spec3 is null)
    ;
    
    --select * from fc_ligne
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

    --select * from fc_ligne
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
    
    --select * from fc_ligne
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

    --select * from fc_ligne
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

    --select * from fc_ligne
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

    --select * from fc_ligne
    update fc_ligne set ide_tiers = 'AVFJ'
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

    --select * from fc_ligne
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

    --select * from fc_ligne
    update fc_ligne set ide_tiers = 'CCGC'
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
    
end;


----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--select * from fc_ligne
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

--select * from fc_ligne
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

--select * from fc_ligne
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

--select * from fc_ligne
update fc_ligne set ide_tiers = 'AVFJ'
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

--select * from fc_ligne
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

--select * from fc_ligne
update fc_ligne set ide_tiers = 'CCGC'
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


--------------------------------- INSERT DANS FC_REF_PIECE -------------------------------------------------------

declare
    var_ide_poste piaf_adm.fc_ecriture.ide_poste%TYPE;
    var_ide_gest piaf_adm.fc_ecriture.ide_gest%TYPE := '2024';
    var_ide_ecr piaf_adm.fc_ecriture.ide_ecr%TYPE;
    var_ide_cpt PIAF_ADM.fc_ligne.ide_cpt%TYPE;
    var_str_code piaf_adm.fc_ligne.ide_tiers%TYPE;
    cursor c_infos is select ide_poste from rm_poste where ide_poste in (select ide_poste from rm_poste where ide_typ_poste in ('P')) and ide_poste not in ('425')
    ;
begin
    
    open c_infos;
    
    loop 
        fetch c_infos into var_ide_poste;
        exit when c_infos%NOTFOUND;
        
        insert into fc_ref_piece
        select * from niaba.fc_ref_piece_flg_o a
        where a.ide_poste = var_ide_poste
        and a.flg_solde = 'O'
        and (ide_poste, ide_ref_piece, ide_jal) not in
        (
        select ide_poste, ide_ref_piece, ide_jal from fc_ref_piece
        where ide_poste = var_ide_poste
        and flg_solde = 'O'
        );
        
        commit;        
    end loop;
    
exception
    when DUP_VAL_ON_INDEX then
        insert into e000618.fc_tiers (ide_poste, ide_piece, ide_cpt, ide_ecr, str_code, nat_dep_code) values (var_ide_poste, var_ide_poste, var_ide_poste,var_ide_poste,var_ide_poste,var_ide_poste);
end;