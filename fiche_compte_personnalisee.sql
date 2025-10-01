delete from fiche_compte;
delete from fiche_compte_ecriture;
delete from fiche_compte_poste_centra;
delete from fiche_compte_poste_libl;
delete from fiche_compte_compte_libl;

insert into fiche_compte 
select ide_gest, ide_poste, ide_jal, ide_cpt, ide_ecr, ide_lig_exec, ide_tiers, ide_ref_piece, cod_ref_piece, dat_ecr, mt debit, 0 credit, observ, flg_cptab
from fc_ligne where (ide_poste, ide_ecr, ide_gest, ide_jal, flg_cptab)
in
(
select ide_poste, ide_ecr, ide_gest, ide_jal, flg_cptab
from fc_ecriture where ide_gest = '2024'
and ide_poste in (select ide_poste from rm_poste where ide_poste_centra = '230C' or ide_poste = '230C')
--and dat_jc between '&&date_debut' and '&&date_fin'
)
and ide_cpt = '&&compte'
--and ide_cpt in ('71612','71613')
and cod_sens = 'D'
and flg_cptab = 'O'
--and ide_tiers like '%411'
--and ide_jal not in ('JCENTRAL', 'JTRANSFERT')
--and spec3 = '891C'
and dat_ecr between '&&date_debut' and '&&date_fin'

union

select ide_gest, ide_poste, ide_jal, ide_cpt, ide_ecr, ide_lig_exec, ide_tiers, ide_ref_piece, cod_ref_piece, dat_ecr, 0 debit, mt credit, observ, flg_cptab
from  fc_ligne where(ide_poste, ide_ecr, ide_gest, ide_jal, flg_cptab)
in
(
select ide_poste, ide_ecr, ide_gest, ide_jal, flg_cptab
from fc_ecriture where ide_gest = '2024'
and ide_poste in (select ide_poste from rm_poste where ide_poste_centra = '230C' or ide_poste = '230C')
--and dat_jc between '&&date_debut' and '&&date_fin'
)
and ide_cpt = '&&compte'
--and ide_cpt in ('71612','71613')
and cod_sens = 'C'
and flg_cptab = 'O'
--and ide_jal not in ('JCENTRAL', 'JTRANSFERT')
--and spec3 = '891C'
and dat_ecr between '&&date_debut' and '&&date_fin'
order by ide_poste, dat_ecr
;

insert into fiche_compte_ecriture 
select a.IDE_GEST, a.ide_poste, a.ide_jal, ide_cpt, a.ide_ecr, ide_lig_exec, ide_tiers, ide_ref_piece, cod_ref_piece, dat_jc, debit, credit, observ, a.dat_ecr, libn, ide_nd_emet, a.flg_cptab from fiche_compte a
inner join fc_ecriture b 
on a.ide_gest = b.ide_gest
and a.ide_poste = b.ide_poste
and a.ide_jal = b.ide_jal
and a.ide_ecr = b.ide_ecr
and a.flg_cptab = b.flg_cptab;

select ide_gest, ide_poste, ide_jal, ide_cpt, ide_ecr, dat_jc, debit, credit, observ, dat_ecr, libn, ide_nd_emet 
from fiche_compte_ecriture
order by ide_poste, dat_jc;

select ide_gest, ide_poste, ide_jal, ide_cpt, ide_ecr, dat_jc, debit, credit, observ, dat_ecr, libn, ide_nd_emet 
from fiche_compte_ecriture
order by ABS(debit + credit), ide_poste, dat_jc;

insert into fiche_compte_poste_centra 
select ide_gest, ide_poste_centra, a.ide_poste, ide_jal, ide_cpt, ide_ecr, ide_lig_exec, ide_tiers, ide_ref_piece, cod_ref_piece, dat_jc, debit, credit, observ, dat_ecr, libn, ide_nd_emet, flg_cptab 
from fiche_compte_ecriture a
inner join rm_poste b on a.ide_poste = b.ide_poste
;

insert into fiche_compte_poste_libl 
select ide_gest, ide_poste_centra, ide_poste, b.libn poste, ide_jal, ide_cpt, ide_ecr, ide_lig_exec, ide_tiers, ide_ref_piece, cod_ref_piece, dat_jc, debit, credit, observ, dat_ecr, a.libn liblecr, ide_nd_emet, flg_cptab
from fiche_compte_poste_centra a
inner join rm_noeud b on a.ide_poste = b.ide_nd
;

insert into fiche_compte_compte_libl 
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
--where ide_poste = '230C'
order by ide_gest, dat_jc, ide_poste
;


select ide_gest, ide_cpt, libn, ide_poste_centra, 
       (select libn from rm_noeud where ide_nd = ide_poste_centra) liblcentra, 
       ide_poste, poste,ide_tiers,ide_ref_piece,cod_ref_piece,
       ide_ecr,ide_lig_exec,dat_ecr,debit, credit, ide_jal,observ,
       dat_jc,liblecr,ide_nd_emet    
from fiche_compte_compte_libl
where ide_jal <> 'JCENTRAL'
order by ide_gest, ide_cpt, ide_poste, dat_jc
;

select ide_gest, ide_cpt, libn, ide_poste_centra, 
       (select libn from rm_noeud where ide_nd = ide_poste_centra) liblcentra, 
       ide_poste, poste,ide_tiers,ide_ref_piece,cod_ref_piece,
       ide_ecr,ide_lig_exec,dat_ecr,debit, credit, ide_jal,observ,
       dat_jc,liblecr,ide_nd_emet    
from fiche_compte_compte_libl
order by abs((debit + credit)), ide_poste
;