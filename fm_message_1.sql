select * from fc_ligne where (ide_poste, ide_gest, ide_jal, flg_cptab, ide_ecr)
in (select ide_poste, ide_gest, ide_jal, flg_cptab, ide_ecr from fc_ecriture where 
ide_gest='2021'
and ide_mess=492
and ide_jal='JCENTRAL'
and ide_poste='506C'
and ide_nd_emet='2001'
)
--and ide_cpt like '390%'
order by mt
;

select sum(mt) from fc_ligne where (ide_poste, ide_gest, ide_jal, flg_cptab, ide_ecr)
in (select ide_poste, ide_gest, ide_jal, flg_cptab, ide_ecr from fc_ecriture where 
ide_gest='2021'
and ide_mess in (1294,1295,1298,1305,1306,1307,1314,1315,1318,1323,1330,1333,1338,1344,1353,1356)
and ide_jal='JCENTRAL'
and ide_poste='892C'
and ide_nd_emet='805'
)
--and ide_cpt like '390%'
and cod_sens='D'
--order by mt
;

--133341591