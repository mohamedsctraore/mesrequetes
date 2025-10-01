--select * from fh_ut_pu 
update fh_ut_pu set dat_fval = null
where ide_util in
(
select distinct a.ide_util
from fh_ut_pu a, fh_util b
where a.ide_util=b.ide_util
and a.ide_util in
(
   select ide_util from fh_util where cod_util in ('E275919','H303530','P345643','A480338','R343690','J435443','N307140','C345321')
)

)
and ide_poste like '4%'
and ide_profil in ('12','110')
--order by ide_util, ide_poste
;