--------------  PEC --------------------
select unique ead_cde_pc_assi_sig poste, (select pct_libelle from pecn.t_poste_comptas where pct_code = ead_cde_pc_assi_sig) libp,
              ead_cde_pc_assi centra, (select pct_libelle from pecn.t_poste_comptas where pct_code = ead_cde_pc_assi) libc,
              ead_journee_pec journee_pec, statut_journ statut_journee
from pecn.t_entete_acte_depenses
inner join pecn.t_journees on ead_journee_pec = date_journ
and ead_cde_pc_assi_sig = code_pct
and type_journ = 'P'
and (ead_cde_pc_assi_sig, ead_num_acte)
in
(
select ead_cde_pc_assi_sig poste, ead_num_acte--, --ead_journee_pec
from t_entete_acte_depenses
inner join pecn.t_journees on ead_journee_pec = date_journ
and ead_cde_pc_assi_sig = code_pct
and type_journ = 'P'
and statut_journ = 'C'
where ead_exe = '2024'
and ead_statut in ('PEC','MER')
--and ead_cde_pc_assi in (510,514,606,613,617,619,623,624,625,642,657,690)
--and ead_cde_pc_assi in (select POSTE_CF from situation_pec_devers where (mt_pec - mt_aster) <> 0)

--and ead_dte_ordon <= '31/05/2022'
and ead_journee_pec between '01/06/2024' and '15/07/2024'

minus

select ide_nd_emet, ide_piece--, --dat_cad
from fc_ecriture@lkast
where ide_gest = '2024'
and ide_poste not like '4%'
and ide_jal = 'JPECDEPBG'
)
and statut_journ = 'C'
--and ead_journee_pec <= '31/05/2022'
--and to_char(ead_dte_pec, 'dd/mm/yyyy') <> to_char(sysdate, 'dd/mm/yyyy')
order by ead_cde_pc_assi,ead_cde_pc_assi_sig, ead_journee_pec
;

-------------------------------------
------------- MER -------------------
select unique ead_cde_pc_assi_sig poste, ead_journee_pec journee_pec, statut_journ statut_journee
from t_entete_acte_depenses
inner join pecn.t_journees on ead_journee_pec = date_journ
and ead_cde_pc_assi_sig = code_pct
and type_journ = 'M'
and (ead_cde_pc_assi_sig, ead_num_acte)
in
(
select ead_cde_pc_assi_sig poste, ead_num_acte--, --ead_journee_pec
from pecn.t_entete_acte_depenses
where ead_exe = '2022'
and ead_statut in ('MER')
and hors_sigacut='O'
--and ead_cde_pc_assi = '501'
--and ead_dte_ordon <= '31/05/2022'
--and ead_journee_pec <= '31/05/2022'

minus

select dap_pct_code, ead_num_acte--, --dat_cad
from fc_transfert_mer
where ead_exe = '2022'
--and ide_poste not like '4%'
)
--and ead_journee_pec <= '31/05/2022'
order by ead_cde_pc_assi_sig, ead_journee_pec
;

