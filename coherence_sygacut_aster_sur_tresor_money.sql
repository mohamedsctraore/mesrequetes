select unique rgl_dte_reglement  from cut_reglement where rgl_num in

(

select rgl_num from cut_reglement
where pc_code = :pccode
and rgl_dte_reglement like '%/23%'
and Rgl_Code_Op is null
AND RGL_MRG_CODE = '01'


minus


select ide_piece from fc_ecriture@asterndir a, fc_ligne@asterndir b
where (flg_emis_recu, cod_typ_nd, ide_nd_emet, ide_mess) 
in (select flg_emis_recu, cod_typ_nd, ide_nd_emet, ide_mess from fm_message@asterndir where ide_gest = '2023' and cod_typ_mess = 24 and ide_nd_emet = :pccode
and libl like 'CUT-PAIEMENT NUMERAIRE DU %')
--and (ide_cpt like '390302%' or ide_cpt='391311' and spec3 like '%C' or spec3='502')
and dat_ref between :date_debut and :date_fin
and cod_sens = 'C'
--and dat_ref <= '30/09/2023'
and a.ide_poste = b.ide_poste and a.ide_gest = b.ide_gest and a.flg_cptab = b.flg_cptab and a.ide_jal = b.ide_jal and a.ide_ecr = b.ide_ecr
)
;