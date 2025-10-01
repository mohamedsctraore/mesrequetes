Drop Table Ctl_Autres;

Create Table Ctl_Autres as
Select 'S' cible, To_Date(Rgl_Dte_Reglement,'DD/MM/RRRR') dte_reglement, Sum(Rgl_Montant_Net) Rgl_Montant_Net
            From Cut_Reglement@lkcut
           Where Pc_Code       = '&&poste'
             And To_Date(Rgl_Dte_Reglement,'DD/MM/RRRR') Between To_Date('&&debut','DD/MM/RRRR') And To_Date('&&fin','DD/MM/RRRR')
             And (Rgl_Statut    In ('V','P') or Rgl_Statut = 'R' and rgl_rout_statut='R')
             And Rgl_Mrg_Code  = '02'
             And Rgl_Regul_Num Is Null
Group By To_Date(Rgl_Dte_Reglement,'DD/MM/RRRR')
union
Select 'A' cible, To_Date(Dat_Ref,'DD/MM/RRRR') dte_reglement, NVL(Sum (Mt),0) Rgl_Montant_Net --Into Pc$Aster_Paie_Vir
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
                         And Libl  Like 'CUT%PAIEMENT%' --And substr(Libl,1,9)  <> 'CUT-REGUL'
                         And  To_Date(Substr(Libl,Length(Libl)-9,10),'DD/MM/RRRR') Between To_Date('&&debut','DD/MM/RRRR') And To_Date('&&fin','DD/MM/RRRR')
                         And Ide_Nd_Emet = '&&poste'
                     )
     ) 
     And Substr(Ide_Cpt,1,2) = '57'
     And Cod_Sens = 'C'
     Group By To_Date(Dat_Ref,'DD/MM/RRRR')
order By 2,1
;

Select Dte_Reglement, Sum(Decode(cible, 'S', RGL_MONTANT_NET, -RGL_MONTANT_NET)) 
From Ctl_Autres
Group By Dte_Reglement
--Having Sum(Decode(cible, 'S', RGL_MONTANT_NET, -RGL_MONTANT_NET)) <> 0
Order By To_Date(Dte_Reglement)
;