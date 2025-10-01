--select * from fh_ut_pu 
update fh_ut_pu set dat_fval = '12/04/2023'
where ide_util in
(
select distinct a.ide_util
from fh_ut_pu a, fh_util b
where a.ide_util=b.ide_util
and a.ide_util in
(
   select ide_util from fh_util where cod_util in ('W308742','N291759','P345643','V283327','C350415','K308801','S848836','W350408','Z312797','D373142','H373146',
   'Q363355','F363393','M332135','C373141','X480327','Q276761','H372466','H350412','K350405')
)

)
and ide_profil not in ('12', '110')
and dat_fval is null
--order by ide_util;