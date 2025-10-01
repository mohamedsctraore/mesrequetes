Drop table pc510_pc;

Create table PIAF_ADM.pc510_pc as
Select ide_gest, ide_poste, ide_cpt m_cpt, ide_ecr, dat_ecr, ide_jal, mt, observ, cod_sens, mt debit, 0 credit
from fc_ligne
where ide_gest = '2025'
and ide_poste in (select ide_poste from rm_poste where ide_poste = '510C' or ide_poste_centra = '510C')
and cod_sens = 'D'
and ide_cpt = '390315'
and dat_ecr between '01/05/2025' and '14/05/2025'
union
Select ide_gest, ide_poste, ide_cpt m_cpt, ide_ecr, dat_ecr, ide_jal, mt, observ, cod_sens, 0 debit, mt credit
from fc_ligne
where ide_gest = '2025'
and ide_poste in (select ide_poste from rm_poste where ide_poste = '510C' or ide_poste_centra = '510C')
and cod_sens = 'C'
and ide_cpt = '390315'
and dat_ecr between '01/05/2025' and '14/05/2025'
;

Select ide_gest ,ide_poste, (select libn from rm_noeud where ide_nd = ide_poste) libn, m_cpt ide_cpt, (select unique libn from fn_compte where ide_cpt = m_cpt) libc, ide_ecr, dat_ecr, debit, credit, cod_sens, ide_jal, observ
From pc510_pc
Order by (debit+credit)
;

Select ide_poste, ide_ecr, observ, cod_sens, debit, credit from pc510_pc order by (debit+credit)
;