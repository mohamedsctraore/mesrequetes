Select * From cut.verif_devers_web@lkcut Order By 4 Desc, 1;
Alter session set nls_date_format = 'DD/MM/RRRR';

execute NIABA.PM_DEVERS_REJET_DTE;
execute NIABA.PM_DEVERS_Manquant_Web_CTL('01/08/2025','08/09/2025');
execute NIABA.PM_DEVERS_Manquant_Web_Niv_Deps('04/07/2025','04/07/2025');

select unique 'execute NIABA.P_DEVERS_FINAL_Web('''||transf_pc_code||''','''||substr(to_date(transf_date,'dd/mm/rrrr'), -4)||''','''||transf_date||''');' 
from cut_transfert_balais
union
select unique 'execute NIABA.P_DEVERS_FINAL_Web('''||transf_pc_code||''','''||substr(to_date(transf_date,'dd/mm/rrrr'), -4)||''','''||transf_date||''');' 
from cut_transfert_balais_devers_ctl
where nb < 300
And transf_pc_code not in ('503','509')
union
select unique 'execute NIABA.P_DEVERS_FINAL_Web('''||transf_pc_code||''','''||substr(to_date(transf_date,'dd/mm/rrrr'), -4)||''','''||transf_date||''');' 
from cut_transfert_balais_devers_niv_deps
where nb < 100
;