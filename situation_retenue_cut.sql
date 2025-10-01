----------------------------------- MONTANT TOTAL  --------------------------------------

select '03-RET-VIR',count(*),sum(RET_MONTANT) 
from cut_retenue 
where RET_STATUT <> 'A' 
AND (RET_RGL_NUM) in 
(
select MER_RGL_NUM from cut_reglement 
where PC_CODE='7021' 
and RGL_DTE_REGLEMENT between '01/01/2023' and '30/09/2023' 
and (RGL_MRG_CODE='02' and RGL_STATUT in ('V','P','R') or RGL_MRG_CODE='01' and RGL_STATUT in ('V','S'))

--union
--
--select RGL_RGL_NUM from cut_reglement 
--where PC_CODE='3013' 
--and RGL_DTE_REGLEMENT between '01/01/2023' and '30/09/2023' 
--and RGL_STATUT in ('V','P','R')
--and (RGL_MONTANT - RGL_MONTANT_NET) <> 0
)
and RET_DTE_REGLEMENT between '01/01/2023' and '30/09/2023'
;

select 'Aster', count(*), sum(mt) from fc_ecriture@asterndir a, fc_ligne@asterndir b
where (flg_emis_recu, cod_typ_nd, ide_nd_emet, ide_mess) 
in (select flg_emis_recu, cod_typ_nd, ide_nd_emet, ide_mess from fm_message@asterndir where ide_gest = '2023' and cod_typ_mess = 24 and ide_nd_emet = '7021'
and libl like '%CUT-PAIEMENT EFFECTIF DU %/2023%')
and ide_cpt like '390302%'
and cod_sens = 'C'
and dat_ref <= '30/09/2023'
and a.ide_poste = b.ide_poste and a.ide_gest = b.ide_gest and a.flg_cptab = b.flg_cptab and a.ide_jal = b.ide_jal and a.ide_ecr = b.ide_ecr
;

----------------------------------- PRESENT CUT PAS ASTER  --------------------------------------

select pc_code, ret_num, ret_montant from cut_retenue where RET_STATUT <> 'A' AND (RET_RGL_NUM)  in 
(select mer_rgl_num from cut_reglement 
where pc_code='7021' 
and rgl_dte_reglement between '01/01/2023' and '30/09/2023' and rgl_statut in ('V','P','R')
--union
--select rgl_rgl_num from cut_reglement where pc_code='3013' and rgl_dte_reglement between '01/01/2023' and '30/09/2023' and rgl_statut in ('V','P','R')
)
and ret_dte_reglement between '01/01/2023' and '30/09/2023'

minus

select a.ide_poste, a.ide_piece, mt  from fc_ecriture@asterndir a, fc_ligne@asterndir b
where (flg_emis_recu, cod_typ_nd, ide_nd_emet, ide_mess) 
in (select flg_emis_recu, cod_typ_nd, ide_nd_emet, ide_mess from fm_message@asterndir where ide_gest = '2023' and cod_typ_mess = 24 and ide_nd_emet = '7021'
and libl like '%CUT-PAIEMENT EFFECTIF DU %/2023%')
and ide_cpt like '390302%'
and cod_sens = 'C'
and dat_ref <= '30/09/2023'
and a.ide_poste = b.ide_poste and a.ide_gest = b.ide_gest and a.flg_cptab = b.flg_cptab and a.ide_jal = b.ide_jal and a.ide_ecr = b.ide_ecr
;

----------------------------------- PRESENT ASTER PAS CUT  --------------------------------------

select a.ide_poste, a.ide_piece, mt  from fc_ecriture@asterndir a, fc_ligne@asterndir b
where (flg_emis_recu, cod_typ_nd, ide_nd_emet, ide_mess) 
in (select flg_emis_recu, cod_typ_nd, ide_nd_emet, ide_mess from fm_message@asterndir where ide_gest = '2023' and cod_typ_mess = 24 and ide_nd_emet = '657'
and libl like '%CUT-PAIEMENT EFFECTIF DU%')
and (ide_cpt like '390302%' or ide_cpt='391311' and spec3 like '%C' or spec3='502')
and cod_sens = 'C'
and dat_ref <= '30/09/2023'
and a.ide_poste = b.ide_poste and a.ide_gest = b.ide_gest and a.flg_cptab = b.flg_cptab and a.ide_jal = b.ide_jal and a.ide_ecr = b.ide_ecr

minus 

select pc_code, ret_num, ret_montant from cut_retenue where RET_STATUT <> 'A' AND (RET_RGL_NUM)  in 
(select mer_rgl_num from cut_reglement 
where pc_code='657' and 
rgl_dte_reglement between '01/01/2023' and '30/09/2023' and rgl_statut in ('V','P','R')
--union
--select rgl_rgl_num from cut_reglement where pc_code='3013' and rgl_dte_reglement between '01/01/2023' and '30/09/2023' and rgl_statut in ('V','P','R')
)
and ret_dte_reglement between '01/01/2023' and '30/09/2023'
;
