drop table check_centra;

create table check_centra as
select 'B' cible, ide_poste, ide_cpt, sum(mt) mt from fc_ligne
where (ide_poste, ide_gest, ide_jal, flg_cptab, ide_ecr)
in
(
select ide_poste, ide_gest, ide_jal, flg_cptab, ide_ecr
from fc_ecriture
where ide_gest = '2024'
and ide_poste in (select ide_poste from rm_poste where ide_poste_centra = '&&poste')
)
and ide_cpt in (select ide_cpt from fn_compte where FLG_ACENTRA = 'O')
and flg_cptab = 'O'
and dat_ecr <= '31/12/2024'
group by ide_poste, ide_cpt
union
select 'C' cible, a.ide_nd_emet, ide_cpt, sum(mt) mt
from fc_ecriture a
left join fc_ligne b on a.ide_poste = b.ide_poste
and a.flg_cptab = b.flg_cptab
and a.ide_gest = b.ide_gest
and a.ide_ecr = b.ide_ecr
and a.ide_jal = b.ide_jal 
where a.ide_gest='2024'
and a.ide_poste= '&&poste'
and a.ide_jal='JCENTRAL'
and a.ide_nd_emet in (select ide_poste from rm_poste where ide_poste_centra = '&&poste')
and ide_cpt in (select ide_cpt from fn_compte where FLG_ACENTRA = 'O')
and a.flg_cptab = 'O'
and b.dat_ecr <= '31/12/2024'
group by a.ide_nd_emet, ide_cpt
order by 2,1
;

select ide_poste, ide_cpt, sum(decode(cible, 'B', mt, -mt)) ecart from check_centra
group by ide_poste, ide_cpt
having sum(decode(cible, 'B', mt, -mt)) <> 0
order by ide_poste, ide_cpt;