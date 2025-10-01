select * from fc_ligne
where ide_gest='2022'
and ide_poste='507'
and spec3='230C'
and flg_cptab='O'
and dat_transf is not null
order by observ
;

select * from fc_ligne where (ide_poste, ide_gest, flg_cptab, ide_jal, ide_ecr) in
(
select ide_poste, ide_gest, flg_cptab, ide_jal, ide_ecr from fc_ecriture
where ide_gest='2022'
and ide_poste='230C'
and ide_nd_emet='507'
)
and ide_cpt='39031'
order by observ
;

select * from fc_ecriture
where ide_gest='2022'
and ide_poste='210C'
and ide_nd_emet='210'
and ide_ecr in (67)
;