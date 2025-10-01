drop table verif_doublon_pec;

create table verif_doublon_pec as
select ide_ecr, count(ide_ecr) nb_ecr from fc_ligne
where (ide_poste,ide_gest,ide_jal,flg_cptab,ide_ecr)
in (select ide_poste, ide_gest,ide_jal,flg_cptab,ide_ecr 
from fc_ecriture where 
ide_poste='503'
and ide_gest='2021'
--and ide_mess=14426
and ide_jal='JPECDEPBG'
and dat_jc like '%/12/%'
)
and cod_sens='C'
and ide_cpt='4081'
group by ide_ecr
;

select * from verif_doublon_pec
where nb_ecr > 1
;