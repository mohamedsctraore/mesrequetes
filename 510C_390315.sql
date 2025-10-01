Delete From PIAF_ADM.pc510_pc;

Insert Into PIAF_ADM.pc510_pc
Select ide_gest, ide_poste, ide_cpt m_cpt, ide_ecr, dat_ecr, ide_jal, mt, observ, cod_sens, mt debit, 0 credit
from PIAF_ADM.fc_ligne
where ide_gest = '2025'
--and ide_poste in (select ide_poste from rm_poste where ide_poste = '503' or ide_poste_centra = '503')
and cod_sens = 'D'
and ide_cpt = '58112106'
and dat_ecr between '01/08/2025' and '31/08/2025'
union all
Select ide_gest, ide_poste, ide_cpt m_cpt, ide_ecr, dat_ecr, ide_jal, mt, observ, cod_sens, 0 debit, mt credit
from PIAF_ADM.fc_ligne
where ide_gest = '2025'
--and ide_poste in (select ide_poste from rm_poste where ide_poste = '503' or ide_poste_centra = '503')
and cod_sens = 'C'
and ide_cpt = '58112106'
and dat_ecr between '01/08/2025' and '31/08/2025'
;
    
Select ide_gest ,ide_poste, (select libn from rm_noeud where ide_nd = ide_poste) libn, m_cpt ide_cpt, (select unique libn from PIAF_ADM.fn_compte where ide_cpt = m_cpt) libc, ide_ecr, to_date(dat_ecr,'dd/mm/rrrr') dat_ecr, debit, credit, cod_sens, ide_jal, observ
From PIAF_ADM.pc510_pc
Order by (debit+credit)
;