select *
from credit_delegue_pec a
left join credit_delegue_47411 b on ide_poste_centra = ide_poste
order by ide_poste_centra;

drop table credit_delegue_pec;

create table credit_delegue_pec as
SELECT a.ide_cpt, c.libn libn_1,ide_poste_centra,b.libn libn_2, CASE
                                    WHEN solde > 0 THEN solde
                                    WHEN solde < 0 THEN 0
                                  END AS DEBIT,
                                  CASE
                                    WHEN solde < 0 THEN ABS(solde)
                                    WHEN solde > 0 THEN 0
                                 END AS CREDIT, c.cod_sens_solde
FROM solde_anormal a, rm_noeud b, fn_compte c
WHERE solde <> 0
AND a.ide_poste_centra=b.ide_nd
AND a.ide_cpt=c.ide_cpt
ORDER BY a.ide_cpt, a.ide_poste_centra