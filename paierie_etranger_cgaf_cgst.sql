----------  BALANCE A 3 CHIFFRES --------------------- PAGE 3 et 4 -----

select ordre ,a.ide_cpt, libl,  be_d, be_c, oa_d, oa_c, sa_d, sa_c, bs_d, bs_c,gras
from CGST.ETAT_CGAF_BGCT_AC a , piaf_adm.fn_compte b, CGST.bgfg_ord_cpt c
where uuid = 'EE3671496C246EA8E0531D00C00ABF65' and (gras = 'O' and length(a.ide_cpt) in (1,2,3) or gras = 'I' and a.ide_cpt ='Total General')
and a.ide_cpt = b.ide_cpt(+)
and a.ide_cpt = c.ide_cpt
order by ordre;

select ordre ,a.ide_cpt, libl,  be_d, be_c, oa_d, oa_c, sa_d, sa_c, bs_d, bs_c,gras
from CGST.ETAT_CGAF_BGCT_AC a
left join piaf_adm.fn_compte b on a.ide_cpt = b.ide_cpt
left join CGST.bgfg_ord_cpt c on a.ide_cpt = c.ide_cpt
where uuid = 'EE3671496C246EA8E0531D00C00ABF65' and (gras = 'O' and length(a.ide_cpt) in (1,2,3) or gras = 'I' and a.ide_cpt ='Total General')
order by ordre;

----------  BALANCE GENERALE ------------------

select ordre ,a.ide_cpt, libl,  be_d, be_c, oa_d, oa_c, sa_d, sa_c, bs_d, bs_c,gras
from CGST.ETAT_CGAF_BGCT_AC a , piaf_adm.fn_compte b, CGST.bgfg_ord_cpt c
where uuid = 'EE3671496C246EA8E0531D00C00ABF65' --and (gras = 'O' and length(a.ide_cpt) in (1,2,3) or gras = 'I' and a.ide_cpt ='Total General')
and a.ide_cpt = b.ide_cpt(+)
and a.ide_cpt = c.ide_cpt
order by ordre;

select ordre ,a.ide_cpt, libl,  be_d, be_c, oa_d, oa_c, sa_d, sa_c, bs_d, bs_c,gras
from CGST.ETAT_CGAF_BGCT_AC a
left join fn_compte b on a.ide_cpt = b.ide_cpt
left join bgfg_ord_cpt c on a.ide_cpt = c.ide_cpt
where sid = 1881 --and (gras = 'O' and length(a.ide_cpt) in (1,2,3) or gras = 'I' and a.ide_cpt ='Total General')
order by ordre;


--------------- CIP RECETTE --------------------

select ordre ,a.ide_cpt, libl,  be_d, be_c, oa_d, oa_c, sa_d, sa_c, bs_d, bs_c,gras
from CGST.ETAT_CGAF_BGCT_AC a , piaf_adm.fn_compte b, CGST.bgfg_ord_cpt c
where uuid = 'EE3671496C246EA8E0531D00C00ABF65' --and (gras = 'O' and length(a.ide_cpt) in (1,2,3) or gras = 'I' and a.ide_cpt ='Total General')
and a.ide_cpt like '475%' and gras = 'N'
and a.ide_cpt = b.ide_cpt(+)
and a.ide_cpt = c.ide_cpt
order by ordre;

select ordre ,a.ide_cpt, libl,  be_d, be_c, oa_d, oa_c, sa_d, sa_c, bs_d, bs_c,gras
from CGST.ETAT_CGAF_BGCT_AC a
left join fn_compte b on a.ide_cpt = b.ide_cpt
left join bgfg_ord_cpt c on a.ide_cpt = c.ide_cpt
where sid = 1881 --and (gras = 'O' and length(a.ide_cpt) in (1,2,3) or gras = 'I' and a.ide_cpt ='Total General')
order by ordre;


--------------- CIP DEPENSE --------------------

select ordre ,a.ide_cpt, libl,  be_d, be_c, oa_d, oa_c, sa_d, sa_c, bs_d, bs_c,gras
from CGST.ETAT_CGAF_BGCT_AC a , piaf_adm.fn_compte b, CGST.bgfg_ord_cpt c
where uuid = 'EE3671496C246EA8E0531D00C00ABF65' --and (gras = 'O' and length(a.ide_cpt) in (1,2,3) or gras = 'I' and a.ide_cpt ='Total General')
and a.ide_cpt like '470%' and gras = 'N'
and a.ide_cpt = b.ide_cpt(+)
and a.ide_cpt = c.ide_cpt
order by ordre;

select ordre ,a.ide_cpt, libl,  be_d, be_c, oa_d, oa_c, sa_d, sa_c, bs_d, bs_c,gras
from CGST.ETAT_CGAF_BGCT_AC a
left join fn_compte b on a.ide_cpt = b.ide_cpt
left join bgfg_ord_cpt c on a.ide_cpt = c.ide_cpt
where sid = 1881 --and (gras = 'O' and length(a.ide_cpt) in (1,2,3) or gras = 'I' and a.ide_cpt ='Total General')
order by ordre;


--------------- COMPTE DISPONIBILITE (Faire le total de tous les 5XX sauf le 5)--------------------

select ordre ,a.ide_cpt, libl,  be_d, be_c, oa_d, oa_c, sa_d, sa_c, bs_d, bs_c,gras
from CGST.ETAT_CGAF_BGCT_AC a , piaf_adm.fn_compte b, CGST.bgfg_ord_cpt c
where uuid = 'EE3671496C246EA8E0531D00C00ABF65' --and (gras = 'O' and length(a.ide_cpt) in (1,2,3) or gras = 'I' and a.ide_cpt ='Total General')
and gras = 'N'
and a.ide_cpt like '5%' and a.ide_cpt not like '58%' and a.ide_cpt <> '5'
and a.ide_cpt = b.ide_cpt(+)
and a.ide_cpt = c.ide_cpt
order by ordre;

select ordre ,a.ide_cpt, libl,  be_d, be_c, oa_d, oa_c, sa_d, sa_c, bs_d, bs_c,gras
from CGST.ETAT_CGAF_BGCT_AC a
left join fn_compte b on a.ide_cpt = b.ide_cpt
left join bgfg_ord_cpt c on a.ide_cpt = c.ide_cpt
where sid = 1881 --and (gras = 'O' and length(a.ide_cpt) in (1,2,3) or gras = 'I' and a.ide_cpt ='Total General')
order by ordre;

--------------- COMPTE MOUVEMENT DE FONDS --------------------

select ordre ,a.ide_cpt, libl,  be_d, be_c, oa_d, oa_c, sa_d, sa_c, bs_d, bs_c,gras
from CGST.ETAT_CGAF_BGCT_AC a , piaf_adm.fn_compte b, CGST.bgfg_ord_cpt c
where uuid = 'EE3671496C246EA8E0531D00C00ABF65' --and (gras = 'O' and length(a.ide_cpt) in (1,2,3) or gras = 'I' and a.ide_cpt ='Total General')
and gras = 'N'
and a.ide_cpt like '58%' --and a.ide_cpt <> '5'
and a.ide_cpt = b.ide_cpt(+)
and a.ide_cpt = c.ide_cpt
order by ordre;

select ordre ,a.ide_cpt, libl,  be_d, be_c, oa_d, oa_c, sa_d, sa_c, bs_d, bs_c,gras
from CGST.ETAT_CGAF_BGCT_AC a
left join fn_compte b on a.ide_cpt = b.ide_cpt
left join bgfg_ord_cpt c on a.ide_cpt = c.ide_cpt
where sid = 1881 --and (gras = 'O' and length(a.ide_cpt) in (1,2,3) or gras = 'I' and a.ide_cpt ='Total General')
order by ordre;


--------------- COMPTE OPERATION PAR SERVICE --------------------

create table CGST.deleg_credit_tmp as

select nom_service, a.ide_cpt, libl,  sum(mt) flux_debit,0 flux_credit
from fc_ligne a , fn_compte b, bgfg_ord_cpt c, CGST.service_paierie d
where ide_poste = '401' and ide_gest = '2022' --and (gras = 'O' and length(a.ide_cpt) in (1,2,3) or gras = 'I' and a.ide_cpt ='Total General')
and flg_cptab = 'O' and nom_service = 'Ambassades'
and cod_sens = 'D'
and ide_jal <> 'TREP'
--and a.ide_cpt like '58%' --and a.ide_cpt <> '5'
and a.ide_cpt = b.ide_cpt(+)
and a.ide_cpt = c.ide_cpt
and a.ide_cpt = ide_cpt_debit
group by nom_service, a.ide_cpt, libl
--and a.ide_cpt = ide_cpt_credit

union

select nom_service, a.ide_cpt, libl,  0, sum(mt)
from fc_ligne a , fn_compte b, bgfg_ord_cpt c, CGST.service_paierie d
where ide_poste = '401' and ide_gest = '2022'
and flg_cptab = 'O' and nom_service = 'Ambassades'
and cod_sens = 'C'
and ide_jal <> 'TREP'
and a.ide_cpt = b.ide_cpt(+)
and a.ide_cpt = c.ide_cpt
and a.ide_cpt = ide_cpt_credit
and (ide_poste, ide_jal, ide_gest, flg_cptab, ide_ecr) in (select ide_poste, ide_jal, ide_gest, flg_cptab, ide_ecr from fc_ligne a, CGST.service_paierie d where ide_poste = '401' and ide_gest = '2022'
and flg_cptab = 'O' and nom_service = 'Ambassades'
and cod_sens = 'D'
and ide_jal <> 'TREP' and a.ide_cpt = ide_cpt_debit)
group by nom_service, a.ide_cpt, libl;


select nom_service, sum(flux_debit), sum(flux_credit) 
from CGST.deleg_credit_tmp
group by nom_service;


select ordre ,a.ide_cpt, libl,  be_d, be_c, oa_d, oa_c, sa_d, sa_c, bs_d, bs_c,gras
from CGST.ETAT_CGAF_BGCT_AC a
left join fn_compte b on a.ide_cpt = b.ide_cpt
left join bgfg_ord_cpt c on a.ide_cpt = c.ide_cpt
where sid = 1881 --and (gras = 'O' and length(a.ide_cpt) in (1,2,3) or gras = 'I' and a.ide_cpt ='Total General')
order by ordre;