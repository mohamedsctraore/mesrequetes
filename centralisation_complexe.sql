select ide_poste, dat_centra, dat_ecr, sum(mt)
from fc_ligne
where ide_poste = '647'
and ide_gest = '2022'
and dat_centra is not null
and ide_cpt = '39030303'
and cod_sens = 'D'
and dat_ecr between '01/07/2022' and '31/07/2022'
group by ide_poste, dat_centra, dat_ecr
order by dat_centra desc
;

select a.ide_poste, a.libn, b.ide_cpt, sum(mt)
from fc_ecriture a
left join fc_ligne b on a.ide_poste = b.ide_poste
and a.flg_cptab = b.flg_cptab
and a.ide_gest = b.ide_gest
and a.ide_ecr = b.ide_ecr
and a.ide_jal = b.ide_jal 
where a.ide_gest='2022'
and a.ide_jal='JCENTRAL'
and b.ide_cpt = '39030303'
and a.ide_poste = '647C'
and a.ide_nd_emet = '647'
and cod_sens = 'C'
and a.dat_jc between '01/07/2022' and '31/07/2022'
group by  a.ide_poste, a.libn, b.ide_cpt;