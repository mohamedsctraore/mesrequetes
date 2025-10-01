Select distinct Pc_Code,
                Str_Code,
                Nat_Dep_Code,
                Rgl_Type_Budg,
                Rgl_Num,
                Rgl_Banque,
                Rgl_Regul_Num,
                Ref_Pce_Code,
                Rgl_Mdt_Num,
                Rgl_Type_Reglt,
                Rgl_Dte_Reglement,
                decode(rgl_type_reglt,'OV',star_msg_montant,Rgl_Montant_Net) Rgl_Montant_Net,
                Rgl_Matricule || '-' || Rgl_Benef_Nom,
                Rgl_Objet || '-' || Rgl_Num_Cpt V_Benef
           From Cut_reglement@LKCUT,Cut_Star_Message@LKCUT
          Where Pc_Code = Pc$Pc_Code
                --And To_Date(Rgl_Dte_Reglement,'dd/mm/rrrr') = To_Date(Pc$Journee,'dd/mm/rrrr')
                And (Rgl_Statut = 'R' and rgl_type_reglt <> 'OV' or Rgl_Statut = 'P' and rgl_type_reglt = 'OV')
                And Rgl_Mrg_Code = '02' and Star_Msg_Type = 'MT202' and (rgl_num = Star_Msg_Ref or Bord_Rgl_Num = Star_Msg_Ref)
                And (Rgl_Num In (Select Star_Msg_Ref
                                  From Cut_Star_Message@LKCUT
                                 Where To_Date (cut.Cut_Fb_Rej_Dte@LKCUT (Star_Msg_Mdte),'dd/mm/rrrr') = To_Date (Pc$Journee, 'dd/mm/rrrr')
                                   And Star_Msg_Type = 'MT202'
                                )
                      or
                     Bord_Rgl_Num In (Select Star_Msg_Ref
                                  From Cut_Star_Message@LKCUT
                                 Where To_Date (cut.Cut_Fb_Rej_Dte@LKCUT (Star_Msg_Mdte),'dd/mm/rrrr') = To_Date (Pc$Journee, 'dd/mm/rrrr')
                                   And Star_Msg_Type = 'MT202' and substr(Star_Msg_Ref,1,2) = 'CI'
                                )
                    ) 
                And (Pc_Code, Rgl_Num) In
                       ((Select Pc_Code, Rgl_Num
                          From Cut_reglement@LKCUT
                         Where     Pc_Code = Pc$Pc_Code --Pc$Pc_Code
                               --And To_Date(Rgl_Dte_Reglement,'dd/mm/rrrr') = To_Date(Pc$Journee,'dd/mm/rrrr')
                               And Rgl_Statut = 'R' and rgl_type_reglt <> 'OV'
                               And Rgl_Mrg_Code = '02'
                               And Rgl_Num In
                                      (Select Star_Msg_Ref
                                         From Cut_Star_Message@LKCUT
                                        Where     To_Date (
                                                     Cut_fb_Rej_Dte@LKCUT (
                                                        Star_Msg_Mdte),
                                                     'dd/mm/rrrr') =
                                                     To_Date (Pc$Journee, --Pc$Journee,
                                                              'dd/mm/rrrr')
                                              And Star_Msg_Type = 'MT202')
                           union
                           Select Pc_Code, Rgl_Num
                          From Cut_reglement@LKCUT
                         Where     Pc_Code = Pc$Pc_Code --Pc$Pc_Code
                               --And To_Date(Rgl_Dte_Reglement,'dd/mm/rrrr') = To_Date(Pc$Journee,'dd/mm/rrrr')
                               And Rgl_Statut = 'P' and rgl_type_reglt = 'OV'
                               And Rgl_Mrg_Code = '02'
                               And (Rgl_Num In
                                      (Select Star_Msg_Ref
                                         From Cut_Star_Message@LKCUT
                                        Where     To_Date (
                                                     Cut_fb_Rej_Dte@LKCUT (
                                                        Star_Msg_Mdte),
                                                     'dd/mm/rrrr') =
                                                     To_Date (Pc$Journee, --Pc$Journee,
                                                              'dd/mm/rrrr')
                                              And Star_Msg_Type = 'MT202')
                                      
                                      or Bord_Rgl_Num IN (Select Star_Msg_Ref
                                         From Cut_Star_Message@LKCUT
                                        Where     To_Date (
                                                     Cut_fb_Rej_Dte@LKCUT (
                                                        Star_Msg_Mdte),
                                                     'dd/mm/rrrr') =
                                                     To_Date (Pc$Journee, --Pc$Journee,
                                                              'dd/mm/rrrr')
                                              And Star_Msg_Type = 'MT202')
                                      )
                            union
                           Select Pc_Code, Rgl_Num
                          From Cut_reglement@LKCUT
                         Where     Pc_Code = Pc$Pc_Code --'503'
                               --And To_Date(Rgl_Dte_Reglement,'dd/mm/rrrr') = To_Date('30/08/2024','dd/mm/rrrr')
                               And Rgl_Statut = 'P' and rgl_type_reglt = 'OV'
                               And Rgl_Mrg_Code = '02'
                               And Bord_Rgl_Num In
                                      (Select Star_Msg_Ref
                                         From Cut_Star_Message@LKCUT
                                        Where     To_Date (
                                                     Cut_fb_Rej_Dte@LKCUT (
                                                        Star_Msg_Mdte),
                                                     'dd/mm/rrrr') =
                                                     To_Date (Pc$Journee, --'30/08/2024',
                                                              'dd/mm/rrrr')
                                              And Star_Msg_Type = 'MT202' and substr(Star_Msg_Ref,1,2) = 'CI')
                          )
                        Minus
                        Select A.Ide_Poste, A.Ide_Piece
                          From Fc_ecriture@lkastweb A, Fc_Ligne@lkastweb B
                         Where     (A.Ide_Poste,
                                    A.Ide_Gest,
                                    A.Ide_Jal,
                                    A.Flg_Cptab,
                                    A.Ide_Ecr) In
                                      (Select Ide_Poste,
                                              Ide_Gest,
                                              Ide_Jal,
                                              Flg_Cptab,
                                              Ide_Ecr
                                         From Fc_ecriture@lkastweb
                                        Where (Ide_Poste,
                                               Ide_Gest,
                                               Ide_Jal,
                                               Flg_Cptab,
                                               Ide_Ecr) In
                                                 (Select Ide_Poste,
                                                         Ide_Gest,
                                                         Ide_Jal,
                                                         Flg_Cptab,
                                                         Ide_Ecr
                                                    From Fc_ecriture@lkastweb
                                                   Where (Flg_Emis_Recu,
                                                          Cod_Typ_Nd,
                                                          Ide_Nd_Emet,
                                                          Ide_Mess) In
                                                            (Select Flg_Emis_Recu,
                                                                    Cod_Typ_Nd,
                                                                    Ide_Nd_Emet,
                                                                    Ide_Mess
                                                               From fm_message@lkastweb
                                                              Where     Cod_Typ_Mess =
                                                                           24
                                                                    And Libl Like
                                                                           'CUT%REJET%DU%'
                                                                    And Ide_Nd_Emet =
                                                                           Pc$Pc_Code --Pc$Pc_Code
                                                                    And Substr (
                                                                           Libl,
                                                                             Length (
                                                                                Libl)
                                                                           - 9,
                                                                           10) =
                                                                           To_Char (
                                                                              To_Date (
                                                                                 Pc$Journee,
                                                                                 'dd/mm/rrrr')))))
                               And Substr (Ide_Cpt, 1, 2) = '57'
                               And A.Ide_Poste = B.Ide_Poste
                               And A.Ide_Gest = B.Ide_Gest
                               And A.Ide_Jal = B.Ide_Jal
                               And A.Flg_Cptab = B.Flg_Cptab
                               And A.Ide_Ecr = B.Ide_Ecr) 
   ;