select unique ide_poste, b.libn from fc_ecriture a , rm_noeud b
where ide_gest='2021'
and ide_poste=ide_nd
order by ide_poste