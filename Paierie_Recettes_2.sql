Select a.ide_gest, TO_CHAR(dat_ecr, 'Mon') mois, a.Ide_Poste, c.libn, a.Spec1, b.libn, Sum(a.Mt) Mt_CR
From Fc_Ligne a, fn_compte b, rm_noeud c
Where a.ide_poste = c.ide_nd
and a.spec1 = b.ide_cpt
--and a.Ide_Gest Between '2010' and '2019'
and a.Ide_Poste in (select ide_poste from rm_poste where ide_typ_poste = 'P')
And Flg_Cptab = 'O'
--And Dat_Ecr <= '31/08/2025'
And Spec1 Like '9%'
group by a.ide_gest, TO_CHAR(dat_ecr, 'Mon'), a.Ide_Poste, c.libn, a.Spec1, b.libn
Order By 5,1,2,3
;