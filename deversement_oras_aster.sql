---------TABLES AGENCES---------------------------
SELECT * FROM T_AGENCE_ORAS
WHERE POSTEB='236'
;

----------TABLE DE DEVERSEMENT NUMERAIRE--------------------------

SELECT * FROM T_TRANSFERT_BIS_N
WHERE JOURNEE='12/01/2024'
AND EMETTEUR='01001'
order by montant
;
----------------------------------------------


----------TABLE DE DEVERSEMENT BANCAIRE--------------------------

SELECT * FROM T_TRANSFERT_BIS_BANQ_N
WHERE JOURNEE='12/01/2024'
AND EMETTEUR='01001'
;
----------------------------------------------


----------TABLE DE DEVERSEMENT ORDRE1--------------------------

SELECT * FROM T_TRANSFERT_BIS_ORDRE_OP1_AG_N
WHERE JOURNEE='05/10/2022'
AND EMETTEUR='01001'
;


----------TABLE DE DEVERSEMENT ORDRE2--------------------------

SELECT * FROM T_TRANSFERT_BIS_ORDRE_OP2_AG_N
WHERE JOURNEE='12/01/2024'
AND EMETTEUR='01001'
;


-----------------------------------------------------------------------------------------------------------------------------

--SELECT * FROM T_TRANSFERT_BIS_N
update T_TRANSFERT_BIS_N set statut = 'S'
WHERE gestion='2024'
--AND EMETTEUR='01001'
and statut = 'V'
--order by montant
;
----------------------------------------------
--SELECT * FROM T_TRANSFERT_BIS_BANQ_N
update T_TRANSFERT_BIS_BANQ_N set statut = 'S'
WHERE gestion='2024'
--AND EMETTEUR='01001'
and statut = 'V'
--order by montant
;

--SELECT * FROM T_TRANSFERT_BIS_ORDRE_OP1_AG_N
update T_TRANSFERT_BIS_ORDRE_OP1_AG_N set statut = 'S'
WHERE gestion='2024'
--AND EMETTEUR='01001'
and statut = 'V'
--order by montant
;

--SELECT * FROM T_TRANSFERT_BIS_ORDRE_OP2_AG_N
update T_TRANSFERT_BIS_ORDRE_OP2_AG_N set statut = 'S'
WHERE gestion='2024'
--AND EMETTEUR='01001'
and statut = 'V'
--order by montant
;

----------TABLE DE DEVERSEMENT BANCAIRE--------------------------

--SELECT * FROM T_TRANSFERT_BIS_BANQ_N
update T_TRANSFERT_BIS_BANQ_N set statut = 'S'
WHERE JOURNEE='12/01/2024'
AND EMETTEUR='01001'
and statut = 'ER'
;


---------------------------------------------------------------------------------------------


--select *
update t_op_transferts_siege_ndir set statut = 'S' 
--from t_op_transferts_siege_ndir
where gestion = '2024'
and statut = 'ER'
;



select *
--update t_op_transferts_siege_ndir set statut = 'S' 
from t_op_transferts_siege_ndir
where gestion = '2024'
and statut = 'ER'


