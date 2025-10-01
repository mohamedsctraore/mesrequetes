select spec3, ide_cpt, mt, observ from fc_ligne
where (ide_poste, ide_ecr, ide_gest, ide_jal, flg_cptab)
in
(
select ide_poste, ide_ecr, ide_gest, ide_jal, flg_cptab
from fc_ecriture where
ide_gest = '2024'
and ide_poste = '619C'
and dat_jc <= '30/06/2024'
)
and spec3 = '501'
and ide_cpt = '39111'

minus

select a.ide_poste, b.ide_cpt, mt, observ
from fc_ecriture a
left join fc_ligne b on a.ide_poste = b.ide_poste
and a.flg_cptab = b.flg_cptab
and a.ide_gest = b.ide_gest
and a.ide_ecr = b.ide_ecr
and a.ide_jal = b.ide_jal 
where a.ide_gest='2024'
and a.ide_poste = '501'
and a.ide_jal='JTRANSFERT'
and b.ide_cpt = '39111'
and  to_date(substr(a.libn, -8)) < '01/07/2024'
--and not regexp_like (substr(a.libn, -8), '^[0-9]{2}\/[0-9]{2}\/[0-9]{2}$')
and a.ide_nd_emet = '619C'