select 'insert into fb_excre values ('''||ide_poste||''','''||ide_ordo||''','''||cod_bud||''','''||IDE_LIG_EXEC||''','''||ide_gest||''',''ORDSE'',''BGD20'',''C'','''||sum(mt)||''','''||sysdate||''',''MES'','''||sysdate||''',''MES'',''MES'');'
from fb_ligne_piece
where (ide_gest, ide_poste, IDE_LIG_EXEC)
in
(
select unique ide_gest, ide_poste, IDE_LIG_EXEC
from fb_ligne_piece
where ide_poste like '4%C'
and ide_gest = '2025'
minus
select unique ide_gest, ide_poste, ide_lig_exec
from fb_excre
where ide_poste like '4%C'
and ide_gest = '2025'
)
group by ide_poste, ide_ordo, cod_bud, IDE_LIG_EXEC, ide_gest, 'ORDSE', 'BGD20', 'C', sysdate, 'MES', sysdate, 'MES', 'MES'
;

select 'insert into fb_credi values ('''||ide_poste||''','''||ide_ordo||''','''||cod_bud||''','''||IDE_LIG_PREV||''','''||ide_gest||''',''ORDSE'',''N'',''I'',''BGD20'','''||sum(mt)||''','''||sysdate||''',''MES'','''||sysdate||''',''MES'',''MES'');'
from fb_ligne_piece
where (ide_gest, ide_poste, IDE_LIG_PREV)
in
(
select unique ide_gest, ide_poste, IDE_LIG_PREV
from fb_ligne_piece
where ide_poste like '4%C'
and ide_gest = '2025'
minus
select unique ide_gest, ide_poste, IDE_LIG_PREV
from fb_excre
where ide_poste like '4%C'
and ide_gest = '2025'
)
group by ide_poste, ide_ordo, cod_bud, IDE_LIG_PREV, ide_gest, 'ORDSE', 'BGD20', 'C', sysdate, 'MES', sysdate, 'MES', 'MES'
;