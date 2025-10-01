select ide_piece, a.ide_poste from fc_ecriture@asterndir a, fc_ligne@asterndir b
where (flg_emis_recu, cod_typ_nd, ide_nd_emet, ide_mess) 
in (select flg_emis_recu, cod_typ_nd, ide_nd_emet, ide_mess from fm_message@asterndir where ide_gest = '2024' and cod_typ_mess = 24 and ide_nd_emet = '690'
and libl like '%CUT-PAIEMENT EFFECTIF%')
and ide_cpt like '572'
and cod_sens = 'C'
and a.ide_poste = b.ide_poste and a.ide_gest = b.ide_gest and a.flg_cptab = b.flg_cptab and a.ide_jal = b.ide_jal and a.ide_ecr = b.ide_ecr
and dat_ref between '01/01/2024' and '31/10/2024'
minus
select rgl_num, pc_code
from cut_reglement where pc_code='690' and to_date(rgl_dte_reglement,'DD/MM/RRRR') between '01/01/2024' and '31/10/2024'
and  RGL_STATUT  in ('V','P') and rgl_mrg_code='02' --and (Rgl_Code_Op not like '%ctualisation%%'  or Rgl_Code_Op is null)
;

select * from fc_ligne@asterndir where (ide_gest, ide_poste, ide_jal, flg_cptab, ide_ecr) in
(
select ide_gest, ide_poste, ide_jal, flg_cptab, ide_ecr from fc_ecriture@asterndir
where (ide_piece, ide_poste) in
(
select ide_piece, a.ide_poste from fc_ecriture@asterndir a, fc_ligne@asterndir b
where (flg_emis_recu, cod_typ_nd, ide_nd_emet, ide_mess) 
in (select flg_emis_recu, cod_typ_nd, ide_nd_emet, ide_mess from fm_message@asterndir where ide_gest = '2024' and cod_typ_mess = 24 and ide_nd_emet = '504'
and libl like '%CUT-PAIEMENT EFFECTIF%')
and ide_cpt like '571'
and cod_sens = 'C'
and a.ide_poste = b.ide_poste and a.ide_gest = b.ide_gest and a.flg_cptab = b.flg_cptab and a.ide_jal = b.ide_jal and a.ide_ecr = b.ide_ecr
and dat_ref between '01/01/2024' and '31/10/2024'
and ide_piece not in
(
'2404110504000064',
'2405100504000155',
'2410240504000407'
)
minus
select rgl_num, pc_code
from cut_reglement where pc_code='504' and to_date(rgl_dte_reglement,'DD/MM/RRRR') between '01/01/2024' and '31/10/2024'
and rgl_num not in
(
'2404110504000064',
'2405100504000155',
'2410240504000407'
)
and  RGL_STATUT  in ('V','P') and rgl_mrg_code='02' --and (Rgl_Code_Op not like '%ctualisation%%'  or Rgl_Code_Op is null)
)
)
and ide_cpt = '571'
