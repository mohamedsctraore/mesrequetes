alter session set nls_date_format = 'DD/MM/RRRR';

declare
v_ide_poste PIAF_ADM.rm_poste.ide_poste%TYPE;
cursor c_paierie is select ide_poste from rm_poste where ide_typ_poste in ('ACCD','AACCD','AACDC');

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
                      nvl((select unique cod_ferm from fc_calend_hist where ide_gest = '2024' and ide_poste = v_ide_poste and cod_ferm = 'O'),'C') CODE,
                      nvl((select count(ide_poste) from fc_calend_hist where ide_gest = '2024' and cod_ferm = 'O'), 0) JRNES_OUVERTES

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


select ide_nd, a.ide_poste, etat_cloture, etat_ouvert, etat_comptabilise, code, (select count(ide_poste) from fc_calend_hist where cod_ferm = 'O') nbre_journee_ouvertes
from tac_paierie a,rm_noeud b, fc_calend_hist c, rm_poste d
where a.ide_poste (+) = b.libn
and b.ide_nd = c.ide_poste
and b.ide_nd = d.ide_poste
and c.cod_ferm = 'O'
and d.ide_poste in (select ide_poste from rm_poste where ide_typ_poste in ('ACCD','AACCD','AACDC'))
group by ide_nd, a.ide_poste, etat_cloture, etat_ouvert, etat_comptabilise, code
order by a.ide_poste;