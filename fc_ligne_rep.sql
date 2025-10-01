insert into fc_ligne
select * from piaf_adm.fc_ligne_rep
;

select 'REP' cible, ide_poste, ide_cpt, sum(mt) from piaf_adm.fc_ligne_rep
where ide_gest = '2024'
and ide_jal = 'TREP'
and ide_poste = '503'
group by ide_poste, ide_cpt
union
select 'BE2024' cible, ide_poste, ide_cpt, sum(mt)
from fc_ligne
where ide_gest = '2024'
and ide_jal = 'TREP'
and ide_poste = '503'
and ide_cpt in (select ide_cpt from fn_compte where flg_justif = 'O')
and ide_ref_piece is null
group by ide_poste, ide_cpt
order by 3,1
;

select cod_sens, sum(mt)
from fc_ligne
where ide_gest = '2024'
and ide_poste = '503'
and flg_cptab = 'O'
group by cod_sens
;