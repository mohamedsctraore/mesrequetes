truncate table NIABA.ENTETE_MANDAT_2022@lkast;

truncate table NIABA.DETAIL_MANDAT_2022@lkast;

insert into NIABA.T_ENTETE_MANDAT_JUIN_2022@lkast
select *
from t_ENTETE_acte_depenses
where ead_exe = '2022';

insert into NIABA.DETAIL_MANDAT_2022@lkast
select *
from t_detail_acte_depenses
where dap_lcp_exe = '2022';