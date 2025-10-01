Select NVL(Sum(Nvl(Opp_Montant_Principal,0) + Nvl(Opp_Montant_Penalite,0)),0)Montant
    From (Select Opp_Num, Opp_Montant_Principal, Opp_Montant_Penalite
            From Cut_Opposition@lkcut  
           Where Pc_Code     =  '511'
             And Opp_Statut  <> 'A'
             And Opp_Rgl_Num In (Select Mer_Rgl_Num
                                   From Cut_Reglement@lkcut
                                  Where Pc_Code    = '511'
                                    And To_Date(Rgl_Dte_Reglement,'DD/MM/RRRR') Between to_Date('01/01/2025','DD/MM/RRRR') And To_Date('05/09/2025','DD/MM/RRRR')
                                    And (rgl_mrg_code='02' and Rgl_Statut In ('V','P','R') or rgl_mrg_code='01' and Rgl_Statut In ('V','S'))
                                 Union
                                 Select Mer_Rgl_Num
                                   From Cut_Reglement@lkcut
                                  Where Pc_Code    = '511'
                                    And Rgl_Montant_Net = 0
                                    And To_Date(Rgl_Dte_Reglement,'DD/MM/RRRR') Between to_Date('01/01/2025','DD/MM/RRRR') And To_Date('05/09/2025','DD/MM/RRRR')
                                    And rgl_mrg_code  ='02'
                                    And Rgl_Statut    = 'S'                                 
                                )
          Union
          Select Opp_Num, Opp_Montant_Principal, Opp_Montant_Penalite
            From Cut_Opposition@lkcut  
           Where Pc_Code     =  '511'
             And Opp_Statut  <> 'A'
             And To_Date(Opp_Dte_Reglement,'DD/MM/RRRR') Between to_Date('01/01/2025','DD/MM/RRRR') And To_Date('05/09/2025','DD/MM/RRRR')
             And Opp_Rgl_Num In (Select Rgl_Num
                                   From Cut_Pre_Reglement@lkcut
                                  Where Pc_Code    = '511'
                                    --And Rgl_Statut = 'A'
                                    And Rgl_Num In (Select Rgl_Rgl_Num
                                                      From Cut_Pre_Reglement@lkcut
                                                     Where Pc_Code    = '511'
                                                       And Rgl_Num In (Select Mer_Rgl_Num
                                                                         From Cut_Reglement@lkcut
                                                                        Where Pc_Code    = '511'
                                                                          And Rgl_Statut In ('V','P','R')
                                                                          And To_Date(Rgl_Dte_Reglement,'DD/MM/RRRR') Between to_Date('01/01/2025','DD/MM/RRRR') And To_Date('05/09/2025','DD/MM/RRRR')
                                                                      )
                                                   )
                                )
          Union all
          Select Opp_Num, Opp_Montant_Principal, Opp_Montant_Penalite
          From Cut_Opposition@lkcut
           Where     Pc_Code = '511'
             And To_Date (Opp_Dte_Reglement, 'dd/mm/rrrr') Between to_Date('01/01/2025','DD/MM/RRRR') And To_Date('05/09/2025','DD/MM/RRRR')
             And Opp_Statut in ('S','V','P')
             And Opp_Rgl_Num  In (Select Rgl_Num From Cut_Pre_Reglement@lkcut Where Pc_Code = '511' And Rgl_Montant_Net=0 And Rgl_Statut In ('S','V','E','R'))
             And Opp_Rgl_Num Not In (Select Rgl_Num
                                   From Cut_Pre_Reglement@lkcut
                                  Where Pc_Code    = '511'
                                    --And Rgl_Statut = 'A'
                                    And Rgl_Num In (Select Rgl_Rgl_Num
                                                      From Cut_Pre_Reglement@lkcut
                                                     Where Pc_Code    = '511'
                                                       And Rgl_Num In (Select Mer_Rgl_Num
                                                                         From Cut_Reglement@lkcut
                                                                        Where Pc_Code    = '511'
                                                                          And Rgl_Statut In ('V','P','R')
                                                                          And To_Date(Rgl_Dte_Reglement,'DD/MM/RRRR') Between to_Date('01/01/2025','DD/MM/RRRR') And To_Date('05/09/2025','DD/MM/RRRR')
                                                                      )
                                                   )
                                )
          Union all      
          Select Rgl_Num Opp_Num, Rgl_Montant_Net Opp_Montant_Principal, 0 Opp_Montant_Penalite
            From Cut_Reglt_Restor_Juil_Aout_24@lkcut
           Where Pc_Code       = '511'
             And To_Date(Rgl_Dte_Reglement,'DD/MM/RRRR') Between to_Date('01/01/2025','DD/MM/RRRR') And To_Date('05/09/2025','DD/MM/RRRR')
             And Rgl_Statut    = 'V'
             And Rgl_Mrg_Code  = '02'
             And Rgl_Ret_Type  = 'ATD'
       )
       ;
       
       
       Select  '8' ORDRE ,'VIREMENT' GROUPE,'ASTERWEB' TYPE, 'ATD Princ Penalites' RUBRIQUE,Nvl(Sum (Mt),0)MONTANT
    From Fc_Ligne@lkastweb 
   Where (Ide_Poste,Ide_Gest,Ide_Jal,Flg_Cptab,Ide_Ecr) In 
         (
              Select Ide_Poste,Ide_Gest,Ide_Jal,Flg_Cptab,Ide_Ecr 
                From Fc_Ecriture@lkastweb 
              Where
     (Flg_Emis_Recu,Cod_Typ_Nd,Ide_Nd_Emet,Ide_Mess) In 
                    (
                    Select Flg_Emis_Recu,Cod_Typ_Nd,Ide_Nd_Emet,Ide_Mess 
                      From Fm_Message@lkastweb 
                      Where Cod_Typ_Mess = 24 And Ide_Gest='2025'
                       And Libl  Like 'CUT-PAIEMENT EFFECTIF DU%'
                       And To_Date(Substr(Libl,Length(Libl)-9,10),'DD/MM/RRRR') Between to_Date('01/01/2025','DD/MM/RRRR') And To_Date('05/09/2025','DD/MM/RRRR')
                       And Ide_Nd_Emet = '511'
                    )  
         ) 
     And (Ide_Cpt ='39051'  And ide_poste Not Like '5%'  Or Ide_Cpt='391311' And ide_poste Like '5%')
     And Observ Like 'ATD%'
     And Cod_Sens = 'C'
     ;
       
       -----------------------------------
       
       
Select unique Opp_Num, Opp_Montant_Principal, Opp_Montant_Penalite
            From Cut_Opposition@lkcut  
           Where Pc_Code     =  '511'
             And Opp_Statut  <> 'A'
             And Opp_Rgl_Num In (Select Mer_Rgl_Num
                                   From Cut_Reglement@lkcut
                                  Where Pc_Code    = '511'
                                    And To_Date(Rgl_Dte_Reglement,'DD/MM/RRRR') Between to_Date('01/01/2025','DD/MM/RRRR') And To_Date('05/09/2025','DD/MM/RRRR')
                                    And (rgl_mrg_code='02' and Rgl_Statut In ('V','P','R') or rgl_mrg_code='01' and Rgl_Statut In ('V','S'))
                                 Union
                                 Select Mer_Rgl_Num
                                   From Cut_Reglement@lkcut
                                  Where Pc_Code    = '511'
                                    And Rgl_Montant_Net = 0
                                    And To_Date(Rgl_Dte_Reglement,'DD/MM/RRRR') Between to_Date('01/01/2025','DD/MM/RRRR') And To_Date('05/09/2025','DD/MM/RRRR')
                                    And rgl_mrg_code  ='02'
                                    And Rgl_Statut    = 'S'                                 
                                )
          Union
          Select unique Opp_Num, Opp_Montant_Principal, Opp_Montant_Penalite
            From Cut_Opposition@lkcut  
           Where Pc_Code     =  '511'
             And Opp_Statut  <> 'A'
             And To_Date(Opp_Dte_Reglement,'DD/MM/RRRR') Between to_Date('01/01/2025','DD/MM/RRRR') And To_Date('05/09/2025','DD/MM/RRRR')
             And Opp_Rgl_Num In (Select Rgl_Num
                                   From Cut_Pre_Reglement@lkcut
                                  Where Pc_Code    = '511'
                                    --And Rgl_Statut = 'A'
                                    And Rgl_Num In (Select Rgl_Rgl_Num
                                                      From Cut_Pre_Reglement@lkcut
                                                     Where Pc_Code    = '511'
                                                       And Rgl_Num In (Select Mer_Rgl_Num
                                                                         From Cut_Reglement@lkcut
                                                                        Where Pc_Code    = '511'
                                                                          And Rgl_Statut In ('V','P','R')
                                                                          And To_Date(Rgl_Dte_Reglement,'DD/MM/RRRR') Between to_Date('01/01/2025','DD/MM/RRRR') And To_Date('05/09/2025','DD/MM/RRRR')
                                                                      )
                                                   )
                                )
          Union all
          Select unique Opp_Num, Opp_Montant_Principal, Opp_Montant_Penalite
          From Cut_Opposition@lkcut
           Where     Pc_Code = '511'
             And To_Date (Opp_Dte_Reglement, 'dd/mm/rrrr') Between to_Date('01/01/2025','DD/MM/RRRR') And To_Date('05/09/2025','DD/MM/RRRR')
             And Opp_Statut in ('S','V','P')
             And Opp_Rgl_Num  In (Select Rgl_Num From Cut_Pre_Reglement@lkcut Where Pc_Code = '511' And Rgl_Montant_Net=0 And Rgl_Statut In ('S','V','E','R'))
             And Opp_Rgl_Num Not In (Select Rgl_Num
                                   From Cut_Pre_Reglement@lkcut
                                  Where Pc_Code    = '511'
                                    --And Rgl_Statut = 'A'
                                    And Rgl_Num In (Select Rgl_Rgl_Num
                                                      From Cut_Pre_Reglement@lkcut
                                                     Where Pc_Code    = '511'
                                                       And Rgl_Num In (Select Mer_Rgl_Num
                                                                         From Cut_Reglement@lkcut
                                                                        Where Pc_Code    = '511'
                                                                          And Rgl_Statut In ('V','P','R')
                                                                          And To_Date(Rgl_Dte_Reglement,'DD/MM/RRRR') Between to_Date('01/01/2025','DD/MM/RRRR') And To_Date('05/09/2025','DD/MM/RRRR')
                                                                      )
                                                   )
                                )
          Union all      
          Select Rgl_Num Opp_Num, Rgl_Montant_Net Opp_Montant_Principal, 0 Opp_Montant_Penalite
            From Cut_Reglt_Restor_Juil_Aout_24@lkcut
           Where Pc_Code       = '511'
             And To_Date(Rgl_Dte_Reglement,'DD/MM/RRRR') Between to_Date('01/01/2025','DD/MM/RRRR') And To_Date('05/09/2025','DD/MM/RRRR')
             And Rgl_Statut    = 'V'
             And Rgl_Mrg_Code  = '02'
             And Rgl_Ret_Type  = 'ATD'
             order by opp_num;
             
 Select  b.ide_piece, a.mt, a.mt
    From Fc_Ligne@lkastweb a, fc_ecriture@lkastweb b
   Where a.ide_poste = b.ide_poste
   and a.ide_gest = b.ide_gest
   and a.ide_jal = b.ide_jal
   and a.flg_cptab = b.flg_cptab
   and a.ide_ecr = b.ide_ecr
   and (b.Flg_Emis_Recu,b.Cod_Typ_Nd,b.Ide_Nd_Emet,b.Ide_Mess) in
   (
   Select Flg_Emis_Recu,Cod_Typ_Nd,Ide_Nd_Emet,Ide_Mess 
                      From Fm_Message@lkastweb 
                      Where Cod_Typ_Mess = 24 And Ide_Gest='2025'
                       And Libl  Like 'CUT-PAIEMENT EFFECTIF DU%'
                       And To_Date(Substr(Libl,Length(Libl)-9,10),'DD/MM/RRRR') Between to_Date('01/01/2025','DD/MM/RRRR') And To_Date('05/09/2025','DD/MM/RRRR')
                       And Ide_Nd_Emet = '511'
   )

     And (Ide_Cpt ='39051'  And a.ide_poste Not Like '5%'  Or Ide_Cpt='391311' And a.ide_poste Like '5%')
     And Observ Like 'ATD%'
     And Cod_Sens = 'C'
     order by ide_piece
     ;