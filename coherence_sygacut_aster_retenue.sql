select 'A', ide_piece, count(*), sum(mt) from fc_ecriture@asterndir a, fc_ligne@asterndir b
where (flg_emis_recu, cod_typ_nd, ide_nd_emet, ide_mess) 
in (select flg_emis_recu, cod_typ_nd, ide_nd_emet, ide_mess from fm_message@asterndir where ide_gest = '2023' and cod_typ_mess = 24 and ide_nd_emet = '7021'
and libl like '%CUT-PAIEMENT EFFECTIF DU %/2023%')
and ide_cpt like '39030202'
and cod_sens = 'C'
and dat_ref <= '30/09/2023'
and a.ide_poste = b.ide_poste and a.ide_gest = b.ide_gest and a.flg_cptab = b.flg_cptab and a.ide_jal = b.ide_jal and a.ide_ecr = b.ide_ecr
group by ide_piece

union

select distinct 'S', ret_num, count(*), ret_montant
from cut_retenue
where pc_code = '3013'
and ret_dte_reglement between '01/01/2023' and '30/09/2023'
and ret_statut <> 'A'
--and rgl_mrg_code = '02'
group by ret_num, ret_montant

/*
select distinct 'S', star_msg_ref, count(*), star_msg_montant
from cut_star_message
where star_msg_type = 'MT202'
and to_date(star_msg_dte, 'DD/MM/RRRR') between to_date('01/01/2022', 'DD/MM/RRRR') and to_date('31/12/2022', 'DD/MM/RRRR')
and star_msg_ref in (select rgl_num from cut_reglement where pc_code = '3017' and rgl_statut = 'R' and rgl_mrg_code = '02')
group by star_msg_ref, star_msg_montant
*/


--2203287024000001, 2203287024000002, 2203287024000003, 2203287024000005
--2204057024000001, 2204057024000002, 2204057024000003, 2204057024000004, 2204057024000005, 2204057024000007, 2204057024000008, 2204057024000009
--2204057024000006, 

order by 2,1