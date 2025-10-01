set heading OFF
--set feedback OFF
SET VERIFY OFF

--define poste=&Code_pc
define date_reglement=&mois_paiement

--select &1,&2 from dual;
alter session set nls_date_format = 'DD/MM/RRRR';
/
--spool f:\Sygacut\Exce_Sygacut_x.sql
spool c:\Sygacut\Exce_Sygacut_mois_EPN.sql

insert into cut_transfert_2020 select * from cut_transfert where (TRANSF_date like '%&&date_reglement%') and transf_param_code not like '%MT900%' 
and (transf_pc_code,bord_rgl_num) in
(select transf_pc_code,bord_rgl_num from cut_transfert where transf_date like '%&&date_reglement%' and transf_param_code not like '%MT900%' and transf_pc_code in (select ide_poste from rm_poste@asterndir where ide_typ_poste in ('EPN')) 
minus
select transf_pc_code,bord_rgl_num from cut_transfert_2020 where transf_date like '%&&date_reglement%' and transf_param_code not like '%MT900%' and transf_pc_code in (select ide_poste from rm_poste@asterndir where ide_typ_poste in ('EPN')) );
commit;

select 'alter session set nls_date_format = ''DD/MM/YYYY'';' from dual;
select '/' from dual;

 select distinct 'execute CUT.P_REPrise_DEVERS_ASTERNDIR2 ('''||transf_pc_code||''',''2021'','''||to_date(transf_date,'DD/MM/RRRR')||''')' 
   from cut_transfert_2020 where (transf_pc_code,bord_rgl_num) in (
(select transf_pc_code,bord_rgl_num
from cut_transfert_2020 where (TRANSF_date like '%&&date_reglement%') and transf_param_code not like '%MT900%' and transf_param_code<>'EMISCHQPCD'
union
select transf_pc_code,bord_rgl_num||transf_code 
from cut_transfert_2020 where (TRANSF_date like '%&&date_reglement%') and transf_param_code = 'EMISCHQPCD')
minus
 select ide_poste,ide_piece from fc_ecriture@asterndir where (ide_poste,ide_gest,ide_jal,flg_cptab,ide_ecr) in (select ide_poste,ide_gest,ide_jal,flg_cptab,ide_ecr from fc_ecriture@asterndir where (flg_emis_recu,cod_typ_nd,ide_nd_emet,ide_mess) in 
                            (select flg_emis_recu,cod_typ_nd,ide_nd_emet,ide_mess from fm_message@asterndir where 
                            COD_TYP_MESS = 24 and (libl like '%&&date_reglement%' or libl like '%REGUL%&&date_reglement%')  
                            )) and ide_gest='2021'
 )
 and transf_param_code not in ('RMT900') and TRANSF_date like '%&&date_reglement%' and transf_pc_code in (select ide_poste from rm_poste@asterndir where ide_typ_poste in ('EPN')) --,'TG','T','P'))
 order by 1;
 
 
 select 'exit' from dual;
 
 spool off
 
 --HOST rename d:\Sygacut\Exce_Sygacut_&1 d:\Sygacut\Exce_Sygacut_&1.sql
 
@c:\Sygacut\Exce_Sygacut_mois_EPN.sql
 


