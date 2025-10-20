---------------  LES COMPTES  ---------------------
select ide_poste, ide_cpt, sum(decode(cod_sens, 'D', mt_dev, -mt_dev)) mt_dev, sum(decode(cod_sens, 'D', mt, -mt)) mt 
from fc_ligne
where ide_gest = '2025'
and ide_cpt in (select ide_cpt from fn_compte where flg_justif = 'O')
and ide_poste in (select ide_poste from rm_poste where ide_typ_poste = 'P')
and ide_poste = '430'
group by ide_poste, ide_cpt
having (sum(decode(cod_sens, 'D', mt_dev, -mt_dev)) = 0 and sum(decode(cod_sens, 'D', mt, -mt)) <> 0)
order by ide_poste, ide_cpt
;

------------  LES PIECES ---------------

select ide_poste, ide_cpt, ide_ref_piece, sum(decode(cod_sens, 'D', mt_dev, -mt_dev)) mt_dev, sum(decode(cod_sens, 'D', mt, -mt)) mt 
from fc_ligne
where ide_gest = '2025'
and ide_cpt in (select ide_cpt from fn_compte where flg_justif = 'O')
and ide_poste in (select ide_poste from rm_poste where ide_typ_poste = 'P')
and ide_poste In ('430')
and ide_cpt in
(
'474322102',
'474322103',
'474322106',
'474322202'
)
group by ide_poste, ide_cpt, ide_ref_piece
having (sum(decode(cod_sens, 'D', mt_dev, -mt_dev)) = 0 and sum(decode(cod_sens, 'D', mt, -mt)) <> 0)
order by ide_poste, ide_cpt, ide_ref_piece
;

---------------------------------------------------------------

select a.ide_poste, a.ide_cpt, b.libn, ide_ref_piece, cod_ref_piece, abs(sum(decode(cod_sens,'C', mt, -mt))) solde
from fc_ligne a, fn_compte b
where a.ide_cpt = b.ide_cpt 
and ide_gest = '2025'
and ide_poste in ('418')
and flg_cptab = 'O'
and a.ide_cpt in
(
'474321101'
)
--and dat_ecr <= '31/12/2024'
group by a.ide_poste, a.ide_cpt, b.libn, ide_ref_piece, cod_ref_piece
having sum(decode(cod_sens,'C', mt, -mt)) <> 0
order by a.ide_poste, a.ide_cpt 
;


select a.ide_poste, a.ide_cpt, b.libn, ide_ref_piece, abs(sum(decode(cod_sens,'C', mt, -mt))) solde
from fc_ligne a, fn_compte b
where a.ide_cpt = b.ide_cpt 
and ide_gest = '2025'
and ide_poste in ('401')
and flg_cptab = 'O'
and a.ide_cpt in
(
'474321101'
)
--and dat_ecr <= '31/12/2024'
group by a.ide_poste, a.ide_cpt, b.libn, ide_ref_piece
having sum(decode(cod_sens,'C', mt, -mt)) <> 0
order by a.ide_poste, a.ide_cpt 
;
