alter session set nls_date_format='DD/MM/RRRR';

select unique 'exec NIABA.Gener_cloture_journee_pc ('''||ide_gest||''','''||a.ide_poste||''','''||dat_jc||''')'
from fc_calend_hist a
inner join rm_poste b on a.ide_poste = b.ide_poste
where ide_gest = '2022'
and cod_ferm = 'O'
--and dat_jc <= '31/07/2022'
--and a.ide_poste  like '2%'
and ide_typ_poste not in ('P', 'PC');






select unique 'exec NIABA.ouvre_jc ('''||ide_gest||''','''||dat_jc||''','''||ide_poste||''')'
from fc_calend_hist
where ide_gest = '2022'
and cod_ferm = 'E'
and ide_poste = '242C';


