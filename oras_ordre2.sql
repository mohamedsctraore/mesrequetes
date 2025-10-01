alter session set nls_date_format = 'DD/MM/RRRR';

exec ORAS."P_MAJ_DONNEES_ORAS" ('10/10/2024')
exec ORAS.P_MAJ_ORAS_ORION_NEW_XXX

select max(MVTC_DATOPER) from T_MVTC_ORAS;

exec ORAS."P_MAJ_ORAS_ORION_NEW";

select * FROM T_TRANSFERT_BIS_ORDRE_OP2_AG_N
where journee='21/02/2024'
order by montant desc, sens;

SELECT journee, sum(decode(sens, 'D',montant, -montant)) equilibre FROM T_TRANSFERT_BIS_ORDRE_OP2_AG_N
WHERE JOURNEE >= '01/01/2024'
group by journee
having sum(decode(sens, 'D',montant, -montant)) <> 0
order by journee desc
;

drop table oras.T_TRANS_ERR_ORD2_20_02_24;

create table
oras.T_TRANS_ERR_ORD2_20_02_24
as
select* FROM T_TRANSFERT_BIS_ORDRE_OP2_AG_N
where journee='21/02/2024';
--------------------------------------------------------------------------------

SELECT * FROM ORAS.T_LJ_OP2_NEW_VIA_DEB
WHERE DATOP='21/02/2024';

DELETE FROM ORAS.T_LJ_OP2_NEW_VIA_DEB
WHERE DATOP='21/02/2024';

COMMIT;
----------------------------------------------------------------------------------------------

------------------------------------------------------------

DELETE FROM ORAS.T_TRANSFERT_BIS_ORDRE_OP2_AG_N
WHERE JOURNEE='21/02/2024';

COMMIT;
--------------------------------------------------------------------------------

DELETE FROM ORAS.T_LJ_OP2_NEW_VIA_DEB
WHERE DATOP='21/02/2024';

COMMIT;
---------------------------------------------------------------------------------------------------

INSERT INTO ORAS.T_LJ_OP2_NEW_VIA_DEB(OPERATION, COMPTE, LIBELLE, SENS, DATOP, AGENCE, STATUT, JOURNAL,
            SCHEMA, COMPTE_INVERSE, MONTANT, TYP_LIVRE, SPEC,
            NUM_ECR, STRUCTURE, GROUPE,POSTE,AG_LIB)
SELECT OPERATION, COMPTE, LIBELLE, SENS, DATOP, AGENCE, STATUT, JOURNAL,
            SCHEMA, COMPTE_INVERSE, MONTANT, TYP_LIVRE, SPEC,
            NUM_ECR, STRUCTURE, GROUPE,POSTE,AG_LIB
FROM ORAS.VB_LJ_OP2_NEW_VIA_DEB
WHERE DATOP='21/02/2024';

COMMIT;
--------------------------------------------------------------------

INSERT INTO T_TRANSFERT_BIS_ORDRE_OP2_AG_N(TYPE,EMETTEUR,LIBELLE,GESTION,MONTANT,PRIORITE ,JOURNEE,SCHEMA,JOURNAL,STATUT,COMPTE,SENS,DAT_TRANSF,DESTINATAIRE,ECRITURE,GROUPE)
SELECT TYPE, EMETTEUR ,JOURNEE||'-'||LIBELLE LIBELLE ,GESTION, MONTANT, PRIORITE,JOURNEE , SCHEMA, JOURNAL , STATUT, COMPTE, SENS, SYSDATE DAT_TRANSF, SPEC,NUM_ECR,GROUPE
FROM VB_TRANS_INFO_ORDRE_OP2_AG_N
WHERE JOURNEE='21/02/2024';

COMMIT;

-------------------------- DEVERSEMENT TRANSFERT AGENCE -------------------------------------------

SELECT * FROM ORAS.T_OP_TRANS_AG_SIEGE_N where journee = '27/10/2023' and emetteur = '01004';

exec ORAS.JODACCD_TRANS ('01004','2023','27/10/2023',116);