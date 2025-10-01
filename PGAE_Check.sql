----Select * From Fc_Ecriture_Cut_Ndir
Update Fc_Ecriture_Cut_Ndir Set Ide_Mess = 1237 Where ide_poste = '3042' And Ide_Mess = 1;--And Ide_Mess In (879779,879780,879781,879782,879783,879784,879785);

Insert Into Piaf_Adm.Fm_Message@lkastweb Select * From Niaba.Fm_Message Where Ide_Nd_Emet = '3042'; --And Ide_Mess = v_ide_mess;
          
Insert Into Piaf_Adm.Fm_Rnl_Me@lkastweb Select * From Niaba.Fm_Rnl_Me Where Ide_Nd_Emet = '3042'; --And Ide_Mess = v_ide_mess;

execute NIABA.P_TRANSF_CUT_ASTerNDIR_b2 ('3042','2025','26/09/2025')  