declare    
    cursor c_balais is select ide_poste v_poste, ide_cpt v_cpt, 
    sum(decode(cod_sens, (select cod_sens_solde from rc_droit_compte where ide_typ_poste = 'P' and ide_cpt = a.ide_cpt), mt_dev, -mt_dev)) mt_dev, 
    sum(decode(cod_sens, (select cod_sens_solde from rc_droit_compte where ide_typ_poste = 'P' and ide_cpt = a.ide_cpt), mt, -mt)) mt 
    from fc_ligne a
    where ide_gest = '2025'
    and ide_cpt in (select ide_cpt from fn_compte where flg_justif = 'O')
    and ide_poste in (select ide_poste from rm_poste where ide_typ_poste = 'P')
    group by ide_poste, ide_cpt
    having (sum(decode(cod_sens, (select cod_sens_solde from rc_droit_compte where ide_typ_poste = 'P' and ide_cpt = a.ide_cpt), mt_dev, -mt_dev)) = 0 and sum(decode(cod_sens, (select cod_sens_solde from rc_droit_compte where ide_typ_poste = 'P' and ide_cpt = a.ide_cpt), mt, -mt)) <> 0)
    order by ide_poste, ide_cpt
    ;
    
    cursor c_detail(v_poste varchar2, v_cpt varchar2) is select ide_poste, ide_cpt, ide_ref_piece, 
    sum(decode(cod_sens, (select cod_sens_solde from rc_droit_compte where ide_typ_poste = 'P' and ide_cpt = a.ide_cpt), mt_dev, -mt_dev)) mt_dev, 
    sum(decode(cod_sens, (select cod_sens_solde from rc_droit_compte where ide_typ_poste = 'P' and ide_cpt = a.ide_cpt), mt, -mt)) mt 
    from fc_ligne a
    where ide_gest = '2025'
    and ide_cpt in (select ide_cpt from fn_compte where flg_justif = 'O')
    and ide_poste in (select ide_poste from rm_poste where ide_typ_poste = 'P')
    and ide_poste = v_poste
    and ide_cpt = v_cpt
    group by ide_poste, ide_cpt, ide_ref_piece
    having (sum(decode(cod_sens, (select cod_sens_solde from rc_droit_compte where ide_typ_poste = 'P' and ide_cpt = a.ide_cpt), mt_dev, -mt_dev)) = 0 and sum(decode(cod_sens, (select cod_sens_solde from rc_droit_compte where ide_typ_poste = 'P' and ide_cpt = a.ide_cpt), mt, -mt)) <> 0)
    order by ide_poste, ide_cpt, ide_ref_piece;
    
    v_devise piaf_adm.fc_ref_piece.val_taux%type;
begin
    
    for ligne in c_balais
        loop
            begin
            for detail in c_detail(ligne.v_poste, ligne.v_cpt)
                loop
                    Select Nvl(Val_taux, 0) Into v_devise From Fc_Ref_Piece Where Ide_Poste = detail.ide_poste and ide_ref_piece = detail.ide_ref_piece;
                    
                    begin
                        dbms_output.put_line(detail.ide_poste || ' ' || detail.ide_cpt || ' ' || detail.ide_ref_piece || ' ' ||  v_devise || ' ' || detail.mt);
                        
                    exception 
                        When NO_DATA_FOUND then
                            dbms_output.put_line('Erreur ' || detail.ide_poste || ' ' || detail.ide_cpt || ' ' || detail.ide_ref_piece || ' ' ||  v_devise);
                    end;

                end loop;
                
            exception 
                When NO_DATA_FOUND then
                dbms_output.put_line('Erreur ' || ligne.v_poste || ' ' || ligne.v_cpt);
            end;
            
        end loop;
   
end;