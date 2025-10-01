set heading OFF
set feedback OFF
SET VERIFY OFF

define poste=&Code_pc
define date_reglement=&date_paiement

--select &1,&2 from dual;
alter session set nls_date_format = 'DD/MM/RRRR';
/
--spool f:\Sygacut\Exce_Sygacut_x.sql
spool c:\Sygacut\Exce_Sygacut_x.sql

insert into cut_transfert_2020 select * from cut_transfert where (TRANSF_date like '%&&date_reglement%') and transf_pc_code = '&&poste' and transf_param_code not like '%MT900%'
and (transf_pc_code,bord_rgl_num) in
(select transf_pc_code,bord_rgl_num from cut_transfert where transf_date like '%&&date_reglement%' and transf_pc_code = '&&poste' and transf_param_code not like '%MT900%'
minus
select transf_pc_code,bord_rgl_num from cut_transfert_2020 where transf_date like '%&&date_reglement%' and transf_pc_code = '&&poste' and transf_param_code not like '%MT900%');
commit;

select 'alter session set nls_date_format = ''DD/MM/RRRR'';' from dual;
select '/' from dual;

 select distinct 'execute CUT.P_REPrise_DEVERS_ASTERNDIR2 ('''||'&&poste'||''','''||substr(to_date('&&date_reglement','DD/MM/RRRR'),7,4)||''','''||to_date('&&date_reglement','DD/MM/RRRR')||''')' 
   from dual
 order by 1;
 
 
 --select 'exit' from dual;
 
 spool off
 
 --HOST rename d:\Sygacut\Exce_Sygacut_&1 d:\Sygacut\Exce_Sygacut_&1.sql
 
@c:\Sygacut\Exce_Sygacut_x.sql
 
