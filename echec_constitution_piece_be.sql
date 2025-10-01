select a.ide_ref_piece, a.cod_ref_piece
from fc_ligne a
inner join fc_ref_piece b on a.ide_ref_piece = b.ide_ref_piece
and a.ide_poste = b.ide_poste
where a.ide_gest = '2023'
and a.flg_cptab = 'O'
and ide_cpt like '475110701'
and a.ide_poste = '659'
and flg_solde = 'O'
group by a.ide_ref_piece, a.cod_ref_piece
having sum(decode(cod_sens, 'C', mt, -mt)) <> 0

minus

select a.ide_ref_piece, a.cod_ref_piece
from fc_ligne a
where ide_gest = '2024'
and ide_jal = 'TREP'
and ide_cpt like '475110701'
and ide_poste = '659'
;


select a.ide_ref_piece, a.cod_ref_piece, b.ide_tiers, sum(decode(cod_sens, 'C', mt, -mt))
from fc_ligne a
inner join fc_ref_piece b on a.ide_ref_piece = b.ide_ref_piece
and a.ide_poste = b.ide_poste
where a.ide_gest = '2023'
and a.flg_cptab = 'O'
and ide_cpt like '475110701'
and a.ide_poste = '659'
and flg_solde = 'O'
and (a.ide_ref_piece, a.cod_ref_piece) in 
(
    select a.ide_ref_piece, a.cod_ref_piece
    from fc_ligne a
    inner join fc_ref_piece b on a.ide_ref_piece = b.ide_ref_piece
    and a.ide_poste = b.ide_poste
    where a.ide_gest = '2023'
    and a.flg_cptab = 'O'
    and ide_cpt like '475110701'
    and a.ide_poste = '659'
    and flg_solde = 'O'
    group by a.ide_ref_piece, a.cod_ref_piece
    having sum(decode(cod_sens, 'C', mt, -mt)) <> 0
    minus
    select a.ide_ref_piece, a.cod_ref_piece
    from fc_ligne a
    where ide_gest = '2024'
    and ide_jal = 'TREP'
    and ide_cpt like '475110701'
    and ide_poste = '659'
)
group by a.ide_ref_piece, a.cod_ref_piece, b.ide_tiers
having sum(decode(cod_sens, 'C', mt, -mt)) <> 0
order by ide_ref_piece
;

------------------------------------  TOUTES LES PIECES ----------------------------------------------------------------

select a.ide_cpt, a.ide_ref_piece, a.cod_ref_piece, b.ide_tiers, sum(decode(cod_sens, 'C', mt, -mt))
from fc_ligne a
inner join fc_ref_piece b on a.ide_ref_piece = b.ide_ref_piece
and a.ide_poste = b.ide_poste
where a.ide_gest = '2023'
and a.flg_cptab = 'O'
and ide_cpt in (select unique ide_cpt from fc_ligne where ide_gest = '2024' and ide_jal = 'TREP' and ide_poste = '659' and ide_cpt in (select ide_cpt from fn_compte where flg_justif = 'O') and ide_ref_piece is null)
and a.ide_poste = '659'
and flg_solde = 'O'
and (a.ide_ref_piece, a.cod_ref_piece) in 
(
    select a.ide_ref_piece, a.cod_ref_piece
    from fc_ligne a
    inner join fc_ref_piece b on a.ide_ref_piece = b.ide_ref_piece
    and a.ide_poste = b.ide_poste
    where a.ide_gest = '2023'
    and a.flg_cptab = 'O'
    and ide_cpt in (select unique ide_cpt from fc_ligne where ide_gest = '2024' and ide_jal = 'TREP' and ide_poste = '659' and ide_cpt in (select ide_cpt from fn_compte where flg_justif = 'O') and ide_ref_piece is null)
    and a.ide_poste = '659'
    and flg_solde = 'O'
    group by a.ide_ref_piece, a.cod_ref_piece
    having sum(decode(cod_sens, 'C', mt, -mt)) <> 0
    minus
    select a.ide_ref_piece, a.cod_ref_piece
    from fc_ligne a
    where ide_gest = '2024'
    and ide_jal = 'TREP'
    and ide_cpt in (select unique ide_cpt from fc_ligne where ide_gest = '2024' and ide_jal = 'TREP' and ide_poste = '659' and ide_cpt in (select ide_cpt from fn_compte where flg_justif = 'O') and ide_ref_piece is null)
    and ide_poste = '659'
)
group by a.ide_cpt, a.ide_ref_piece, a.cod_ref_piece, b.ide_tiers
having sum(decode(cod_sens, 'C', mt, -mt)) <> 0
order by a.ide_cpt, ide_ref_piece
;

-------------------------------------------  COMPTE SUR PIECES  ------------------------------

select unique ide_cpt, ide_ecr, ide_jal from fc_ligne 
where ide_gest = '2024' 
and ide_jal = 'TREP' and ide_poste = '659' 
and ide_cpt in (select ide_cpt from fn_compte where flg_justif = 'O') and ide_ref_piece is null
order by ide_ecr;

--------------------------------------  SCRIPT RECONSTITUTION DE PIECES  -------------------------------

select '659' ide_poste, '2024' ide_gest, 'TREP' ide_jal, 'O' flg_cptab, 148 ide_ecr, 1680 ide_lig, 'C2020' var_cpta, 'T2012' var_tiers, b.ide_tiers, a.ide_cpt, a.ide_ref_piece, a.cod_ref_piece, null var_bud, null ide_lig_exec, null ide_ope, null ide_ordo,
'C' cod_sens, sum(decode(cod_sens, 'C', mt, -mt)) mt, null spec1, null spec2, null spec3, null observ, null dat_centra, null dat_transf, 'REP PARTIELLE' ide_schema, 'A' cod_typ_schema, 'DEBIT' ide_modele_lig, '01/01/2024' dat_ecr, sum(decode(cod_sens, 'C', mt, -mt)) mt_dev
from fc_ligne a
inner join fc_ref_piece b on a.ide_ref_piece = b.ide_ref_piece
and a.ide_poste = b.ide_poste
where a.ide_gest = '2023'
and a.flg_cptab = 'O'
and ide_cpt in (select unique ide_cpt from fc_ligne where ide_gest = '2024' and ide_jal = 'TREP' and ide_poste = '659' and ide_cpt in (select ide_cpt from fn_compte where flg_justif = 'O') and ide_ref_piece is null)
and a.ide_poste = '659'
and flg_solde = 'O'
and (a.ide_ref_piece, a.cod_ref_piece) in 
(
    select a.ide_ref_piece, a.cod_ref_piece
    from fc_ligne a
    inner join fc_ref_piece b on a.ide_ref_piece = b.ide_ref_piece
    and a.ide_poste = b.ide_poste
    where a.ide_gest = '2023'
    and a.flg_cptab = 'O'
    and ide_cpt in (select unique ide_cpt from fc_ligne where ide_gest = '2024' and ide_jal = 'TREP' and ide_poste = '659' and ide_cpt in (select ide_cpt from fn_compte where flg_justif = 'O') and ide_ref_piece is null)
    and a.ide_poste = '659'
    and flg_solde = 'O'
    group by a.ide_ref_piece, a.cod_ref_piece
    having sum(decode(cod_sens, 'C', mt, -mt)) <> 0
    minus
    select a.ide_ref_piece, a.cod_ref_piece
    from fc_ligne a
    where ide_gest = '2024'
    and ide_jal = 'TREP'
    and ide_cpt in (select unique ide_cpt from fc_ligne where ide_gest = '2024' and ide_jal = 'TREP' and ide_poste = '659' and ide_cpt in (select ide_cpt from fn_compte where flg_justif = 'O') and ide_ref_piece is null)
    and ide_poste = '659'
)
and ide_cpt = '47012202'
group by a.ide_cpt, a.ide_ref_piece, a.cod_ref_piece, b.ide_tiers
having sum(decode(cod_sens, 'C', mt, -mt)) <> 0
order by a.ide_cpt, ide_ref_piece