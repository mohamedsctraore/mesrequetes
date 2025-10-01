select a.ide_cpt,b.libn,sum(decode(a.cod_sens,'C',a.mt,-a.mt)) 
from fc_ligne a,fn_compte b 
where a.ide_gest='2025' 
and a.dat_ecr<='30/06/2025' 
and a.flg_cptab='O' and a.ide_cpt like '7%' 
and a.ide_jal not in ('TREP','REPMAN')
and a.ide_cpt=b.ide_cpt
group by a.ide_cpt,b.libn having sum(decode(a.cod_sens,'C',a.mt,-a.mt))<>0
union
select a.ide_cpt,b.libn,sum(decode(a.cod_sens,'C',a.mt,0)) 
from fc_ligne a,fn_compte b 
where a.ide_gest='2025' 
and a.dat_ecr<='30/06/2025'
and a.flg_cptab='O' 
and substr(a.ide_cpt,1,1) in ('1','2') 
and a.ide_jal not in ('TREP','REPMAN') 
and a.cod_sens='C'
and a.ide_cpt=b.ide_cpt
group by a.ide_cpt,b.libn having sum(decode(a.cod_sens,'C',a.mt,0))<>0
order by 1
