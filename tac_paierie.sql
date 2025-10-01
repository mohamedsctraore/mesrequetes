alter session set nls_date_format = 'DD/MM/RRRR';

declare
v_ide_poste PIAF_ADM.rm_poste.ide_poste%TYPE;
cursor c_paierie is select ide_poste from rm_poste where ide_typ_poste = 'P';

begin

delete from tac_paierie;

open c_paierie;

loop 
        fetch c_paierie into v_ide_poste;
        exit when c_paierie%NOTFOUND;
        
        insert into tac_paierie
        select unique b.libn as IDE_POSTE,
                      nvl((select to_char(max(dat_jc)) from fc_calend_hist where ide_gest = '2024' and ide_poste = v_ide_poste  and cod_ferm = 'C'),'Pas de journee clotur»e')  as ETAT_CLOTURE,
                      nvl((select to_char(max(dat_jc)) from fc_calend_hist where ide_gest = '2024' and ide_poste = v_ide_poste and cod_ferm = 'O'),'Pas de journee ouverte') as ETAT_OUVERT,
                      nvl((select to_char(max(dat_jc)) from fc_ecriture where ide_gest = '2024' and ide_poste = v_ide_poste and flg_cptab = 'O'), 'Aucune comptabilisation') as ETAT_COMPTABILISE,
                      nvl((select unique cod_ferm from fc_calend_hist where ide_gest = '2024' and ide_poste = v_ide_poste and cod_ferm = 'O'),'C') CODE

        from fc_calend_hist a, rm_noeud b, fc_ecriture c
        where a.ide_poste = b.ide_nd
          and a.ide_gest = c.ide_gest
          and a.ide_poste = c.ide_poste
          and a.ide_gest = '2024'
          and a.ide_poste = v_ide_poste
          ;
        
        commit;        
    end loop;
          
          
end;


select * from tac_paierie
order by ide_poste;