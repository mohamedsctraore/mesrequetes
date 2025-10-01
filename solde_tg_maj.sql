declare
    var_ide_poste piaf_adm.rm_poste.ide_poste%TYPE;
    cursor c_infos is select unique ide_poste from piaf_adm.fc_ecriture where flg_cptab = 'O' and ide_gest = '2024';
begin
    
    open c_infos;
    
    loop 
        fetch c_infos into var_ide_poste;
        exit when c_infos%NOTFOUND;
        
        NIABA.Maj_Manuel_Table_Solde_Cpt_5 ('2024',var_ide_poste);
        
        commit;        
    end loop;
    
end;