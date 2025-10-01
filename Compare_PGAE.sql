Drop Table Compare;

Create Table Compare As
Select 'S' sourc, Rgl_Num, Rgl_Montant_Net
            From Cut_Reglement@lkcut
           Where Pc_Code       = '503'
             And To_Date(Rgl_Dte_Reglement,'DD/MM/RRRR') Between To_Date('23/04/2025','DD/MM/RRRR') And To_Date('23/04/2025','DD/MM/RRRR')
             And (Rgl_Statut    In ('V','P') or Rgl_Statut = 'R' and rgl_rout_statut='R')
             And Rgl_Mrg_Code  = '02'
             --And Rgl_Regul_Num Is Null
--Group By To_Date(Rgl_Dte_Reglement,'DD/MM/RRRR')
union
Select 'A' sourc, Ide_Piece, Mt From Fc_Ecriture@lkastweb a, Fc_Ligne@lkastweb b 
Where A.Ide_Poste = B.Ide_Poste
And A.Ide_Gest = B.Ide_Gest
And A.Ide_Ecr = B.Ide_Ecr
And A.Flg_Cptab = B.Flg_Cptab
And A.Ide_Jal = B.Ide_Jal
And B.Cod_sens = 'C'
And A.Ide_Gest = '2025'
And A.Ide_Poste = '503'
And A.Ide_Mess In (Select unique ide_mess from fm_message@Lkastweb Where ide_nd_emet = '503' and cod_typ_mess = 24 and ide_gest = '2025' and libl like '%23/04/%')
And Length(ide_Piece) > 14
;

Select Rgl_Num, Sum(Decode(Sourc, 'S', Rgl_Montant_Net, -Rgl_Montant_Net)) From Compare
Group By Rgl_Num
Having Sum(Decode(Sourc, 'S', Rgl_Montant_Net, -Rgl_Montant_Net)) <> 0
Order By 2,1;

---------------------------------------- RETENUE -------------------------------------------------

Drop Table Compare_Ret;

Create Table Compare_Ret As
Select 'S' sourc, Ret_Num, Ret_Montant
            From Cut_Retenue@lkcut
           Where Pc_Code       = '503'
             And To_Date(Ret_Dte_Reglement,'DD/MM/RRRR') Between To_Date('23/04/2025','DD/MM/RRRR') And To_Date('23/04/2025','DD/MM/RRRR')
             And Ret_Statut = 'P'
union
Select 'A' sourc, Ide_Piece, Mt From Fc_Ecriture@lkastweb a, Fc_Ligne@lkastweb b 
Where A.Ide_Poste = B.Ide_Poste
And A.Ide_Gest = B.Ide_Gest
And A.Ide_Ecr = B.Ide_Ecr
And A.Flg_Cptab = B.Flg_Cptab
And A.Ide_Jal = B.Ide_Jal
And B.Cod_sens = 'C'
And A.Ide_Gest = '2025'
And A.Ide_Poste = '503'
And A.Ide_Mess In (Select unique ide_mess from fm_message@Lkastweb Where ide_nd_emet = '503' and cod_typ_mess = 24 and ide_gest = '2025' and libl like '%23/04/%')
And B.ide_Cpt = '39112'
And Length(ide_Piece) < 15
;

Select Ret_Num, Sum(Decode(Sourc, 'S', Ret_Montant, -Ret_Montant)) From Compare_Ret
Group By Ret_Num
Having Sum(Decode(Sourc, 'S', Ret_Montant, -Ret_Montant)) <> 0
Order By 2,1;

----------------------------------------------- PROGRAMME ----------------------------------------------------------------

Declare
    cursor c_paiement is Select Ret_Num From Compare_Ret Where Ret_Num In
    (
    '25042305030052',
    '25042305030014',
    '25042305030015',
    '25042305030061',
    '25042305030004',
    '25042305030005',
    '25042305030030',
    '25042305030006',
    '25042305030007',
    '25042305030053',
    '25042305030054',
    '25042305030055',
    '25042305030056',
    '25042305030010',
    '25042305030016',
    '25042305030047',
    '25042305030017',
    '25042305030024',
    '25042305030062',
    '25042305030019',
    '25042305030025',
    '25042305030057',
    '25042305030020',
    '25042305030058',
    '25042305030031',
    '25042305030044',
    '25042305030037',
    '25042305030038',
    '25042305030059',
    '25042305030045',
    '25042305030060',
    '25042305030021',
    '25042305030022',
    '25042305030023'
    );
    
    v_rgl_num   niaba.fc_ecriture_cut_ndir.ide_piece%type;
    v_ide_ecr   niaba.fc_ecriture_cut_ndir.ide_ecr%type;
    v_objet     niaba.fc_ecriture_cut_ndir.libn%type;
    v_montant   niaba.fc_ligne_cut_ndir.mt%type;
    v_ide_lig   niaba.fc_ligne_cut_ndir.ide_lig%type;
    v_mdt       niaba.fc_ligne_cut_ndir.observ%type;    
    
Begin
    for Param_Ligne in c_paiement
        loop
--            Select Rgl_Num, Rgl_Objet, Rgl_Mdt_Num, Rgl_Montant_Net Into v_rgl_num, v_objet, v_mdt, v_montant 
--            From Cut.Cut_Reglement@lkcut
--            Where Rgl_Num = Param_Ligne.Rgl_Num;

            Select Ret_Num, Ret_Objet, Ret_Montant Into v_rgl_num, v_objet, v_montant 
            From Cut.Cut_Retenue@lkcut
            where Ret_Num = Param_Ligne.Ret_Num;
            
            Select Max(Ide_Ecr) + 1 Into v_ide_ecr
            From Fc_Ligne@Lkastweb
            Where Ide_Gest = '2025'
            And Flg_Cptab = 'N'
            And Ide_Poste = '503'
            ;
            
            Insert Into Fc_Ecriture@Lkastweb 
            (ide_poste,ide_gest,ide_jal,flg_cptab,ide_ecr,var_cpta,ide_schema,cod_typ_nd,ide_nd_emet,ide_mess,flg_emis_recu,libn,dat_saisie,cod_statut,ide_piece,dat_cre,uti_cre,dat_maj,uti_maj,terminal) 
            Values ('503','2025','JODPGAE','N',v_ide_ecr,'C2020','12','P','503',879925,'R',v_rgl_num,sysdate,'AC',v_rgl_num,sysdate,'SIBINTERFACE',sysdate,'SIBINTERFACE','PECMER');
            
            Insert Into Fc_Ligne@Lkastweb
            (ide_poste,ide_gest,ide_jal,flg_cptab,ide_ecr,ide_lig,var_cpta,ide_cpt,cod_sens,mt,observ,ide_schema,cod_typ_schema,ide_modele_lig,dat_ref,dat_cre,uti_cre,dat_maj,uti_maj,terminal,flg_annul_dcst,mt_dev)
            Values ('503','2025','JODPGAE','N',v_ide_ecr,1,'C2020','39112','C',v_montant,v_objet,'11','T','C 39112',to_date('23/04/2025','dd/mm/rrrr'),sysdate,'SIBINTERFACE',sysdate,'SIBINTERFACE','PECMER','N',v_montant);
            
            Insert Into Fc_Ligne@Lkastweb
            (ide_poste,ide_gest,ide_jal,flg_cptab,ide_ecr,ide_lig,var_cpta,ide_cpt,cod_sens,mt,observ,ide_schema,cod_typ_schema,ide_modele_lig,dat_ref,dat_cre,uti_cre,dat_maj,uti_maj,terminal,flg_annul_dcst,mt_dev)
            Values ('503','2025','JODPGAE','N',v_ide_ecr,2,'C2020','4751153','D',v_montant,v_objet,'11','T','DEBIT',to_date('23/04/2025','dd/mm/rrrr'),sysdate,'SIBINTERFACE',sysdate,'SIBINTERFACE','PECMER','N',v_montant);
            
            Insert Into Fc_Ligne@Lkastweb
            (ide_poste,ide_gest,ide_jal,flg_cptab,ide_ecr,ide_lig,var_cpta,ide_cpt,cod_sens,mt,observ,ide_schema,cod_typ_schema,ide_modele_lig,dat_ref,dat_cre,uti_cre,dat_maj,uti_maj,terminal,flg_annul_dcst,mt_dev)
            Values ('503','2025','JODPGAE','N',v_ide_ecr,3,'C2020','475','C',v_montant,v_objet,'11','T','CREDIT',to_date('23/04/2025','dd/mm/rrrr'),sysdate,'SIBINTERFACE',sysdate,'SIBINTERFACE','PECMER','N',v_montant);
            
            Insert Into Fc_Ligne@Lkastweb
            (ide_poste,ide_gest,ide_jal,flg_cptab,ide_ecr,ide_lig,var_cpta,ide_cpt,cod_sens,mt,observ,ide_schema,cod_typ_schema,ide_modele_lig,dat_ref,dat_cre,uti_cre,dat_maj,uti_maj,terminal,flg_annul_dcst,mt_dev)
            Values ('503','2025','JODPGAE','N',v_ide_ecr,4,'C2020','4701122','D',v_montant,v_objet,'11','T','DEBIT+T',to_date('23/04/2025','dd/mm/rrrr'),sysdate,'SIBINTERFACE',sysdate,'SIBINTERFACE','PECMER','N',v_montant);
            
            Commit;
        end loop;
End;


Select * From Fc_Ligne@Lkastweb
Where Ide_Gest = '2025'
And Ide_Poste = '503'
;