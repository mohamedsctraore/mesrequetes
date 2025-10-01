drop table verif_doublon_T;

create table verif_doublon_T as
Select 'S' sourc, Pc_Code, To_Date(Rgl_Dte_Reglement, 'DD/MM/RRRR') dte, Sum(Rgl_Montant_Net) mt
                From Cut_Reglement@lkcut
               Where To_Date(Rgl_Dte_Reglement,'DD/MM/RRRR') Between To_Date('01/01/2025','DD/MM/RRRR') And To_Date('20/07/2025','DD/MM/RRRR')
                 And (Rgl_Statut    In ('V','P') or Rgl_Statut = 'R' and rgl_rout_statut='R')
                 And Rgl_Mrg_Code  = '02'
                 And Rgl_Regul_Num Is Null
                 --And RGL_CODE_OP IS Null
                 --And RGL_CODE_OP Not Like '%ctualisation%Paiement%Virement%'
group by Pc_code, To_Date(Rgl_Dte_Reglement, 'DD/MM/RRRR')
union
Select 'A' sourc, a.ide_poste, To_Date(Dat_Ref, 'DD/MM/RRRR') dte, sum(mt) mt from fc_ecriture@lkastweb a, fc_ligne@lkastweb b
                Where (flg_emis_recu, cod_typ_nd, ide_nd_emet, ide_mess) 
                In (select flg_emis_recu, cod_typ_nd, ide_nd_emet, ide_mess from fm_message@lkastweb where ide_gest = '2025' and cod_typ_mess = 24 --and ide_nd_emet = v_pc_code
                And libl like '%CUT-PAIEMENT EFFECTIF DU%')
                and ide_cpt like '57%'
                And cod_sens = 'C'
                And length(ide_piece) > 14
                And to_date(Dat_ref,'dd/mm/rrrr') between to_date('01/01/2025','dd/mm/rrrr') and to_date('20/07/2025','dd/mm/rrrr')
                And a.ide_poste = b.ide_poste and a.ide_gest = b.ide_gest and a.flg_cptab = b.flg_cptab and a.ide_jal = b.ide_jal and a.ide_ecr = b.ide_ecr
                group by a.ide_poste, To_Date(Dat_Ref, 'DD/MM/RRRR')
                order by 1,2
                ;
                
Select Pc_Code, Dte, Sum(decode(sourc, 'S', mt, -mt)) From verif_doublon_T
Where Pc_Code Not In ('503','509')
--And Pc_Code = '7'
--And Dte Between '01/01/2025' And '12/05/2025'
Group By Pc_Code, Dte
Having Sum(decode(sourc, 'S', mt, -mt)) <> 0
Order By 1,2
;


-------------------------------------------------------------------------------------------------------------------------

drop table verif_doublon_TT;

create table verif_doublon_TT as
Select 'S' sourc, Pc_Code, To_Date(Rgl_Dte_Reglement, 'DD/MM/RRRR') dte, Sum(Rgl_Montant_Net) mt
                From Cut_Reglement@lkcut
               Where To_Date(Rgl_Dte_Reglement,'DD/MM/RRRR') Between To_Date('01/01/2025','DD/MM/RRRR') And To_Date('23/07/2025','DD/MM/RRRR')
                 And Rgl_Statut  In ('S','V','P')
                 And Rgl_Mrg_Code  = '01'
                 And Rgl_Regul_Num Is Null
                 --And RGL_CODE_OP IS Null
                 --And RGL_CODE_OP Not Like '%ctualisation%Paiement%Virement%'
group by Pc_code, To_Date(Rgl_Dte_Reglement, 'DD/MM/RRRR')
union
Select 'A' sourc, a.ide_poste, To_Date(Dat_Ref, 'DD/MM/RRRR') dte, sum(mt) mt from fc_ecriture@lkastweb a, fc_ligne@lkastweb b
                Where (flg_emis_recu, cod_typ_nd, ide_nd_emet, ide_mess) 
                In (select flg_emis_recu, cod_typ_nd, ide_nd_emet, ide_mess from fm_message@lkastweb where ide_gest = '2025' and cod_typ_mess = 24 --and ide_nd_emet = v_pc_code
                And libl like '%CUT-PAIEMENT NUMERAIRE DU%')
                --and ide_cpt like '572'
                And cod_sens = 'C'
                --And length(ide_piece) > 14
                And to_date(Dat_ref,'dd/mm/rrrr') between to_date('01/01/2025','dd/mm/rrrr') and to_date('23/07/2025','dd/mm/rrrr')
                And a.ide_poste = b.ide_poste and a.ide_gest = b.ide_gest and a.flg_cptab = b.flg_cptab and a.ide_jal = b.ide_jal and a.ide_ecr = b.ide_ecr
                group by a.ide_poste, To_Date(Dat_Ref, 'DD/MM/RRRR')
                order by 1,2
                ;
                
Select Pc_Code, Dte, Sum(decode(sourc, 'S', mt, -mt)) From verif_doublon_TT
Where Pc_Code Not In ('503','509')
And Pc_Code = '731'
--And Dte Between '01/01/2025' And '12/05/2025'
Group By Pc_Code, Dte
Having Sum(decode(sourc, 'S', mt, -mt)) <> 0
Order By 1,2
;