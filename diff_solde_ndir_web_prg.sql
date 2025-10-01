declare 
    cursor c_poste is select unique ide_poste from fc_ecriture where flg_cptab = 'O' and ide_gest = '2024';
    v_poste piaf_adm.fc_ecriture.ide_poste%type;
begin

    delete from diff_ndir_web;
    open c_poste;
    
    loop 
        fetch c_poste into v_poste;
        exit when c_poste%NOTFOUND;
        
        insert into diff_ndir_web
        select 'ndir-trep' cible, ide_poste, dat_ecr, sum(mt) mt from fc_ligne@asterv4
        where ide_gest = '2024'
        and ide_poste = v_poste
        and cod_sens = 'C'
        and dat_ecr <= '30/08/2024'
        group by ide_poste,dat_ecr
        union
        select 'web-trep' cible, ide_poste, dat_ecr, sum(mt) from fc_ligne
        where ide_gest = '2024'
        and ide_poste = v_poste
        and cod_sens = 'C'
        and dat_ecr <= '30/08/2024'
        group by ide_poste,dat_ecr
        ;
        
        commit;        
    end loop; 

    

end;