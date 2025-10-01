select ide_poste, libn, count(cod_ferm)
from fc_calend_hist a
inner join rm_noeud b on a.ide_poste=b.ide_nd
where ide_gest='2022'
and cod_ferm='O'
and ide_poste like '2%'
group by ide_poste,libn
order by ide_poste