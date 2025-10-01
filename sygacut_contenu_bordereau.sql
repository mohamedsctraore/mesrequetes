select ide_cpt, cod_sens, flg_cptab, cod_typ_schema, sum(mt)
from fc_ligne
where (ide_poste, ide_ecr, ide_gest, ide_jal, flg_cptab)
in
(
select ide_poste, ide_ecr, ide_gest, ide_jal, flg_cptab
from fc_ecriture where
ide_gest = '2024'
and ide_poste = '657'
--and dat_jc between '01/01/2024' and '31/12/2024'
and ide_mess in (select ide_mess from fm_message where ide_gest = '2024' and ide_nd_emet = '721' and cod_typ_mess = 24 and libl like '%NUMERAIRE%')
)
and flg_cptab = 'N'
and dat_ref between '01/01/2024' and '31/10/2024'
group by ide_cpt, cod_sens, flg_cptab, cod_typ_schema
order by ide_cpt
;

select ide_cpt, cod_sens, flg_cptab, cod_typ_schema, sum(mt)
from fc_ligne
where (ide_poste, ide_ecr, ide_gest, ide_jal, flg_cptab)
in
(
select ide_poste, ide_ecr, ide_gest, ide_jal, flg_cptab
from fc_ecriture where
ide_gest = '2024'
and ide_poste = '657'
--and dat_jc between '01/01/2024' and '31/10/2024'
and ide_mess not in (select ide_mess from fm_message where ide_gest = '2024' and ide_nd_emet = '657' and cod_typ_mess = 24 and libl like '%EFFECTIF%')
)
and dat_ref between '01/01/2024' and '31/10/2024'
and ide_cpt in ('448241')
--and cod_sens = 'D'
--and flg_cptab = 'N'
group by ide_cpt, cod_sens, flg_cptab, cod_typ_schema
order by ide_cpt
;

select ide_cpt, cod_sens, flg_cptab, cod_typ_schema, sum(mt)
from fc_ligne
where (ide_poste, ide_ecr, ide_gest, ide_jal, flg_cptab)
in
(
select ide_poste, ide_ecr, ide_gest, ide_jal, flg_cptab
from fc_ecriture where
ide_gest = '2023'
and ide_poste = '622'
and dat_jc between '01/01/2023' and '30/09/2023'
and ide_mess in (select ide_mess from fm_message where ide_gest = '2023' and ide_nd_emet = '622' and cod_typ_mess = 24 and libl like '%CONF%')
)
and dat_ref between '01/01/2023' and '30/09/2023'
group by ide_cpt, cod_sens, flg_cptab, cod_typ_schema
order by ide_cpt
;

select ide_cpt, cod_sens, flg_cptab, cod_typ_schema, sum(mt)
from fc_ligne
where (ide_poste, ide_ecr, ide_gest, ide_jal, flg_cptab)
in
(
select ide_poste, ide_ecr, ide_gest, ide_jal, flg_cptab
from fc_ecriture where
ide_gest = '2023'
and ide_poste = '685'
and dat_jc between '01/01/2023' and '30/09/2023'
and ide_mess in (select ide_mess from fm_message where ide_gest = '2023' and ide_nd_emet = '685' and cod_typ_mess = 24 and libl like '%FDS%')
)
and dat_ref between '01/01/2023' and '30/09/2023'
group by ide_cpt, cod_sens, flg_cptab, cod_typ_schema
order by ide_cpt
;

select ide_cpt, cod_sens, flg_cptab, cod_typ_schema, sum(mt)
from fc_ligne
where (ide_poste, ide_ecr, ide_gest, ide_jal, flg_cptab)
in
(
select ide_poste, ide_ecr, ide_gest, ide_jal, flg_cptab
from fc_ecriture where
ide_gest = '2023'
and ide_poste = '622'
and dat_jc between '01/01/2023' and '30/09/2023'
and ide_mess in (select ide_mess from fm_message where ide_gest = '2023' and ide_nd_emet = '622' and cod_typ_mess = 24 and libl like '%REGUL%')
)
and dat_ref between '01/01/2023' and '30/09/2023'
group by ide_cpt, cod_sens, flg_cptab, cod_typ_schema
order by ide_cpt
;