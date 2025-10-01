select ide_gest, ide_poste, dat_ecr, ide_jal, ide_ecr, ide_tiers, ide_cpt, ide_ref_piece, cod_ref_piece, 
                                                                                                                        CASE
                                                                                                                        WHEN cod_sens='C' THEN mt
                                                                                                                        ELSE 0
                                                                                                                        END as "CREDIT",
                                                                                                                        CASE
                                                                                                                        WHEN cod_sens='D' THEN mt
                                                                                                                        ELSE 0
                                                                                                                        END as "DEBIT",
observ, ide_schema, cod_typ_schema, ide_modele_lig from fc_ligne where ide_ref_piece in
(
select ide_ref_piece from fc_ref_piece where ide_ref_piece in
(
select ide_ref_piece from fc_ligne where
(ide_poste,ide_gest,ide_jal,flg_cptab,ide_ecr)
in (select ide_poste, ide_gest,ide_jal,flg_cptab,ide_ecr 
from fc_ecriture where 
ide_gest='2021'
and ide_poste='671'
and ide_mess=7172
)
and ide_cpt in ('4721111')
)
and ide_poste='671'
)
and ide_poste='671'
and ide_gest in ('2020','2021')
order by ide_ref_piece, ide_gest, dat_ecr