--------------  PIECES NON SOLDEES DANS FC_REF_PIECE ------------------------------------

select unique c.ide_cpt, a.ide_poste, b.libn, a.ide_ref_piece, a.cod_ref_piece, a.ide_tiers, a.mt_cr, a.mt_db, a.ide_gest, a.mt_dev mt_disponible
from fc_ref_piece a
inner join rm_noeud b on a.ide_poste = b.ide_nd
inner join fc_ligne c on a.ide_ecr = c.ide_ecr
and a.ide_ref_piece = c.ide_ref_piece 
where a.ide_poste = '502'
and flg_solde = 'N'
and c.ide_cpt IN
(
'47551'
)
--and (mt_cr in (100000,200000) or mt_db in (100000,200000) )
--and a.cod_ref_piece like '%3956789%'
and mt_cr - mt_db <> 0
--and dat_der_mvt <= '31/08/2024'
--and a.ide_gest = '2024'
--and c.dat_ecr like '%/12/2023'
order by ide_gest desc, c.ide_cpt, ide_tiers, ide_ref_piece, ide_gest
;


---------------  PIECES NON SOLDEES DANS FC_LIGNE A UNE DATE --------------------

select a.ide_poste, a.ide_cpt, b.libn, ide_ref_piece, cod_ref_piece, ide_devise, abs(sum(decode(cod_sens,'C', mt_dev, -mt_dev))) solde
from fc_ligne a, fn_compte b
where a.ide_cpt = b.ide_cpt 
and ide_gest = '2025'
and ide_poste like '501'
and flg_cptab = 'O'
and a.ide_cpt in (select ide_cpt from fn_compte where flg_justif = 'O')
--and a.ide_cpt Like '474%'
--and a.ide_cpt In 
--(
--'474321101'
--)
--and cod_ref_piece Like '%A%'
--and dat_ecr <= '31/03/2025'
group by a.ide_poste, a.ide_cpt, b.libn, ide_ref_piece, cod_ref_piece, ide_devise
having sum(decode(cod_sens,'C', mt_dev, -mt_dev)) <> 0
order by a.ide_poste, ide_devise, a.ide_cpt
;

--------------------- MASSE SUR CHAQUE COMPTE -------------------
select a.ide_cpt, b.libn, a.ide_ref_piece, abs(sum(decode(cod_sens,'C', mt, -mt))) solde
from fc_ligne a, fn_compte b
where a.ide_cpt = b.ide_cpt 
and ide_gest = '2025'
and ide_poste = '3103'
and flg_cptab = 'O'
--and a.ide_cpt = '4482304'
--and a.ide_cpt in (select ide_cpt from fn_compte where flg_justif = 'O')
and dat_ecr <= '31/12/2025'
group by a.ide_cpt, b.libn, a.ide_ref_piece
having sum(decode(cod_sens,'C', mt, -mt)) <> 0
order by a.ide_cpt
;