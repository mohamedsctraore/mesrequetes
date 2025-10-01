drop table credit_delegue_47411; 

create table credit_delegue_47411 as
select ide_poste, sum(mt) mt
from fc_ligne
where ide_gest = '2022'
and ide_cpt = '47411'
and flg_cptab = 'N'
and ide_jal = 'JCENTRAL'
and cod_sens = 'D'
group by ide_poste
order by ide_poste;
