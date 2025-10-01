SELECT ' DECLARE' FROM dual
UNION
SELECT ' Vdebit varchar2(10);' FROM dual
UNION
SELECT ' Vcredit varchar2(10);' FROM dual
UNION
SELECT 'BEGIN' FROM dual
union
select distinct 'SIBINTERFACE.P_CALCUL_CPT_PEC ('''||dap_ead_num_acte||''','''||dap_ead_type||''','''||pct_tpc_code||''','''||substr(dap_lcp_num,12,instr(substr(dap_lcp_num,12),'0',5,1)-1)||''',Vdebit,Vcredit);'
from t_detail_acte_depenses,t_mouvements_sib,t_poste_comptas
where dap_lcp_exe=2021 and dap_cpt_credit is null and dap_ead_type='M'
and substr(dap_lcp_num,12,instr(substr(dap_lcp_num,12),'0',5,1)-1)=mvt_nat_code
and dap_pct_code=pct_code
union
SELECT 'end;' FROM dual