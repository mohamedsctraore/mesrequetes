select ide_poste, ide_gest, ide_jal, ide_cpt, mt, observ, cod_typ_schema, ide_modele_lig, dat_ecr, dat_ref from fc_ligne where ide_cpt like '411%'
and ide_gest between '2007' and '2011'
and dat_ecr between '01/01/2007' and '31/12/2010'
order by dat_ecr