select * from fc_ecriture where 
ide_gest='2021'
and ide_poste='270C'
and libn like 'Centralisation 270 du 13/09/21';
--and ide_mess in ('132816')
.
select * from fc_ligne where (ide_poste, ide_gest, ide_jal, flg_cptab, ide_ecr)
in (select ide_poste, ide_gest, ide_jal, flg_cptab, ide_ecr from fc_ecriture where 
ide_gest='2021'
and ide_poste='663C'
--and dat_jc='18/06/2021'
and ide_mess in ('9862')
--and mt=50000
)
--and ide_cpt like '390%'
;

select unique ide_mess from fc_ecriture where 
ide_gest='2021'
and ide_poste='663C'
and libn like 'Centralisation 663 du 15/06/21';
--and ide_mess in ('132816')
;

/*
Affichage des lignes d'une centralisation reussie chez le centralisateur
*/
select * from fc_ligne where (ide_poste, ide_gest, ide_jal, flg_cptab, ide_ecr)
in (select ide_poste, ide_gest, ide_jal, flg_cptab, ide_ecr from fc_ecriture where 
ide_gest='2021'
and ide_poste='663C'
--and dat_jc='18/06/2021'
and ide_mess in (select unique ide_mess from fc_ecriture where 
ide_gest='2021'
and ide_poste='663C'
and libn like 'Centralisation 663 du 15/06/21')
--and mt=50000
)
--and ide_cpt like '390%'
;