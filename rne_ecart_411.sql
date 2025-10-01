select * from fc_reglement
where ide_poste = '411'
--and ide_piece like '%376'
--and ide_reglt = 112
and ide_gest = '2024'
and dat_cre > '31/12/2024'
and ide_mod_reglt = 'RAPE'
;

select ide_poste, ide_ref_piece, sum(decode(cod_sens,'C',mt,0)), sum(decode(cod_sens,'D',mt,0)), sum(decode(cod_sens,'C',mt_dev,-mt_dev))
from fc_ligne
where ide_gest = '2024' 
and ide_poste = '411'
group by ide_poste, ide_ref_piece
order by ide_ref_piece
;