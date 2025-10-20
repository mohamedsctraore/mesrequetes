select * from fc_ligne@lkastweb 
--update fc_ligne@lkastweb set observ = 'ATD ' || observ
where (ide_gest, ide_poste, flg_cptab, ide_ecr, ide_jal)
in
(
    select ide_gest, ide_poste, flg_cptab, ide_ecr, ide_jal
    from fc_ecriture@lkastweb where (ide_piece, ide_poste) in
    (
        select opp_num, pc_code from cut_opposition@lkcut
        where To_Date(OPP_DTE_REGLEMENT,'DD/MM/RRRR') Between To_Date('01/01/2025','DD/MM/RRRR') and To_Date('31/12/2025','DD/MM/RRRR')
        and opp_statut = 'P'
        and OPP_TYPE = 'ATD'
    )
and ide_gest = '2025'
)
and ide_gest = '2025'
and ide_cpt in ('39051','391311')
and cod_sens = 'C'
and (spec3 in (select ide_poste from rm_poste@lkastweb where ide_typ_poste = 'TCDGI') or spec3 = '@RPIC')
and observ Not Like 'ATD%'
--order by 1,2
;