select unique 'exec NIABA.Gener_Jpecdepbg_last ('''||ide_poste||''','''||ide_gest||''','''||dat_cad||''')'
from fb_piece
where ide_gest='2022'
and cod_statut in ('RC');


--NIABA.Maj_Manuel_Table_Solde_Cpt_5 ('2022','617C')

select unique 'exec NIABA.Maj_Manuel_Table_Solde_Cpt_5 (''2024'','''||ide_poste||''')'
from rm_poste
where ide_poste in (select ide_poste from rm_poste where ide_typ_poste in ('ACCD','AACCD','AACDC'));


select unique 'exec NIABA.Maj_Manuel_Table_Solde_Cpt_5 (''2024'','''||ide_poste||''');'
from rm_poste
where ide_poste in 
(
select ide_poste from rm_poste where ide_poste_centra in ('510C') 
union 
select ide_poste from rm_poste where ide_typ_poste = 'TC' 
union 
select ide_poste from rm_poste where ide_poste_centra in (select ide_poste from rm_poste where ide_typ_poste = 'TC')
)
and ide_poste not in ('632','687')
;



select unique 'exec NIABA.Verrou_Finmois_pc (''2023'',''31/12/2023'','''||a.ide_poste||''')'
from fc_calend_hist a
inner join fc_ecriture b on a.ide_poste = b.ide_poste and a.ide_gest = b.ide_gest
where a.ide_poste in 
(
select ide_poste from rm_poste where ide_poste_centra in ('510C') 
union 
select ide_poste from rm_poste where ide_typ_poste = 'TC' 
union 
select ide_poste from rm_poste where ide_poste_centra in (select ide_poste from rm_poste where ide_typ_poste = 'TC')
)
and flg_cptab = 'O'
having (max(a.dat_jc) < '31/12/2023')
group by a.ide_poste
;
