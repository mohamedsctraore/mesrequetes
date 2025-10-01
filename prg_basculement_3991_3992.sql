drop table c_rep_paierie;

create table c_rep_paierie as
select ide_poste pc_code, b.libn libelle_poste, a.ide_cpt compte, c.libn libelle_compte, sum(decode(cod_sens, 'D', mt, -mt)) solde                                 
from fc_ligne a
inner join rm_noeud b on ide_poste = ide_nd
inner join fn_compte c on a.ide_cpt = c.ide_cpt
where ide_gest = '2024'
and flg_cptab = 'O'
--and ide_poste in ('429','442','435','406')
and a.ide_cpt in 
(
'3991','3992'
)
group by ide_poste, b.libn, a.ide_cpt, c.libn
having sum(decode(cod_sens, 'D', mt, -mt)) <> 0
order by a.ide_cpt, a.ide_poste
;


select pc_code ide_poste, libelle_poste v_libelle, compte v_compte, libelle_compte v_lib_compte, solde v_solde from c_rep_paierie 
    order by 1,3;

Declare
    cursor c_poste is select unique pc_code ide_poste from c_rep_paierie where pc_code = '460'
                  order by 1;
                  
    cursor c_reprise(v_poste varchar2) is select pc_code ide_poste, libelle_poste v_libelle, compte v_compte, libelle_compte v_lib_compte, solde v_solde from c_rep_paierie 
    where pc_code = '460'
    ;
                    
    v_mess piaf_adm.fm_message.ide_mess%type;
    v_libl piaf_adm.fm_message.libl%type;
    v_nbr_piece piaf_adm.fm_message.nbr_piece%type;
    v_ide_ecr piaf_adm.fc_ligne.ide_ecr%type;
    v_libn_1 piaf_adm.fc_ecriture.libn%type;
    --v_nv_cpt_1 piaf_adm.fc_ligne.ide_cpt%type;
    v_cpt_debit piaf_adm.fc_ligne.ide_cpt%type;
    v_cpt_credit piaf_adm.fc_ligne.ide_cpt%type;
                
begin   
        for param_poste in c_poste
            loop    
                v_libl := 'REVERSEMENT SOLDE 3991 | 3992';
                select max(ide_mess) + 1 into v_mess from fm_message where ide_nd_emet = param_poste.ide_poste and flg_emis_recu = 'R';
                insert into fm_message values ('R','P',param_poste.ide_poste, v_mess,'P',param_poste.ide_poste,v_mess,null,null,'2024','O',null,null,null,null,null,null,null,null,'8',v_libl,100, null,1,'1.0',1,1,0,0,sysdate,'BASCUL',sysdate,'BASCUL','BASCUL');
                insert into fm_rnl_me values ('P',param_poste.ide_poste,v_mess,'P',param_poste.ide_poste,'R','AC',0,sysdate,'BASCUL',sysdate,'BASCUL','BASCUL');
                commit;
                dbms_output.put_line(param_poste.ide_poste || ' - ' || v_mess);
            for param_ligne in c_reprise(param_poste.ide_poste)
                loop
                    v_libn_1 := 'REVERSEMENT DU SOLDE DU ' || param_ligne.v_compte || ' A LACCT-C';
                    v_cpt_debit := '3903068211';
                    v_cpt_credit := '3903051191';
                    
                    select nvl(max(ide_ecr) + 1,1) into v_ide_ecr from fc_ligne where ide_gest = '2024' and flg_cptab = 'N' and ide_poste = param_ligne.ide_poste;
                    insert into fc_ecriture values (param_ligne.ide_poste, '2024', 'A29','N', v_ide_ecr, null, 'C2020','6','P',param_ligne.ide_poste,v_mess,'R',v_libn_1,sysdate,null,'AC',null,null,null,null,null,null,sysdate,'BASCUL',sysdate,'BASCUL','BASCUL',null,null,null,null);
                    commit;
                    IF param_ligne.v_solde > 0 THEN
                        insert into fc_ligne values(param_ligne.ide_poste, '2024','A29','N',v_ide_ecr,1,'C2020',null,null,v_cpt_debit,null,null,null,null,null,null,'D',abs(param_ligne.v_solde),'39111','131','501C',v_libn_1,null,null,'6','A','D 3903068211',null,'31/12/2024',null,null,null,sysdate,'BASCUL',sysdate,'BASCUL','BASCUL','N',null,null,null,null,abs(param_ligne.v_solde),null,null,null);
                        insert into fc_ligne values(param_ligne.ide_poste, '2024','A29','N',v_ide_ecr,2,'C2020',null,null,param_ligne.v_compte,null,null,null,null,null,null,'C',abs(param_ligne.v_solde),null,null,null,v_libn_1,null,null,'6','A','C ' || param_ligne.v_compte,null,'31/12/2024',null,null,null,sysdate,'BASCUL',sysdate,'BASCUL','BASCUL','N',null,null,null,null,abs(param_ligne.v_solde),null,null,null);
                        commit;
                    ELSE
                        insert into fc_ligne values(param_ligne.ide_poste, '2024','A29','N',v_ide_ecr,1,'C2020',null,null,v_cpt_credit,null,null,null,null,null,null,'C',abs(param_ligne.v_solde),'39112','131','501C',v_libn_1,null,null,'6','A','C 3903051191',null,'31/12/2024',null,null,null,sysdate,'BASCUL',sysdate,'BASCUL','BASCUL','N',null,null,null,null,abs(param_ligne.v_solde),null,null,null);
                        insert into fc_ligne values(param_ligne.ide_poste, '2024','A29','N',v_ide_ecr,2,'C2020',null,null,param_ligne.v_compte,null,null,null,null,null,null,'D',abs(param_ligne.v_solde),null,null,null,v_libn_1,null,null,'6','A','D ' || param_ligne.v_compte,null,'31/12/2024',null,null,null,sysdate,'BASCUL',sysdate,'BASCUL','BASCUL','N',null,null,null,null,abs(param_ligne.v_solde),null,null,null);
                        commit;
                    END IF;
                    dbms_output.put_line(param_ligne.ide_poste || ' - ' || v_mess || ' - ' || v_ide_ecr || ' - ' || param_ligne.v_compte);
                end loop;
                
        end loop;
        
        EXCEPTION
        WHEN NO_DATA_FOUND THEN
            dbms_output.put_line('error no data found');
            RAISE;
            --continue;
        WHEN OTHERS THEN
            dbms_output.put_line('error others');
            RAISE;
        

end;

select * from fc_ligne where ide_ecr in (3,4) and ide_poste = '445' and ide_jal = 'A29' and ide_gest = '2023' order by ide_ecr, cod_sens desc;
select * from fc_ligne where ide_ecr = 4 and ide_poste = '445' and ide_jal = 'A29' and ide_gest = '2023';
select * from fc_ecriture where ide_gest = '2023' and ide_poste = '445' and ide_mess = 6;