declare
    v_mt piaf_adm.fc_ligne.mt%type;
    v_cod_sens piaf_adm.fc_ligne.cod_sens%type;
    
    cursor c_ref_piece is select ide_gest v_ide_gest, ide_poste v_poste, ide_ref_piece v_ide_ref_piece, cod_ref_piece v_cod_ref_piece, var_tiers v_var_tiers, ide_tiers v_ide_tiers, ide_ecr v_ide_ecr, ide_jal v_ide_jal, ide_lig v_ide_lig
                        from fc_ref_piece 
                        where (ide_gest, ide_poste, ide_ref_piece, cod_ref_piece)
                        in
                        (
                            select a.ide_gest, a.ide_poste, ide_ref_piece, cod_ref_piece
                            from fc_ligne a, fn_compte b
                            where a.ide_cpt = b.ide_cpt 
                            and ide_gest in ('2025')
                            and ide_poste in ('3086')
                            and flg_cptab = 'O'
                            and a.ide_cpt in (select ide_cpt from fn_compte where flg_justif = 'O')
                            group by a.ide_gest, a.ide_poste, ide_ref_piece, cod_ref_piece
                            having sum(decode(cod_sens,'C', mt, -mt)) <> 0
                        )
                        --and ide_poste <> '684'
                        and (mt_db = 0 and mt_cr = 0)
                        and to_date(dat_cre,'dd/mm/rrrr') > to_date('01/01/2025','dd/mm/rrrr')
                        ;
begin
    for param_ligne in c_ref_piece
       loop
            select mt, cod_sens into v_mt, v_cod_sens from fc_ligne
            where ide_gest = param_ligne.v_ide_gest
            and ide_jal = param_ligne.v_ide_jal
            and ide_poste = param_ligne.v_poste
            and ide_ref_piece = param_ligne.v_ide_ref_piece
            and cod_ref_piece = param_ligne.v_cod_ref_piece
            --and var_tiers = param_ligne.v_var_tiers
            --and ide_tiers = param_ligne.v_ide_tiers
            and ide_ecr = param_ligne.v_ide_ecr
            and ide_lig = param_ligne.v_ide_lig
            ;
            
           --dbms_output.put_line('IDE_POSTE ' || param_ligne.v_poste || ' - IDE_REF_PIECE : ' || param_ligne.v_ide_ref_piece || ' - MONTANT : ' || v_mt || ' - COD SENS : ' || v_cod_sens);
           
           if (v_cod_sens = 'C') then
               update fc_ref_piece set mt_cr = v_mt, mt_dev = v_mt, flg_solde = 'N'
               where ide_gest = param_ligne.v_ide_gest
               and ide_jal = param_ligne.v_ide_jal
               and ide_poste = param_ligne.v_poste
               and ide_ref_piece = param_ligne.v_ide_ref_piece
               and cod_ref_piece = param_ligne.v_cod_ref_piece
               --and var_tiers = param_ligne.v_var_tiers
               --and ide_tiers = param_ligne.v_ide_tiers
               and ide_ecr = param_ligne.v_ide_ecr
               and ide_lig = param_ligne.v_ide_lig
               ;
           elsif (v_cod_sens = 'D') then
                update fc_ref_piece set mt_db = v_mt, mt_dev = v_mt, flg_solde = 'N'
                where ide_gest = param_ligne.v_ide_gest
                and ide_jal = param_ligne.v_ide_jal
                and ide_poste = param_ligne.v_poste
                and ide_ref_piece = param_ligne.v_ide_ref_piece
                and cod_ref_piece = param_ligne.v_cod_ref_piece
                --and var_tiers = param_ligne.v_var_tiers
                --and ide_tiers = param_ligne.v_ide_tiers
                and ide_ecr = param_ligne.v_ide_ecr
                and ide_lig = param_ligne.v_ide_ecr
                ;
           end if;
           
       end loop;
       
      commit;

   EXCEPTION
     WHEN NO_DATA_FOUND THEN
       NULL;
     WHEN OTHERS THEN
       -- Consider logging the error and then re-raise
       RAISE;
end;


select * from fc_ref_piece 
                        where (ide_gest, ide_poste, ide_ref_piece, cod_ref_piece)
                        in
                        (
                            select a.ide_gest, a.ide_poste, ide_ref_piece, cod_ref_piece
                            from fc_ligne a, fn_compte b
                            where a.ide_cpt = b.ide_cpt 
                            --and ide_gest = '2025'
                            --and ide_poste in ('502')
                            and flg_cptab = 'O'
                            and a.ide_cpt in (select ide_cpt from fn_compte where flg_justif = 'O')
                            group by a.ide_gest, a.ide_poste, ide_ref_piece, cod_ref_piece
                            having sum(decode(cod_sens,'C', mt, -mt)) <> 0
                        )
                        --and mt_cr - mt_db = 0
                        and (mt_db = 0 and mt_cr = 0)
                        and dat_cre > '01/01/2025'
                        order by ide_poste, ide_ref_piece
                        ;
                        
                        
select ide_gest, ide_nd_emet, ide_mess from fm_message 
                where (ide_gest, ide_nd_emet, ide_mess) in
                (
                    select unique ide_gest v_gest, ide_nd_emet v_nd_emet, ide_mess v_mess
                    from fc_ecriture
                    where ide_gest = '2024'
                    AND ide_jal in ('JCENTRAL')
                    and flg_cptab = 'N'
                )
                and cod_typ_mess = 11
                and flg_emis_recu = 'R'
                group by ide_gest, ide_nd_emet, ide_mess
                having count(ide_mess) = 1
                order by ide_nd_emet, ide_mess
                ;