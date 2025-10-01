drop table diff_ndir_web;


create table diff_ndir_web as
        select 'ndir-trep' cible, ide_poste, dat_ecr, sum(mt) mt from fc_ligne@asterv4
        where ide_gest = '2024'
        and ide_poste = '429'
        and cod_sens = 'C'
        and dat_ecr <= '30/08/2024'
        group by ide_poste, dat_ecr
        union
        select 'web-trep' cible, ide_poste, dat_ecr, sum(mt) from fc_ligne
        where ide_gest = '2024'
        and ide_poste = '429'
        and cod_sens = 'C'
        and dat_ecr <= '30/08/2024'
        group by ide_poste, dat_ecr
        ;
        
create table diff as
select ide_poste, dat_ecr, sum(decode(cible, 'ndir-trep',mt,-mt)) diff from diff_ndir_web
group by ide_poste, dat_ecr
having sum(decode(cible, 'ndir-trep',mt,-mt)) <> 0
order by 1,2;

select * from diff_ndir_web
order by 3,2,1;

select ide_poste, libn, dat_ecr, diff
from diff a
inner join rm_noeud b on a.ide_poste = b.ide_nd
order by 1,2
;