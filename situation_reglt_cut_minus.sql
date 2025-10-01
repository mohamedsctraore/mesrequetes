select distinct 'A', rgl_num, count(*), rgl_montant_net
from cut_reglement
where pc_code = '651'
and rgl_dte_reglement between '01/01/2023' and '30/09/2023'
and rgl_mrg_code = '02'
and rgl_statut <> 'A'
group by rgl_num, rgl_montant_net

minus

select 'A', ide_piece, count(*), sum(mt) from fc_ecriture@asterndir a, fc_ligne@asterndir b
where (flg_emis_recu, cod_typ_nd, ide_nd_emet, ide_mess) 
in (select flg_emis_recu, cod_typ_nd, ide_nd_emet, ide_mess from fm_message@asterndir where ide_gest = '2023' and cod_typ_mess = 24 and ide_nd_emet = '651'
and libl like '%CUT-PAIEMENT EFFECTIF DU%')
and ide_cpt like '572'
and cod_sens = 'C'
and dat_ref <= '30/09/2023'
and a.ide_poste = b.ide_poste and a.ide_gest = b.ide_gest and a.flg_cptab = b.flg_cptab and a.ide_jal = b.ide_jal and a.ide_ecr = b.ide_ecr
group by ide_piece

