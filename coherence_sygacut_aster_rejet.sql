select unique star_msg_ref, star_msg_montant, star_msg_mdte
from cut_star_message@lkcut where star_msg_ref in
(
select rgl_num from cut_reglement@lkcut
where pc_code = '503'
and rgl_statut = 'P'
AND RGL_TYPE_REGLT = 'OV'
and rgl_rout_statut = 'R'
)
and star_msg_type = 'MT202'
and to_date(star_msg_mdte, 'DD/MM/RRRR') between '01/01/2025' and '31/12/2025'
order by to_date(star_msg_mdte,'dd/mm/rrrr'), star_msg_ref;

------------------------------------------------------------------------------------------------------------------------------------

select 'A', ide_piece, count(*), sum(mt) from fc_ecriture@lkastweb a, fc_ligne@lkastweb b
where (flg_emis_recu, cod_typ_nd, ide_nd_emet, ide_mess) 
in (select flg_emis_recu, cod_typ_nd, ide_nd_emet, ide_mess from fm_message@lkastweb where ide_gest = '2025' and cod_typ_mess = 24 and ide_nd_emet = '503'
and libl like '%CUT-RETOUR DE FDS REJET VIREMENT%2025%')
--and ide_cpt like '58%'
and cod_sens = 'C'
and to_date(dat_ref,'dd/mm/rrrr') = to_date('06/08/2025','dd/mm/rrrr') 
and a.ide_poste = b.ide_poste and a.ide_gest = b.ide_gest and a.flg_cptab = b.flg_cptab and a.ide_jal = b.ide_jal and a.ide_ecr = b.ide_ecr
group by ide_piece, dat_ref
union
select distinct 'S', star_msg_ref, count(*), star_msg_montant
from cut_star_message@lkcut
where star_msg_type = 'MT202'
and to_date(STAR_MSG_MDTE, 'DD/MM/RRRR') between to_date('06/08/2025', 'DD/MM/RRRR') and to_date('06/08/2025', 'DD/MM/RRRR')
and star_msg_ref in (select rgl_num from cut_reglement@lkcut where pc_code = '503' and rgl_statut = 'R' and rgl_mrg_code = '02')
group by star_msg_ref, star_msg_montant

--2203287024000001, 2203287024000002, 2203287024000003, 2203287024000005
--2204057024000001, 2204057024000002, 2204057024000003, 2204057024000004, 2204057024000005, 2204057024000007, 2204057024000008, 2204057024000009
--2204057024000006, 

order by 2,1;