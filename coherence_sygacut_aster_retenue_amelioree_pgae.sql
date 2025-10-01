-------------------------------------- SOMME MONTANT -----------------------------------
select 'ASTER', count(*), sum(mt) from fc_ecriture@asterndir a, fc_ligne@asterndir b
where (flg_emis_recu, cod_typ_nd, ide_nd_emet, ide_mess) 
in (select flg_emis_recu, cod_typ_nd, ide_nd_emet, ide_mess from fm_message@asterndir where ide_gest = '2023' and cod_typ_mess = 24 and ide_nd_emet = :pc_code
and libl like '%CUT-PAIEMENT EFFECTIF DU %%')
and (ide_cpt like '390302%' or ide_cpt='391311' and spec3 like '%C' or spec3='502')
and dat_ref between :date_debut and :date_fin
and cod_sens = 'C'
--and dat_ref <= '30/09/2023'
and a.ide_poste = b.ide_poste and a.ide_gest = b.ide_gest and a.flg_cptab = b.flg_cptab and a.ide_jal = b.ide_jal and a.ide_ecr = b.ide_ecr;


select '03-RET-VIR',count(*), sum(ret_montant) from cut_retenue where RET_STATUT <> 'A' AND (RET_RGL_NUM)  in 
(select mer_rgl_num from cut_reglement 
where pc_code=:pc_code and rgl_dte_reglement between :date_debut and :date_fin
and (rgl_mrg_code='02' and rgl_statut in ('V','P','R')  or rgl_mrg_code='01' and rgl_statut in ('V','S'))
union
select rgl_rgl_num from cut_reglement where pc_code=:pc_code and rgl_dte_reglement between :date_debut and :date_fin
and rgl_statut in ('V','P','R')
) 
and ret_dte_reglement between :date_debut and :date_fin;


--------------------------------------------- MINUS --------------------------------------

select ide_piece, count(*), sum(mt) from fc_ecriture@asterndir a, fc_ligne@asterndir b
where (flg_emis_recu, cod_typ_nd, ide_nd_emet, ide_mess) 
in (select flg_emis_recu, cod_typ_nd, ide_nd_emet, ide_mess from fm_message@asterndir where ide_gest = '2023' and cod_typ_mess = 24 and ide_nd_emet = :pc_code
and libl like '%CUT-PAIEMENT EFFECTIF DU %%')
and (ide_cpt like '390302%' or ide_cpt='391311' and spec3 like '%C' or spec3='502')
and dat_ref between :date_debut and :date_fin
and cod_sens = 'C'
--and dat_ref <= '30/09/2023'
and a.ide_poste = b.ide_poste and a.ide_gest = b.ide_gest and a.flg_cptab = b.flg_cptab and a.ide_jal = b.ide_jal and a.ide_ecr = b.ide_ecr
group by ide_piece

minus

select ret_num, count(*), sum(ret_montant) from cut_retenue where RET_STATUT <> 'A' AND (RET_RGL_NUM)  in 
(select mer_rgl_num from cut_reglement 
where pc_code=:pc_code and rgl_dte_reglement between :date_debut and :date_fin
and (rgl_mrg_code='02' and rgl_statut in ('V','P','R')  or rgl_mrg_code='01' and rgl_statut in ('V','S'))
--union
--select rgl_rgl_num from cut_reglement where pc_code=:pc_code and rgl_dte_reglement between :date_debut and :date_fin
--and rgl_statut in ('V','P','R')
) 
and ret_dte_reglement between :date_debut and :date_fin
group by ret_num, ret_statut
order by 2,1
;

----------------------------------------  CROISEE  -------------------------------------------------
select 'A', ide_piece, count(*), sum(mt) from fc_ecriture@asterndir a, fc_ligne@asterndir b
where (flg_emis_recu, cod_typ_nd, ide_nd_emet, ide_mess) 
in (select flg_emis_recu, cod_typ_nd, ide_nd_emet, ide_mess from fm_message@asterndir where ide_gest = '2023' and cod_typ_mess = 24 and ide_nd_emet = '615'
and libl like '%CUT-PAIEMENT EFFECTIF DU %%')
and (ide_cpt like '390302%' or ide_cpt='391311' and spec3 like '%C' or spec3='502')
and dat_ref between :date_debut and :date_fin
and cod_sens = 'C'
--and dat_ref <= '30/09/2023'
and a.ide_poste = b.ide_poste and a.ide_gest = b.ide_gest and a.flg_cptab = b.flg_cptab and a.ide_jal = b.ide_jal and a.ide_ecr = b.ide_ecr
group by ide_piece

union

select 'S', ret_num, count(*), sum(ret_montant) from cut_retenue where RET_STATUT <> 'A' AND (RET_RGL_NUM)  in 
(select mer_rgl_num from cut_reglement 
where pc_code=:pc_code and rgl_dte_reglement between :date_debut and :date_fin
and (rgl_mrg_code='02' and rgl_statut in ('V','P','R')  or rgl_mrg_code='01' and rgl_statut in ('V','S'))
--union
--select rgl_rgl_num from cut_reglement where pc_code=:pc_code and rgl_dte_reglement between :date_debut and :date_fin
--and rgl_statut in ('V','P','R')
) 
and ret_dte_reglement between :date_debut and :date_fin
group by ret_num
order by 2,1
;