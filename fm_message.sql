select unique ide_nd_emet,ide_poste_centra,ide_mess,mt_cr,mt_db,nbr_piece,nbr_ligne 
from fm_message a, rm_poste b
where a.IDE_ND_EMET=b.IDE_POSTE 
and a.libl like '%Centralisation%'
and a.ide_gest='2021'
order by a.IDE_ND_EMET, ide_mess
;

select unique ide_nd_emet,ide_poste_centra,ide_mess,mt_cr,mt_db,nbr_piece,nbr_ligne 
from fm_message a, rm_poste b
where a.IDE_ND_EMET=b.IDE_POSTE 
and a.libl like '%Transfert%'
and a.ide_gest='2021'
order by a.IDE_ND_EMET, ide_mess
;


select * from fc_ecriture
where ide_gest='2021'
and ide_poste='805'
and dat_jc='15/01/2021'
;

select * from fc_ligne where (ide_poste, ide_gest, ide_jal, flg_cptab, ide_ecr)
in (select ide_poste, ide_gest, ide_jal, flg_cptab, ide_ecr from fc_ecriture where 
ide_gest='2021'
and ide_poste='805'
and dat_jc='15/01/2021'
)
and ide_cpt like '390%'
order by mt
;

select * from fc_ecriture
where ide_gest='2021'
and ide_mess in 
(1294)
and ide_jal='JCENTRAL'
and ide_poste='892C'
and ide_nd_emet='805'
;

select * from fc_ligne where (ide_poste, ide_gest, ide_jal, flg_cptab, ide_ecr)
in (select ide_poste, ide_gest, ide_jal, flg_cptab, ide_ecr from fc_ecriture where 
ide_gest='2021'
and ide_mess in 
(1294)
and ide_jal='JCENTRAL'
and ide_poste='892C'
and ide_nd_emet='805'
)
--and ide_cpt like '390%'
order by mt
;