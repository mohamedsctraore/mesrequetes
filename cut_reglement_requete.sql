---------------- etat reglement ---------------------
select *
from cut_reglement 
where pc_code = '3028'
and rgl_num = '2209193028000095';

------------- etat regularisation d'un paiement rejeté -------------------
select * from cut_reglement
where rgl_regul_num in
(
select rgl_num
from cut_reglement 
where pc_code = '3090'
and rgl_num = '2112273090000159' -- paiement rejeté
);


------- etat paiement rejeté d'une regularisation --------------
select * from cut_reglement 
where rgl_num in
(
select rgl_regul_num from cut_reglement
where rgl_num in
(
select rgl_num
from cut_reglement 
where pc_code = '3028'
and rgl_num = '2212203028000962' -- regularisation
)
);



------------ TOUS LES PAIEMENTS NON REGULARISES -----------------

select *
from cut_reglement
where rgl_num in
(

select rgl_num
from cut_reglement 
where pc_code = '3001'
and rgl_statut = 'R'

minus

select rgl_regul_num from cut_reglement
where rgl_regul_num is not null
and pc_code = '3001'
)
;