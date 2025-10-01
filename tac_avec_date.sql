Alter session set nls_date_format = 'DD/MM/RRRR';

Declare
    v_ide_poste PIAF_ADM.rm_poste.ide_poste%TYPE;
    v_date date;
    Cursor c_paierie is Select ide_poste From Rm_Poste --where ide_typ_poste in ('ACCD','AACCD','AACDC')
;

Begin

Delete From tac_accd;

v_date := '30/04/2025';

Open c_paierie;

Loop 
        Fetch c_paierie into v_ide_poste;
        Exit when c_paierie%NOTFOUND;
        
        Insert into tac_accd
        Select unique b.libn as IDE_POSTE,
                      nvl((select to_char(max(dat_jc)) from fc_calend_hist where ide_gest = '2025' and ide_poste = v_ide_poste  and cod_ferm = 'C' and dat_jc <= v_date),'Pas de journee cloturÈe')  as ETAT_CLOTURE,
                      nvl((select to_char(max(dat_jc)) from fc_calend_hist where ide_gest = '2025' and ide_poste = v_ide_poste and cod_ferm = 'O' and dat_jc <= v_date),'Pas de journee ouverte') as ETAT_OUVERT,
                      nvl((select to_char(max(dat_jc)) from fc_ecriture where ide_gest = '2025' and ide_poste = v_ide_poste and flg_cptab = 'O' and dat_jc <= v_date), 'Aucune comptabilisation') as ETAT_COMPTABILISE,
                      nvl((select unique cod_ferm from fc_calend_hist where ide_gest = '2025' and ide_poste = v_ide_poste and cod_ferm = 'O' and dat_jc <= v_date),'C') CODE,
                      nvl((select count(ide_poste) from fc_calend_hist where ide_gest = '2025' and cod_ferm = 'O' and ide_poste = v_ide_poste and dat_jc <= v_date), 0) JRNES_OUVERTES

        From fc_calend_hist a, rm_noeud b, fc_ecriture c
        Where a.ide_poste = b.ide_nd
          and a.ide_gest = c.ide_gest
          and a.ide_poste = c.ide_poste
          and a.ide_gest = '2025'
          and a.ide_poste = v_ide_poste
          ;
        
        Commit;        
    End loop;
          
          
End;


Select ide_nd, a.ide_poste, etat_cloture, etat_ouvert, etat_comptabilise, code, JRNES_OUVERTES
From tac_accd a,rm_noeud b, rm_poste d
Where a.ide_poste (+) = b.libn
And b.ide_nd = d.ide_poste
--and d.ide_poste in (select ide_poste from rm_poste where ide_typ_poste in ('ACCD','AACCD','AACDC'))
And a.ide_poste is not null
Order by a.ide_poste;