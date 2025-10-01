drop table epn;

create table epn as

select 
    a.ide_nd_emet as epn,
    extract(month from a.dat_jc) as mois,
    extract(year from a.dat_jc) as an,
    b.ide_cpt as compte, 
    cod_sens as sens_compte, 
    sum(mt) as montant
from fc_ecriture a
left join fc_ligne b on a.ide_poste = b.ide_poste
and a.flg_cptab = b.flg_cptab
and a.ide_gest = b.ide_gest
and a.ide_ecr = b.ide_ecr
and a.ide_jal = b.ide_jal 
where a.ide_gest='2023'
--and a.ide_poste not like '4%'
--and a.ide_jal='JCENTRAL'
--and a.ide_piece like '2%'
and b.ide_cpt like '390%'
and a.dat_jc <= '31/08/2023'
and a.ide_poste in (select ide_poste from rm_poste where ide_poste_centra = '510C')
--and a.flg_cptab = 'O'
group by 
    a.ide_nd_emet,
    extract(month from a.dat_jc), 
    extract(year from a.dat_jc),
    b.ide_cpt, 
    cod_sens
order by 
    ide_nd_emet, 
    extract(month from a.dat_jc), 
    b.ide_cpt;


select epn, b.libn, mois, an, compte, c.libn, sens_compte, montant 
from epn a
inner join rm_noeud b on epn = ide_nd
inner join fn_compte c on compte = ide_cpt
--and sens_compte <> 'D'
order by compte, epn,  mois, an;