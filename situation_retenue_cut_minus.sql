select distinct 'A', star_msg_ref, star_msg_montant
from cut_star_message
where star_msg_type = 'MT202'
and to_date(star_msg_mdte, 'DD/MM/RRRR') between to_date('01/01/2023', 'DD/MM/RRRR') and to_date('30/09/2023', 'DD/MM/RRRR')
and star_msg_ref in (select rgl_num from cut_reglement where pc_code = '657' and rgl_statut = 'R' and rgl_mrg_code = '02')
group by star_msg_ref, star_msg_montant


minus 

select 'A', ide_piece, sum(mt) from fc_ecriture@asterndir a, fc_ligne@asterndir b
where (flg_emis_recu, cod_typ_nd, ide_nd_emet, ide_mess) 
in (select flg_emis_recu, cod_typ_nd, ide_nd_emet, ide_mess from fm_message@asterndir where ide_gest = '2023' and cod_typ_mess = 24 and ide_nd_emet = '657'
and libl like '%CUT-RETOUR DE FDS REJET VIREMENT%2023%')
--and ide_cpt like '58%'
and cod_sens = 'C'
and a.ide_poste = b.ide_poste and a.ide_gest = b.ide_gest and a.flg_cptab = b.flg_cptab and a.ide_jal = b.ide_jal and a.ide_ecr = b.ide_ecr
and dat_ref <= '30/09/2023'
group by ide_piece, dat_ref