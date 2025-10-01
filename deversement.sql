select * from fc_cumul
where dat_maj like '03/09/%'
and ide_gest='2021'
--and ide_cpt like '390%'
and ide_poste='222'
--and ide_chaine='QUOT' --TFERT
and ide_cpt like '390%'
order by dat_arrete,dat_maj desc
;

select * from fc_ligne where (ide_poste, ide_gest, ide_jal, flg_cptab, ide_ecr)
in (select ide_poste, ide_gest, ide_jal, flg_cptab, ide_ecr from fc_ecriture where 
ide_gest='2021'
and ide_poste='705'
and dat_jc='31/08/2021'
--and ide_mess in ('9862')
--and mt=20000
)
and ide_cpt like '390%'
--and ide_cpt like '390303023'
;

select * from fm_depeche
--where flg_emis_recu='E'
--where dat_cre like '05/09/%'
order by ide_depeche desc, flg_emis_recu
;

select * from tm_depeche
;

select * from fm_message
where --dat_maj like '03/09/%' and 
libl like 'Centralisation %'
and ide_nd_emet='270'
and ide_gest='2021'
order by dat_maj desc
;

select * from fm_rnl_me
where ide_nd_dest='270C'
and ide_nd_emet='270'
--and ide_mess='9262'
order by dat_maj desc
;

select * from fc_ecriture
where ide_poste='232C'
and ide_mess='20036'
and ide_gest='2021'
;