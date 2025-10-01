select *
from fc_ligne a, fc_calend_hist b
where a.dat_ecr = b.dat_jc
and a.ide_poste = b.ide_poste
and a.ide_gest = '2022'
and a.dat_maj like '%07/12/22%'
and a.ide_poste not like '%C'
and a.ide_cpt like '390%'
and a.ide_cpt not in ('39031','39032')
and a.dat_centra is null
and a.flg_cptab = 'O'
and b.cod_ferm = 'C';