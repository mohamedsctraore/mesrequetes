alter session set nls_date_format='DD/MM/RRRR';

select unique 'exec NIABA.ouvre_jc ('''||ide_gest||''','''||dat_jc||''','''||ide_poste||''')'
from fc_calend_hist
where ide_gest = '2024'
and cod_ferm = 'E'
and to_char(dat_maj, 'dd/mm/yyyy') <> to_date(sysdate,'dd/mm/rrrr');
;

select unique 'exec NIABA.Gener_cloture_journee_pc ('''||ide_gest||''','''||ide_poste||''','''||dat_jc||''')'
from fc_calend_hist
where ide_gest = '2024'
and cod_ferm = 'E'
and to_char(dat_maj, 'dd/mm/yyyy') <> to_date(sysdate,'dd/mm/rrrr');