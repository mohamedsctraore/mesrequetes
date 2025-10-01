select ide_poste_centra, a.ide_poste, spec2, sum(mt)
from fc_ligne a
inner join rm_poste b on a.ide_poste = b.ide_poste
where ide_gest = '2023'
and a.ide_poste in (select ide_poste from rm_poste where ide_typ_poste in ('TG','TP','T'))
and ide_cpt = '46693'
group by ide_poste_centra, a.ide_poste, spec2
order by ide_poste_centra
;

create table envoi_caution as
select ide_poste, ide_gest, ide_jal, ide_ecr, ide_cpt, spec2, mt, observ, dat_ecr  from fc_ligne 
where (ide_poste, ide_gest, flg_cptab, ide_ecr, mt)
in
(
select ide_poste, ide_gest, flg_cptab, ide_ecr, mt from fc_ligne
where ide_gest = '2023'
and ide_poste in (select ide_poste from rm_poste where ide_typ_poste = 'TC')
and ide_cpt = '39030272299'
and cod_sens = 'D'
--and upper(observ) like '%CAUT%'
)
and spec2 is not null
order by ide_poste, dat_ecr
;

select ide_poste, ide_gest, ide_jal, ide_ecr, ide_cpt, mt debit, 0 credit, observ, dat_ecr, cod_sens from fc_ligne
where ide_gest = '2023'
and ide_poste = '501'
and ide_jal = 'JTRANSFERT'
and cod_sens = 'D'
and observ in
(
select observ from envoi_caution

minus

select observ from fc_ligne
where ide_gest = '2023'
and ide_poste = '501'
and ide_cpt in ('46693')
)


union 

select ide_poste, ide_gest, ide_jal, ide_ecr, ide_cpt, 0 debit, mt credit, observ, dat_ecr, cod_sens from fc_ligne
where ide_gest = '2023'
and ide_poste = '501'
and ide_jal = 'JTRANSFERT'
and cod_sens = 'C'
and observ in
(
select observ from envoi_caution

minus

select observ from fc_ligne
where ide_gest = '2023'
and ide_poste = '501'
and ide_cpt in ('46693')
)

order by ide_ecr, observ, cod_sens;

select ide_poste, mt, observ
from fc_ligne
where ide_gest = '2023'
and ide_poste in (select ide_poste from rm_poste where ide_poste_centra = '644C')
and ide_cpt = '39030272299'
order by dat_ecr;

select a.ide_poste, b.ide_cpt, mt, observ
from fc_ecriture a
left join fc_ligne b on a.ide_poste = b.ide_poste
and a.flg_cptab = b.flg_cptab
and a.ide_gest = b.ide_gest
and a.ide_ecr = b.ide_ecr
and a.ide_jal = b.ide_jal 
where a.ide_gest='2023'
and a.ide_jal='JTRANSFERT'
and ide_nd_emet = '604C'
and b.ide_cpt = '46693'
and a.ide_poste = '501'
order by a.dat_jc
;

select a.ide_poste, b.ide_cpt, mt, observ
from fc_ecriture a
left join fc_ligne b on a.ide_poste = b.ide_poste
and a.flg_cptab = b.flg_cptab
and a.ide_gest = b.ide_gest
and a.ide_ecr = b.ide_ecr
and a.ide_jal = b.ide_jal 
where a.ide_gest='2023'
--and a.ide_jal='JTRANSFERT'
--and ide_nd_emet = '604C'
and b.ide_cpt = '39030272299'
and a.ide_poste in (select ide_poste from rm_poste where ide_poste_centra = '604C')
order by a.dat_jc
;

select mt, observ
from fc_ecriture a
left join fc_ligne b on a.ide_poste = b.ide_poste
and a.flg_cptab = b.flg_cptab
and a.ide_gest = b.ide_gest
and a.ide_ecr = b.ide_ecr
and a.ide_jal = b.ide_jal 
where a.ide_gest='2023'
and a.ide_jal='JTRANSFERT'
and ide_nd_emet = '604C'
and b.ide_cpt = '46693'
and a.ide_poste = '501'

minus

select mt, observ
from fc_ecriture a
left join fc_ligne b on a.ide_poste = b.ide_poste
and a.flg_cptab = b.flg_cptab
and a.ide_gest = b.ide_gest
and a.ide_ecr = b.ide_ecr
and a.ide_jal = b.ide_jal 
where a.ide_gest='2023'
--and a.ide_jal='JTRANSFERT'
--and ide_nd_emet = '604C'
and b.ide_cpt = '39030272299'
and a.ide_poste in (select ide_poste from rm_poste where ide_poste_centra = '604C')

