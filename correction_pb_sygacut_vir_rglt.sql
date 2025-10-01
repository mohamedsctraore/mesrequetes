SELECT Pc_Code,
                Str_Code,
                Nat_Dep_Code,
                Rgl_Num,
                Rgl_Banque,
                Rgl_Regul_Num,
                Ref_Pce_Code,
                Rgl_Mdt_Num,
                Rgl_Type_Reglt,
                Rgl_Dte_Reglement,
                Rgl_Montant_Net,
                Rgl_Matricule || '-' || Rgl_Benef_Nom V_Benef,
                Rgl_Objet || '-' || Rgl_Num_Cpt Objet,
                Rgl_source
           FROM Cut_Reglement
          WHERE Pc_Code = '501'
            AND TO_DATE (Rgl_Dte_Reglement, 'dd/mm/rrrr') = TO_DATE ('14/12/2022', 'dd/mm/rrrr')
            AND Rgl_Statut IN ('V', 'P', 'R')
            AND Rgl_Mrg_Code = '02'
            
            
            /*
            And ( (Rgl_Num In (Select Star_Msg_Ref From Cut_Star_Message Where Star_Msg_Type = 'MT900'))
               Or (Bord_Rgl_Num In (Select Star_Msg_Ref From Cut_Star_Message Where Star_Msg_Type = 'MT900'))
            )
            */
            
            AND (Pc_Code, Rgl_Num) IN
                       (
                       
                       (
                       
                       SELECT Pc_Code, Rgl_Num
                            FROM Cut_Reglement
                           WHERE Pc_Code = '501'
                             AND TO_DATE (Rgl_Dte_Reglement,'DD/MM/RRRR') = TO_DATE ('14/12/2022', 'DD/MM/RRRR')
                             AND Rgl_Statut   IN ('V', 'P', 'R')
                             AND Rgl_Mrg_Code  = '02'
                             AND Rgl_Regul_Num IS NULL
                             
                             
                          MINUS
                          
                          
                          SELECT A.Ide_Poste, A.Ide_Piece
                            FROM Fc_Ecriture@Asterndir A,
                                 Fc_Ligne@Asterndir B
                           WHERE     (A.Ide_Poste,
                                      A.Ide_Gest,
                                      A.Ide_Jal,
                                      A.Flg_Cptab,
                                      A.Ide_Ecr) IN
                                        
                                        
                                        (SELECT Ide_Poste,
                                                Ide_Gest,
                                                Ide_Jal,
                                                Flg_Cptab,
                                                Ide_Ecr
                                           FROM Fc_Ecriture@Asterndir
                                          WHERE (Ide_Poste,
                                                 Ide_Gest,
                                                 Ide_Jal,
                                                 Flg_Cptab,
                                                 Ide_Ecr) IN
                                                   (SELECT Ide_Poste,
                                                           Ide_Gest,
                                                           Ide_Jal,
                                                           Flg_Cptab,
                                                           Ide_Ecr
                                                      FROM Fc_Ecriture@Asterndir
                                                     WHERE (Flg_Emis_Recu,
                                                            Cod_Typ_Nd,
                                                            Ide_Nd_Emet,
                                                            Ide_Mess) IN
                                                              (SELECT Flg_Emis_Recu,
                                                                      Cod_Typ_Nd,
                                                                      Ide_Nd_Emet,
                                                                      Ide_Mess
                                                                 FROM Fm_Message@Asterndir
                                                                WHERE     Cod_Typ_Mess =
                                                                             24
                                                                      AND Libl LIKE
                                                                             'CUT%DU%'
                                                                      AND Ide_Nd_Emet =
                                                                             '501'
                                                                             And To_Date(Substr(Libl, Length(Libl) - 9, 10) , 'DD/MM/RRRR') = To_Date('14/12/2022', 'DD/MM/RRRR')
                                                                             /*
                                                                      AND SUBSTR (
                                                                             Libl,
                                                                               LENGTH (
                                                                                  Libl)
                                                                             - 9,
                                                                             10) =
                                                                             TO_CHAR (
                                                                                TO_DATE (
                                                                                   '14/12/2022',
                                                                                   'DD/MM/RRRR'))
                                                                                   */
                                                                                   
                                                                                   ))
                                                                                   
                                                                                   )
                                                                                   
                                                                                   
                                 AND SUBSTR (Ide_Cpt, 1, 2) = '57' and cod_sens='C'
                                 AND A.Ide_Poste = B.Ide_Poste
                                 AND A.Ide_Gest = B.Ide_Gest
                                 AND A.Ide_Jal = B.Ide_Jal
                                 AND A.Flg_Cptab = B.Flg_Cptab
                                 AND A.Ide_Ecr = B.Ide_Ecr
                                 
                                 )
                                 
                                 
                                
                        UNION
                        (
                        
                        
                        SELECT Pc_Code, Rgl_Num
                           FROM Cut_Reglement
                          WHERE     Pc_Code = '501'
                                AND TO_DATE (Rgl_Dte_Reglement, 'DD/MM/RRRR') =
                                       TO_DATE ('14/12/2022', 'DD/MM/RRRR')
                                AND Rgl_Statut IN ('V', 'P', 'R')
                                AND Rgl_Mrg_Code = '02'
                                AND Rgl_Regul_Num IS NOT NULL
                                
                                
                         MINUS
                         SELECT A.Ide_Poste, A.Ide_Piece
                           FROM Fc_Ecriture@Asterndir A, Fc_Ligne@Asterndir B
                          WHERE     (A.Ide_Poste,
                                     A.Ide_Gest,
                                     A.Ide_Jal,
                                     A.Flg_Cptab,
                                     A.Ide_Ecr) IN
                                       (SELECT Ide_Poste,
                                               Ide_Gest,
                                               Ide_Jal,
                                               Flg_Cptab,
                                               Ide_Ecr
                                          FROM Fc_Ecriture@Asterndir
                                         WHERE (Ide_Poste,
                                                Ide_Gest,
                                                Ide_Jal,
                                                Flg_Cptab,
                                                Ide_Ecr) IN
                                                  (SELECT Ide_Poste,
                                                          Ide_Gest,
                                                          Ide_Jal,
                                                          Flg_Cptab,
                                                          Ide_Ecr
                                                     FROM Fc_Ecriture@Asterndir
                                                    WHERE (Flg_Emis_Recu,
                                                           Cod_Typ_Nd,
                                                           Ide_Nd_Emet,
                                                           Ide_Mess) IN
                                                             (SELECT Flg_Emis_Recu,
                                                                     Cod_Typ_Nd,
                                                                     Ide_Nd_Emet,
                                                                     Ide_Mess
                                                                FROM Fm_Message@Asterndir
                                                               WHERE     Cod_Typ_Mess =
                                                                            24
                                                                     AND Libl LIKE
                                                                            'CUT%REGUL%DU%'
                                                                     AND Ide_Nd_Emet =
                                                                            '501'
                                                                            And To_Date(Substr(Libl, Length(Libl) - 9, 10) , 'DD/MM/RRRR') = To_Date('14/12/2022', 'DD/MM/RRRR')
                                                                            /*
                                                                     AND SUBSTR (
                                                                            Libl,
                                                                              LENGTH (
                                                                                 Libl)
                                                                            - 9,
                                                                            10) =
                                                                            TO_CHAR (
                                                                               TO_DATE (
                                                                                  '14/12/2022',
                                                                                  'DD/MM/RRRR'))
                                                                                  */
                                                                                  
                                                                                  
                                                                                  )))
                                                                                  
                                                                                  
                                                                                  
                                                                                  
                                AND SUBSTR (Ide_Cpt, 1, 2) = '57' and cod_sens='C'
                                AND A.Ide_Poste = B.Ide_Poste
                                AND A.Ide_Gest = B.Ide_Gest
                                AND A.Ide_Jal = B.Ide_Jal
                                AND A.Flg_Cptab = B.Flg_Cptab
                                AND A.Ide_Ecr = B.Ide_Ecr
                                
            )
            
                                
                                
        )