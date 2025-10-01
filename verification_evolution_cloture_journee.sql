select ide_poste,dat_jc,cod_ferm,dat_maj from fc_calend_hist
where uti_maj='AMANI' and
dat_maj like '04/09/%'
and ide_gest='2021'
and cod_ferm like 'O'
order by cod_ferm,ide_poste,dat_jc
;