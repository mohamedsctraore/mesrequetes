SELECT EMETTEUR, LIBELLE, GESTION, JOURNEE, CASE
                                                WHEN sens='D' THEN montant
                                                ELSE 0
                                            END as "DEBIT",    
                                            CASE
                                                WHEN sens='C' THEN montant
                                                ELSE 0
                                            END as "CREDIT"

FROM T_TRANSFERT_BIS_N
WHERE EMETTEUR='01546'
AND GESTION='2022'
AND COMPTE='531131'
AND JOURNEE <= '28/01/2022'
order by journee
;

