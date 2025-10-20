alter session set nls_date_format='DD/MM/RRRR';

select unique 'exec NIABA.ouvre_jc ('''||ide_gest||''','''||dat_jc||''','''||ide_poste||''')'
from fc_calend_hist
where ide_gest = '2025'
and cod_ferm = 'O'
and dat_jc <= '31/03/2025'
--and ide_poste in (select unique poste from centra_a_denouer)
--and to_char(dat_maj, 'dd/mm/yyyy') <> '16/09/2024'
--and dat_jc >= '01/08/2024' and dat_jc <= '31/08/2024'
--and ide_poste = '201C'
--and (dat_maj like '04/08/22%' or dat_maj like '03/08/22%');
and (ide_poste not like '%C' and ide_poste not like '5%')
;


select unique 'exec NIABA.Gener_cloture_journee_pc_bis ('''||ide_gest||''','''||dat_jc||''','''||ide_poste||''')'
from fc_calend_hist
where ide_gest = '2025'
and cod_ferm = 'O'
and dat_jc <= '30/09/2025'
--and (ide_poste not like '5%' and ide_poste not like '%C')
and ide_poste not like '5%'
--and to_char(dat_maj, 'dd/mm/yyyy') <> '16/09/2024'
;

select unique 'exec NIABA.Gener_cloture_journee_pc ('''||ide_gest||''','''||a.ide_poste||''','''||dat_jc||''')'
from fc_calend_hist a
inner join rm_poste b on a.ide_poste = b.ide_poste
where ide_gest = '2022'
and cod_ferm = 'O'
and dat_jc <= '31/07/2022'
and a.ide_poste  like '2%'
and ide_typ_poste in ('ACP', 'ACPC', 'C2D');



select unique 'exec NIABA.ouvre_jc ('''||2022||''',''31/07/2022'','''||poste||''')'
from centra_a_denouer;
--and (ide_poste not like '%C' and ide_poste not like '5%');

select *
from centra_a_denouer;

