UPDATE fc_ligne tc
SET (tc.ide_devise, tc.mt_dev) = (
    SELECT ts.ide_devise, ts.solde 
    FROM maj_piece ts
    WHERE ts.ide_poste = tc.ide_poste
    AND   ts.ide_cpt   = tc.ide_cpt
    AND   ts.ide_ref_piece = tc.ide_ref_piece
)
WHERE EXISTS (
    SELECT 1
    FROM maj_piece ts
    WHERE ts.ide_poste = tc.ide_poste
    AND   ts.ide_cpt   = tc.ide_cpt
    AND   ts.ide_ref_piece = tc.ide_ref_piece
)
And ide_jal = 'TREP'
And ide_gest = '2025'
;
