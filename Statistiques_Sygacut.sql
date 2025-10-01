drop table stats_numeraire;

create table stats_numeraire as
Select '1-Syg-Num' cible, PC_CODE, Count(Rgl_Num) nb
            From Cut_Reglement@lkcut
           Where -- Pc_Code      = Pc$Pc_Code
             --And 
             To_Date(Rgl_Dte_Reglement,'DD/MM/RRRR') Between To_Date('01/01/2025','DD/MM/RRRR') And To_Date('11/04/2025','DD/MM/RRRR')
             And Rgl_Statut   In ('V','S') 
             And ((Rgl_Code_Op Not Like '%sor Pay%' And Rgl_Code_Op Not Like '%MAJ%Pai%Num%' And Rgl_Code_Op Not Like '%tualisa%Pai%Num%') Or Rgl_Code_Op Is Null)
             And Rgl_Mrg_Code = '01'
             group by pc_code
Union All
Select '2-Aster-Num' cible, Ide_poste, Count(Ide_piece) nb From Fc_Ecriture@lkastweb where (Ide_Poste,Ide_Gest,Ide_Jal,Flg_Cptab,Ide_Ecr) in
(
  Select Ide_Poste,Ide_Gest,Ide_Jal,Flg_Cptab,Ide_Ecr
    From Fc_Ligne@lkastweb 
   Where (Ide_Poste,Ide_Gest,Ide_Jal,Flg_Cptab,Ide_Ecr) In 
         (
                  Select Ide_Poste,Ide_Gest,Ide_Jal,Flg_Cptab,Ide_Ecr 
                    From Fc_Ecriture@lkastweb 
                   Where (Flg_Emis_Recu,Cod_Typ_Nd,Ide_Nd_Emet,Ide_Mess) In 
                         (
                          Select Flg_Emis_Recu,Cod_Typ_Nd,Ide_Nd_Emet,Ide_Mess 
                            From Fm_Message@lkastweb 
                           Where Cod_Typ_Mess = 24 and ide_gest='2025'
                             And Libl Like 'CUT%PAIEMENT%NUMERAIRE%DU%'
                             And To_Date(Substr(Libl,Length(Libl)-9,10),'DD/MM/RRRR') Between To_Date('01/01/2025','DD/MM/RRRR') And To_Date('11/04/2025','DD/MM/RRRR')
                             --And Ide_Nd_Emet = Pc$Pc_Code
                         ) 
         )
     And Cod_Sens='C'
     )
 Group By Ide_poste
Order By 2,1;

drop table stats_num;

create table stats_num as
select pc_code, nb sygacut, 0 aster  
from stats_numeraire
where cible = '1-Syg-Num'
union
select pc_code, 0 sygacut, nb aster  
from stats_numeraire
where cible = '2-Aster-Num'
;

select pc_code, sum(sygacut) sygacut, sum(aster) aster from stats_num
group by pc_code
Order By 1;


drop table stats_virent;

create table stats_virent as             
Select '1-Syg-Vir' cible, PC_CODE, COUNT(Rgl_Num) nb
            From Cut_Reglement@lkcut
           Where 
             To_Date(Rgl_Dte_Reglement,'DD/MM/RRRR') Between To_Date('01/01/2025','DD/MM/RRRR') And To_Date('04/04/2025','DD/MM/RRRR')
             And (Rgl_Statut    In ('V','P') or Rgl_Statut = 'R' and rgl_rout_statut='R')
             And Rgl_Mrg_Code  = '02'
             And Rgl_Regul_Num Is Null
             Group By pc_code
          Union All
Select '1-Syg-Vir-Restor' cible, PC_CODE, COUNT(Rgl_Num) nb
            From Cut_Reglt_Restor_Juil_Aout_24@lkcut
            Where
             To_Date(Rgl_Dte_Reglement,'DD/MM/RRRR') Between To_Date('01/01/2025','DD/MM/RRRR') And To_Date('04/04/2025','DD/MM/RRRR')
             And Rgl_Statut    = 'P'
             And Rgl_Mrg_Code  = '02'
             And Rgl_Ret_Type  = 'PAI'
             And Rgl_Regul_Num Is Null
             Group By pc_code
             --Order By 2,3
             Union ALl
             Select '2-Aster-Vir' cible, a.ide_poste, count(ide_piece) from fc_ecriture@lkastweb a, fc_ligne@lkastweb b
                Where (flg_emis_recu, cod_typ_nd, ide_nd_emet, ide_mess) 
                In (select flg_emis_recu, cod_typ_nd, ide_nd_emet, ide_mess from fm_message@lkastweb where ide_gest = '2025' and cod_typ_mess = 24 --and ide_nd_emet = v_pc_code
                And libl like '%CUT-PAIEMENT EFFECTIF DU%')
                --and ide_cpt like '572'
                And cod_sens = 'C'
                And length(ide_piece) > 14
                And to_date(Dat_ref,'dd/mm/rrrr') between to_date('01/01/2025','dd/mm/rrrr') and to_date('04/04/2025','dd/mm/rrrr')
                And a.ide_poste = b.ide_poste and a.ide_gest = b.ide_gest and a.flg_cptab = b.flg_cptab and a.ide_jal = b.ide_jal and a.ide_ecr = b.ide_ecr
                group by a.ide_poste
                  ;
                  
drop table stats_vi;                  
                  
create table stats_vi as
select pc_code, nb sygacut, 0 aster  
from stats_virent
where cible = '1-Syg-Vir'
union
select pc_code, nb sygacut, 0 aster  
from stats_virent
where cible = '1-Syg-Vir-Restor'
union
select pc_code, 0 sygacut, nb aster  
from stats_virent
where cible = '2-Aster-Vir'
;

select pc_code, sum(sygacut) sygacut, sum(aster) aster from stats_vi
group by pc_code
Order By 1;