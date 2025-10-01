Alter session set nls_date_format = 'DD/MM/RRRR';

Select unique 'execute NIABA.GENERE_BE_ASTERWEB ('''||ide_poste||''',''2024'','''||NIABA.ASTERWEB_MAX_DATE ('2024',ide_poste)||''',''2025'',''02/01/2025'',''P'')'
From fc_calend_hist where ide_poste not in 
(
Select ide_poste from fc_calend_hist where ide_gest = '2024' and ide_poste in (select * from E000618.be_a_reprendre) and cod_ferm in ('O')
)
And ide_poste in (select * from E000618.be_a_reprendre)
--And Ide_Poste In ('3019','630','691')
--And Ide_Poste In 
--(Select Ide_Poste from Rm_Poste where Ide_Typ_Poste In ('P','PC'))
And ide_gest = '2024'
Order By 1
;

execute NIABA.GENERE_BE_ASTERWEB ('411C','2024','31/12/2024','2025','02/01/2025','P')