select
'exec niaba.ouvre_jc ('''||2021||''','''||dat_jc||''','''||ide_poste||''');'
FROM fc_calend_hist
WHERE
ide_gest='2021'
and dat_maj like '03/09/%' or dat_maj like '02/09/%'
and cod_ferm='E'
order by ide_poste, dat_jc
;