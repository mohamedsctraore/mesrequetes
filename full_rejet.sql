select 'A', ide_piece, count(*), sum(mt) from fc_ecriture@asterndir a, fc_ligne@asterndir b
where (flg_emis_recu, cod_typ_nd, ide_nd_emet, ide_mess) 
in (select flg_emis_recu, cod_typ_nd, ide_nd_emet, ide_mess from fm_message@asterndir where ide_gest between '2022' and '2024' and cod_typ_mess = 24 and ide_nd_emet = '503'
and libl like '%CUT-RETOUR DE FDS REJET VIREMENT%')
--and ide_cpt like '58%'
and cod_sens = 'C'
and a.ide_poste = b.ide_poste and a.ide_gest = b.ide_gest and a.flg_cptab = b.flg_cptab and a.ide_jal = b.ide_jal and a.ide_ecr = b.ide_ecr
group by ide_piece, dat_ref
union
select distinct 'S', star_msg_ref, count(*), star_msg_montant
from cut_star_message
where star_msg_type = 'MT202'
and to_date(STAR_MSG_MDTE, 'DD/MM/RRRR') between to_date('01/01/2022', 'DD/MM/RRRR') and to_date('31/12/2023', 'DD/MM/RRRR')
and star_msg_ref in (select rgl_num from cut_reglement where pc_code = '503' and rgl_statut = 'R' and rgl_mrg_code = '02')
group by star_msg_ref, star_msg_montant
union
select unique 'OV', star_msg_ref, count(*), star_msg_montant
from cut_star_message where star_msg_ref in
(
select rgl_num from cut_reglement
where pc_code = '503'
and rgl_statut = 'P'
AND RGL_TYPE_REGLT = 'OV'
and rgl_rout_statut = 'R'
)
and star_msg_type = 'MT202'
and to_date(star_msg_mdte, 'DD/MM/RRRR') between '01/01/2022' and '31/12/2024'
group by star_msg_ref, star_msg_montant
order by 2,1;