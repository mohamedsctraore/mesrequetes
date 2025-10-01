select * from ORAS.T_NCGLIB_ORAS
where ncg_code in
(
select unique NCG_CODE
from t_mvtc_oras m 
inner join t_cpt_oras c
on m.cpt_num = c.cpt_num
and m.mvtc_datoper = '31/10/2023'
and c.AGCODE = '01001'
--and m.MVTC_LIBELLE like 'FRAIS COMPTE N.%'

)
order by NCG_CODE
;


select *
from t_mvtc_oras m 
inner join t_cpt_oras c
on m.cpt_num = c.cpt_num
and m.mvtc_datoper = '31/10/2023'
and c.AGCODE = '01002'
order by MVTC_NOOPER
;

select *
from t_cli_oras
inner join t_cpt_oras using(cli_code)
where CLI_CODE = :cli_code
;

--045103
--045388
--510038
