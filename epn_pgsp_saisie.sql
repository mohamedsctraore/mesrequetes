Insert Into evolution_390315
Select ide_gest, ide_poste, ide_jal, flg_cptab, ide_ecr, ide_cpt, cod_sens, mt debit, 0 credit, observ, dat_ecr, dat_maj from fc_ligne where
(ide_poste, ide_gest, ide_jal, flg_cptab, ide_ecr)
In
(
Select ide_poste, ide_gest, ide_jal, flg_cptab, ide_ecr
From fc_ecriture
Where ide_gest = '2025' 
)
And ide_cpt = '390315'
And to_date(dat_ecr,'dd/mm/rrrr') between to_date('01/02/2025','dd/mm/rrrr') and to_date('28/02/2025','dd/mm/rrrr')
And cod_sens = 'D'
Union All
Select ide_gest, ide_poste, ide_jal, flg_cptab, ide_ecr, ide_cpt, cod_sens, 0 debit, mt credit, observ, dat_ecr, dat_maj from fc_ligne where
(ide_poste, ide_gest, ide_jal, flg_cptab, ide_ecr)
In
(
Select ide_poste, ide_gest, ide_jal, flg_cptab, ide_ecr
From fc_ecriture
Where ide_gest = '2025' 
)
And ide_cpt = '390315'
And to_date(dat_ecr,'dd/mm/rrrr') between to_date('01/02/2025','dd/mm/rrrr') and to_date('28/02/2025','dd/mm/rrrr')
And cod_sens = 'C'
Order by dat_maj desc
;


Select a.ide_gest, b.libn, a.ide_poste, a.ide_jal, a.flg_cptab, a.ide_ecr, a.ide_cpt, a.cod_sens, a.debit, a.credit, a.dat_ecr, a.dat_maj dat_saisie 
From evolution_390315 a
Inner Join rm_noeud b on ide_poste = ide_nd
Order By a.dat_maj Desc;