Insert into PIAF_ADM.FC_ECRITURE
   (IDE_POSTE, IDE_GEST, IDE_JAL, FLG_CPTAB, IDE_ECR, 
    DAT_JC, VAR_CPTA, IDE_SCHEMA, COD_TYP_ND, IDE_ND_EMET, 
    IDE_MESS, FLG_EMIS_RECU, LIBN, DAT_SAISIE, DAT_ECR, 
    COD_STATUT, IDE_PIECE, IDE_TRT)
select ide_poste, ide_gest, ide_jal, 'N', ide_ecr, null, 'C2020', ide_schema, cod_typ_nd, ide_nd_emet, ide_mess, 'R', libn, dat_saisie, null, 'AC', null, ide_trt from ic_ecriture
where ide_poste = '899C'
and ide_mess = 9280
and ide_trt = 159;

Insert into FC_LIGNE
   (IDE_POSTE, IDE_GEST, IDE_JAL, FLG_CPTAB, IDE_ECR, 
    IDE_LIG, VAR_CPTA, VAR_TIERS, IDE_TIERS, IDE_CPT, 
    IDE_REF_PIECE, COD_REF_PIECE, VAR_BUD, IDE_LIG_EXEC, IDE_OPE, 
    IDE_ORDO, COD_SENS, MT, SPEC1, SPEC2, 
    SPEC3, OBSERV, DAT_CENTRA, DAT_TRANSF, IDE_SCHEMA, 
    COD_TYP_SCHEMA, IDE_MODELE_LIG, DAT_ECR, DAT_REF, COD_TYP_BUD, 
    COD_BUD, COD_BE, FLG_ANNUL_DCST, IDE_PLAN_AUX, IDE_CPT_AUX, 
    IDE_DEVISE, VAL_TAUX, MT_DEV, NUM_QUITTANCE, NOM_BQ, 
    CPT_BQ)
select ide_poste, ide_gest, ide_jal, 'N', ide_ecr, ide_lig, 'C2020', null, ide_tiers, ide_cpt, null, cod_ref_piece, null, ide_lig_exec, ide_ope, ide_ordo, cod_sens, mt, spec1, spec2, spec3,
observ, null, null, 'RECFISCAL', 'A', ide_modele_lig, null, dat_ref, cod_typ_bud, cod_bud, null, 'N', ide_plan_aux, ide_cpt_aux, ide_devise, val_taux, mt_dev, null, null, null  from ic_ligne
where (ide_poste, ide_gest, ide_jal, ide_ecr)
in
(
select ide_poste, ide_gest, ide_jal, ide_ecr
from ic_ecriture
where ide_gest = '2024'
and ide_poste = '899C'
and libn like 'Centralisation 822 du 24/07/24'
and ide_mess = 9280
and ide_nd_emet = '822'
)
and ide_trt = 159;