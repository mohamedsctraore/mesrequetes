Select Sum(Rgl_Montant_Net) -- Into Pc$SyGACUT_Paie_Vir
    From (
          Select Sum(Rgl_Montant_Net) Rgl_Montant_Net --Into Lc$Flux_Crediteur
            From Cut_Reglement
           Where Pc_Code       = '3021'
             --And To_Char(Rgl_Dte_Reglement,'rrrr') = Pc$Gestion
             And To_Date(Rgl_Dte_Reglement,'DD/MM/RRRR') Between To_Date('01/01/2024','DD/MM/RRRR') And To_Date('31/10/2024','DD/MM/RRRR')
             And (Rgl_Statut    In ('V','P') or Rgl_Statut = 'R' and rgl_rout_statut='R')
             And Rgl_Mrg_Code  = '02'
             And Rgl_Regul_Num Is Null
          Union All
          Select Sum(Rgl_Montant_Net) Rgl_Montant_Net --Into Lc$Flux_Crediteur
            From Cut_Reglt_Restor_Juil_Aout_24
           Where Pc_Code       = '3021'
             --And To_Char(Rgl_Dte_Reglement,'rrrr') = Pc$Gestion
             And To_Date(Rgl_Dte_Reglement,'DD/MM/RRRR') Between To_Date('01/01/2024','DD/MM/RRRR') And To_Date('31/10/2024','DD/MM/RRRR')
             And Rgl_Statut    = 'P'
             --And (Rgl_Statut    In ('P') or Rgl_Statut = 'R' and rgl_rout_statut='R')
             And Rgl_Mrg_Code  = '02'
             And Rgl_Ret_Type  = 'PAI'
             And Rgl_Regul_Num Is Null
  )
  ;
  
  
    select sum(mt) from fc_ecriture@asterndir a, fc_ligne@asterndir b
where (flg_emis_recu, cod_typ_nd, ide_nd_emet, ide_mess) 
in (select flg_emis_recu, cod_typ_nd, ide_nd_emet, ide_mess from fm_message@asterndir where ide_gest = '2024' and cod_typ_mess = 24 and ide_nd_emet = '3021'
and libl like '%CUT-PAIEMENT EFFECTIF DU%')
and ide_cpt like '572'
--and cod_sens = 'C'
and length(ide_piece) > 14
and dat_ref between '25/07/2024' and '25/07/2024'
and a.ide_poste = b.ide_poste and a.ide_gest = b.ide_gest and a.flg_cptab = b.flg_cptab and a.ide_jal = b.ide_jal and a.ide_ecr = b.ide_ecr
;
  
  
Select rgl_num, rgl_montant_net -- Into Pc$SyGACUT_Paie_Vir
    From (
          Select rgl_num, rgl_montant_net --Into Lc$Flux_Crediteur
            From Cut_Reglement@lkcut
           Where Pc_Code       = '508'
             --And To_Char(Rgl_Dte_Reglement,'rrrr') = Pc$Gestion
             And To_Date(Rgl_Dte_Reglement,'DD/MM/RRRR') Between To_Date('25/02/2025','DD/MM/RRRR') And To_Date('25/02/2025','DD/MM/RRRR')
             And (Rgl_Statut    In ('V','P') or Rgl_Statut = 'R' and rgl_rout_statut='R')
             And Rgl_Mrg_Code  = '02'
             And Rgl_Regul_Num Is Null
          Union All
          Select rgl_num, rgl_montant_net --Into Lc$Flux_Crediteur
            From Cut_Reglt_Restor_Juil_Aout_24@lkcut
           Where Pc_Code       = '3021'
             --And To_Char(Rgl_Dte_Reglement,'rrrr') = Pc$Gestion
             And To_Date(Rgl_Dte_Reglement,'DD/MM/RRRR') Between To_Date('25/02/2025','DD/MM/RRRR') And To_Date('25/02/2025','DD/MM/RRRR')
             And Rgl_Statut    = 'P'
             --And (Rgl_Statut    In ('P') or Rgl_Statut = 'R' and rgl_rout_statut='R')
             And Rgl_Mrg_Code  = '02'
             And Rgl_Ret_Type  = 'PAI'
             And Rgl_Regul_Num Is Null
)
minus
select ide_piece, mt from fc_ecriture@lkastweb a, fc_ligne@lkastweb b
where (flg_emis_recu, cod_typ_nd, ide_nd_emet, ide_mess) 
in (select flg_emis_recu, cod_typ_nd, ide_nd_emet, ide_mess from fm_message@lkastweb where ide_gest = '2025' and cod_typ_mess = 24 and ide_nd_emet = '508'
and libl like '%CUT-PAIEMENT EFFECTIF DU%')
--and ide_cpt like '572'
and cod_sens = 'C'
and length(ide_piece) > 14
and dat_ref between '25/02/2025' and '25/02/2025'
and a.ide_poste = b.ide_poste and a.ide_gest = b.ide_gest and a.flg_cptab = b.flg_cptab and a.ide_jal = b.ide_jal and a.ide_ecr = b.ide_ecr
;

select ide_piece, mt from fc_ecriture@asterndir a, fc_ligne@asterndir b
where (flg_emis_recu, cod_typ_nd, ide_nd_emet, ide_mess) 
in (select flg_emis_recu, cod_typ_nd, ide_nd_emet, ide_mess from fm_message@asterndir where ide_gest = '2024' and cod_typ_mess = 24 and ide_nd_emet = '3021'
and libl like '%CUT-PAIEMENT EFFECTIF DU%')
--and ide_cpt like '572'
and cod_sens = 'C'
and length(ide_piece) > 14
and dat_ref between '01/01/2024' and '31/10/2024'
and a.ide_poste = b.ide_poste and a.ide_gest = b.ide_gest and a.flg_cptab = b.flg_cptab and a.ide_jal = b.ide_jal and a.ide_ecr = b.ide_ecr
minus
Select rgl_num, rgl_montant_net -- Into Pc$SyGACUT_Paie_Vir
    From (
          Select rgl_num, rgl_montant_net --Into Lc$Flux_Crediteur
            From Cut_Reglement
           Where Pc_Code       = '3021'
             --And To_Char(Rgl_Dte_Reglement,'rrrr') = Pc$Gestion
             And To_Date(Rgl_Dte_Reglement,'DD/MM/RRRR') Between To_Date('01/01/2024','DD/MM/RRRR') And To_Date('31/10/2024','DD/MM/RRRR')
             And (Rgl_Statut    In ('V','P') or Rgl_Statut = 'R' and rgl_rout_statut='R')
             And Rgl_Mrg_Code  = '02'
             And Rgl_Regul_Num Is Null
          Union All
          Select rgl_num, rgl_montant_net --Into Lc$Flux_Crediteur
            From Cut_Reglt_Restor_Juil_Aout_24
           Where Pc_Code       = '3021'
             --And To_Char(Rgl_Dte_Reglement,'rrrr') = Pc$Gestion
             And To_Date(Rgl_Dte_Reglement,'DD/MM/RRRR') Between To_Date('01/01/2024','DD/MM/RRRR') And To_Date('31/10/2024','DD/MM/RRRR')
             And Rgl_Statut    = 'P'
             --And (Rgl_Statut    In ('P') or Rgl_Statut = 'R' and rgl_rout_statut='R')
             And Rgl_Mrg_Code  = '02'
             And Rgl_Ret_Type  = 'PAI'
             And Rgl_Regul_Num Is Null
)
;

select a.ide_poste, a.ide_jal, a.ide_ecr, mt, observ, dat_ref date_sygacut from fc_ecriture@asterndir a, fc_ligne@asterndir b
where (flg_emis_recu, cod_typ_nd, ide_nd_emet, ide_mess) 
in (select flg_emis_recu, cod_typ_nd, ide_nd_emet, ide_mess from fm_message@asterndir where ide_gest = '2024' and cod_typ_mess = 24 and ide_nd_emet = '3021'
and libl like '%CUT-PAIEMENT EFFECTIF DU%')
--and ide_cpt like '572'
and cod_sens = 'C'
and length(ide_piece) > 14
and dat_ref between '01/01/2024' and '31/10/2024'
and a.ide_poste = b.ide_poste and a.ide_gest = b.ide_gest and a.flg_cptab = b.flg_cptab and a.ide_jal = b.ide_jal and a.ide_ecr = b.ide_ecr
;