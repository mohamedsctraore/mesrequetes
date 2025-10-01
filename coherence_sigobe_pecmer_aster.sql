-------------  CREATION TABLE DU FICHIER EXCEL --------------------------
select count(*) from e000618.mandat_sigobe_brut;

------------ AJUSTER LA TABLE --------------------------
create table e000618.mandat_sigobe as
select substr(comptable, 1,7) code, comptable, mandat, objet, montant, date_pec, date_deversement
from e000618.mandat_sigobe_brut;

select *
from e000618.mandat_sigobe;


----------------------- COMPARAISON MANDAT SIGOBE ABSENT MANDAT PECMER --------------------------------------------
select code, mandat, montant
from mandat_sigobe

minus

select ead_fon_code, ead_num_acte, (ead_mnt_cp_tre+ ead_mnt_cp_emp + ead_mnt_cp_don) 
from t_entete_acte_depenses
where ead_statut not in ('PEC', 'MER')
and ead_dte_ordon >= '01/09/2022';


------------------------------- MANDAT SIGOGE NON PEC DANS PECMER  -------------------------------------------------------
select ead_cde_pc_assi_sig poste, (select pct_libelle from pecn.t_poste_comptas where pct_code = ead_cde_pc_assi_sig) libp, ead_num_acte mandat, ead_objet objet, (ead_mnt_cp_tre+ ead_mnt_cp_emp + ead_mnt_cp_don) montant, ead_statut statut, ead_motif_rejet
from t_entete_acte_depenses
where (ead_fon_code, ead_num_acte, (ead_mnt_cp_tre+ ead_mnt_cp_emp + ead_mnt_cp_don)) in
(
select code, mandat, montant
from mandat_sigobe
)
and ead_statut not in ('PEC', 'MER')
order by poste, mandat;

---------------------------------------------  MANDAT PECMER ABSENT FICHIER SIGOBE  -----------------------------------------
select ead_fon_code, ead_num_acte, (ead_mnt_cp_tre+ ead_mnt_cp_emp + ead_mnt_cp_don) 
from t_entete_acte_depenses
where ead_dte_ordon < '01/09/2022'
and ead_exe = '2022'
and ead_type = 'M'

minus

select code, mandat, montant
from mandat_sigobe;


select ead_cde_pc_assi_sig poste, (select pct_libelle from pecn.t_poste_comptas where pct_code = ead_cde_pc_assi_sig) libp, ead_num_acte mandat, ead_objet objet, (ead_mnt_cp_tre+ ead_mnt_cp_emp + ead_mnt_cp_don) montant, ead_statut statut, ead_motif_rejet
from t_entete_acte_depenses
where (ead_fon_code, ead_num_acte, (ead_mnt_cp_tre+ ead_mnt_cp_emp + ead_mnt_cp_don)) in
(
select ead_fon_code, ead_num_acte, (ead_mnt_cp_tre+ ead_mnt_cp_emp + ead_mnt_cp_don) 
from t_entete_acte_depenses
where ead_dte_ordon < '01/09/2022'
and ead_exe = '2022'
and ead_type = 'M'

minus

select code, mandat, montant
from mandat_sigobe
)
order by poste, mandat;


----------------------------------------  MANDAT PEC HORS PERIODE --------------------------------------
select ead_cde_pc_assi_sig poste, (select pct_libelle from pecn.t_poste_comptas where pct_code = ead_cde_pc_assi_sig) libp, ead_num_acte mandat, ead_objet objet, (ead_mnt_cp_tre+ ead_mnt_cp_emp + ead_mnt_cp_don) montant,
 ead_statut statut, ead_journee_pec, ead_dte_ordon
from t_entete_acte_depenses
where (ead_fon_code, ead_num_acte, (ead_mnt_cp_tre+ ead_mnt_cp_emp + ead_mnt_cp_don)) in
(
select ead_fon_code, ead_num_acte, (ead_mnt_cp_tre+ ead_mnt_cp_emp + ead_mnt_cp_don) 
from t_entete_acte_depenses
where ead_statut in ('PEC', 'MER')
and ead_journee_pec <= '31/08/2022'
and ead_type = 'M'
and ead_exe = '2022'

minus

select code, mandat, montant
from mandat_sigobe
)
order by poste, mandat;