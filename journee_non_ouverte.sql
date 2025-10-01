select ide_poste, dat_jc, cod_ferm from fc_calend_hist
where ide_gest='2021'
and dat_maj like '02/09/%'
and cod_ferm not like 'O'
order by ide_poste, dat_jc
;