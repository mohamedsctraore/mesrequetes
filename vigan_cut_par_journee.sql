select unique dat_jc,ide_cpt from fc_ligne 
---update fc_ligne set spec3= '511', observ = 'BDC20234983 primes et indemnités  PC 671'
where
(ide_poste, ide_gest, flg_cptab, ide_jal, ide_ecr) in
(select ide_poste, ide_gest, flg_cptab, ide_jal, ide_ecr
from fc_ecriture where
ide_gest = '2023'
and ide_poste = '504'
and ide_mess in
(
    select ide_mess from fm_message where
    ide_gest = '2023'
    and cod_typ_mess = 24
    and ide_nd_emet = '504'
    and libl like '%CUT%/2023%'
)
)
--and ide_cpt like '390%'
--and observ like '%LTA%'
--and spec3 = '@PC'
order by ide_cpt
;

select a.ide_poste, c.libl, b.ide_cpt, cod_sens, sum(mt)
from fc_ecriture a
left join fc_ligne b on a.ide_poste = b.ide_poste
inner join fm_message c on a.ide_poste = c.ide_nd_emet
and a.ide_mess = c.ide_mess
and a.flg_cptab = b.flg_cptab
and a.ide_gest = b.ide_gest
and a.ide_ecr = b.ide_ecr
and a.ide_jal = b.ide_jal 
where a.ide_gest='2023'
and a.ide_poste = '504'
and a.flg_cptab = 'O'
--and a.ide_jal='JODPGSGAP'
and b.ide_cpt like '40%'
and ide_mess in
(
    select ide_mess from fm_message where
    ide_gest = '2023'
    and cod_typ_mess = 24
    and ide_nd_emet = '504'
    and libl like '%CUT%EFF%/2023%'
)
group by a.ide_poste, c.libl, b.ide_cpt, cod_sens
order by ide_cpt, to_date(substr(c.libl, -11));
