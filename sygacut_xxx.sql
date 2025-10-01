--------------------------  REJET QUI ONT ETE REGULARISES ----------------------------------

select * from cut_reglement
where rgl_regul_num in
(
    select ide_piece from fc_ecriture@asterndir where
    (ide_poste, ide_gest, flg_cptab, ide_ecr, dat_ecr)
    in
    (
        select ide_poste, ide_gest, flg_cptab, ide_ecr, dat_ecr
        from fc_ligne@asterndir where
        (ide_poste, ide_ecr, ide_gest, ide_jal, flg_cptab)
        in
        (
            select ide_poste, ide_ecr, ide_gest, ide_jal, flg_cptab
            from fc_ecriture@asterndir where
            ide_gest in ('2023','2024')
            and ide_poste = '3021'
            and ide_jal <> 'TREP'
        )
        and ide_cpt = '475131'
        and cod_sens = 'C'
    )
)
order by rgl_num;

--2212223021000266 2306063021000003

------------------------------ PAIEMENTS REJETES --------------------------

select ide_piece from fc_ecriture@asterndir where
    (ide_poste, ide_gest, flg_cptab, ide_ecr, dat_ecr)
    in
    (
        select ide_poste, ide_gest, flg_cptab, ide_ecr, dat_ecr
        from fc_ligne@asterndir where
        (ide_poste, ide_ecr, ide_gest, ide_jal, flg_cptab)
        in
        (
            select ide_poste, ide_ecr, ide_gest, ide_jal, flg_cptab
            from fc_ecriture@asterndir where
            ide_gest in ('2023','2024')
            and ide_poste = '3021'
            and ide_jal <> 'TREP'
        )
        and ide_cpt = '475131'
        and cod_sens = 'C'
    )
;


----------------------  PAIEMENT NON REGULARISEES  -----------------------------

select '' || rgl_num, rgl_benef_nom, rgl_objet, rgl_dte_reglement, rgl_montant_net from cut_reglement where rgl_num in
(

select ide_piece from fc_ecriture@asterndir where
    (ide_poste, ide_gest, flg_cptab, ide_ecr, dat_ecr)
    in
    (
        select ide_poste, ide_gest, flg_cptab, ide_ecr, dat_ecr
        from fc_ligne@asterndir where
        (ide_poste, ide_ecr, ide_gest, ide_jal, flg_cptab)
        in
        (
            select ide_poste, ide_ecr, ide_gest, ide_jal, flg_cptab
            from fc_ecriture@asterndir where
            ide_gest in ('2023','2024')
            and ide_poste = '3021'
            and ide_jal <> 'TREP'
        )
        and ide_cpt = '475131'
        and cod_sens = 'C'
    )

minus

select rgl_regul_num from cut_reglement
where rgl_regul_num in
(
    select ide_piece from fc_ecriture@asterndir where
    (ide_poste, ide_gest, flg_cptab, ide_ecr, dat_ecr)
    in
    (
        select ide_poste, ide_gest, flg_cptab, ide_ecr, dat_ecr
        from fc_ligne@asterndir where
        (ide_poste, ide_ecr, ide_gest, ide_jal, flg_cptab)
        in
        (
            select ide_poste, ide_ecr, ide_gest, ide_jal, flg_cptab
            from fc_ecriture@asterndir where
            ide_gest in ('2023','2024')
            and ide_poste = '3021'
            and ide_jal <> 'TREP'
        )
        and ide_cpt = '475131'
        and cod_sens = 'C'
    )
)

)
order by rgl_num
;

