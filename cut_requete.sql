select *
from CUT.CUT_RETENUE
where ret_rgl_num in
(select mer_rgl_num from CUT.cut_reglement where pc_code=&pc and rgl_dte_reglement like '%14/03/%')
order by ret_mdt_num;

select * 
from CUT.cut_reglement 
where pc_code=&pc 
and rgl_dte_reglement like '%14/03/%'
order by RGL_MDT_NUM;

select rgl_num, ret_num
from cut.cut_retenue a
left join cut.cut_reglement b on a.RET_MDT_NUM = b.RGL_MDT_NUM
and a.PC_CODE = b.PC_CODE
and a.ret_rgl_num like '%14/03/%';