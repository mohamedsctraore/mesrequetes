declare
    cursor c_poste is select unique ide_gest, ide_poste, ide_devise from fc_ligne
                  where ide_gest = '2025'
                  and ide_jal = 'TREP'
                  and ide_cpt like '474322%'
                  and cod_sens = 'C'
                  and ide_poste = '460'
                  and ide_devise = 'EUR'
                  order by 2;
                  
    cursor c_reprise(v_poste in varchar2, v_devise in varchar2) is select ide_gest, ide_poste, ide_ecr, ide_ref_piece, cod_ref_piece, mt, mt_dev, ide_devise, ide_cpt
                    from fc_ligne
                    where ide_jal = 'TREP'
                    and ide_gest = '2025'
                    and ide_cpt like '474322%'
                    and cod_sens = 'C'
                    and ide_poste = v_poste
                    and ide_devise = v_devise
                    and ide_ref_piece is not null
                    order by 2,4;
                    
    v_mess piaf_adm.fm_message.ide_mess%type;
    v_libl piaf_adm.fm_message.libl%type;
    v_nbr_piece piaf_adm.fm_message.nbr_piece%type;
    v_ide_ecr piaf_adm.fc_ligne.ide_ecr%type;
    v_libn piaf_adm.fc_ecriture.libn%type;
    v_mandat varchar2(50);
    v_nv_cod_ref_piece piaf_adm.fc_ligne.cod_ref_piece%type;
    v_nv_cpt piaf_adm.fc_ligne.ide_cpt%type;
                
begin   
        for param_poste in c_poste
            loop    
                select count(ide_ecr) into v_nbr_piece from fc_ligne where ide_gest = param_poste.ide_gest and ide_poste = param_poste.ide_poste and ide_cpt = '474321101' and ide_devise = param_poste.ide_devise;
                v_libl := 'BASCULEMENT DES COMPTES 474322 AU 474323 ' ||  param_poste.ide_devise;
                select nvl(max(ide_mess) + 1,1) into v_mess from fm_message where ide_nd_emet = param_poste.ide_poste and flg_emis_recu = 'R';
                insert into fm_message values ('R','P',param_poste.ide_poste, v_mess,'P',param_poste.ide_poste,v_mess,null,null,param_poste.ide_gest,'O',null,null,null,null,null,null,null,null,'8',v_libl,100, null,v_nbr_piece,'1.0',1,1,0,0,sysdate,'BASCUL',sysdate,'BASCUL','BASCUL');
                insert into fm_rnl_me values ('P',param_poste.ide_poste,v_mess,'P',param_poste.ide_poste,'R','AC',0,sysdate,'BASCUL',sysdate,'BASCUL','BASCUL');
                commit;
                dbms_output.put_line(param_poste.ide_poste || ' - ' || v_mess || ' - ' || v_nbr_piece);
            for param_ligne in c_reprise(param_poste.ide_poste, param_poste.ide_devise)
                loop
                    
                    select ide_piece into v_mandat from fc_ref_piece where ide_ref_piece = param_ligne.ide_ref_piece and ide_poste = param_ligne.ide_poste;
                    v_libn := 'BASCULENT DU MANDAT N° ' || v_mandat;
                    v_nv_cod_ref_piece := replace(param_ligne.cod_ref_piece,'BGDEP-2024','BGDEP-2025');
                    v_nv_cpt := replace(param_ligne.ide_cpt,'474322','474323');
                    select nvl(max(ide_ecr) + 1,1) into v_ide_ecr from fc_ligne where ide_gest = param_ligne.ide_gest and flg_cptab = 'N' and ide_poste = param_ligne.ide_poste;
                    insert into fc_ecriture values (param_ligne.ide_poste, param_ligne.ide_gest, 'A29','N', v_ide_ecr, null, 'C2020','6','P',param_ligne.ide_poste,v_mess,'R',v_libn,sysdate,null,'AC',null,null,null,null,null,null,sysdate,'BASCUL',sysdate,'BASCUL','BASCUL',null,null,null,null);
                    insert into fc_ligne values(param_ligne.ide_poste, param_ligne.ide_gest,'A29','N',v_ide_ecr,1,'C2020',null,null,param_ligne.ide_cpt,param_ligne.ide_ref_piece,param_ligne.cod_ref_piece,null,null,null,null,'D',param_ligne.mt,null,null,null,v_libn,null,null,'6','A','D 47432XX P',null,'02/01/2025',null,null,null,sysdate,'BASCUL',sysdate,'BASCUL','BASCUL','N',null,null,param_ligne.ide_devise,null,param_ligne.mt_dev,null,null,null);
                    insert into fc_ligne values(param_ligne.ide_poste, param_ligne.ide_gest,'A29','N',v_ide_ecr,2,'C2020',null,null,v_nv_cpt,null,v_nv_cod_ref_piece,null,null,null,null,'C',param_ligne.mt,null,null,null,v_libn,null,null,'6','A','C 47432XX P',null,'02/01/2025',null,null,null,sysdate,'BASCUL',sysdate,'BASCUL','BASCUL','N',null,null,param_ligne.ide_devise,null,param_ligne.mt_dev,null,null,null);
                    commit;
                    dbms_output.put_line(v_mess || ' - ' || v_mandat || ' - ' || v_ide_ecr);
                end loop;
                
        end loop;
        
        EXCEPTION
        WHEN NO_DATA_FOUND THEN
            dbms_output.put_line('error no data found');
            --continue;
            RAISE;
        WHEN OTHERS THEN
            dbms_output.put_line('error others');
            RAISE;
        

end;


select unique ide_gest, ide_poste, ide_devise from fc_ligne
                  where ide_gest = '2025'
                  and ide_jal = 'TREP'
                  and ide_cpt = '474321101'
                  and cod_sens = 'C'
                  --and ide_poste = '403'
                  and ide_ref_piece is not null
                  order by 2;