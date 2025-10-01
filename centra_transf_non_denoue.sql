drop table centra_non_denoue;
drop table transfert_non_denoue;

----------- CENTRALISATION NON DENOUE -------------------------
create table centra_non_denoue as
select unique a.ide_gest, a.ide_poste, a.ide_mess, a.libn, b.cod_statut, to_date(substr (libn, -9)) as "PERIODE"
from fc_ecriture a
inner join fm_rnl_me b on a.ide_poste = b.ide_nd_dest
and a.ide_nd_emet=b.ide_nd_emet
and a.ide_mess=b.ide_mess
where a.ide_jal in ('JCENTRAL')
and a.libn like 'Centralisation %'
and a.ide_gest='2025'
and a.cod_statut='AC'
and b.flg_emis_recu='R'
and b.cod_statut not in ('AN','TR');
--and to_date(substr (a.libn, -9)) between '01/01/2022' and '31/03/2022';

---- POINT CENTRA A DENOUER -------
Select unique 'exec NIABA.ouvre_jc (''2025'','''||to_date(substr(observation, -8, 8),'dd/mm/rrrr')||''','''||poste||''')'
From centra_a_denouer;

drop table centra_a_denouer;

create table centra_a_denouer as
select ide_gest, ide_poste poste, b.libn libelle, ide_mess bordereau, a.libn observation--, a.cod_statut, periode 
from centra_non_denoue a
inner join rm_noeud b on a.ide_poste=b.ide_nd
where periode between '01/01/2025' and '30/09/2025'
order by ide_poste, periode;

-----  POINT NOMBRE DE BORDEREAU PAR POSTE ------
select ide_poste, b.libn, count(ide_poste) as "TOTAL"
from centra_non_denoue a
inner join rm_noeud b on a.ide_poste=b.ide_nd
where periode between '01/01/2022' and '31/03/2022'
group by ide_poste, b.libn
order by ide_poste;

-----  POINT NOMBRE ECRITURE PAR BORDEREAU ------
select a.ide_poste, a.ide_mess, count(b.ide_poste)
from centra_non_denoue a
left join fc_ecriture b on a.ide_poste=b.ide_poste
and a.ide_mess=b.ide_mess
where periode between '01/01/2022' and '31/03/2022'
group by a.ide_poste, a.ide_mess
order by a.ide_poste, a.ide_mess;


----------- TRANSFERT NON DENOUE -------------------------
create table transfert_non_denoue as
select unique a.ide_poste, a.ide_mess, a.libn, b.cod_statut, to_date(substr (libn, -9)) as "PERIODE"
from fc_ecriture a
inner join fm_rnl_me b on a.ide_poste = b.ide_nd_dest
and a.ide_nd_emet=b.ide_nd_emet
and a.ide_mess=b.ide_mess
where a.ide_jal in ('JTRANSFERT')
and a.libn like 'Transfert %'
and a.ide_gest='2024'
and a.cod_statut='AC'
and b.flg_emis_recu='R'
and b.cod_statut not in ('AN','TR')
--and to_date(substr (a.libn, -9)) between '01/01/2022' and '31/03/2022'
;

drop table transf_a_denouer;
create table transf_a_denouer as
select ide_poste poste, b.libn libelle, ide_mess bordereau, a.libn observation
from transfert_non_denoue a
inner join rm_noeud b on a.ide_poste=b.ide_nd
where periode between '01/01/2024' and '30/06/2024'
--and ide_poste in (select ide_poste from rm_poste where ide_typ_poste in ('ACCD','AACDC')) 
order by ide_poste, periode;

-----  POINT NOMBRE DE BORDEREAU PAR POSTE ------
select ide_poste, b.libn, count(ide_poste) as "TOTAL"
from transfert_non_denoue a
inner join rm_noeud b on a.ide_poste=b.ide_nd
where periode between '01/01/2022' and '31/03/2022'
group by ide_poste, b.libn
order by ide_poste;

-----  POINT NOMBRE ECRITURE PAR BORDEREAU ------
select a.ide_poste, a.ide_mess, count(b.ide_mess)
from transfert_non_denoue a
left join fc_ecriture b on a.ide_poste=b.ide_poste
where periode between '01/01/2022' and '31/03/2022'
group by a.ide_poste, a.ide_mess
order by a.ide_poste, a.ide_mess;


-------------------------- CENTRALISATION HORS PERIODE ------------------------------------------
select unique ide_poste poste, ide_gest gestion, dat_jc dat_jc, ide_mess bordereau, ide_ecr ecriture, libn libn
from fc_ecriture
where ide_gest = '2024'
and ide_jal = 'JCENTRAL'
and dat_jc >= '01/02/2024'
and to_date(substr (libn, -8)) <= '31/01/2024'
order by ide_poste, ide_mess, ide_ecr;

------------------------  ---------------------------

select unique ide_poste poste, ide_gest gestion, dat_jc dat_jc, ide_mess bordereau, ide_ecr ecriture, libn libn
from fc_ecriture
where ide_gest = '2024'
and ide_jal = 'JTRANSFERT'
and dat_jc <= '30/06/2024'
--and libn like 'Centralisation %'
--and to_date(substr (libn, -8)) >= '01/09/2023'
and ( regexp_like (substr(libn, -8), '^[0-9]{2}\/[0-9]{2}\/[0-9]{2}$') and  to_date(substr(libn, -8)) >= '01/07/2024')
and ( not regexp_like (substr(libn, -8), '^[0-9]{2}\/[0-9]{2}\/[0-9]{2}$')  )
order by ide_poste, ide_mess, ide_ecr;

----------------------          --------------------------

select unique ide_poste, ide_gest, dat_jc, ide_mess, ide_ecr, libn, ide_cpt, mt, observ
from fc_ecriture a
left join fc_ligne b on a.ide_poste = b.ide_poste
inner join rm_noeud c on a.ide_poste = c.ide_nd
and a.flg_cptab = b.flg_cptab
and a.ide_gest = b.ide_gest
and a.ide_ecr = b.ide_ecr
and a.ide_jal = b.ide_jal
where a.ide_gest = '2024'
and a.ide_jal = 'JCENTRAL'
and dat_jc >= '31/01/2024'
--and libn like 'Centralisation %'
and to_date(substr (libn, -9)) <= '31/01/2024';


------------------------  BORDEREAU DE CENTRALISATION A L'ECRAN   -------------------------------
select unique a.ide_mess, b.cod_statut from fc_ecriture a
inner join fm_rnl_me b on a.ide_mess = b.ide_mess
and a.ide_poste = b.ide_nd_dest 
where a.ide_gest in ('2020','2021')
and a.ide_poste = '888C'
and a.ide_jal in ('JCENTRAL')
and b.flg_emis_recu = 'R'
and b.cod_statut <> 'TR'
order by a.ide_mess;


---------------- CUT DEVERS NON COMPTABILISE -----------------------
select a.ide_poste poste, c.libn libelle, a.ide_mess bordereau, count(a.ide_ecr) nb_ecriture_non_comptabilise, b.libl, a.cod_statut statut, b.mt_db, b.mt_cr
from fc_ecriture a
inner join fm_message b on a.ide_poste = b.ide_nd_emet
inner join rm_noeud c on a.ide_poste = c.ide_nd
and b.ide_nd_emet = c.ide_nd
and a.ide_mess = b.ide_mess
and a.ide_gest='2024'
and cod_typ_mess=24
and a.flg_cptab = 'N'
--and b.libl like '%/08/%'
--and a.ide_poste like '651'
--and regexp_like (substr(libl, -10), '^[0-9]{2}\/[0-9]{2}\/[0-9]{4}$')
--and to_date(substr(libl, -10), 'DD/MM/YYYY') between to_date('01/01/2023', 'DD/MM/YYYY') and to_date('30/11/2023', 'DD/MM/YYYY')
and a.cod_statut not in ('AN', 'RJ')
group by a.ide_poste, c.libn, a.ide_mess, b.libl, a.cod_statut, b.mt_db, b.mt_cr
order by a.ide_poste, a.ide_mess;


-------------------------  DETAILS DES ECRITURES DES TRANSFERTS NON DENOUEES ---------------------------------------------------

select a.ide_poste, c.libn libelle, a.ide_mess bordereau, a.ide_ecr ecriture, a.libn, b.ide_cpt, mt, observ, cod_sens, (select libn from rm_noeud where ide_nd = a.ide_nd_emet) libl_emetteur
from fc_ecriture a
left join fc_ligne b on a.ide_poste = b.ide_poste
inner join rm_noeud c on a.ide_poste = c.ide_nd
and a.flg_cptab = b.flg_cptab
and a.ide_gest = b.ide_gest
and a.ide_ecr = b.ide_ecr
and a.ide_jal = b.ide_jal 
where a.ide_gest='2024'
and a.ide_poste like '503%'
and a.ide_jal='JTRANSFERT'
and a.flg_cptab = 'N'
--and ide_cpt in ('39111', '39112', '391212', '391311', '391321', '391322')
and (regexp_like (substr(a.libn, -8), '^[0-9]{2}\/[0-9]{2}\/[0-9]{2}$') 
and  to_date(substr(a.libn, -8)) <= '31/12/2024'
)
and (a.ide_poste, a.ide_mess) in (select unique ide_poste, ide_mess from transfert_non_denoue)
order by ide_cpt, a.ide_poste, a.ide_ecr, mt, cod_sens, observ;



-----------------------------------  DETAILS DES T23 -----------------------------------------------------
select a.ide_poste, c.libn libelle, a.ide_mess bordereau, b.dat_ecr journee, a.ide_ecr ecriture, a.libn, b.ide_cpt, mt, observ, cod_sens
from fc_ecriture a
left join fc_ligne b on a.ide_poste = b.ide_poste
inner join rm_noeud c on a.ide_poste = c.ide_nd
and a.flg_cptab = b.flg_cptab
and a.ide_gest = b.ide_gest
and a.ide_ecr = b.ide_ecr
and a.ide_jal = b.ide_jal 
where a.ide_gest='2022'
--and a.ide_poste like '5%'
and a.ide_jal='T23'
and a.flg_cptab = 'O'

--and (a.ide_poste, a.ide_mess) in (select unique ide_poste, ide_mess from transfert_non_denoue)
order by ide_cpt, a.ide_poste, a.ide_ecr, mt, cod_sens, observ;



-------------------------- ECRITURE TRANSFERTS HORS PERIODE ------------------------------------------
select unique a.ide_poste poste, c.libn, a.ide_gest gestion, dat_jc dat_jc, ide_mess bordereau, a.ide_ecr ecriture, a.libn libn, mt, ide_cpt, observ, cod_sens
from fc_ecriture a
inner join fc_ligne b on a.ide_poste = b.ide_poste
inner join rm_noeud c on a.ide_poste = c.ide_nd
and a.flg_cptab = b.flg_cptab
and a.ide_gest = b.ide_gest
and a.ide_ecr = b.ide_ecr
and a.ide_jal = b.ide_jal
where a.ide_gest = '2023'
and a.ide_jal = 'JTRANSFERT'
and dat_jc >= '01/12/2023'
--and (a.ide_poste like '2%C' or a.ide_poste = '507')
and ( regexp_like (substr(a.libn, -8), '^[0-9]{2}\/[0-9]{2}\/[0-9]{2}$') and  to_date(substr(a.libn, -8)) <= '30/11/2023')
--and ide_cpt like '391%'
and ide_cpt in ('39111', '39112', '391212', '391311', '391321', '391322')
order by ide_cpt, a.ide_poste, ide_mess, a.ide_ecr;

------------------------  ---------------------------

select unique a.ide_poste poste, c.libn, a.ide_gest gestion, dat_jc dat_jc, ide_mess bordereau, a.ide_ecr ecriture, a.libn libn, mt, ide_cpt, observ, cod_sens
from fc_ecriture a
left join fc_ligne b on a.ide_poste = b.ide_poste
inner join rm_noeud c on a.ide_poste = c.ide_nd
and a.flg_cptab = b.flg_cptab
and a.ide_gest = b.ide_gest
and a.ide_ecr = b.ide_ecr
and a.ide_jal = b.ide_jal
where a.ide_gest = '2023'
and a.ide_jal = 'JTRANSFERT'
and dat_jc <= '30/11/2023'
--and (a.ide_poste like '2%C' or a.ide_poste = '507')
and ( regexp_like (substr(a.libn, -8), '^[0-9]{2}\/[0-9]{2}\/[0-9]{2}$') and  to_date(substr(a.libn, -8)) >= '01/12/2023')
and ide_cpt in ('39111', '39112', '391212', '391311', '391321', '391322')
order by ide_cpt, a.ide_poste, ide_mess, a.ide_ecr;

----------------------          --------------------------



select unique a.ide_poste poste, c.libn, a.ide_gest gestion, dat_jc dat_jc, ide_mess bordereau, a.ide_ecr ecriture, a.libn libn, mt, ide_cpt, observ, cod_sens
from fc_ecriture a
left join fc_ligne b on a.ide_poste = b.ide_poste
inner join rm_noeud c on a.ide_poste = c.ide_nd
and a.flg_cptab = b.flg_cptab
and a.ide_gest = b.ide_gest
and a.ide_ecr = b.ide_ecr
and a.ide_jal = b.ide_jal
where a.ide_gest = '2023'
and a.ide_jal = 'JTRANSFERT'
and dat_jc <= '30/09/2023'
--and (a.ide_poste like '2%C' or a.ide_poste = '507')
and ( regexp_like (substr(a.libn, -8), '^[0-9]{2}\/[0-9]{2}\/[0-9]{2}$') and  to_date(substr(a.libn, -8)) >= '01/10/2023')
and ide_cpt in ('391312')
order by ide_cpt, a.ide_poste, ide_mess, a.ide_ecr;


-----------------  CENTRA HORS PERIODE AUTRE VERSION ------------------------

select ide_cpt, sum(decode(cod_sens, 'C', mt, -mt))
from fc_ligne
where (ide_gest, ide_poste, flg_cptab, ide_ecr, ide_jal)
in
(
    select ide_gest, ide_poste, flg_cptab, ide_ecr, ide_jal
    from fc_ecriture
    where ide_gest = '2023'
    and dat_jc >= to_date('01/11/2023', 'DD/MM/RRRR')
    and ide_jal = 'JCENTRAL'
    and flg_cptab = 'O'
    and to_date(substr(libn, -8), 'DD/MM/RRRR') < to_date('01/11/2023', 'DD/MM/RRRR')
)
and ide_cpt like '390%'
group by ide_cpt
order by ide_cpt
; 



select *
from fc_ligne
where (ide_gest, ide_poste, flg_cptab, ide_ecr, ide_jal)
in
(
    select ide_gest, ide_poste, flg_cptab, ide_ecr, ide_jal
    from fc_ecriture
    where ide_gest = '2023'
    and dat_jc >= to_date('01/11/2023', 'DD/MM/RRRR')
    and ide_jal = 'JCENTRAL'
    and flg_cptab = 'O'
    and to_date(substr(libn, -8), 'DD/MM/RRRR') < to_date('01/11/2023', 'DD/MM/RRRR')
)
order by ide_ecr
; 


select a.ide_poste, c.libn libelle, a.ide_mess bordereau, a.ide_ecr ecriture, a.libn, b.ide_cpt, mt, observ, cod_sens, (select libn from rm_noeud where ide_nd = a.ide_nd_emet) libl_emetteur
from fc_ecriture a
left join fc_ligne b on a.ide_poste = b.ide_poste
inner join rm_noeud c on a.ide_poste = c.ide_nd
and a.flg_cptab = b.flg_cptab
and a.ide_gest = b.ide_gest
and a.ide_ecr = b.ide_ecr
and a.ide_jal = b.ide_jal 
where a.ide_gest='2024'
and a.ide_poste like '503%'
and a.ide_jal='JTRANSFERT'
and a.flg_cptab = 'N'
--and ide_cpt in ('39111', '39112', '391212', '391311', '391321', '391322')
and (regexp_like (substr(a.libn, -8), '^[0-9]{2}\/[0-9]{2}\/[0-9]{2}$') 
and  to_date(substr(a.libn, -8)) <= '31/12/2024'
)
and (a.ide_poste, a.ide_mess) in (select unique ide_poste, ide_mess from transfert_non_denoue)
order by a.ide_poste, a.ide_ecr, cod_sens, observ;
