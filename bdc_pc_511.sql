select rgl_ead_num_acte, rgl_mnt_net, rgl_num from t_reglements
where rgl_num
in
(
select rgl_num
from t_entete_acte_depenses a
inner join pecn.t_reglements b on ead_num_acte = rgl_ead_num_acte
where RGL_MRG_CODE = 'BDC'
and rgl_journee between '01/01/2023' and '31/12/2023'
and ead_cde_pc_assi_sig = '511'
and rgl_statut = 'V'
)
--and ead_statut = 'MER'


union

select ide_piece, mt, ''
from fc_ligne@lkast a, fc_ecriture@lkast b 
where (flg_emis_recu, cod_typ_nd, ide_nd_emet, ide_mess)
in
(
select flg_emis_recu, cod_typ_nd, ide_nd_emet, ide_mess
from fm_message@lkast where ide_nd_emet = '511' and ide_gest = '2023' and cod_typ_mess = 23
)
and a.ide_poste = b.ide_poste and a.ide_gest = b.ide_gest and a.flg_cptab = b.flg_cptab and a.ide_jal = b.ide_jal and a.ide_ecr = b.ide_ecr
;


select a.ide_poste pc_code, ide_mess bordereau, a.ide_ecr ecriture, a.flg_cptab comptabilisee, ide_cpt compte, cod_sens sens, mt montant, observ, dat_jc journee_aster, rgl_journee journee_mer
from fc_ligne@lkast a, fc_ecriture@lkast b, t_reglements c 
where (flg_emis_recu, cod_typ_nd, ide_nd_emet, ide_mess)
in
(
select flg_emis_recu, cod_typ_nd, ide_nd_emet, ide_mess
from fm_message@lkast where ide_nd_emet = '511' and ide_gest = '2023' and cod_typ_mess = 23
)
and rgl_num in
(
    select rgl_num
    from t_entete_acte_depenses a
    inner join pecn.t_reglements b on ead_num_acte = rgl_ead_num_acte
    where RGL_MRG_CODE = 'BDC'
    and rgl_journee between '01/01/2023' and '31/12/2023'
    and ead_cde_pc_assi_sig = '511'
    and rgl_statut = 'V'
)
and a.ide_poste = b.ide_poste and a.ide_gest = b.ide_gest and a.flg_cptab = b.flg_cptab and a.ide_jal = b.ide_jal and a.ide_ecr = b.ide_ecr and b.ide_piece = c.rgl_num
order by rgl_journee, a.ide_ecr, a.flg_cptab, cod_sens
; 