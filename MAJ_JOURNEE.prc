CREATE OR REPLACE PROCEDURE CGST.MAJ_JOURNEE(v_gest varchar2) IS
BEGIN

DELETE FROM JOURNEE;

INSERT INTO JOURNEE
SELECT unique ide_poste, dat_jc, 'O' cod_ferm
from fc_calend_hist
where ide_gest = v_gest
and cod_ferm = 'O'

UNION

SELECT unique ide_poste, dat_jc, 'C' cod_ferm
from fc_calend_hist
where ide_gest = v_gest
and cod_ferm = 'C'
;

END; 


select cod_ferm, count(cod_ferm)
from JOURNEE
group by cod_ferm;