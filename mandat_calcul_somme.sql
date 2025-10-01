drop table pec_b;
drop table pec_c;
drop table pec_cc;
drop table aster_c;
drop table aster_b;
drop table situation_pec_devers;
drop table situation_aster_constat_pec;

--------------  PEC DANS LE CENTRALISATEUR DE LA CF -------------------

create table pec_b as
select ead_cde_pc_assi centra, ead_cde_pc_assi_sig poste, dap_cpt_debit compte, sum(ead_mnt_cp_tre) mt
from t_detail_acte_depenses
inner join t_entete_acte_depenses on ead_num_acte = dap_ead_num_acte
inner join t_journees on ead_journee_pec = date_journ
and ead_cde_pc_assi_sig = code_pct
--and statut_journ = 'C'
and type_journ = 'P'
and ead_cde_pc_assi = '623'
and dap_cpt_debit like '408%'
and ead_journee_pec between '&debut' and '&fin'
and ead_statut in ('PEC','MER')
and ead_type = 'M'
and ead_exe = '2023'
--and statut_journ = 'C'
and ead_cde_pc_assi_sig not like '5%'
group by ead_cde_pc_assi, ead_cde_pc_assi_sig, dap_cpt_debit
order by ead_cde_pc_assi,dap_cpt_debit,ead_cde_pc_assi_sig;

--------------  PEC POUR CHAQUE POSTE DE LA CF -------------------

create table pec_c as
select ead_cde_pc_assi centra, dap_cpt_debit compte, sum(ead_mnt_cp_tre) mt, count(ead_num_acte) nb_actes
from t_detail_acte_depenses
inner join t_entete_acte_depenses on ead_num_acte = dap_ead_num_acte
inner join t_journees on ead_journee_pec = date_journ
and ead_cde_pc_assi_sig = code_pct
--and statut_journ = 'C'
and type_journ = 'P'
--and type_journ = 'P'
and ead_cde_pc_assi = '623'
and dap_cpt_debit like '408%'
and ead_journee_pec between '&debut' and '&fin'
and ead_statut in ('PEC','MER')
and ead_type = 'M'
and ead_exe = '2023'
--and statut_journ = 'C'
and ead_cde_pc_assi_sig not like '5%'
group by ead_cde_pc_assi, dap_cpt_debit
order by ead_cde_pc_assi, dap_cpt_debit;

create table pec_cc as
select replace(centra, centra, centra || 'C') centra, compte, mt, nb_actes
from pec_c;


----------------- DEVERSEMENT AU JPECDEPBG -----------------------

create table aster_c as
select a.ide_poste poste, b.ide_cpt compte, sum(mt) mt, count(ide_piece) nb_piece
from fc_ecriture@lkast a
left join fc_ligne@lkast b on a.ide_poste = b.ide_poste
and a.flg_cptab = b.flg_cptab
and a.ide_gest = b.ide_gest
and a.ide_ecr = b.ide_ecr
and a.ide_jal = b.ide_jal 
where a.ide_gest='2023'
and a.dat_jc between '&debut' and '&fin'
and a.ide_poste not like '4%'
and a.ide_jal='JPECDEPBG'
and b.ide_cpt in ('47411', '47421')
and a.ide_poste = '623C'
group by a.ide_poste, b.ide_cpt
order by a.ide_poste, b.ide_cpt;


----------------- CONSTAPEC DANS LE POSTE DE BASE DANS ASTER ------------------------

create table aster_b as
select c.ide_poste_centra, a.ide_poste poste, b.ide_cpt compte, sum(mt) mt
from fc_ecriture@lkast a
left join fc_ligne@lkast b on a.ide_poste = b.ide_poste
inner join rm_poste@lkast c on a.ide_poste = c.ide_poste
and b.ide_poste = c.ide_poste
and a.flg_cptab = b.flg_cptab
and a.ide_gest = b.ide_gest
and a.ide_ecr = b.ide_ecr
and a.ide_jal = b.ide_jal 
and a.ide_gest='2023'
and a.ide_poste not like '4%'
and b.ide_cpt like '390304%'
and a.ide_jal not in ('JCENTRAL')
and b.dat_ecr between '&debut' and '&fin'
and a.ide_poste in (select ide_poste from rm_poste@lkast where ide_poste_centra='623C')
group by c.ide_poste_centra,a.ide_poste, b.ide_cpt
order by c.ide_poste_centra,a.ide_poste, b.ide_cpt;

--------------     ******************** ------------------------

create table situation_pec_devers as
select centra poste_cf, c.libn, a.compte pec_compte_408x, b.compte aster_compte_474xx, a.mt mt_pec, b.mt mt_aster, nb_actes actes_pec, nb_piece acte_aster
from pec_cc a
inner join aster_c b on a.centra = b.poste
inner join rm_noeud c on a.centra = c.IDE_ND
and b.poste = c.ide_nd 
and ( (a.compte = '4081' and b.compte = '47411')  or (a.compte = '4082' and b.compte = '47421') ) 
order by centra;

select *
from situation_pec_devers
where (mt_pec - mt_aster) <> 0
;

create table situation_aster_constat_pec as
select ide_poste_centra poste_cf, a.poste, c.libc, a.compte pec_compte_408x, b.compte aster_compte_474xx, a.mt mt_pec, b.mt mt_aster, (a.mt - b.mt) diff
from pec_b a
left join aster_b b on a.poste = b.poste
inner join rm_noeud c on a.poste = c.IDE_ND
and b.poste = c.ide_nd
and ( (a.compte = '4081' and b.compte = '390304111')  or (a.compte = '4082' and b.compte = '390304112') ) 
order by ide_poste_centra, a.poste;

select *
from situation_aster_constat_pec
where (mt_pec - mt_aster) <> 0
order by poste_cf, poste, pec_compte_408x
;

--------------------  VERIFICATION DES ECARTS DE DEVERSEMENT -----------------------

select ead_cde_pc_assi centra, ead_cde_pc_assi_sig poste, ead_num_acte, ead_dte_pec, ead_pec_aster, dap_cpt_debit compte, ead_journee_pec, statut_journ
from t_detail_acte_depenses
inner join t_entete_acte_depenses on ead_num_acte = dap_ead_num_acte
inner join t_journees on ead_journee_pec = date_journ
and ead_cde_pc_assi_sig = code_pct
--and statut_journ = 'C'
and type_journ = 'P'
and ead_cde_pc_assi = '6015'
and dap_cpt_debit like '408%'
--and ead_journee_pec <= '01/06/2022'
and ead_statut in ('PEC','MER')
and ead_type = 'M'
and ead_exe = '2023'
and ead_cde_pc_assi_sig not like '5%'
order by ead_cde_pc_assi, ead_cde_pc_assi_sig;


---------------  PRISE EN CHARGE PAR JOURNEE PEC  --------------------------------

select ead_cde_pc_assi centra, ead_cde_pc_assi_sig poste,ead_journee_pec, dap_cpt_debit compte, ead_num_bordereau, ead_mnt_cp_tre mt
from t_detail_acte_depenses
inner join t_entete_acte_depenses on ead_num_acte = dap_ead_num_acte
inner join t_journees on ead_journee_pec = date_journ
and ead_cde_pc_assi_sig = code_pct
--and statut_journ = 'C'
and type_journ = 'P'
and ead_cde_pc_assi_sig = '636'
and dap_cpt_debit like '408%'
--and ead_journee_pec <= '01/06/2022'
and ead_statut in ('PEC','MER')
and ead_journee_pec between '01/11/2023' and '30/11/2023'
and ead_type = 'M'
and ead_exe = '2023'
--group by ead_cde_pc_assi, ead_cde_pc_assi_sig, dap_cpt_debit, ead_num_bordereau, ead_journee_pec
order by ead_journee_pec,dap_cpt_debit, ead_num_bordereau, ead_cde_pc_assi_sig;


------------   CONSTAPEC EFFECTUE DANS ASTER ----------------------------
select c.ide_poste_centra centra, a.ide_poste poste,a.dat_jc, b.ide_cpt compte, observ, sum(mt) mt
from fc_ecriture@lkast a
left join fc_ligne@lkast b on a.ide_poste = b.ide_poste
inner join rm_poste@lkast c on a.ide_poste = c.ide_poste
and b.ide_poste = c.ide_poste
and a.flg_cptab = b.flg_cptab
and a.ide_gest = b.ide_gest
and a.ide_ecr = b.ide_ecr
and a.ide_jal = b.ide_jal 
and a.ide_gest='2023'
and a.ide_poste not like '4%'
and a.ide_poste = '636'
and b.ide_cpt like '390304%'
and a.ide_jal not in ('JCENTRAL')
and a.dat_jc between '01/11/2023' and '30/11/2023'
group by c.ide_poste_centra,a.ide_poste, b.ide_cpt,a.dat_jc, observ
order by c.ide_poste_centra,a.ide_poste,a.dat_jc, b.ide_cpt;