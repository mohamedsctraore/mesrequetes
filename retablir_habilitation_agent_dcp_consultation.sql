--select * from fh_ut_pu 
update fh_ut_pu set dat_fval = null
where ide_util in
(
select distinct a.ide_util
from fh_ut_pu a, fh_util b
where a.ide_util=b.ide_util
and a.ide_util in
(
   select ide_util from fh_util where cod_util in ('N331591','D343590','N320256','Y323466','Y343581','U349979','P331700','J331700','J331595','Y275896','R349976','H296330','H308592','V331336','E350122',
   'G372322','G350116','H303501','B308985','V313952','E459144','K308715','T361885','A244088','W497288','Z419489','Z848835','K823623','U823656','P849230','E823609','V419501','Q419513','M313537')
)

)
--and ide_poste like '4%'
and ide_profil in ('12','110')
and dat_fval is not null
--order by ide_util, ide_poste
;