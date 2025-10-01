CREATE OR REPLACE PROCEDURE CGST.MAJ_ERREUR(v_gest varchar2) IS
BEGIN

DELETE FROM ERREUR;

INSERT INTO ERREUR
select unique ide_gest, ide_poste, ide_mess
from fc_ecriture
where ide_gest = v_gest
and ide_jal in ('T23','A23')
group by ide_gest, ide_poste;

END;

SELECT ide_gest, ide_poste, count(ide_mess)
FROM ERREUR
group by ide_gest, ide_poste;
