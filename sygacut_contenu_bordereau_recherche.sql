select * from fc_ligne
where (ide_poste, ide_gest, flg_cptab, ide_ecr, ide_jal)
in
(
select ide_poste, ide_gest, flg_cptab, ide_ecr, ide_jal from fc_ligne
where (ide_poste, ide_ecr, ide_gest, ide_jal, flg_cptab)
in
(
select ide_poste, ide_ecr, ide_gest, ide_jal, flg_cptab
from fc_ecriture where
ide_gest = '2023'
and ide_poste = '657'
)
and ide_cpt = '51162'
and cod_sens = 'C'
)
--and ide_ecr in (11565,13944,12952)
--group by cod_sens
and ide_cpt = '47512235'
;


select ide_cpt, cod_sens, flg_cptab, cod_typ_schema, sum(mt)
from fc_ligne
where (ide_poste, ide_ecr, ide_gest, ide_jal, flg_cptab)
in
(
select ide_poste, ide_ecr, ide_gest, ide_jal, flg_cptab
from fc_ecriture where
ide_gest = '2023'
and ide_poste = '657'
and dat_jc between '01/01/2023' and '31/12/2023'
and ide_mess not in (select ide_mess from fm_message where ide_gest = '2023' and ide_nd_emet = '657' and cod_typ_mess = 24 and libl like '%NUMERAIRE%')
)
--and dat_ref between '01/01/2023' and '31/12/2023'
and ide_cpt = '531122'
group by ide_cpt, cod_sens, flg_cptab, cod_typ_schema
order by ide_cpt
;

select *
from fc_ligne
where (ide_poste, ide_ecr, ide_gest, ide_jal, flg_cptab)
in
(
select ide_poste, ide_ecr, ide_gest, ide_jal, flg_cptab
from fc_ecriture where
ide_gest = '2023'
and ide_poste = '657'
and dat_jc between '01/01/2023' and '31/12/2023'
and ide_mess not in (select ide_mess from fm_message where ide_gest = '2023' and ide_nd_emet = '657' and cod_typ_mess = 24 and libl like '%NUMERAIRE%')
)
--and dat_ref between '01/01/2023' and '31/12/2023'
and ide_cpt = '531122'
--group by ide_cpt, cod_sens, flg_cptab, cod_typ_schema
--and ide_ecr not in (11565,13944,12952)
and cod_sens = 'C'
order by ide_ecr
;