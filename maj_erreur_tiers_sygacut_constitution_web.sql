select * from e000618.fc_tiers@lknewp;

insert into e000618.fc_tiers@lknewp
select a.ide_poste, ide_piece, ide_cpt, a.ide_ecr, str_code, nat_dep_code from fc_ecriture@lknewp a, fc_ligne@lknewp b, cut_reglement@lkcut c  
where (flg_emis_recu, cod_typ_nd, ide_nd_emet, ide_mess) 
in (select flg_emis_recu, cod_typ_nd, ide_nd_emet, ide_mess from fm_message@lknewp where ide_gest = '2024' and cod_typ_mess = 24)
--and ide_cpt like '4413'
and cod_sens = 'D'
and ide_tiers is null
and b.ide_modele_lig = 'DEBIT+T'
and a.flg_cptab = 'N'
and a.ide_poste not like '5%'
--and dat_ref <= '04/06/2024'
and a.ide_poste = b.ide_poste and a.ide_gest = b.ide_gest and a.flg_cptab = b.flg_cptab and a.ide_jal = b.ide_jal and a.ide_ecr = b.ide_ecr and a.ide_poste = c.PC_CODE and a.IDE_PIECE = c.rgl_num
order by ide_poste;