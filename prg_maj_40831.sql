DECLARE
    v_mandat piaf_adm.fc_ecriture.ide_piece%type;
    v_poste piaf_adm.fb_piece.ide_poste%type; 
    v_ide_gest piaf_adm.fb_piece.ide_gest%type; 
    v_ide_ordo piaf_adm.fb_piece.ide_ordo%type;
    v_cod_bud piaf_adm.fb_piece.cod_bud%type;
    v_ide_piece piaf_adm.fb_piece.ide_piece%type;
    v_cod_typ_nd piaf_adm.fb_piece.cod_typ_nd%type;
    v_ide_nd_emet piaf_adm.fb_piece.ide_nd_emet%type;
    v_flg_emis_recu piaf_adm.fb_piece.flg_emis_recu%type;
    v_objet piaf_adm.fb_piece.objet%type;
    v_mt piaf_adm.fb_piece.mt%type;
    v_dat_cpta piaf_adm.fb_piece.dat_cpta%type;
    v_cod_typ_piece piaf_adm.fb_piece.cod_typ_piece%type;
    v_var_bud piaf_adm.Fb_Ligne_Piece.var_bud%type;
    v_ide_lig_exec piaf_adm.Fb_Ligne_Piece.ide_lig_exec%type;
    v_var_cpta piaf_adm.Fb_Ligne_Piece.var_cpta%type;
    v_cpt_credit piaf_adm.Fb_Ligne_Tiers_Piece.ide_cpt%type;
    v_cpt_debit piaf_adm.Fb_Ligne_Piece.ide_cpt%type;
    v_ide_ecr_max piaf_adm.Fc_Ecriture.ide_ecr%type;
    v_var_tiers piaf_adm.Fb_Ligne_Tiers_Piece.var_tiers%type;
    v_ide_tiers piaf_adm.Fb_Ligne_Tiers_Piece.ide_tiers%type;

BEGIN
    Select a.Ide_Poste, a.Ide_Gest, a.Ide_Ordo, a.Cod_Bud, a.Ide_Piece, a.Cod_Typ_Nd, a.Ide_Nd_Emet, a.Flg_Emis_Recu, a.Objet, a.Mt, a.Dat_Cpta, a.cod_typ_piece, b.Ide_Cpt, c.var_bud, c.ide_lig_exec, c.var_cpta, c.ide_cpt, b.var_tiers, b.ide_tiers
    Into v_poste, v_ide_gest, v_ide_ordo, v_cod_bud, v_ide_piece, v_cod_typ_nd, v_ide_nd_emet, v_flg_emis_recu, v_objet, v_mt, v_dat_cpta, v_cod_typ_piece, v_cpt_credit, v_var_bud, v_ide_lig_exec, v_var_cpta, v_cpt_debit, v_var_tiers, v_ide_tiers
    From Fb_Piece a, Fb_Ligne_Tiers_Piece b, Fb_Ligne_Piece c
    Where A.Ide_Poste = B.Ide_Poste
    And A.ide_Piece = B.Ide_Piece
    And a.Ide_Poste = C.Ide_Poste
    And A.ide_Piece = C.Ide_Piece
    And A.Ide_Poste = '409C'
    And A.Ide_Piece = '317110025100388';
    
    Select Max(Ide_Ecr) + 1 Into v_ide_ecr_max From Fc_Ecriture Where Ide_Jal = 'JPECDEPBG' And Flg_Cptab = 'O' And Ide_Poste = '409C' And ide_Gest = '2025';
    
    Insert Into Fc_Ecriture (Ide_Poste, Ide_Gest, Ide_Jal, Flg_Cptab, Ide_Ecr, Dat_Jc, Var_Cpta, Ide_Schema, Ide_Nd_Emet, Libn, Dat_Saisie, Dat_Ecr, Cod_Statut, Cod_Bud, Ide_Ordo, Ide_Piece, Cod_Typ_Piece, Dat_Cre, Uti_Cre, Dat_Maj, Uti_Maj, Terminal)
    Values (v_poste, v_ide_gest, 'JPECDEPBG', 'O', v_ide_ecr_max, v_dat_cpta, v_var_cpta, '1', v_ide_nd_emet, v_objet, sysdate, v_dat_cpta, 'CO', v_cod_bud, v_ide_ordo, v_ide_piece, v_cod_typ_piece, sysdate, 'DEV', sysdate, 'DEV', 'DEV');
    
    Insert Into Fc_Ligne (Ide_Poste, Ide_Gest, Ide_Jal, Flg_Cptab, Ide_Ecr, Ide_Lig, Var_Cpta, Var_tiers, Ide_tiers, ide_cpt, var_bud, ide_lig_exec, ide_ordo, cod_sens, mt, observ, ide_schema, cod_typ_schema, ide_modele_lig, dat_ecr, cod_typ_bud, cod_bud, Dat_Cre, Uti_Cre, Dat_Maj, Uti_Maj, Terminal, mt_dev)
    Values (v_poste, v_ide_gest, 'JPECDEPBG', 'O', v_ide_ecr_max, 1, v_var_cpta, null, null, v_cpt_credit, v_var_bud, v_ide_lig_exec, v_ide_ordo, 'C', v_mt, 'PEC BUDGETAIRE MANDAT '|| v_ide_piece, '1', 'P', 'PEC4XX', v_dat_cpta, null, null, sysdate, 'DEV', sysdate, 'DEV', 'DEV', v_mt); 
    
    Insert Into Fc_Ligne (Ide_Poste, Ide_Gest, Ide_Jal, Flg_Cptab, Ide_Ecr, Ide_Lig, Var_Cpta, Var_tiers, Ide_tiers, ide_cpt, var_bud, ide_lig_exec, ide_ordo, cod_sens, mt, observ, ide_schema, cod_typ_schema, ide_modele_lig, dat_ecr, cod_typ_bud, cod_bud, Dat_Cre, Uti_Cre, Dat_Maj, Uti_Maj, Terminal, mt_dev)
    Values (v_poste, v_ide_gest, 'JPECDEPBG', 'O', v_ide_ecr_max, 2, v_var_cpta, v_var_tiers, v_ide_tiers, v_cpt_debit, v_var_bud, null, null, 'D', v_mt, 'PEC BUDGETAIRE MANDAT '|| v_ide_piece, '1', 'P', 'PEC4XX', v_dat_cpta, null, null, sysdate, 'DEV', sysdate, 'DEV', 'DEV', v_mt); 
    
    DBMS_OUTPUT.PUT_LINE(v_poste);
END;

Select * From Fb_Piece Where Ide_Piece = '317217525100276';
Select * From Fb_Ligne_Tiers_Piece Where Ide_Piece = '317217525100276';
Select * From Fb_Ligne_Piece Where Ide_Piece = '317217525100276';


Select * From Fc_Ecriture Where Ide_Piece = '317217525100276' And ide_poste = '407C';

Select * From Fc_Ligne
Where (ide_Poste, ide_gest, ide_jal, flg_cptab, ide_ecr)
in
(
Select ide_Poste, ide_gest, ide_jal, flg_cptab, ide_ecr
from fc_ecriture
where Ide_piece = '317217525100276'
and ide_poste = '407C'
)
;