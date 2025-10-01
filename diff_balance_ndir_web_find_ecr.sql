select 'ndir-trep' cible, dat_ecr, sum(mt) from fc_ligne@asterv4
where ide_gest = '2024'
and ide_poste = '429'
and cod_sens = 'C'
and dat_ecr <= '06/08/2024'
and ide_jal <> 'TREP'
group by dat_ecr
union
select 'web-trep' cible, dat_ecr, sum(mt) from fc_ligne
where ide_gest = '2024'
and ide_poste = '429'
and cod_sens = 'C'
and dat_ecr <= '06/08/2024'
and ide_jal <> 'TREP'
group by dat_ecr
order by 2,1
;

select ide_cpt, mt, observ from fc_ligne@asterv4
where ide_gest = '2024'
and ide_poste = '429'
and cod_sens = 'D'
and dat_ecr = '06/08/2024'
and ide_jal <> 'TREP'
and ide_cpt = '474321101'
--group by dat_ecr
minus
select ide_cpt, mt, observ from fc_ligne
where ide_gest = '2024'
and ide_poste = '429'
and cod_sens = 'D'
and dat_ecr = '30/07/2024'
and ide_jal <> 'TREP'
and ide_cpt = '474321101'
--group by dat_ecr
;