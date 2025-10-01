select *
from solde390xx a
left join mt_a_denouer b on a.ide_cpt = b.ide_cpt
and ide_poste_centra = ide_poste;

select *
from mt_a_denouer
order by ide_cpt, ide_poste;

select *
from centra_a_denouer;

select ide_poste, ide_cpt, sum(mt)
from fc_ligne
where (ide_poste, ide_gest, flg_cptab, ide_jal, ide_ecr) in
(select ide_poste, ide_gest, flg_cptab, ide_jal, ide_ecr
from fc_ecriture where
ide_gest = '2022'
and (ide_poste, ide_mess) in
(
select ide_poste, ide_mess
from centra_a_denouer
)
)
group by ide_poste, ide_cpt;

create table mt_a_denouer as
select a.ide_poste, a.ide_cpt, sum(mt) mt
from fc_ligne a
inner join fc_ecriture b on a.ide_poste = b.ide_poste
inner join centra_a_denouer c on a.ide_poste = poste
and b.ide_mess = bordereau
and a.ide_gest = b.ide_gest
and a.flg_cptab = b.flg_cptab
and a.ide_jal = b.ide_jal
and a.ide_ecr = b.ide_ecr
and b.ide_poste = poste
and a.ide_gest = '2022'
and a.ide_cpt in ('39030202','390302722171','390302722172')
group by a.ide_poste, a.ide_cpt
order by ide_poste
;