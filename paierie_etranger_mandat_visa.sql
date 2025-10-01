select ide_nd_emet poste, libn libelle, ide_gest gestion, ide_piece mandat, dat_cpta dat_visa, objet, mt montant, mt_dev montant_dev, ide_devise devise, val_taux from fb_piece a, rm_noeud b
where a.ide_nd_emet = b.ide_nd 
and ide_gest = '2024'
and cod_statut = 'VI'
and ide_poste like '4%'
and dat_cad between '01/05/2024' and '31/05/2024'
and type_acte = 'M'
order by ide_nd_emet, dat_cpta;



select ide_nd_emet poste, libn libelle, ide_gest gestion, ide_piece mandat, dat_cpta dat_visa, objet, mt montant, mt_dev montant_dev, ide_devise devise, val_taux from fb_piece a, rm_noeud b
where a.ide_nd_emet = b.ide_nd 
and ide_gest = '2024'
and cod_statut = 'VI'
and ide_poste like '4%'
and dat_cad between '01/05/2024' and '31/05/2024'
and type_acte = 'M'
order by ide_nd_emet, dat_cpta;