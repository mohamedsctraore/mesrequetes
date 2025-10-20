select opp_num, pc_code from cut_opposition@lkcut
    where To_Date(OPP_DTE_REGLEMENT,'DD/MM/RRRR') Between To_Date('01/01/2025','DD/MM/RRRR') and To_Date('31/12/2025','DD/MM/RRRR')
    and opp_statut = 'P'
    and OPP_TYPE = 'ATD'
minus
select ide_piece, ide_poste
    from fc_ecriture@lkastweb where (ide_piece, ide_poste) in
    (
        select opp_num, pc_code from cut_opposition@lkcut
        where To_Date(OPP_DTE_REGLEMENT,'DD/MM/RRRR') Between To_Date('01/01/2025','DD/MM/RRRR') and To_Date('31/12/2025','DD/MM/RRRR')
        and opp_statut = 'P'
        and OPP_TYPE = 'ATD'
    )
and ide_gest = '2025'
order by 2,1
;