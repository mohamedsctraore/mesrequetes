CREATE OR REPLACE Procedure NIABA.Cut_Pb_Ctrl_Coherence_Aster2(Pc$Pc_Code             Varchar2
                                                            ,Pc$Gestion             Varchar2
                                                            ,Pc$Date_Deb            DATE
                                                            ,Pc$Date_Fin            DATE  
                                                            ,sortie OUT SYS_REFCURSOR
                                                             ) Is
BEGIN
    Execute Immediate 'alter session set nls_date_format = ''DD/MM/RRRR''';
                                                            
    open sortie for
    Select 'SyGACUT_Paie_Num' rubrique,  NVL(Sum(Rgl_Montant_Net),0) Pc$SyGACUT_Paie_Num
        --From (Select NVL(Sum(Rgl_Montant_Net),0) Rgl_Montant_Net
                From CUT.Cut_Reglement@lkcut
               Where Pc_Code      = Pc$Pc_Code
                 And To_Date(Rgl_Dte_Reglement,'DD/MM/RRRR') Between To_Date(Pc$Date_Deb,'DD/MM/RRRR') And To_Date(Pc$Date_Fin,'DD/MM/RRRR')
                 And Rgl_Statut   In ('V','S') 
                 And (Rgl_Code_Op Not Like '%sor Pay%' Or Rgl_Code_Op Is Null)
                 And Rgl_Mrg_Code = '01'
     --        )
      union
      
      Select 'SyGACUT_TresorPay_Paie', Nvl(Sum(Rgl_Montant_Net),0)  Pc$TresorPay_Paie
        From CUT.Cut_Reglement@lkcut
       Where Pc_Code      = Pc$Pc_Code
         And To_Date(Rgl_Dte_Reglement,'DD/MM/RRRR') Between To_Date(Pc$Date_Deb,'DD/MM/RRRR') And To_Date(Pc$Date_Fin,'DD/MM/RRRR')
         And Rgl_Statut   In ('V','S') 
         And Rgl_Code_Op  Like '%@Actualisation%'
         And Rgl_Code_Op  Like '%sor Pay%'
         And Rgl_Mrg_Code = '01'
      union
      
      Select 'SyGACUT_Paie_Vir', NVL(Sum(Rgl_Montant_Net),0)  Pc$SyGACUT_Paie_Vir
        From (
              Select Sum(Rgl_Montant_Net) Rgl_Montant_Net
                From Cut_Reglement@lkcut
               Where Pc_Code       = Pc$Pc_Code
                 And To_Date(Rgl_Dte_Reglement,'DD/MM/RRRR') Between To_Date(Pc$Date_Deb,'DD/MM/RRRR') And To_Date(Pc$Date_Fin,'DD/MM/RRRR')
                 And (Rgl_Statut    In ('V','P') or Rgl_Statut = 'R' and rgl_rout_statut='R')
                 And Rgl_Mrg_Code  = '02'
                 And Rgl_Regul_Num Is Null
              Union All
              Select Sum(Rgl_Montant_Net) Rgl_Montant_Net
                From Cut_Reglt_Restor_Juil_Aout_24@lkcut
               Where Pc_Code       = Pc$Pc_Code
                 And To_Date(Rgl_Dte_Reglement,'DD/MM/RRRR') Between To_Date(Pc$Date_Deb,'DD/MM/RRRR') And To_Date(Pc$Date_Fin,'DD/MM/RRRR')
                 And Rgl_Statut    = 'P'
                 And Rgl_Mrg_Code  = '02'
                 And Rgl_Ret_Type  = 'PAI'
                 And Rgl_Regul_Num Is Null
      )
      union
      
      Select 'SyGACUT_Regul_Rejet', NVL(Sum(Rgl_Montant_Net),0)  Pc$SyGACUT_Regul_Rejet
        From (
              Select Sum(Rgl_Montant_Net) Rgl_Montant_Net -- Lc$Flux_Crediteur
                From Cut_Reglement@lkcut
               Where Pc_Code       = Pc$Pc_Code
                 And To_Date(Rgl_Dte_Reglement,'DD/MM/RRRR') Between To_Date(Pc$Date_Deb,'DD/MM/RRRR') And To_Date(Pc$Date_Fin,'DD/MM/RRRR')
                 And (Rgl_Statut   In ('V','P') or Rgl_Statut = 'R' and rgl_rout_statut='R')
                 And Rgl_Mrg_Code  ='02' 
                 And Rgl_Regul_Num Is Not Null 
              Union All
              Select Sum(Rgl_Montant_Net) Rgl_Montant_Net
                From Cut_Reglt_Restor_Juil_Aout_24@lkcut
               Where Pc_Code       = Pc$Pc_Code
                 And To_Date(Rgl_Dte_Reglement,'DD/MM/RRRR') Between To_Date(Pc$Date_Deb,'DD/MM/RRRR') And To_Date(Pc$Date_Fin,'DD/MM/RRRR')
                 And Rgl_Statut    = 'P'
                 And Rgl_Mrg_Code  = '02'
                 And Rgl_Ret_Type  = 'PAI'
                 And Rgl_Regul_Num Is Not Null
      )
      union
      
      Select 'SyGACut_Retenue', NVL(Sum(Ret_Montant),0)  Pc$SyGACut_Retenue
        From (Select Ret_Montant
                From Cut_Retenue@lkcut 
               Where Pc_Code     =  Pc$Pc_Code 
                 And To_Date(Ret_Dte_Reglement,'DD/MM/RRRR') Between To_Date(Pc$Date_Deb,'DD/MM/RRRR') And To_Date(Pc$Date_Fin,'DD/MM/RRRR')
                 And Ret_Statut  = 'P' 
                 And (Bord_Rgl_Num Not Like '%@Actualisation%' Or Bord_Rgl_Num Is Null)
              Union All
              Select Rgl_Montant_Net Ret_Montant
                From Cut_Reglt_Restor_Juil_Aout_24@lkcut
               Where Pc_Code       = Pc$Pc_Code
                 And To_Date(Rgl_Dte_Reglement,'DD/MM/RRRR') Between To_Date(Pc$Date_Deb,'DD/MM/RRRR') And To_Date(Pc$Date_Fin,'DD/MM/RRRR')
                 And Rgl_Statut    = 'V'
                 And Rgl_Mrg_Code  = '02'
                 And Rgl_Ret_Type  = 'RET' 
             )
      union
      
      Select 'SyGACUT_Princ_Pen', NVL(Sum(Nvl(Opp_Montant_Principal,0) + Nvl(Opp_Montant_Penalite,0)),0)  Pc$SyGACUT_Princ_Pen
        From (Select Opp_Num, Opp_Montant_Principal, Opp_Montant_Penalite
                From Cut_Opposition@lkcut
               Where Pc_Code     =  Pc$Pc_Code 
                 And Opp_Statut  <> 'A'
                 And Opp_Rgl_Num In (Select Mer_Rgl_Num 
                                       From Cut_Reglement@lkcut 
                                      Where Pc_Code    = Pc$Pc_Code 
                                        And To_Date(Rgl_Dte_Reglement,'DD/MM/RRRR') Between To_Date(Pc$Date_Deb,'DD/MM/RRRR') And To_Date(Pc$Date_Fin,'DD/MM/RRRR') 
                                        And (rgl_mrg_code='02' and Rgl_Statut In ('V','P','R') or rgl_mrg_code='01' and Rgl_Statut In ('V','S'))
                                     Union 
                                     Select Mer_Rgl_Num 
                                       From Cut_Reglement@lkcut 
                                      Where Pc_Code    = Pc$Pc_Code 
                                        And Rgl_Montant_Net = 0
                                        And To_Date(Rgl_Dte_Reglement,'DD/MM/RRRR') Between To_Date(Pc$Date_Deb,'DD/MM/RRRR') And To_Date(Pc$Date_Fin,'DD/MM/RRRR') 
                                        And rgl_mrg_code  ='02' 
                                        And Rgl_Statut    = 'S'                                 
                                    ) 
              Union
              Select Opp_Num, Opp_Montant_Principal, Opp_Montant_Penalite --*
                From Cut_Opposition@lkcut  
               Where Pc_Code     =  Pc$Pc_Code 
                 And Opp_Statut  <> 'A'
                 And To_Date(Opp_Dte_Reglement,'DD/MM/RRRR') Between To_Date(Pc$Date_Deb,'DD/MM/RRRR') And To_Date(Pc$Date_Fin,'DD/MM/RRRR') 
                 And Opp_Rgl_Num In (Select Rgl_Num 
                                       From Cut_Pre_Reglement@lkcut 
                                      Where Pc_Code    = Pc$Pc_Code 
                                        And Rgl_Num In (Select Rgl_Rgl_Num 
                                                          From Cut_Pre_Reglement@lkcut
                                                         Where Pc_Code    = Pc$Pc_Code 
                                                           And Rgl_Num In (Select Mer_Rgl_Num 
                                                                             From Cut_Reglement@lkcut 
                                                                            Where Pc_Code    = Pc$Pc_Code 
                                                                              And Rgl_Statut In ('V','P','R')
                                                                              And To_Date(Rgl_Dte_Reglement,'DD/MM/RRRR') Between To_Date(Pc$Date_Deb,'DD/MM/RRRR') And To_Date(Pc$Date_Fin,'DD/MM/RRRR') 
                                                                          )
                                                       )
                                    ) 
              Union
              Select Opp_Num, Opp_Montant_Principal, Opp_Montant_Penalite
              From Cut_Opposition@lkcut
               Where     Pc_Code = Pc$Pc_Code
                 And To_Date (Opp_Dte_Reglement, 'dd/mm/rrrr') Between To_Date(Pc$Date_Deb,'DD/MM/RRRR') And To_Date(Pc$Date_Fin,'DD/MM/RRRR') 
                 And Opp_Statut in ('S','V','P')
                 And Opp_Rgl_Num  In (Select Rgl_Num From Cut_Pre_Reglement@lkcut Where Pc_Code = Pc$Pc_Code  And Rgl_Montant_Net=0 And Rgl_Statut In ('S','V','E','R'))
              Union       
              Select Rgl_Num Opp_Num, Rgl_Montant_Net Opp_Montant_Principal, 0 Opp_Montant_Penalite
                From Cut_Reglt_Restor_Juil_Aout_24@lkcut
               Where Pc_Code       = Pc$Pc_Code
                 And To_Date(Rgl_Dte_Reglement,'DD/MM/RRRR') Between To_Date(Pc$Date_Deb,'DD/MM/RRRR') And To_Date(Pc$Date_Fin,'DD/MM/RRRR')
                 And Rgl_Statut    = 'V'
                 And Rgl_Mrg_Code  = '02'
                 And Rgl_Ret_Type  = 'ATD'
           )
      union
      
      Select 'SyGACUT_Tse', NVL(Sum(Opp_Montant_Tse),0)  Pc$SyGACUT_Tse
        From (Select *
                From Cut_Opposition@lkcut
               Where Pc_Code     =  Pc$Pc_Code 
                 And Opp_Statut  <> 'A'
                 And Opp_Rgl_Num In (Select Mer_Rgl_Num 
                                       From Cut_Reglement@lkcut 
                                      Where Pc_Code    = Pc$Pc_Code 
                                        And To_Date(Rgl_Dte_Reglement,'DD/MM/RRRR') Between To_Date(Pc$Date_Deb,'DD/MM/RRRR') And To_Date(Pc$Date_Fin,'DD/MM/RRRR') 
                                        And Rgl_Statut In ('V','P','R')
                                    ) 
              Union
              Select *
                From Cut_Opposition@lkcut
               Where Pc_Code =  Pc$Pc_Code 
                 And Opp_Statut <> 'A'
                 And To_Date(Opp_Dte_Reglement,'DD/MM/RRRR') Between To_Date(Pc$Date_Deb,'DD/MM/RRRR') And To_Date(Pc$Date_Fin,'DD/MM/RRRR') 
                 And Opp_Rgl_Num In (Select Rgl_Num 
                                       From Cut_Pre_Reglement@lkcut 
                                      Where Pc_Code    = Pc$Pc_Code 
                                        And Rgl_Num In (Select Rgl_Rgl_Num 
                                                          From Cut_Pre_Reglement@lkcut
                                                         Where Pc_Code    = Pc$Pc_Code 
                                                           And Rgl_Num In (Select Mer_Rgl_Num 
                                                                             From Cut_Reglement@lkcut 
                                                                            Where Pc_Code    = Pc$Pc_Code 
                                                                              And Rgl_Statut In ('V','P','R')
                                                                              And To_Date(Rgl_Dte_Reglement,'DD/MM/RRRR') Between To_Date(Pc$Date_Deb,'DD/MM/RRRR') And To_Date(Pc$Date_Fin,'DD/MM/RRRR') 
                                                                          )
                                                       )
                                    ) 
             )
      union
      
      Select 'SyGACUT_Dep_Fds', NVL(Sum(Chq_Montant),0)  Pc$SyGACUT_Dep_Fds
       From Cut_Cheque_Tresor@lkcut 
      Where Chq_Pc_Code = Pc$Pc_Code 
        And To_Date(Chq_Dte_Confirm,'DD/MM/RRRR') Between To_Date(Pc$Date_Deb,'DD/MM/RRRR') And To_Date(Pc$Date_Fin,'DD/MM/RRRR')
        And Chq_Statut  In ('P')
      union
      
      Select 'SyGACUT_Retour_Fds', NVL(Sum(Rgl_Montant_Net),0)   Pc$SyGACUT_Retour_Fds
        From (Select Sum(Rgl_Montant_Net) Rgl_Montant_Net
                From Cut_Reglement@lkcut
               Where Pc_Code  = Pc$Pc_Code 
                 And Rgl_Statut = 'R'
                 and rgl_rout_statut ='R'
                 And Rgl_Num In (Select Distinct Star_Msg_Ref 
                                   From Cut_Star_Message@lkcut
                                  Where Star_Msg_Type = 'MT202'  
                                    And To_Date(Star_Msg_Mdte,'DD/MM/RRRR') Between To_Date(Pc$Date_Deb,'DD/MM/RRRR') And To_Date(Pc$Date_Fin,'DD/MM/RRRR')
                                 )
              Union All
              Select Sum(Star_Msg_Montant) Rgl_Montant_Net
                From (Select Distinct Star_Msg_Ref, Star_Msg_Montant 
                        From Cut_Star_Message@lkcut
                       Where Star_Msg_Type = 'MT202'  
                         And To_Date(Star_Msg_Mdte,'DD/MM/RRRR') Between To_Date(Pc$Date_Deb,'DD/MM/RRRR') And To_Date(Pc$Date_Fin,'DD/MM/RRRR')
                         And Star_Msg_Ref In (Select Rgl_Num 
                                                From Cut_Reglement@lkcut
                                               Where Pc_Code  = Pc$Pc_Code 
                                                 And Rgl_Statut In ('P')
                                                 And Rgl_rout_statut='R' and Rgl_type_reglt='OV'
                                             )
                 )
         )
      union
        
      Select 'SyGACUT_Nivel', NVL(Sum(Niv_Montant),0)  Pc$SyGACUT_Nivel
       From Cut_Nivellement@lkcut 
      Where Pc_Code = Pc$Pc_Code 
        And To_Date(Niv_Dte_Transfert,'DD/MM/RRRR') Between To_Date(Pc$Date_Deb,'DD/MM/RRRR') And To_Date(Pc$Date_Fin,'DD/MM/RRRR')
        And Niv_Statut  In ('V')
      union  
      
      --================= ASTER ================-
       
       Select 'Aster_Paie_Num',  NVL(Sum (Mt),0)  Pc$Aster_Paie_Num
        From Fc_Ligne@lkastweb 
       Where (Ide_Poste,Ide_Gest,Ide_Jal,Flg_Cptab,Ide_Ecr) In 
             (
                      Select Ide_Poste,Ide_Gest,Ide_Jal,Flg_Cptab,Ide_Ecr 
                        From Fc_Ecriture@lkastweb 
                       Where (Flg_Emis_Recu,Cod_Typ_Nd,Ide_Nd_Emet,Ide_Mess) In 
                             (
                              Select Flg_Emis_Recu,Cod_Typ_Nd,Ide_Nd_Emet,Ide_Mess 
                                From Fm_Message@lkastweb 
                               Where Cod_Typ_Mess = 24 and ide_gest=Pc$Gestion
                                 And Libl Like 'CUT%PAIEMENT%NUMERAIRE%DU%'
                                 And To_Date(Substr(Libl,Length(Libl)-9,10),'DD/MM/RRRR') Between To_Date(Pc$Date_Deb,'DD/MM/RRRR') And To_Date(Pc$Date_Fin,'DD/MM/RRRR')
                                 And Ide_Nd_Emet = Pc$Pc_Code
                             ) 
              --       )
             )
         And Cod_Sens='C'
      union

      -- Paiement Virement
        Select 'Aster_Paie_Vir', NVL(Sum (Mt),0)  Pc$Aster_Paie_Vir
        From Fc_Ligne@lkastweb 
        Where (Ide_Poste,Ide_Gest,Ide_Jal,Flg_Cptab,Ide_Ecr) In 
            (
                  Select Ide_Poste,Ide_Gest,Ide_Jal,Flg_Cptab,Ide_Ecr 
                    From Fc_Ecriture@lkastweb 
                   Where (Flg_Emis_Recu,Cod_Typ_Nd,Ide_Nd_Emet,Ide_Mess) In 
                         (
                          Select Flg_Emis_Recu,Cod_Typ_Nd,Ide_Nd_Emet,Ide_Mess 
                            From Fm_Message@lkastweb 
                           Where Cod_Typ_Mess = 24 and ide_gest=Pc$Gestion
                             And Libl  Like 'CUT%' And substr(Libl,1,9)  <> 'CUT-REGUL'
                             And  To_Date(Substr(Libl,Length(Libl)-9,10),'DD/MM/RRRR') Between To_Date(Pc$Date_Deb,'DD/MM/RRRR') And To_Date(Pc$Date_Fin,'DD/MM/RRRR')
                             And Ide_Nd_Emet = Pc$Pc_Code 
                         )
         ) 
         And Substr(Ide_Cpt,1,2) = '57'
         And Cod_Sens = 'C'
        union
      
        Select 'Aster_Paie_Vir', NVL(Sum (Mt),0)  Pc$Aster_Paie_Vir
        From Fc_Ligne@lkastweb 
       Where (Ide_Poste,Ide_Gest,Ide_Jal,Flg_Cptab,Ide_Ecr) In 
            (
                  Select Ide_Poste,Ide_Gest,Ide_Jal,Flg_Cptab,Ide_Ecr 
                    From Fc_Ecriture@lkastweb 
                   Where (Flg_Emis_Recu,Cod_Typ_Nd,Ide_Nd_Emet,Ide_Mess) In 
                         (
                          Select Flg_Emis_Recu,Cod_Typ_Nd,Ide_Nd_Emet,Ide_Mess 
                            From Fm_Message@lkastweb 
                           Where Cod_Typ_Mess = 24 and ide_gest=Pc$Gestion
                             And Libl  Like 'CUT%PAIEMENT%DU%'
                             And  To_Date(Substr(Libl,Length(Libl)-9,10),'DD/MM/RRRR') Between To_Date(Pc$Date_Deb,'DD/MM/RRRR') And To_Date(Pc$Date_Fin,'DD/MM/RRRR')
                             And Ide_Nd_Emet = Pc$Pc_Code 
                         )
         ) 
         And Substr(Ide_Cpt,1,2) = '57'
         And Cod_Sens = 'C'
        union
      
      -- Regul de Rejet
      Select 'Aster_Regul_Rejet', NVL(Sum (Mt),0)  Pc$Aster_Regul_Rejet
        From Fc_Ligne@lkastweb 
       Where (Ide_Poste,Ide_Gest,Ide_Jal,Flg_Cptab,Ide_Ecr) In 
             (
                    Select Ide_Poste,Ide_Gest,Ide_Jal,Flg_Cptab,Ide_Ecr 
                      From Fc_Ecriture@lkastweb 
                     Where (Flg_Emis_Recu,Cod_Typ_Nd,Ide_Nd_Emet,Ide_Mess) In 
                           (
                           Select Flg_Emis_Recu,Cod_Typ_Nd,Ide_Nd_Emet,Ide_Mess 
                             From Fm_Message@lkastweb 
                            Where Cod_Typ_Mess = 24 and ide_gest=Pc$Gestion
                              And Libl  Like 'CUT-REGUL DE REJET VIREMENT DU%'
                              And  To_Date(Substr(Libl,Length(Libl)-9,10),'DD/MM/RRRR') Between To_Date(Pc$Date_Deb,'DD/MM/RRRR') And To_Date(Pc$Date_Fin,'DD/MM/RRRR')
                              And Ide_Nd_Emet = Pc$Pc_Code  
                            ) 
            )
         And Substr(Ide_Cpt,1,2) = '57'
         And Cod_Sens = 'C'
      union
      
      Select 'Aster_Retenue', Nvl(Sum (Mt),0)  Pc$Aster_Retenue 
        From Fc_Ligne@lkastweb 
       Where (Ide_Poste,Ide_Gest,Ide_Jal,Flg_Cptab,Ide_Ecr) In (
        Select Ide_Poste,Ide_Gest,Ide_Jal,Flg_Cptab,Ide_Ecr 
        From Fc_Ecriture@lkastweb 
        Where (Ide_Poste,Ide_Gest,Ide_Jal,Flg_Cptab,Ide_Ecr) In 
        (Select Ide_Poste,Ide_Gest,Ide_Jal,Flg_Cptab,Ide_Ecr 
        From Fc_Ecriture@lkastweb 
        Where 
        (Flg_Emis_Recu,Cod_Typ_Nd,Ide_Nd_Emet,Ide_Mess) In 
                                (Select Flg_Emis_Recu,Cod_Typ_Nd,Ide_Nd_Emet,Ide_Mess 
                                From Fm_Message@lkastweb 
                                Where Cod_Typ_Mess = 24 And Ide_Gest=Pc$Gestion
                                And Libl  Like 'CUT%DU%' 
                                And To_Date(Substr(Libl,Length(Libl)-9,10),'DD/MM/RRRR') Between To_Date(Pc$Date_Deb,'DD/MM/RRRR') And To_Date(Pc$Date_Fin,'DD/MM/RRRR')
                                And Ide_Nd_Emet =Pc$Pc_Code 
                                ) )) 
                                And (Ide_Cpt Like '390302%' And Spec3='502' Or Ide_Cpt='3903027295' And Spec3 Like '%C' Or Ide_Cpt In ('391311','39051') And Observ Not Like '%ATD%' And (Spec3 Like '%C' Or Spec3='502') Or Ide_Cpt='39112' And (Ide_Poste='509' Or Spec3='502' Or Spec3='510C')) 
    union

      
      Select 'Aster_Princ_Pen', Nvl(Sum (Mt),0)  Pc$Aster_Princ_Pen
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
                          Where Cod_Typ_Mess = 24 And Ide_Gest=Pc$Gestion
                           And Libl  Like 'CUT-PAIEMENT EFFECTIF DU%'
                           And To_Date(Substr(Libl,Length(Libl)-9,10),'DD/MM/RRRR') Between To_Date(Pc$Date_Deb,'DD/MM/RRRR') And To_Date(Pc$Date_Fin,'DD/MM/RRRR')
                           And Ide_Nd_Emet = Pc$Pc_Code  
                        )  
             ) 
         And (Ide_Cpt ='39051'  And Pc$Pc_Code Not Like '5%'  Or Ide_Cpt='391311' And Pc$Pc_Code Like '5%')
         And Observ Like 'ATD%'
         And Cod_Sens = 'C'
      union
      
      Select 'Aster_Dep_Fds', NVL(Sum (Mt),0)  Pc$Aster_Dep_Fds
        From Fc_Ligne@lkastweb 
       Where (Ide_Poste,Ide_Gest,Ide_Jal,Flg_Cptab,Ide_Ecr) In 
             (
                  Select Ide_Poste,Ide_Gest,Ide_Jal,Flg_Cptab,Ide_Ecr 
                    From Fc_Ecriture@lkastweb 
                  Where (Flg_Emis_Recu,Cod_Typ_Nd,Ide_Nd_Emet,Ide_Mess) In 
                        (
                        Select Flg_Emis_Recu,Cod_Typ_Nd,Ide_Nd_Emet,Ide_Mess 
                          From Fm_Message@lkastweb 
                          Where Cod_Typ_Mess = 24 and ide_gest=Pc$Gestion
                           And Libl Like 'CUT-CONFIRMATION DEPOTS DU %'
                           And To_Date(Substr(Libl,Length(Libl)-9,10),'DD/MM/RRRR') Between To_Date(Pc$Date_Deb,'DD/MM/RRRR') And To_Date(Pc$Date_Fin,'DD/MM/RRRR')
                           And Ide_Nd_Emet = Pc$Pc_Code  
                        )  
             ) 
         And Cod_Sens = 'C'
      union
      
      Select 'Aster_Couv_Num', NVL(Sum (Mt),0)  Pc$Aster_Couv_Num 
        From Fc_Ligne@lkastweb 
       Where (Ide_Poste,Ide_Gest,Ide_Jal,Flg_Cptab,Ide_Ecr) In 
             (
                    Select Ide_Poste,Ide_Gest,Ide_Jal,Flg_Cptab,Ide_Ecr 
                      From Fc_Ecriture@lkastweb 
                     Where (Flg_Emis_Recu,Cod_Typ_Nd,Ide_Nd_Emet,Ide_Mess) In 
                           (
                           Select Flg_Emis_Recu,Cod_Typ_Nd,Ide_Nd_Emet,Ide_Mess 
                             From Fm_Message@lkastweb 
                            Where Cod_Typ_Mess = 24 and ide_gest=Pc$Gestion
                              And Libl Like 'CUT-CHQ DE COUV NUMERAIRE DU%'
                              And To_Date(Substr(Libl,Length(Libl)-9,10),'DD/MM/RRRR') Between To_Date(Pc$Date_Deb,'DD/MM/RRRR') And To_Date(Pc$Date_Fin,'DD/MM/RRRR')
                              And Ide_Nd_Emet = Pc$Pc_Code  
                           )
             --       )
          )
         And Cod_Sens = 'C'
      union
      
      Select 'Aster_Retour_Fds', NVL(Sum (Mt),0)  Pc$Aster_Retour_Fds 
        From Fc_Ligne@lkastweb 
        Where (Ide_Poste,Ide_Gest,Ide_Jal,Flg_Cptab,Ide_Ecr) In 
             (
                    Select Ide_Poste,Ide_Gest,Ide_Jal,Flg_Cptab,Ide_Ecr 
                      From Fc_Ecriture@lkastweb 
                     Where (Flg_Emis_Recu,Cod_Typ_Nd,Ide_Nd_Emet,Ide_Mess) In 
                           (
                           Select Flg_Emis_Recu,Cod_Typ_Nd,Ide_Nd_Emet,Ide_Mess 
                             From Fm_Message@lkastweb 
                            Where Cod_Typ_Mess = 24 and ide_gest=Pc$Gestion
                              And Libl Like 'CUT-RETOUR DE FDS REJET VIREMENT DU%'
                              And To_Date(Substr(Libl,Length(Libl)-9,10),'DD/MM/RRRR') Between To_Date(Pc$Date_Deb,'DD/MM/RRRR') And To_Date(Pc$Date_Fin,'DD/MM/RRRR')
                              And Ide_Nd_Emet = Pc$Pc_Code  
                           ) 
          )
         And Cod_Sens = 'C'
      union
       
      Select 'Aster_Confirm_Debit', NVL(Sum (Mt),0)  Pc$Aster_Confirm_Debit
        From Fc_Ligne@lkastweb 
        Where (Ide_Poste,Ide_Gest,Ide_Jal,Flg_Cptab,Ide_Ecr) In 
             (
                    Select Ide_Poste,Ide_Gest,Ide_Jal,Flg_Cptab,Ide_Ecr 
                      From Fc_Ecriture@lkastweb 
                     Where (Flg_Emis_Recu,Cod_Typ_Nd,Ide_Nd_Emet,Ide_Mess) In 
                           (
                           Select Flg_Emis_Recu,Cod_Typ_Nd,Ide_Nd_Emet,Ide_Mess 
                             From Fm_Message@lkastweb 
                            Where Cod_Typ_Mess = 24 and ide_gest=Pc$Gestion
                              And Libl Like 'CUT-CONFIRMATION DE DEBIT DU%'
                              And To_Date(Substr(Libl,Length(Libl)-9,10),'DD/MM/RRRR') Between To_Date(Pc$Date_Deb,'DD/MM/RRRR') And To_Date(Pc$Date_Fin,'DD/MM/RRRR')
                              And Ide_Nd_Emet = Pc$Pc_Code  
                           ) 
          )
         And Cod_Sens = 'D'
      union

          Select 'Aster_Nivel', NVL(Sum (Mt),0)  Pc$Aster_Nivel
            From Fc_Ligne@lkastweb A,
                 Fc_Ecriture@lkastweb B,
                 Fm_Message@lkastweb C
           Where A.Ide_Poste = Pc$Pc_Code
             And A.Cod_Sens = 'D'
             And (Ide_Piece,Mt) In (Select Chq_Code,Niv_Montant
                                      From Cut_Nivellement@lkcut
                                     Where Pc_Code = Pc$Pc_Code
                                       And To_Date(Niv_Dte_Transfert,'DD/MM/RRRR') Between To_Date(Pc$Date_Deb,'DD/MM/RRRR') And To_Date(Pc$Date_Fin,'DD/MM/RRRR')
                                       And Niv_Statut = 'V'
                                   )
             And A.Ide_Poste = B.Ide_Poste
             And A.Ide_Gest = B.Ide_Gest
             And A.Ide_Jal = B.Ide_Jal
             And A.Flg_Cptab = B.Flg_Cptab
             And A.Ide_Ecr = B.Ide_Ecr
             And B.Flg_Emis_Recu = C.Flg_Emis_Recu
             And B.Cod_Typ_Nd = C.Cod_Typ_Nd
             And B.Ide_Nd_Emet = C.Ide_Nd_Emet
             And B.Ide_Mess = C.Ide_Mess
             And Libl Like 'CUT%NIVELLEMENT%DU%'
             and Cod_Typ_Mess = 24
             ;
         
End Cut_Pb_Ctrl_Coherence_Aster2;
/
