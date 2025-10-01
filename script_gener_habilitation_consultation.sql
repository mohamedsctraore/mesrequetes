select unique 'insert into fh_ut_pu(ide_site, ide_util, ide_profil, ide_poste, dat_dval) values (''CITFI'',''8215'',''12'','''||ide_poste||''',''&&date_dval'');'
from rm_poste
where ide_poste in
(
select ide_poste from rm_poste where ide_poste_centra = '506C'
)
;

select unique 'insert into fh_ut_pu(ide_site, ide_util, ide_profil, ide_poste, dat_dval) values (''CITFI'',''8215'',''110'','''||ide_poste||''',''&&date_dval'');'
from rm_poste
where ide_poste in
(
select ide_poste from rm_poste where ide_poste_centra = '506C'
)
;