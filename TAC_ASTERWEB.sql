CREATE OR REPLACE PROCEDURE PIAF_ADM.TAC_ASTERWEB(sortie OUT SYS_REFCURSOR) IS
v_ide_poste PIAF_ADM.rm_poste.ide_poste%TYPE;
--cursor c_paierie is select ide_poste from rm_poste where ide_typ_poste = 'P';
cursor c_paierie is select unique ide_poste from fc_ecriture where ide_gest = '2024' and flg_cptab = 'O';

begin

Execute Immediate 'alter session set nls_date_format = ''DD/MM/RRRR''';

delete from e000618.tac_paierie;

open c_paierie;

loop 
        fetch c_paierie into v_ide_poste;
        exit when c_paierie%NOTFOUND;
        
        insert into e000618.tac_paierie
        select unique b.libn as IDE_POSTE,
                      nvl((select to_char(max(dat_jc)) from fc_calend_hist where ide_gest = '2024' and ide_poste = v_ide_poste  and cod_ferm = 'C'),'Pas de journee cloturÈe')  as ETAT_CLOTURE,
                      nvl((select to_char(max(dat_jc)) from fc_calend_hist where ide_gest = '2024' and ide_poste = v_ide_poste and cod_ferm = 'O'),'Pas de journee ouverte') as ETAT_OUVERT,
                      nvl((select to_char(max(dat_jc)) from fc_ecriture where ide_gest = '2024' and ide_poste = v_ide_poste and flg_cptab = 'O' and ide_jal not in ('JPECDEPBG')), 'Aucune comptabilisation') as ETAT_COMPTABILISE,
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
    
    open sortie for
    select ide_typ_poste, ide_poste_centra, ide_nd, a.ide_poste, etat_cloture, etat_ouvert, etat_comptabilise, code 
    from e000618.tac_paierie a, rm_noeud b, rm_poste c
    where a.IDE_POSTE = b.libn
    and b.IDE_ND = c.ide_poste
    and ide_nd not like '%C'
    --and to_date(etat_comptabilise, 'dd/mm/rrrr') >= '05/08/2024'
    order by ide_typ_poste, ide_nd;
          
end;


select ide_typ_poste, ide_poste_centra, ide_nd, a.ide_poste, etat_cloture, etat_ouvert, etat_comptabilise, code 
from e000618.tac_paierie a, rm_noeud b, rm_poste c
where a.IDE_POSTE = b.libn
and b.IDE_ND = c.ide_poste
and ide_nd not like '%C'
--and to_date(etat_comptabilise, 'dd/mm/rrrr') >= '05/08/2024'
order by ide_typ_poste, ide_nd;
--to_date(ETAT_COMPTABILISE, 'DD/MM/RRRR') desc, 

select ide_typ_poste, count(etat_comptabilise)
from e000618.tac_paierie a, rm_noeud b, rm_poste c
where a.IDE_POSTE = b.libn
and b.IDE_ND = c.ide_poste
and ide_nd not like '%C'
--and to_date(etat_comptabilise, 'dd/mm/rrrr') >= '05/08/2024'
group by ide_typ_poste 
order by ide_typ_poste;