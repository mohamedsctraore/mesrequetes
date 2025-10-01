select '04-OPP',opp_num, count(*),Sum(Nvl(Opp_Montant_Principal,0) + Nvl(Opp_Montant_Penalite,0)) 
from cut_opposition where (opp_RGL_NUM in (select mer_rgl_num from cut_reglement where pc_code='3070' and rgl_dte_reglement like '%22/02/23%' and rgl_statut in ('V','P','R')) or (opp_dte_reglement like '%22/02/23%' and opp_statut in ('S','P')) )
group by opp_num
union
select '04-OPP-TSE',opp_num,count(*),Sum(Nvl(Opp_Montant_TSE,0)) 
from cut_opposition where (opp_RGL_NUM in (select mer_rgl_num from cut_reglement where pc_code='3070' and rgl_dte_reglement like '%22/02/23%' and rgl_statut in ('V','P','R')) or (opp_dte_reglement like '%22/02/23%' and opp_statut in ('S','P')) )
group by opp_num
;