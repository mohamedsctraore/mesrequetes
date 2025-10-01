select ide_poste, sum(mt) from fc_ligne
where ide_gest='2021'
and spec3='201C'
and spec2='39031'
and cod_sens='D'
and ide_cpt in (39111,39112)
and dat_ecr between '01/01/2021' and '30/09/2021'
group by ide_poste
order by ide_poste
;

select b.ide_nd_emet, sum(mt) from fc_ligne a, fc_ecriture b
where a.ide_gest='2021'
and a.ide_gest = b.ide_gest
and a.ide_ecr=b.ide_ecr
and a.dat_ecr=b.dat_ecr
and a.ide_poste=b.ide_poste
and a.ide_cpt='39031'
and a.cod_sens='D'
and a.ide_poste='201C'
and a.dat_ecr between '01/01/2021' and '30/09/2021'
group by b.ide_nd_emet
order by b.ide_nd_emet
;