----Select * From Fc_Ecriture_Cut_Ndir
Update Fc_Ecriture_Cut_Ndir Set Ide_Mess = 18305 Where ide_poste = '626' And Ide_Mess = 1;--And Ide_Mess In (879779,879780,879781,879782,879783,879784,879785);

Insert Into Piaf_Adm.Fm_Message@lkastweb Select * From Niaba.Fm_Message Where Ide_Nd_Emet = '626'; --And Ide_Mess = v_ide_mess;
          
Insert Into Piaf_Adm.Fm_Rnl_Me@lkastweb Select * From Niaba.Fm_Rnl_Me Where Ide_Nd_Emet = '626'; --And Ide_Mess = v_ide_mess;

execute NIABA.P_TRANSF_CUT_ASTerNDIR_b2 ('626','2025','20/10/2025')

select * from fm_message@lkastweb where ide_gest = '2025' and ide_nd_emet = '639' order by ide_mess desc, flg_emis_recu;