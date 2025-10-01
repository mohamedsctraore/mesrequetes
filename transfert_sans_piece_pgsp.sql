select ide_ecr, sum(mt)
from fc_ligne
where (ide_poste, ide_ecr, ide_gest, ide_jal, flg_cptab)
in
(
select ide_poste, ide_ecr, ide_gest, ide_jal, flg_cptab
from fc_ecriture where
ide_gest = '2023'
and ide_poste = '891C'
and ide_nd_emet = '510C'
--and ide_jal = 'JTRANSFERT'
and ide_mess in (3246,3077,2227,3291,3406,3657,3710,3717)
);


select a.ide_mess, ide_cpt, sum(mt)
from fc_ecriture a
left join fc_ligne b on a.ide_poste = b.ide_poste
and a.flg_cptab = b.flg_cptab
and a.ide_gest = b.ide_gest
and a.ide_ecr = b.ide_ecr
and a.ide_jal = b.ide_jal 
where ide_mess in (3246,3077,2227,3291,3406,3657,3710,3717)
and a.ide_poste = '891C'
and ide_nd_emet = '510C'
and ide_cpt = '391311'
group by a.ide_mess, ide_cpt
order by a.ide_mess;


select substr(libn, 16, 4) pc_code, substr(libn, 24, 8) dat_jc,  mt
from fc_ecriture a
left join fc_ligne b on a.ide_poste = b.ide_poste
and a.flg_cptab = b.flg_cptab
and a.ide_gest = b.ide_gest
and a.ide_ecr = b.ide_ecr
and a.ide_jal = b.ide_jal 
where a.ide_gest = '2023'
and a.ide_poste = '510C'
and a.ide_jal = 'JCENTRAL'
and a.dat_jc = '28/12/2023'
and a.ide_ecr in
(
9207,9924,9148,9208,9209,9210
)
and spec3 = '891C'
order by a.ide_mess, a.ide_ecr;



select a.ide_gest, a.ide_poste, (select libn from rm_noeud where ide_nd = a.ide_poste) libl, a.IDE_JAL, a.IDE_ECR, b.ide_cpt, mt, observ, dat_jc
from fc_ecriture a
left join fc_ligne b on a.ide_poste = b.ide_poste
and a.flg_cptab = b.flg_cptab
and a.ide_gest = b.ide_gest
and a.ide_ecr = b.ide_ecr
and a.ide_jal = b.ide_jal 
where a.ide_gest = '2023'
and (a.ide_poste, mt) in 
(
    select substr(libn, 16, 4) pc_code,  mt
    from fc_ecriture a
    left join fc_ligne b on a.ide_poste = b.ide_poste
    and a.flg_cptab = b.flg_cptab
    and a.ide_gest = b.ide_gest
    and a.ide_ecr = b.ide_ecr
    and a.ide_jal = b.ide_jal 
    where a.ide_gest = '2023'
    and a.ide_poste = '510C'
    and a.ide_jal = 'JCENTRAL'
    and a.dat_jc = '28/12/2023'
    and a.ide_ecr in
        (
        9207,9924,9148,9208,9209,9210
        )
    and spec3 = '891C'
)
and cod_sens = 'C'
and spec3 = '891C'
order by a.ide_poste, a.ide_ecr
;


select a.ide_poste, a.ide_nd_emet, a.ide_mess, ide_cpt, a.ide_ecr, a.ide_jal, mt, observ, dat_jc, libn
from fc_ecriture a
left join fc_ligne b on a.ide_poste = b.ide_poste
and a.flg_cptab = b.flg_cptab
and a.ide_gest = b.ide_gest
and a.ide_ecr = b.ide_ecr
and a.ide_jal = b.ide_jal 
where a.ide_gest = '2023'
and a.ide_poste = '891C'
and a.ide_nd_emet = '510C'
--and ide_jal = 'JPECDEPBG'
and ide_mess in (3246,3077,2227,3291,3406,3657,3710,3717)
and ide_cpt like '391311'
order by ide_mess;


select ide_poste, ide_gest, mt, spec3, observ from fc_ligne
where (ide_poste, mt, observ)
in
(
select a.ide_nd_emet, mt, observ
from fc_ecriture a
left join fc_ligne b on a.ide_poste = b.ide_poste
and a.flg_cptab = b.flg_cptab
and a.ide_gest = b.ide_gest
and a.ide_ecr = b.ide_ecr
and a.ide_jal = b.ide_jal 
where a.ide_gest = '2023'
and a.ide_poste = '891C'
and a.ide_nd_emet = '510C'
--and ide_jal = 'JPECDEPBG'
and ide_mess in (3246,3077,2227,3291,3406,3657,3710,3717)
and ide_cpt like '391311'
)
and ide_cpt like '391311'
;
--order by ide_mess;

select ide_poste, (select libn from rm_noeud where ide_nd = ide_poste) libl , ide_gest, ide_jal, ide_ecr, ide_cpt, cod_sens, mt, observ from fc_ligne
where (ide_gest, mt, spec3, observ)
in
(
select ide_gest, mt, spec3, observ from fc_ligne
where (ide_poste, mt, observ)
in
(
select a.ide_nd_emet, mt, observ
from fc_ecriture a
left join fc_ligne b on a.ide_poste = b.ide_poste
and a.flg_cptab = b.flg_cptab
and a.ide_gest = b.ide_gest
and a.ide_ecr = b.ide_ecr
and a.ide_jal = b.ide_jal 
where a.ide_gest = '2023'
and a.ide_poste = '891C'
and a.ide_nd_emet = '510C'
--and ide_jal = 'JPECDEPBG'
and ide_mess in (3246,3077,2227,3291,3406,3657,3710,3717)
and ide_cpt like '391311'
)
and ide_cpt like '391311'
)
and ide_jal <> 'JCENTRAL'
order by ide_poste, ide_ecr
;