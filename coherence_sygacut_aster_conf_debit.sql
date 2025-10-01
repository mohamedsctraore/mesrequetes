alter session set nls_date_format = 'DD/MM/RRRR';

select 'ASTER', libl, sum(mt)
from fc_ecriture@asterndir a, fc_ligne@asterndir b, fm_message@asterndir c
where (c.flg_emis_recu, c.cod_typ_nd, a.ide_nd_emet, a.ide_mess) 
in (select flg_emis_recu, cod_typ_nd, ide_nd_emet, ide_mess from fm_message@asterndir where ide_gest = '2023' and cod_typ_mess = 24 and ide_nd_emet = '501' and libl like '%CUT-DEBITS CONFIRMATION PAIEMENT DU %/2023%')
and substr(ide_cpt, 1,2) = '57'
and a.ide_poste = b.ide_poste and a.ide_gest = b.ide_gest and a.flg_cptab = b.flg_cptab and a.ide_jal = b.ide_jal and a.ide_ecr = b.ide_ecr
and a.ide_poste = c.ide_nd_emet and a.ide_gest = c.ide_gest and a.ide_mess = c.ide_mess
group by libl, dat_ref

union

select 'SYGACUT', 'CUT-DEBITS CONFIRMATION PAIEMENT DU ' || to_date(extract(day from rgl_dte_reglement) || '/' || extract(month from rgl_dte_reglement) || '/' || extract(year from rgl_dte_reglement), 'DD/MM/RRRR')
 rgl_dte_reglement,
 sum(rgl_montant_net)
from cut_reglement
where to_char(rgl_dte_reglement, 'DD/MM/RRRR') like '%/2023'
and rgl_mrg_code = '02'
and rgl_statut in ('P','R')
and rgl_rout_statut = 'R'
group by extract(day from rgl_dte_reglement), extract(month from rgl_dte_reglement), extract(year from rgl_dte_reglement)
order by 2,1
;

select rgl_statut,rgl_rout_statut, sum(rgl_montant_net) 
from cut_reglement
where to_char(rgl_dte_reglement, 'DD/MM/RRRR') = '02/10/2023'
and rgl_statut in ('P','R')
group by rgl_statut, rgl_rout_statut
;