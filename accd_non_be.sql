select * 
from rm_poste
where ide_poste in
(
select unique ide_poste from fc_ecriture
where ide_gest = '2022'
and ide_poste like '2%'

minus

select unique ide_poste from fc_ecriture
where ide_gest = '2023'
and ide_jal = 'TREP'
and ide_poste like '2%'
)
and ide_typ_poste in ('AACCD','AACDC')
;

-----------------------------------------------------------------------------------------------------------------------------------------

select * 
from fc_calend_hist
where ide_poste in
(
select ide_poste 
from rm_poste
where ide_poste in
(
select unique ide_poste from fc_ecriture
where ide_gest = '2022'
and ide_poste like '2%'

minus

select unique ide_poste from fc_ecriture
where ide_gest = '2023'
and ide_jal = 'TREP'
and ide_poste like '2%'
)
and ide_typ_poste in ('AACCD','AACDC')
)
and cod_ferm = 'E'
and ide_gest = '2022'
;