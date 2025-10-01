select distinct 'exec NIABA.Gener_cloture_journee_pc (''2021'','''||ide_poste||''','''||dat_jc||''')'''
from fc_calend_hist
where ide_poste like '%C'
and cod_ferm='O'
and dat_jc between '01/01/2021' and '30/11/2021'