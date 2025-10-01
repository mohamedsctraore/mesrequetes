Delete From PIAF_ADM.pc510_pc;

Insert Into PIAF_ADM.pc510_pc
Select ide_gest, ide_poste, ide_cpt m_cpt, ide_ecr, dat_ecr, ide_jal, mt, observ, cod_sens, mt debit, 0 credit
from PIAF_ADM.fc_ligne
where ide_gest = '2025'
--and ide_poste in (select ide_poste from rm_poste where ide_poste = '510C' or ide_poste_centra = '510C')
and cod_sens = 'D'
and ide_cpt in ('39030272331','39030272364','44826')
--and spec3 = '502'
and dat_ecr between '01/01/2025' and '24/09/2025'
union all
Select ide_gest, ide_poste, ide_cpt m_cpt, ide_ecr, dat_ecr, ide_jal, mt, observ, cod_sens, 0 debit, mt credit
from PIAF_ADM.fc_ligne
where ide_gest = '2025'
--and ide_poste in (select ide_poste from rm_poste where ide_poste = '510C' or ide_poste_centra = '510C')
and cod_sens = 'C'
and ide_cpt in ('39030272331','39030272364','44826')
--and spec3 = '502'
and dat_ecr between '01/01/2025' and '24/09/2025'
;
    
Select ide_gest ,ide_poste, (select libn from rm_noeud where ide_nd = ide_poste) libn, m_cpt ide_cpt, (select unique libn from PIAF_ADM.fn_compte where ide_cpt = m_cpt) libc, ide_ecr, to_date(dat_ecr,'dd/mm/rrrr') dat_ecr, debit, credit, cod_sens, ide_jal, observ
From PIAF_ADM.pc510_pc
Order by (debit+credit)
;

Select ide_gest ,ide_poste, (select libn from rm_noeud where ide_nd = ide_poste) libn, m_cpt ide_cpt, (select unique libn from PIAF_ADM.fn_compte where ide_cpt = m_cpt) libc, ide_ecr, to_date(dat_ecr,'dd/mm/rrrr') dat_ecr, debit, credit, cod_sens, ide_jal, observ
From PIAF_ADM.pc510_pc
Order by to_date(dat_ecr,'dd/mm/rrrr')
;

Select ide_gest ,ide_poste, (select libn from rm_noeud where ide_nd = ide_poste) libn, m_cpt ide_cpt, (select unique libn from PIAF_ADM.fn_compte where ide_cpt = m_cpt) libc, ide_ecr, to_date(dat_ecr,'dd/mm/rrrr') dat_ecr, debit, credit, cod_sens, ide_jal, observ
From PIAF_ADM.pc510_pc
Where Ide_Jal <> 'JCENTRAL'
Order by m_cpt, ide_poste, to_date(dat_ecr,'dd/mm/rrrr')
;