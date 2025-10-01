select unique ide_piece from fc_ecriture@asterndir a, fc_ligne@asterndir b, cut_reglement c
where (flg_emis_recu, cod_typ_nd, ide_nd_emet, ide_mess) 
in (select flg_emis_recu, cod_typ_nd, ide_nd_emet, ide_mess from fm_message@asterndir where ide_gest = '2024' and cod_typ_mess = 24 and ide_nd_emet = '3010'
and libl like '%CUT-PAIEMENT EFFECTIF DU 24/06/2024%')
and c.rgl_statut = 'A'
and a.ide_poste = b.ide_poste and a.ide_gest = b.ide_gest and a.flg_cptab = b.flg_cptab and a.ide_jal = b.ide_jal and a.ide_ecr = b.ide_ecr and a.ide_poste = c.pc_code and a.ide_piece = c.rgl_num
;