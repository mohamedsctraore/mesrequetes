select dap_ead_num_acte
from t_detail_acte_depenses a
inner join t_entete_acte_depenses b on a.dap_ead_num_acte = b.ead_num_acte
and a.dap_cpt_debit = '4081'
and b.ead_cde_pc_assi_sig = '514'
and ead_exe = '2021'

minus 

select a.ide_piece
from fb_piece@lkast a
inner join fb_ligne_piece@lkast b on a.ide_poste = b.ide_poste
and a.ide_gest = b.ide_gest
and a.ide_piece = b.ide_piece
and a.ide_gest = '2021'
and a.ide_poste = '514'
and b.IDE_CPT='4081'