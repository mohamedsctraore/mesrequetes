select * from e000618.FC_TIERS@asterndir;

insert into e000618.FC_TIERS@asterndir
select a.ide_poste, ide_piece, ide_cpt, a.ide_ecr, str_code, nat_dep_code 
from fc_ecriture@asterndir a, fc_ligne@asterndir b, cut_reglement c  
where (flg_emis_recu, cod_typ_nd, ide_nd_emet, ide_mess) 
in (select flg_emis_recu, cod_typ_nd, ide_nd_emet, ide_mess from fm_message@asterndir where ide_gest = '2024' and cod_typ_mess = 24)
--and ide_cpt like '4413'
and cod_sens = 'D'
and ide_tiers is null
and b.ide_modele_lig = 'DEBIT+T'
and a.flg_cptab = 'N'
and a.ide_poste not like '5%'
--and dat_ref <= '04/06/2024'
and a.ide_poste = b.ide_poste and a.ide_gest = b.ide_gest and a.flg_cptab = b.flg_cptab and a.ide_jal = b.ide_jal and a.ide_ecr = b.ide_ecr and a.ide_poste = c.PC_CODE and a.IDE_PIECE = c.rgl_num
order by ide_poste;

SELECT pc_code, rgl_num, str_code from cut_reglement
where (pc_code, rgl_num) in
(
select a.ide_poste, ide_piece from fc_ecriture@asterndir a, fc_ligne@asterndir b
where (flg_emis_recu, cod_typ_nd, ide_nd_emet, ide_mess) 
in (select flg_emis_recu, cod_typ_nd, ide_nd_emet, ide_mess from fm_message@asterndir where ide_gest = '2024' and cod_typ_mess = 24)
and ide_cpt like '4413'
and cod_sens = 'D'
and ide_tiers is null
--and dat_ref <= '04/06/2024'
and a.ide_poste = b.ide_poste and a.ide_gest = b.ide_gest and a.flg_cptab = b.flg_cptab and a.ide_jal = b.ide_jal and a.ide_ecr = b.ide_ecr
and a.flg_cptab = 'N'
)
and rgl_dte_reglement like '%/24' 
;

----------------------------------------------------------------------------------------------------------------------

select pc_code, nat_dep_code, rgl_num, str_code from cut_reglement
where (pc_code, rgl_num)
in
(
select ide_poste, ide_piece from fc_ecriture@asterndir where (ide_poste, ide_ecr, ide_jal, ide_gest, flg_cptab)
in
(
select unique ide_poste, ide_ecr, ide_jal, ide_gest, flg_cptab from fc_ligne@asterndir
where ide_gest = '2024'
and flg_cptab = 'N'
and ide_modele_lig = 'DEBIT+T'
and cod_typ_schema = 'T'
and ide_cpt = '44899'
and ide_tiers is null
)
)
order by pc_code, nat_dep_code, str_code;

--(
--44801
--44809
--44811
--44812
--44813
--44814
--44816
--44817
--44899
--)