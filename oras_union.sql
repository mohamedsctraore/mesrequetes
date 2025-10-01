SELECT 'ORAS' sourc, libelle, gestion, journee, statut, compte, montant debit, 0 credit FROM T_TRANSFERT_BIS_N
WHERE JOURNEE between '01/01/2022' and '31/12/2022'
AND EMETTEUR='01516'
and compte = '39031'
and sens = 'D'
union 
SELECT 'ORAS' sourc, libelle, gestion, journee, statut, compte, 0 debit, montant credit FROM T_TRANSFERT_BIS_N
WHERE JOURNEE between '01/01/2022' and '31/12/2022'
AND EMETTEUR='01516'
and compte = '39031'
and sens = 'C'
union
SELECT 'ORAS' sourc, libelle, gestion, journee, statut, compte, montant debit, 0 credit FROM T_TRANSFERT_BIS_BANQ_N
WHERE JOURNEE between '01/01/2022' and '31/12/2022'
AND EMETTEUR='01516'
and compte = '39031'
and sens = 'D'
union 
SELECT 'ORAS' sourc, libelle, gestion, journee, statut, compte, 0 debit, montant credit FROM T_TRANSFERT_BIS_BANQ_N
WHERE JOURNEE between '01/01/2022' and '31/12/2022'
AND EMETTEUR='01516'
and compte = '39031'
and sens = 'C'
union 
SELECT 'ORAS' sourc, libelle, gestion, journee, statut, compte, montant debit, 0 credit FROM T_TRANSFERT_BIS_ORDRE_OP1_AG_N
WHERE JOURNEE between '01/01/2022' and '31/12/2022'
AND EMETTEUR='01516'
and compte = '39031'
and sens = 'D'
union 
SELECT 'ORAS' sourc, libelle, gestion, journee, statut, compte, 0 debit, montant credit FROM T_TRANSFERT_BIS_ORDRE_OP1_AG_N
WHERE JOURNEE between '01/01/2022' and '31/12/2022'
AND EMETTEUR='01516'
and compte = '39031'
and sens = 'C'
union 
SELECT 'ORAS' sourc, libelle, gestion, journee, statut, compte, montant debit, 0 credit FROM T_TRANSFERT_BIS_ORDRE_OP2_AG_N
WHERE JOURNEE between '01/01/2022' and '31/12/2022'
AND EMETTEUR='01516'
and compte = '39031'
and sens = 'D'
union 
SELECT 'ORAS' sourc, libelle, gestion, journee, statut, compte, 0 debit, montant credit FROM T_TRANSFERT_BIS_ORDRE_OP2_AG_N
WHERE JOURNEE between '01/01/2022' and '31/12/2022'
AND EMETTEUR='01516'
and compte = '39031'
and sens = 'C'
union 
select 'ASTER' sourc, observ, ide_gest, dat_ref, ' ' statut, ide_cpt, mt debit, 0 credit from fc_ligne@asterv4
where ide_gest = '2022'
and ide_poste = '232'
and ide_cpt = '39031'
and flg_cptab = 'O'
and cod_sens = 'D'
union
select 'ASTER' sourc, observ, ide_gest, dat_ref, ' ' statut, ide_cpt, 0 debit, mt credit from fc_ligne@asterv4
where ide_gest = '2022'
and ide_poste in ('232', '232C')
and ide_cpt = '39031'
and flg_cptab = 'O'
and cod_sens = 'C'
order by 7,4

--create table a as