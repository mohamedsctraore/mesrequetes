drop table controle_transfert;

create table controle_transfert as
select 'E' cible, ide_poste, ide_cpt, dat_ecr, sum(decode(cod_sens, 'C', mt, -mt)) mt
from fc_ligne
where (ide_poste, ide_gest, ide_jal, flg_cptab, ide_ecr)
in
(
select ide_poste, ide_gest, ide_jal, flg_cptab, ide_ecr
from fc_ecriture
where ide_gest = '2024'
and ide_poste = '501'
and ide_jal <> 'JTRANSFERT'
)
and spec3 = '503'
and flg_cptab = 'O'
and ide_cpt in (select ide_cpt from fn_compte where flg_atrans = 'O')
group by ide_poste, ide_cpt, dat_ecr
union
select 'R' cible, a.ide_poste, ide_cpt, to_date(substr(libn,-8),'dd/mm/rrrr'), sum(decode(cod_sens, 'D', mt, -mt)) mt
from fc_ligne a, fc_ecriture b
where a.ide_gest = b.ide_gest
and a.ide_poste = b.ide_poste
and a.ide_jal = b.ide_jal
and a.ide_poste = b.ide_poste
and a.ide_ecr = b.ide_ecr
and a.flg_cptab = b.flg_cptab
and a.ide_gest = '2024'
and a.ide_poste = '503'
and b.ide_nd_emet = '501'
and a.ide_jal = 'JTRANSFERT'
and ide_cpt in (select ide_cpt from fn_compte where flg_atrans = 'O')
group by a.ide_poste, ide_cpt, to_date(substr(libn,-8),'dd/mm/rrrr')
order by 3,4,1
;

select * from controle_transfert;

select ide_cpt, dat_ecr, sum(decode(cible,'E',mt,-mt)) 
from controle_transfert
group by ide_cpt, dat_ecr
having sum(decode(cible,'E',mt,-mt)) <> 0
order by ide_cpt, dat_ecr;


select * from fc_ligne
--update fc_ligne set dat_transf = dat_cre
where (ide_poste, ide_gest, ide_jal, flg_cptab, ide_ecr) in
(
select ide_poste, ide_gest, ide_jal, flg_cptab, ide_ecr from fc_transfert where (ide_poste, ide_gest, ide_jal, flg_cptab, ide_ecr) in
(
select ide_poste, ide_gest, ide_jal, flg_cptab, ide_ecr from fc_ligne
where (ide_poste, ide_gest, ide_jal, flg_cptab, ide_ecr)
in
(
select ide_poste, ide_gest, ide_jal, flg_cptab, ide_ecr
from fc_ecriture
where ide_gest = '2024' 
and ide_poste = '501'
and dat_jc = '30/12/2024'
and ide_jal = 'JODACCT'
)
--and spec3 = '503'
and ide_cpt like '391%'
)
)
and ide_cpt like '391%'
and dat_transf is null
;