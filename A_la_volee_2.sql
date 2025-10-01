Select  ORDRE ,GROUPE,TYPE,rubrique,NVL(SUM(MONTANT),0)MONTANT 
    From (
          Select '5' ORDRE,'VIREMENT' GROUPE,'SyGACUT' TYPE,'Paiement(virement)' rubrique,Sum(Rgl_Montant_Net) Montant
            From Cut_Reglement@lkcut 
           Where Pc_Code       = '644'
             And To_Date(Rgl_Dte_Reglement,'DD/MM/RRRR') Between to_Date('01/01/2024','DD/MM/RRRR') And To_Date('31/12/2024','DD/MM/RRRR')
             And (Rgl_Statut    In ('V','P') or Rgl_Statut = 'R' and rgl_rout_statut='R')
             And Rgl_Mrg_Code  = '02'
             And Rgl_Regul_Num Is Null
          Union All
          Select '5' ORDRE,'VIREMENT' GROUPE,'SyGACUT' TYPE,'Paiement(virement)'rubrique ,Sum(Rgl_Montant_Net) Montant
            From Cut_Reglt_Restor_Juil_Aout_24@lkcut 
           Where Pc_Code       = '644'
             --And To_Char(Rgl_Dte_Reglement,'rrrr') = Pc$Gestion 
             And To_Date(Rgl_Dte_Reglement,'DD/MM/RRRR') Between to_Date('01/01/2024','DD/MM/RRRR') And To_Date('31/12/2024','DD/MM/RRRR')
             And Rgl_Statut    = 'P'
             --And (Rgl_Statut    In ('P') or Rgl_Statut = 'R' and rgl_rout_statut='R')
             And Rgl_Mrg_Code  = '02'
             And Rgl_Ret_Type  = 'PAI'
             And Rgl_Regul_Num Is Null)
            GROUP BY ORDRE ,GROUPE,TYPE,rubrique;
            
            
            Select '5' ORDRE, 'VIREMENT' GROUPE,'ASTERWEB' TYPE,'Paiement(virement)' rubrique ,NVL(Sum (Mt),0) MONTANT
        From Fc_Ligne@lkastweb 
       Where (Ide_Poste,Ide_Gest,Ide_Jal,Flg_Cptab,Ide_Ecr) In 
            (
                  Select Ide_Poste,Ide_Gest,Ide_Jal,Flg_Cptab,Ide_Ecr 
                    From Fc_Ecriture@lkastweb 
                   Where (Flg_Emis_Recu,Cod_Typ_Nd,Ide_Nd_Emet,Ide_Mess) In 
                         (
                          Select Flg_Emis_Recu,Cod_Typ_Nd,Ide_Nd_Emet,Ide_Mess 
                            From Fm_Message@lkastweb 
                           Where Cod_Typ_Mess = 24 and ide_gest='2024'
                             And Libl  Like 'CUT%PAIEMENT%DU%'
                             And  To_Date(Substr(Libl,Length(Libl)-9,10),'DD/MM/RRRR') Between to_Date('01/01/2024','DD/MM/RRRR') And To_Date('31/12/2024','DD/MM/RRRR')
                             And Ide_Nd_Emet = '644'
                         )
         ) 
         And Substr(Ide_Cpt,1,2) = '57'
         And Cod_Sens = 'C'
         
         ;
         
         
         Select Rgl_Num, Rgl_Montant_Net
    From (
          Select Rgl_Num, Rgl_Montant_Net
            From Cut_Reglement@lkcut 
           Where Pc_Code       = '644'
             And To_Date(Rgl_Dte_Reglement,'DD/MM/RRRR') Between to_Date('01/01/2024','DD/MM/RRRR') And To_Date('31/12/2024','DD/MM/RRRR')
             And (Rgl_Statut    In ('V','P') or Rgl_Statut = 'R' and rgl_rout_statut='R')
             And Rgl_Mrg_Code  = '02'
             And Rgl_Regul_Num Is Null
          Union All
          Select Rgl_Num, Rgl_Montant_Net
            From Cut_Reglt_Restor_Juil_Aout_24@lkcut 
           Where Pc_Code       = '644'
             --And To_Char(Rgl_Dte_Reglement,'rrrr') = Pc$Gestion 
             And To_Date(Rgl_Dte_Reglement,'DD/MM/RRRR') Between to_Date('01/01/2024','DD/MM/RRRR') And To_Date('31/12/2024','DD/MM/RRRR')
             And Rgl_Statut    = 'P'
             --And (Rgl_Statut    In ('P') or Rgl_Statut = 'R' and rgl_rout_statut='R')
             And Rgl_Mrg_Code  = '02'
             And Rgl_Ret_Type  = 'PAI'
             And Rgl_Regul_Num Is Null)
            --GROUP BY ORDRE ,GROUPE,TYPE,rubrique
           minus
            Select Ide_Piece, Mt
        From Fc_Ligne@lkastweb a, Fc_Ecriture@lkastweb b 
       Where (A.Ide_Poste,A.Ide_Gest,A.Ide_Jal,A.Flg_Cptab,A.Ide_Ecr) In 
            (
                  Select Ide_Poste,Ide_Gest,Ide_Jal,Flg_Cptab,Ide_Ecr 
                    From Fc_Ecriture@lkastweb 
                   Where (Flg_Emis_Recu,Cod_Typ_Nd,Ide_Nd_Emet,Ide_Mess) In 
                         (
                          Select Flg_Emis_Recu,Cod_Typ_Nd,Ide_Nd_Emet,Ide_Mess 
                            From Fm_Message@lkastweb 
                           Where Cod_Typ_Mess = 24 and ide_gest='2024'
                             And Libl  Like 'CUT%PAIEMENT%DU%'
                             And  To_Date(Substr(Libl,Length(Libl)-9,10),'DD/MM/RRRR') Between to_Date('01/01/2024','DD/MM/RRRR') And To_Date('31/12/2024','DD/MM/RRRR')
                             And Ide_Nd_Emet = '644'
                         )
         ) 
         And Substr(A.Ide_Cpt,1,2) = '57'
         And Cod_Sens = 'C'
         And A.Ide_Gest = B.Ide_Gest
        And A.Ide_Ecr = B.Ide_Ecr
        And A.Flg_Cptab = B.Flg_Cptab
        And A.Ide_Poste = B.Ide_Poste
        And A.Ide_Jal = B.Ide_Jal
        Order By 2 
        ;
        
        
         Select Ide_Piece, Mt
        From Fc_Ligne@lkastweb a, Fc_Ecriture@lkastweb b 
       Where (A.Ide_Poste,A.Ide_Gest,A.Ide_Jal,A.Flg_Cptab,A.Ide_Ecr) In 
            (
                  Select Ide_Poste,Ide_Gest,Ide_Jal,Flg_Cptab,Ide_Ecr 
                    From Fc_Ecriture@lkastweb 
                   Where (Flg_Emis_Recu,Cod_Typ_Nd,Ide_Nd_Emet,Ide_Mess) In 
                         (
                          Select Flg_Emis_Recu,Cod_Typ_Nd,Ide_Nd_Emet,Ide_Mess 
                            From Fm_Message@lkastweb 
                           Where Cod_Typ_Mess = 24 and ide_gest='2024'
                             And Libl  Like 'CUT%PAIEMENT%DU%'
                             And  To_Date(Substr(Libl,Length(Libl)-9,10),'DD/MM/RRRR') Between to_Date('01/01/2024','DD/MM/RRRR') And To_Date('31/12/2024','DD/MM/RRRR')
                             And Ide_Nd_Emet = '644'
                         )
         ) 
         And Substr(A.Ide_Cpt,1,2) = '57'
         And Cod_Sens = 'C'
         And A.Ide_Gest = B.Ide_Gest
        And A.Ide_Ecr = B.Ide_Ecr
        And A.Flg_Cptab = B.Flg_Cptab
        And A.Ide_Poste = B.Ide_Poste
        And A.Ide_Jal = B.Ide_Jal 

minus

Select Rgl_Num, Rgl_Montant_Net
    From (
          Select Rgl_Num, Rgl_Montant_Net
            From Cut_Reglement@lkcut 
           Where Pc_Code       = '644'
             And To_Date(Rgl_Dte_Reglement,'DD/MM/RRRR') Between to_Date('01/01/2024','DD/MM/RRRR') And To_Date('31/12/2024','DD/MM/RRRR')
             And (Rgl_Statut    In ('V','P') or Rgl_Statut = 'R' and rgl_rout_statut='R')
             And Rgl_Mrg_Code  = '02'
             And Rgl_Regul_Num Is Null
          Union All
          Select Rgl_Num, Rgl_Montant_Net
            From Cut_Reglt_Restor_Juil_Aout_24@lkcut 
           Where Pc_Code       = '644'
             --And To_Char(Rgl_Dte_Reglement,'rrrr') = Pc$Gestion 
             And To_Date(Rgl_Dte_Reglement,'DD/MM/RRRR') Between to_Date('01/01/2024','DD/MM/RRRR') And To_Date('31/12/2024','DD/MM/RRRR')
             And Rgl_Statut    = 'P'
             --And (Rgl_Statut    In ('P') or Rgl_Statut = 'R' and rgl_rout_statut='R')
             And Rgl_Mrg_Code  = '02'
             And Rgl_Ret_Type  = 'PAI'
             And Rgl_Regul_Num Is Null)
            --GROUP BY ORDRE ,GROUPE,TYPE,rubrique
           Order By 2
        ;