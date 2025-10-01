Select ide_poste, ide_ecr, sum(decode(cod_sens,'C',mt,-mt)) mt
from fc_ligne
where (ide_gest, ide_poste, ide_jal, ide_ecr, flg_cptab)
In
(
Select ide_gest, ide_poste, ide_jal, ide_ecr, flg_cptab
From fc_ecriture
Where Ide_Gest in ('2025')
and (ide_poste,ide_mess) in (select ide_nd_emet, ide_mess from fm_message where ide_gest = '2025' and ide_nd_emet = ide_poste and cod_typ_mess = 24)
and flg_cptab = 'N'
)
group by ide_poste, ide_ecr
having sum(decode(cod_sens,'C',mt,-mt)) <> 0
order by ide_poste
;