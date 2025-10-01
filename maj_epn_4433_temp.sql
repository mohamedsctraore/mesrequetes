--select * from fc_ligne
update fc_ligne set ide_cpt = '44331', ide_modele_lig = 'D 44331'
where ide_poste like '3%'
and cod_typ_schema = 'T'
and ide_cpt = '4433'
and cod_sens = 'D'
and flg_cptab = 'N'
;