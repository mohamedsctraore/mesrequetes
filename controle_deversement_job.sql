select * from e000618.fc_tiers@lknewp;
select * from verif_devers_web@lkcut
order by 1,3;

delete from verif_devers_web@lkcut where to_char(sys_date, 'dd/mm/yyyy') <> to_char(sysdate, 'dd/mm/yyyy');
delete from verif_devers_web@lkcut where transf_pc_code = '504';