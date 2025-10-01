Delete From les_pieces_non_soldees;

Insert Into les_pieces_non_soldees
Select a.ide_poste, a.ide_cpt, b.libn, ide_ref_piece, cod_ref_piece, ide_devise, Sum(Decode(cod_sens,(select cod_sens_solde from rc_droit_compte where ide_typ_poste in (select ide_typ_poste from rm_poste where ide_poste = a.ide_poste) and ide_cpt = a.ide_cpt), mt_dev, -mt_dev)) solde
From fc_ligne a, fn_compte b
Where a.ide_cpt = b.ide_cpt 
And ide_gest = '2025'
--and ide_poste like '451'
And flg_cptab = 'O'
And a.ide_cpt in (Select ide_cpt From fn_compte Where flg_justif = 'O')
Group by a.ide_poste, a.ide_cpt, b.libn, ide_ref_piece, cod_ref_piece, ide_devise
Having Sum(decode(cod_sens,'C', mt_dev, -mt_dev)) <> 0
Order by a.ide_poste, ide_devise, a.ide_cpt
;

Select a.ide_poste, a.ide_cpt, a.libn, a.ide_ref_piece, a.cod_ref_piece, a.ide_devise, a.solde, b.mt_db, b.mt_cr, b.mt_dev, b.flg_solde 
From les_pieces_non_soldees a, fc_ref_piece b
where a.ide_poste = b.ide_poste
and a.ide_ref_piece = b.ide_ref_piece
and a.ide_ref_piece is not null
and (a.solde <> 0 and b.flg_solde = 'N')
and a.ide_poste = '451'
and a.ide_cpt not like '474%'
Order By 1,2,4
;