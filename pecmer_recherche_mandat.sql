select ead_num_acte, ead_pec_aster, ead_devers_pec, dat_valic_centra  /** */from t_entete_acte_depenses@asterwebpec a, t_detail_acte_depenses@asterwebpec b
where a.ead_cde_pc_assi_sig = b.dap_pct_code
and a.ead_num_acte = b.dap_ead_num_acte
and a.ead_cde_pc_assi_sig in ('676','696')
and a.EAD_JOURNEE_PEC Between '01/07/2025' And '31/07/2025'
--And a.EAD_TYPE = 'M'
and a.ead_num_acte in
(
'314142625100015',
'314142625100016',
'314178425100017',
'314178425100018',
'314178425100019',
'314178425100020',
'211180225100003',
'211180225100004',
'217103725100002',
'217103725100003',
'217103725100004',
'217103725100005'
)
--and dat_valic_centra is null
--Group by a.Ead_Cde_Pc_Assi_Sig, DAP_CPT_CREDIT
--Order By 1,2
--Order by 2,3
;


----------------------------------------------------------------------------------

select Ead_Cde_Pc_Assi_Sig, DAP_CPT_CREDIT, Sum(Ead_Mnt_Cp_Tre) from t_entete_acte_depenses@asterwebpec a, t_detail_acte_depenses@asterwebpec b
where a.ead_cde_pc_assi_sig = b.dap_pct_code
and a.ead_num_acte = b.dap_ead_num_acte
and a.ead_cde_pc_assi = '632'
and a.EAD_JOURNEE_PEC Between '01/07/2025' And '31/07/2025'
And a.EAD_TYPE = 'M'
Group by a.Ead_Cde_Pc_Assi_Sig, DAP_CPT_CREDIT
Order By 1,2
;

select a.ide_poste, a.ide_nd_emet, b.ide_cpt, sum(mt)
from fc_ecriture a
left join fc_ligne b on a.ide_poste = b.ide_poste
and a.flg_cptab = b.flg_cptab
and a.ide_gest = b.ide_gest
and a.ide_ecr = b.ide_ecr
and a.ide_jal = b.ide_jal 
where a.ide_gest='2025'
and a.ide_poste = '632C'
and a.ide_jal='JPECDEPBG'
and b.ide_cpt like '474%'
and cod_sens = 'C'
and a.dat_jc between '01/07/2025' and '31/07/2025'
group by a.ide_poste, a.ide_nd_emet, b.ide_cpt
order by 2,3;