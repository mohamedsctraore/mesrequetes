select unique 'exec NIABA.Gener_Jpecdepbg_last ('''||ide_poste||''','''||ide_gest||''','''||dat_cad||''')'
from fb_piece
where ide_gest='2022'
and cod_statut in ('RC')
;

select unique 'insert into fh_ut_pu(ide_site, ide_util, ide_profil, ide_poste, dat_dval) values (''CITFI'',''8215'',''12'','''||ide_poste||''',''18/10/2023'');'
from rm_poste
where ide_poste not in
(
'ACCD',
'ADMIN CITFI',
'ADMIN_DABOU',
'ADMIN_DALOA',
'CG',
'PCD',
'PCPAR',
'RPD',
'RPI'
)
;

select unique 'insert into fh_ut_pu(ide_site, ide_util, ide_profil, ide_poste, dat_dval) values (''CITFI'',''8215'',''110'','''||ide_poste||''',''18/10/2023'');'
from rm_poste
where ide_poste not in
(
'ACCD',
'ADMIN CITFI',
'ADMIN_DABOU',
'ADMIN_DALOA',
'CG',
'PCD',
'PCPAR',
'RPD',
'RPI'
)
;

select distinct a.ide_util
from fh_ut_pu a, fh_util b
where a.ide_util=b.ide_util
and a.ide_util in
(
   select ide_util from fh_util where cod_util in ('F363393','M332135','C373141','X480327','Q276761','H372466','H350412','K350405')
)