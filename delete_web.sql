delete from fm_rnl_me where ide_nd_dest in ('3077');
delete from fm_message where ide_nd_emet in ('3077');
delete from fc_ligne_cut_ndir where ide_poste in ('3077');
delete from fc_ecriture_cut_ndir  where ide_poste in ('3077');

delete from cut.verif_devers_web@lkcut where transf_pc_code in ('3077');


--delete from fm_rnl_me;
--delete from fm_message;
--delete from fc_ligne_cut_ndir;
--delete from fc_ecriture_cut_ndir;
--
--delete from cut.verif_devers_web@lkcut;

--Select V_Dte_Reglement, V_Mt
--From V_PGAE