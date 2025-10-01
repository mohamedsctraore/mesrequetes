----------------------- VERIFICATION INTEGRATION MT 900 J-1 ---------------------------------------

select count(*) from cut_reglement where
bord_rgl_num in 
(
    select bord_rgl_num from cut_bord_reglement where to_date(bord_rgl_dte_reglement,'DD/MM/RRRR') = to_date(sysdate,'DD/MM/RRRR') - 1
)
and rgl_statut not in ('P','R') and rgl_rout_statut='R' and rgl_mrg_code='02'
;

----------------------- SI RESULTAT = 0 DONC MT900 J-1 PEUT ÊTRE LANCE ---------------------------------------

exec CUT.P_DEVERS_MT900('501','2023','27/10/2023','27/10/2023');

----------------------------------- DETAILS MT 900 NON INTEGRE ---------------------------------------------

select * from cut_reglement where
bord_rgl_num in 
(
    select bord_rgl_num from cut_bord_reglement where to_date(bord_rgl_dte_reglement,'DD/MM/RRRR') = to_date(sysdate,'DD/MM/RRRR') - 1
)
and rgl_statut not in ('P','R') and rgl_rout_statut='R' and rgl_mrg_code='02'
;

------------------------------ CONTRÖLE INTEGRATION DES MT 900 DANS ASTER J-1 ----------------------------------

select 'SYGACUT-DEBIT-BORD' source, sum(BORD_RGL_MONTANT_NET) montant
from cut_bord_reglement
where to_date(bord_rgl_dte_reglement,'DD/MM/RRRR') = to_date(sysdate,'DD/MM/RRRR') - 1
and bord_rgl_statut in ('T','P')

union

select 'SYGACUT-DEBIT-RGLT', sum(RGL_MONTANT_NET) from cut_reglement where
bord_rgl_num in 
(
    select bord_rgl_num from cut_bord_reglement where to_date(bord_rgl_dte_reglement,'DD/MM/RRRR') = to_date(sysdate,'DD/MM/RRRR') - 1
)
and rgl_statut in ('P','R') and rgl_rout_statut='R' and rgl_mrg_code='02'

union

select 'ASTER-CONF-DEBIT', sum(mt) from fc_ligne@asterndir a, fc_ecriture@asterndir b
where a.ide_gest = b.ide_gest
and a.ide_poste = b.ide_poste
and a.ide_jal = b.ide_jal
and a.flg_cptab = b.flg_cptab
and a.ide_ecr = b.ide_ecr
and a.ide_gest = '2023'
and a.ide_poste = '501'
and b.ide_mess in (select ide_mess from fm_message@asterndir where ide_nd_emet = '501' and ide_gest = '2023' and cod_typ_mess = 24 and libl like '%DEBIT%')
and dat_ref = to_date(sysdate, 'DD/MM/RRRR') - 1
group by cod_sens
;


------------------------------------ CONTROLE SUR UNE PERIODE  --------------------------------------
select 'SYGACUT-BORD', to_date(bord_rgl_dte_reglement, 'DD/MM/RRRR') rglt, sum(BORD_RGL_MONTANT_NET) montant
from cut_bord_reglement
where to_date(bord_rgl_dte_reglement,'DD/MM/RRRR') between to_date(:debut,'DD/MM/RRRR') and to_date(:fin,'DD/MM/RRRR')
and bord_rgl_statut in ('T','P')
group by to_date(bord_rgl_dte_reglement, 'DD/MM/RRRR')

union

select 'SYGACUT-RGLT', to_date(rgl_dte_reglement, 'DD/MM/RRRR'),sum(RGL_MONTANT_NET) from cut_reglement where
bord_rgl_num in 
(
    select bord_rgl_num from cut_bord_reglement where to_date(bord_rgl_dte_reglement,'DD/MM/RRRR') between to_date(:debut,'DD/MM/RRRR') and to_date(:fin,'DD/MM/RRRR')
)
and rgl_statut in ('P','R') and rgl_rout_statut='R' and rgl_mrg_code='02'
group by to_date(rgl_dte_reglement, 'DD/MM/RRRR')

union

select 'ASTER', to_date(dat_ref, 'DD/MM/RRRR'), sum(mt) from fc_ligne@asterndir a, fc_ecriture@asterndir b
where a.ide_gest = b.ide_gest
and a.ide_poste = b.ide_poste
and a.ide_jal = b.ide_jal
and a.flg_cptab = b.flg_cptab
and a.ide_ecr = b.ide_ecr
and a.ide_gest = '2023'
and a.ide_poste = '501'
and b.ide_mess in 
(
    select ide_mess 
    from fm_message@asterndir 
    where ide_nd_emet = '501' 
    and ide_gest = '2023' 
    and cod_typ_mess = 24 
    and libl like '%DEBIT%'
    and to_date(substr(libl, -10), 'DD/MM/RRRR') between to_date(:debut, 'DD/MM/RRRR') and to_date(:fin, 'DD/MM/RRRR')
)
group by to_date(dat_ref, 'DD/MM/RRRR'), cod_sens

order by 2,1
;