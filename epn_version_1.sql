drop table epn_detail_poste;

create table epn_detail_poste as
select a.ide_poste, ide_gest, flg_cptab, a.ide_tiers ide_tiers, b.ide_poste cod_tiers, ide_cpt, cod_sens, mt, observ, dat_ecr
from fc_ligne a
inner join e000618.epn_tiers b on a.ide_tiers = b.ide_tiers 
where ide_gest = '2022'
and a.ide_poste = '510'
and ide_cpt = '4667106'
and dat_ecr <= '30/09/2022'
--and flg_cptab = 'N'
and ide_jal = 'JODPGSP'
and cod_sens = 'D';

drop table epn_masse_recette_poste;

create table epn_masse_recette_poste as
select cod_tiers code_epn,ide_tiers tiers, libn libelle, sum(mt) transf_recette
from epn_detail_poste a
left join rm_noeud b on a.cod_tiers = b.ide_nd 
group by ide_tiers, cod_tiers, libn
order by cod_tiers;

drop table epn_masse_recette;

create table epn_masse_recette as
select code_epn, libelle, sum(transf_recette) sum_transfert
from epn_masse_recette_poste
group by code_epn, libelle;

select code_epn, libelle, sum_transfert
from epn_masse_recette
order by code_epn;

drop table epn_ecart_39031;

create table epn_ecart_39031 as
select poste, b.LIBN, compte, flux_db flux_ges_db, flux_cr flux_ges_cr, sum_transfert transfert_recette_epn, (sum_transfert - flux_db) ecart
from ccc_bbb a
INNER JOIN rm_noeud b on a.poste = b.ide_nd
left join epn_masse_recette on poste = code_epn
where compte = '39031'
order by compte,centralisaeur, poste;


select code_epn, a.libelle, compte, sum_transfert pgsp_transfert, flux_db saisie_epn_39031 
from epn_masse_recette a
left join ccc_bbb b on code_epn = poste
where compte = '39031' or compte is null
order by code_epn;

select poste, libn, compte, flux_ges_db, transfert_recette_epn transf_epn, CASE
                                                                                WHEN ecart > 0 THEN ecart
                                                                                WHEN ecart < 0 THEN 0
                                                                                ELSE 0
                                                                            END as EN_MOINS,
                                                                            CASE
                                                                                WHEN ecart > 0 THEN 0
                                                                                WHEN ecart < 0 THEN ABS(ecart)
                                                                                ELSE 0
                                                                            END as EN_TROP
from epn_ecart_39031;


select ide_poste, mt, observ
from fc_ligne
where ide_gest = '2022'
and ide_poste like '5%'
and ide_poste <> '510'
and spec3 = '510C'
and dat_ecr <= '30/09/2022'
and ide_cpt = '39112'
order by dat_ecr;

select ide_poste, mt, observ
from fc_ligne
where ide_gest = '2022'
and ide_poste like '5%'
and ide_poste <> '510'
and spec3 = '510C'
and dat_ecr <= '30/09/2022'
and ide_cpt = '39111'
order by dat_ecr;