drop table fiche_compte;
drop table fiche_compte_ecriture;
drop table fiche_compte_poste_centra;
drop table fiche_compte_poste_libl;
drop table fiche_compte_compte_libl;

create table fiche_compte as
select ide_gest, ide_poste, ide_jal, ide_cpt, ide_ecr, ide_lig_exec, ide_tiers, ide_ref_piece, cod_ref_piece, dat_ecr, mt debit, 0 credit, observ, flg_cptab
from fc_ligne where (ide_poste, ide_ecr, ide_gest, ide_jal, flg_cptab)
in
(
select ide_poste, ide_ecr, ide_gest, ide_jal, flg_cptab
from fc_ecriture where 
ide_gest between '&&deb' and '&&gestion'

)
and ide_lig_exec in (select unique ide_lig_exec from PIAF_ADM.FN_LIGNE_BUD_EXEC where lower(libl) like '%amendes%judiciaires%')
and cod_sens = 'D'
and flg_cptab = 'O'
and ide_jal <> 'JCENTRAL'
and dat_ecr between '&&date_debut' and '&&date_fin'
union
select ide_gest, ide_poste, ide_jal, ide_cpt, ide_ecr, ide_lig_exec, ide_tiers, ide_ref_piece, cod_ref_piece, dat_ecr, 0 debit, mt credit, observ, flg_cptab
from  fc_ligne where(ide_poste, ide_ecr, ide_gest, ide_jal, flg_cptab)
in
(
select ide_poste, ide_ecr, ide_gest, ide_jal, flg_cptab
from fc_ecriture 
where ide_gest between '&&deb' and '&&gestion'
)
and ide_lig_exec in (select unique ide_lig_exec from PIAF_ADM.FN_LIGNE_BUD_EXEC where lower(libl) like '%amendes%judiciaires%')
and cod_sens = 'C'
and flg_cptab = 'O'
and ide_jal <> 'JCENTRAL'
and dat_ecr between '&&date_debut' and '&&date_fin'
order by ide_poste, dat_ecr
;

create table fiche_compte_ecriture as
select a.IDE_GEST, a.ide_poste, a.ide_jal, ide_cpt, a.ide_ecr, ide_lig_exec, ide_tiers, ide_ref_piece, cod_ref_piece, dat_jc, debit, credit, observ, a.dat_ecr, libn, ide_nd_emet, a.flg_cptab from fiche_compte a
inner join fc_ecriture b 
on a.ide_gest = b.ide_gest
and a.ide_poste = b.ide_poste
and a.ide_jal = b.ide_jal
and a.ide_ecr = b.ide_ecr
and a.flg_cptab = b.flg_cptab;

create table fiche_compte_poste_centra as
select ide_gest, ide_poste_centra, a.ide_poste, ide_jal, ide_cpt, ide_ecr, ide_lig_exec, ide_tiers, ide_ref_piece, cod_ref_piece, dat_jc, debit, credit, observ, dat_ecr, libn, ide_nd_emet, flg_cptab 
from fiche_compte_ecriture a
inner join rm_poste b on a.ide_poste = b.ide_poste
;

create table fiche_compte_poste_libl as
select ide_gest, ide_poste_centra, ide_poste, b.libn poste, ide_jal, ide_cpt, ide_ecr, ide_lig_exec, ide_tiers, ide_ref_piece, cod_ref_piece, dat_jc, debit, credit, observ, dat_ecr, a.libn liblecr, ide_nd_emet, flg_cptab
from fiche_compte_poste_centra a
inner join rm_noeud b on a.ide_poste = b.ide_nd
;

create table fiche_compte_compte_libl as
select ide_gest, ide_poste_centra, ide_poste, poste, ide_jal, a.ide_cpt, b.libn, ide_ecr, ide_lig_exec, ide_tiers, ide_ref_piece, cod_ref_piece, dat_jc, debit, credit, observ, dat_ecr, liblecr, ide_nd_emet, flg_cptab 
from fiche_compte_poste_libl a
inner join fn_compte b on a.ide_cpt = b.ide_cpt
;

select ide_gest, ide_cpt, libn, ide_poste_centra, 
       (select libn from rm_noeud where ide_nd = ide_poste_centra) liblcentra, 
       ide_poste, poste,ide_tiers,ide_ref_piece,cod_ref_piece,
       ide_ecr,ide_lig_exec,dat_ecr,debit, credit, ide_jal,observ,
       dat_jc,liblecr,ide_nd_emet    
from fiche_compte_compte_libl
where ide_jal not in ('JCENTRAL','JPECDEPBG')
order by dat_jc, ide_poste
;