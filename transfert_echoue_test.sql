select * from fc_ligne where 
(spec3, spec2, mt, observ ) in

(

select spec3, spec2, mt, observ from fc_ligne where (ide_poste, ide_gest, ide_jal, flg_cptab, ide_ecr)
in (select ide_poste, ide_gest, ide_jal, flg_cptab, ide_ecr 
from fc_ecriture where 
ide_gest='2021'
and ide_poste='228C'
)
and dat_transf is not null
and spec3='201C'
and flg_cptab='O'
MINUS
select ide_poste, ide_cpt, mt, observ from fc_ligne where (ide_poste, ide_gest, ide_jal, flg_cptab, ide_ecr)
in (select ide_poste, ide_gest, ide_jal, flg_cptab, ide_ecr 
from fc_ecriture where 
ide_gest='2021'
and ide_poste='201C'
and ide_nd_emet='228C'
and ide_mess in (select unique ide_mess from fm_rnl_me
where ide_nd_dest='201C'
and ide_nd_emet='228C'
and dat_cre >= to_date('01/01/2021')
)
)
and ide_cpt='39031'

)

and ide_poste='228C'
and spec3='201C'