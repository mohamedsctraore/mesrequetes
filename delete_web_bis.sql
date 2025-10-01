delete from fm_rnl_me where ide_nd_dest in (select pc_code from cut.cut_poste@lkcut where pc_gp='EPN' and pc_code between '3043' and '3080');
delete from fm_message where ide_nd_emet in (select pc_code from cut.cut_poste@lkcut where pc_gp='EPN' and pc_code between '3043' and '3080');
delete from fc_ligne_cut_ndir where ide_poste in (select pc_code from cut.cut_poste@lkcut where pc_gp='EPN' and pc_code between '3043' and '3080');
delete from fc_ecriture_cut_ndir where ide_poste in (select pc_code from cut.cut_poste@lkcut where pc_gp='EPN' and pc_code between '3043' and '3080');

delete from cut.verif_devers_web@lkcut where transf_pc_code in (select pc_code from cut.cut_poste@lkcut where pc_gp='EPN' and pc_code between '3043' and '3080');
