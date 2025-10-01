Select a.Ide_Poste, c.libn, a.Spec1, b.libn, Sum(a.Mt) Mt_CR
From Fc_Ligne a, fn_compte b, rm_noeud c
Where a.ide_poste = c.ide_nd
and a.spec1 = b.ide_cpt
and a.Ide_Gest = '2025'
and a.Ide_Poste in (select ide_poste from rm_poste where ide_typ_poste = 'P')
And Flg_Cptab = 'O'
And Dat_Ecr <= '30/09/2025'
And Spec1 Like '7%'
group by a.Ide_Poste, c.libn, a.Spec1, b.libn
Order By 3,1
;