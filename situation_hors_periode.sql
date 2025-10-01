-------------------  AOUT PRIS EN JUILLET  -----------------------------------

select a.ide_poste poste, c.libn, ide_cpt ,cod_sens, sum(mt) mt
from fc_ecriture a
inner join fc_ligne b on a.ide_poste = b.ide_poste
inner join rm_noeud c on a.ide_poste = c.ide_nd
and a.flg_cptab = b.flg_cptab
and a.ide_gest = b.ide_gest
and a.ide_ecr = b.ide_ecr
and a.ide_jal = b.ide_jal
where a.ide_gest = '2024'
and a.ide_jal = 'JTRANSFERT'
and dat_jc <= '31/07/2024'
and ( regexp_like (substr(a.libn, -8), '^[0-9]{2}\/[0-9]{2}\/[0-9]{2}$') and  to_date(substr(a.libn, -8)) >= '01/08/2024')
and ide_cpt in ('39111', '39112', '391212', '391311', '391321', '391322')
group by a.ide_poste, libn, ide_cpt ,cod_sens
order by ide_cpt, a.ide_poste;


-----------------------  JUILLET PRIS EN AOUT -------------------------------------------------

select a.ide_poste poste, c.libn, ide_cpt ,cod_sens, sum(mt) mt
from fc_ecriture a
inner join fc_ligne b on a.ide_poste = b.ide_poste
inner join rm_noeud c on a.ide_poste = c.ide_nd
and a.flg_cptab = b.flg_cptab
and a.ide_gest = b.ide_gest
and a.ide_ecr = b.ide_ecr
and a.ide_jal = b.ide_jal
where a.ide_gest = '2024'
and a.ide_jal = 'JTRANSFERT'
and dat_jc >= '01/08/2024'
and ( regexp_like (substr(a.libn, -8), '^[0-9]{2}\/[0-9]{2}\/[0-9]{2}$') and  to_date(substr(a.libn, -8)) <= '31/07/2024')
and ide_cpt in ('39111', '39112', '391212', '391311', '391321', '391322')
group by a.ide_poste, libn, ide_cpt ,cod_sens
order by ide_cpt, a.ide_poste;

------------------------ NON DENOUEE --------------------------------

select a.ide_poste poste, c.libn, ide_cpt ,cod_sens, sum(mt) mt
from fc_ecriture a
inner join fc_ligne b on a.ide_poste = b.ide_poste
inner join rm_noeud c on a.ide_poste = c.ide_nd
inner join fm_rnl_me d on a.ide_poste = d.ide_nd_dest
and a.ide_nd_emet = d.ide_nd_emet
and a.ide_mess = d.ide_mess
and a.flg_cptab = b.flg_cptab
and a.ide_gest = b.ide_gest
and a.ide_ecr = b.ide_ecr
and a.ide_jal = b.ide_jal
where a.ide_gest = '2024'
and a.ide_jal = 'JTRANSFERT'
and a.flg_cptab = 'N'
and d.flg_emis_recu = 'R'
and d.cod_statut in ('AC','SA')
and ( regexp_like (substr(a.libn, -8), '^[0-9]{2}\/[0-9]{2}\/[0-9]{2}$') and  to_date(substr(a.libn, -8)) <= '31/07/2024')
and ide_cpt in ('39111', '39112', '391212', '391311', '391321', '391322')
group by a.ide_poste, libn, ide_cpt ,cod_sens
order by ide_cpt, a.ide_poste;

--------------------- DETAILS ECRITURES NON DENOUEES -----------------------------

select unique a.ide_poste poste, c.libn, a.ide_gest gestion, dat_jc dat_jc, ide_mess bordereau, a.ide_ecr ecriture, a.libn libn, mt, ide_cpt, observ, cod_sens
from fc_ecriture a
inner join fc_ligne b on a.ide_poste = b.ide_poste
inner join rm_noeud c on a.ide_poste = c.ide_nd
inner join fm_rnl_me d on a.ide_poste = d.ide_nd_dest
and a.ide_nd_emet = d.ide_nd_emet
and a.ide_mess = d.ide_mess
and a.flg_cptab = b.flg_cptab
and a.ide_gest = b.ide_gest
and a.ide_ecr = b.ide_ecr
and a.ide_jal = b.ide_jal
where a.ide_gest = '2024'
and a.ide_jal = 'JTRANSFERT'
and a.flg_cptab = 'N'
and d.flg_emis_recu = 'R'
and d.cod_statut in ('AC','SA')
--and dat_jc >= '01/12/2023'
--and (a.ide_poste like '2%C' or a.ide_poste = '507')
and ( regexp_like (substr(a.libn, -8), '^[0-9]{2}\/[0-9]{2}\/[0-9]{2}$') and  to_date(substr(a.libn, -8)) <= '31/07/2024')
--and ide_cpt like '391%'
and ide_cpt in ('39111', '39112', '391212', '391311', '391321', '391322')
order by ide_cpt, a.ide_poste, ide_mess, a.ide_ecr;


--------------------- DETAILS ECRITURES AOUT PRIS EN JUILLET -----------------------------

select unique a.ide_poste poste, c.libn, a.ide_gest gestion, dat_jc dat_jc, ide_mess bordereau, a.ide_ecr ecriture, a.libn libn, mt, ide_cpt, observ, cod_sens
from fc_ecriture a
inner join fc_ligne b on a.ide_poste = b.ide_poste
inner join rm_noeud c on a.ide_poste = c.ide_nd
and a.flg_cptab = b.flg_cptab
and a.ide_gest = b.ide_gest
and a.ide_ecr = b.ide_ecr
and a.ide_jal = b.ide_jal
where a.ide_gest = '2024'
and a.ide_jal = 'JTRANSFERT'
and dat_jc <= '31/07/2024'
--and (a.ide_poste like '2%C' or a.ide_poste = '507')
and ( regexp_like (substr(a.libn, -8), '^[0-9]{2}\/[0-9]{2}\/[0-9]{2}$') and  to_date(substr(a.libn, -8)) >= '01/08/2024')
--and ide_cpt like '391%'
and ide_cpt in ('39111', '39112', '391212', '391311', '391321', '391322')
order by ide_cpt, a.ide_poste, ide_mess, a.ide_ecr;

--------------------- DETAILS ECRITURES JUILLET EN AOUT -----------------------------

select unique a.ide_poste poste, c.libn, a.ide_gest gestion, dat_jc dat_jc, ide_mess bordereau, a.ide_ecr ecriture, a.libn libn, mt, ide_cpt, observ, cod_sens
from fc_ecriture a
inner join fc_ligne b on a.ide_poste = b.ide_poste
inner join rm_noeud c on a.ide_poste = c.ide_nd
and a.flg_cptab = b.flg_cptab
and a.ide_gest = b.ide_gest
and a.ide_ecr = b.ide_ecr
and a.ide_jal = b.ide_jal
where a.ide_gest = '2024'
and a.ide_jal = 'JTRANSFERT'
and dat_jc >= '01/08/2024'
--and (a.ide_poste like '2%C' or a.ide_poste = '507')
and ( regexp_like (substr(a.libn, -8), '^[0-9]{2}\/[0-9]{2}\/[0-9]{2}$') and  to_date(substr(a.libn, -8)) <= '31/07/2024')
--and ide_cpt like '391%'
and ide_cpt in ('39111', '39112', '391212', '391311', '391321', '391322')
order by ide_cpt, a.ide_poste, ide_mess, a.ide_ecr;