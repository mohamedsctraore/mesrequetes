alter session set nls_date_format='DD/MM/RRRR';

-----------------------  ACCD -----------------------
select unique 'exec NIABA.ouvre_jc ('''||ide_gest||''','''||dat_jc||''','''||ide_poste||''')'
from fc_calend_hist
where ide_gest = '2023'
and cod_ferm = 'E'
--and dat_jc <= '31/07/2022'
and ide_poste in (select ide_poste from rm_poste where ide_typ_poste in ('ACCD','AACCD','AACDC'));

select unique 'exec NIABA.Gener_cloture_journee_pc ('''||ide_gest||''','''||ide_poste||''','''||dat_jc||''')'
from fc_calend_hist
where ide_gest = '2023'
and cod_ferm = 'O'
--and dat_jc <= '31/07/2022'
and ide_poste in (select ide_poste from rm_poste where ide_typ_poste in ('ACCD','AACCD','AACDC'))
;

select unique 'exec NIABA.Gener_Demand_Be_Pc_last(''2023'',''31/12/2023'',''02/01/2024'','''||ide_poste||''');'
from fc_ecriture
where ide_gest = '2023'
and flg_cptab = 'O'
and ide_poste in (select ide_poste from rm_poste where ide_typ_poste in ('ACCD','AACCD','AACDC'))
;

-----------------------  PCD EPN -----------------------
select unique 'exec NIABA.ouvre_jc ('''||ide_gest||''','''||dat_jc||''','''||ide_poste||''')'
from fc_calend_hist
where ide_gest = '2023'
and cod_ferm = 'E'
--and dat_jc <= '31/07/2022'
and ide_poste in 
(
select ide_poste from rm_poste where ide_poste_centra in ('510C') 
union 
select ide_poste from rm_poste where ide_typ_poste = 'TC' 
union 
select ide_poste from rm_poste where ide_poste_centra in (select ide_poste from rm_poste where ide_typ_poste = 'TC')
);

select unique 'exec NIABA.Gener_cloture_journee_pc ('''||ide_gest||''','''||ide_poste||''','''||dat_jc||''')'
from fc_calend_hist
where ide_gest = '2023'
and cod_ferm = 'O'
--and dat_jc <= '31/07/2022'
and ide_poste in 
(
select ide_poste from rm_poste where ide_poste_centra in ('510C') 
union 
select ide_poste from rm_poste where ide_typ_poste = 'TC' 
union 
select ide_poste from rm_poste where ide_poste_centra in (select ide_poste from rm_poste where ide_typ_poste = 'TC')
);

select unique 'exec NIABA.Gener_Demand_Be_Pc_last(''2023'','''||max(b.dat_jc)||''',''02/01/2024'','''||a.ide_poste||''');'
from fc_ecriture a
inner join fc_calend_hist b on a.ide_poste = b.ide_poste
and a.ide_gest = b.ide_gest
where a.ide_gest = '2023'
and flg_cptab = 'O'
and a.ide_poste in 
(
select ide_poste from rm_poste where ide_poste_centra in ('510C') 
union 
select ide_poste from rm_poste where ide_typ_poste = 'TC' 
union 
select ide_poste from rm_poste where ide_poste_centra in (select ide_poste from rm_poste where ide_typ_poste = 'TC')
)
group by a.ide_poste
;