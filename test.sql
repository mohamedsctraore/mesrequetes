DECLARE
    Cursor c_balais is
    Select * From Fm_Message Where Ide_Nd_Emet = '501' And Libl Like 'CUT-DEBITS CONFIRMATION PAIEMENT DU%';

    v_ide_mess Niaba.Fm_Message.Ide_mess%type;
BEGIN
    Execute Immediate 'alter session set nls_date_format = ''DD/MM/RRRR''';
    
    FOR ligne IN c_balais LOOP
        BEGIN
            -- Traitement
          DBMS_OUTPUT.PUT_LINE('Message Base Tampon : ' || ligne.ide_mess);
          Select max(ide_mess) + 1 into v_ide_mess from fm_message@lkastweb where Ide_Nd_Emet = '501';
          DBMS_OUTPUT.PUT_LINE('Message Base AsterWeb : ' || v_ide_mess);
          
          Update Fm_Message Set Ide_Mess = v_ide_mess, Ref_Mess = v_ide_mess
          Where Ide_Nd_Emet = '501'
          And Ide_Mess = ligne.ide_mess;
          
          Insert Into Piaf_Adm.Fm_Message@lkastweb
          Select * From Niaba.Fm_Message
          Where Ide_Nd_Emet = '501'
          And Ide_Mess = v_ide_mess;
          
          Update Fc_Ecriture_Cut_Ndir Set Ide_Mess = v_ide_mess
          Where ide_poste = '501'
          And Ide_Mess = ligne.ide_mess;
          
          NIABA.P_TRANSF_CUT_ASTerNDIR_b2('501','2025',To_Date(substr(ligne.libl,-10)));
          
          COMMIT;
          
          EXCEPTION 
                WHEN NO_DATA_FOUND THEN
                    DBMS_OUTPUT.PUT_LINE('Aucune donnée trouvée pour cet ID.');
      
        END;
      
    END LOOP;

END;