select unique ide_poste, libn from fc_ecriture 
where ide_gest='2022'
and ide_jal = 'TREP'
--and ide_poste like '4%'
order by ide_poste
;