drop table tfert;

create table tfert as
select 'E' cible, ide_poste emetteur, spec3 recepteur, ide_cpt compte, nvl(sum(mt),0) montant, cod_sens, dat_ecr
from fc_ligne
where substr(ide_cpt, 1, 3) = '391'
and flg_cptab = 'O'
and ide_gest = '2023'
--and spec3 is not null
and ide_jal <> 'JTRANSFERT'
and dat_ecr between '01/01/2023' and '31/12/2023'
--and (ide_poste like '2%C' or ide_poste = '507')
--and ide_poste in (select ide_poste from piaf_adm.piaf_adm.rm_poste where ide_poste_centra = '501C')
group by ide_poste, ide_cpt, spec3, cod_sens, dat_ecr

union

select 'R' cible, a.ide_nd_emet emetteur, a.ide_poste recepteur, b.ide_cpt compte, nvl(sum(mt),0) montant, cod_sens, to_date(substr (libn, -9)) dat_ecr
from fc_ecriture a
left join fc_ligne b on a.ide_poste = b.ide_poste
and a.flg_cptab = b.flg_cptab
and a.ide_gest = b.ide_gest
and a.ide_ecr = b.ide_ecr
and a.ide_jal = b.ide_jal
--and a.flg_cptab = 'N'
where a.ide_gest='2023'
and a.ide_jal='JTRANSFERT'
and substr(b.ide_cpt, 1, 3) = '391'
--and dat_jc between '01/01/2023' and '31/05/2023'
and ( regexp_like (substr(libn, -8), '^[0-9]{2}\/[0-9]{2}\/[0-9]{2}$') and  to_date(substr(libn, -8)) between '01/01/2023' and '31/12/2023')
--and b.dat_ecr <= '31/12/2023'
--and a.ide_poste in (select ide_poste from piaf_adm.piaf_adm.rm_poste where ide_poste_centra = '501C')
--and (a.ide_poste like '2%C' or a.ide_poste = '507')
group by a.ide_nd_emet, a.ide_poste, b.ide_cpt, cod_sens, to_date(substr (libn, -9))

--union
--
--select 'N' cible, a.ide_nd_emet emetteur, a.ide_poste recepteur, b.ide_cpt compte, nvl(sum(mt),0) montant, cod_sens
--from fc_ecriture a
--left join fc_ligne b on a.ide_poste = b.ide_poste
--and a.flg_cptab = b.flg_cptab
--and a.ide_gest = b.ide_gest
--and a.ide_ecr = b.ide_ecr
--and a.ide_jal = b.ide_jal
--and a.flg_cptab = 'N'
--where a.ide_gest='2023'
--and a.ide_jal='JTRANSFERT'
--and substr(b.ide_cpt, 1, 3) = '391'
----and b.dat_ecr <= '31/12/2022'
----and a.ide_poste in (select ide_poste from piaf_adm.piaf_adm.rm_poste where ide_poste_centra = '501C')
--group by a.ide_nd_emet, a.ide_poste, b.ide_cpt, cod_sens
;

drop table tfert_envoye;

create table tfert_envoye as
select 'Transfert envoyé par le poste ' clb, emetteur, ' à destination du poste ' frm,  recepteur distinataire, compte, montant mt_envoye, 0 mt_recu, cod_sens, dat_ecr
from tfert
--where emetteur = '218C'
where cible = 'E';

drop table tfert_recu;

create table tfert_recu as
select 'Transfert en provenance du poste ' clb, emetteur, 'reçu par le poste ' frm , recepteur distinataire , compte, 0 mt_envoye, montant mt_recu, cod_sens, dat_ecr
from tfert
--where emetteur = '215C'
where cible = 'R'
order by emetteur;

drop table tfert_recu_non_compta;

create table tfert_recu_non_compta as
select 'Transfert en provenance du poste ' clb, emetteur, 'non comptabilisé par le poste ' frm , recepteur distinataire , compte, 0 mt_envoye, montant mt_recu, cod_sens
from tfert
--where emetteur = '212C'
where cible = 'N'
order by emetteur;

drop table transf_a_trait;

create table transf_a_trait as
select a.clb env, a.emetteur poste_emet , a.frm frm_env, a.distinataire poste_dest, a.compte compte_envoye, a.mt_envoye, a.cod_sens sens_emet, a.dat_ecr dat_envoye, 
       b.clb recu, b.emetteur poste_emett, b.frm frm_dest, b.distinataire poste_desti, b.compte compte_recu, b.mt_recu, b.cod_sens sens_recept, b.dat_ecr dat_recu
--, 
--c.clb, c.emetteur poste, c.frm, c.distinataire poste, c.compte, c.mt_recu, c.cod_sens  
from tfert_envoye a
--left join tfert_recu b on a.emetteur = b.emetteur
full outer join tfert_recu b on a.emetteur = b.emetteur
and a.distinataire = b.distinataire
and a.compte = b.compte
and a.dat_ecr = b.dat_ecr
--and (a.emetteur is null or b.emetteur is null)
--left join tfert_recu_non_compta c on a.emetteur = c.emetteur
--and a.distinataire = c.distinataire
--and a.compte = c.compte
group by a.clb, a.emetteur,a.frm, a.distinataire, a.compte, a.dat_ecr, b.clb, b.emetteur, b.frm, b.distinataire, b.compte, a.mt_envoye , b.mt_recu, a.cod_sens, b.cod_sens, b.dat_ecr 
--, 
--c.clb, c.emetteur, c.frm, c.distinataire, c.compte, c.mt_recu, c.cod_sens
having ((a.mt_envoye - b.mt_recu) <> 0 or b.mt_recu is null or a.mt_envoye is null)
--having (a.mt_envoye - b.mt_recu) = 0
order by a.emetteur, a.compte, a.dat_ecr
;

drop table transf_a_traite;

create table transf_a_traite as
select env, nvl(poste_emet, poste_emett) poste_emet, frm_env, nvl(poste_dest, poste_desti) poste_dest, compte_envoye, mt_envoye, sens_emet, nvl(dat_envoye, dat_recu) dat_envoye, recu, poste_emett, frm_dest, poste_desti, compte_recu, mt_recu, sens_recept, dat_recu 
from transf_a_trait
;

select * from transf_a_traite
order by poste_emet,poste_dest, compte_envoye, dat_envoye;

drop table transf_a_traite_avec_date;

create table transf_a_traite_avec_date as
select env, poste_emet, frm_env, poste_dest, compte_envoye, mt_envoye, sens_emet, dat_envoye, recu, poste_emett, frm_dest, poste_desti, compte_recu, mt_recu, sens_recept, dat_recu, cod_ferm
from transf_a_traite
left join fc_calend_hist on dat_envoye = dat_jc
and poste_emet = ide_poste
order by poste_emet, poste_desti, compte_envoye, dat_envoye;


select * from transf_a_traite_avec_date
where cod_ferm <> 'O'
and poste_emet = '501' 
and poste_dest = '506'
;


select 'E' cible, ide_poste emetteur, spec3 recepteur, ide_cpt compte, mt montant, observ, cod_sens
from fc_ligne
where ide_cpt like '391%'
and flg_cptab = 'O'
and ide_gest = '2023'
and ide_poste = '663C'
and spec3 = '501'
and ide_cpt like '39111%'
--and spec3 is not null
and ide_jal <> 'JTRANSFERT'
--and dat_ecr < '01/03/2022'
--and ide_poste in (select ide_poste from piaf_adm.piaf_adm.rm_poste where ide_poste_centra = '501C')
--group by ide_poste, ide_cpt, spec3, cod_sens

union

select 'R' cible, a.ide_nd_emet emetteur, a.ide_poste recepteur, b.ide_cpt compte, mt montant, observ, cod_sens
from fc_ecriture a
left join fc_ligne b on a.ide_poste = b.ide_poste
and a.flg_cptab = b.flg_cptab
and a.ide_gest = b.ide_gest
and a.ide_ecr = b.ide_ecr
and a.ide_jal = b.ide_jal
and a.flg_cptab = 'O'
where a.ide_gest='2023'
and a.ide_jal='JTRANSFERT'
and b.ide_cpt like '39111%'
--and b.dat_ecr < '01/03/2022'
and a.ide_poste = '501'
and a.ide_nd_emet = '663C'
--and a.ide_poste in (select ide_poste from piaf_adm.piaf_adm.rm_poste where ide_poste_centra = '501C')
--group by a.ide_nd_emet, a.ide_poste, b.ide_cpt, cod_sens
order by observ,montant, 1
;



------------------------------------- CENTRALISATION --------------------------------------------------------------------
select * from centra_envoye;
select * from centra_recu;

select a.cible, a.ide_poste, a.ide_poste_centra, a.ide_cpt, a.dat_ecr, a.mt, b.cible, b.ide_poste, b.ide_nd_emet, b.ide_cpt, b.dat_ecr, b.mt from centra_envoye a
left join centra_recu b on ide_poste_centra = b.ide_poste
and a.ide_poste = ide_nd_emet
and a.ide_cpt = b.ide_cpt
and a.dat_ecr = b.dat_ecr
--inner join fc_calend_hist c on a.dat_ecr = c.dat_jc
group by a.cible, a.ide_poste, a.ide_poste_centra, a.ide_cpt, a.dat_ecr, a.mt, b.cible, b.ide_poste, b.ide_nd_emet, b.ide_cpt, b.dat_ecr, b.mt
--having (a.mt + b.mt) <> 0
having (abs(a.mt) <>  abs(b.mt)) or b.mt is null --/ 2
order by ide_poste_centra, a.dat_ecr
;

drop table centra_envoye;

create table centra_envoye as
select 'B' cible, a.ide_poste, ide_poste_centra, ide_cpt, dat_ecr, sum(decode(cod_sens, 'C', mt, -mt)) mt
from fc_ligne a, piaf_adm.rm_poste b
where a.ide_poste = b.ide_poste
and ide_jal <> 'JCENTRAL'
--and a.dat_maj between '24/04/2023' and '29/04/2023'
and a.dat_ecr between '01/09/2023' and '30/09/2023'
--and dat_maj between '07/05/2023'
and substr(ide_cpt, 1, 3) = '390'
and substr(ide_cpt, 1, 5) <> '39031'
and substr(ide_cpt, 1, 5) <> '39032'
and a.flg_cptab = 'O'
group by a.ide_poste, ide_poste_centra, ide_cpt, dat_ecr
;

drop table centra_recu;

create table centra_recu as
select 'C' cible, a.ide_poste, ide_nd_emet, ide_cpt, to_date(substr (libn, -9)) dat_ecr, sum(decode(cod_sens, 'C', mt, -mt)) mt
--from fc_ligne
--where ide_jal = 'JCENTRAL'
--and dat_cre between '24/04/2023' and '27/04/2023'
--group by ide_poste, ide_cpt
from fc_ecriture a
left join fc_ligne b on a.ide_poste = b.ide_poste
and a.flg_cptab = b.flg_cptab
and a.ide_gest = b.ide_gest
and a.ide_ecr = b.ide_ecr
and a.ide_jal = b.ide_jal 
where a.ide_gest='2023'
and substr(ide_cpt, 1, 3) = '390'
and substr(ide_cpt, 1, 5) <> '39031'
and substr(ide_cpt, 1, 5) <> '39032'
and a.ide_jal='JCENTRAL'
and to_date(substr (libn, -9)) between '01/09/2023' and '30/09/2023'
--and a.dat_cre between '24/04/2023' and '29/04/2023'
group by a.ide_poste, ide_nd_emet, ide_cpt, to_date(substr (libn, -9))

order by 3, 4, 5
;

drop table a_traite;

create table a_traite as
select a.cible cible_e, a.ide_poste poste_emet, a.ide_poste_centra, a.ide_cpt compte_envoye, a.dat_ecr date_envoye, a.mt mt_envoye, b.cible cible_r, b.ide_poste poste_recept, b.ide_nd_emet, b.ide_cpt compte_recu, b.dat_ecr date_recu, b.mt mt_recu 
from centra_envoye a
--left join centra_recu b on ide_poste_centra = b.ide_poste
full outer join centra_recu b on ide_poste_centra = b.ide_poste
and a.ide_poste = ide_nd_emet
and a.ide_cpt = b.ide_cpt
and a.dat_ecr = b.dat_ecr
--inner join fc_calend_hist c on a.dat_ecr = c.dat_jc
group by a.cible, a.ide_poste, a.ide_poste_centra, a.ide_cpt, a.dat_ecr, a.mt, b.cible, b.ide_poste, b.ide_nd_emet, b.ide_cpt, b.dat_ecr, b.mt
--having (a.mt + b.mt) <> 0
having ((abs(a.mt) <>  abs(b.mt)) or b.mt is null or a.mt is null)--/ 2
order by ide_poste_centra, a.dat_ecr
;


drop table a_traiter;

create table a_traiter as
select cible_e, nvl(poste_emet, ide_nd_emet) poste_emet, nvl(ide_poste_centra, poste_recept) ide_poste_centra, compte_envoye, nvl(date_envoye, date_recu) date_envoye, mt_envoye, cible_r, poste_recept, 
ide_nd_emet, compte_recu, date_recu, mt_recu 
from a_traite;

select * from a_traiter
order by ide_poste_centra, date_envoye;

drop table a_traite_avec_journee;

create table a_traite_avec_journee as
select unique cible_e, poste_emet, ide_poste_centra, compte_envoye, date_envoye, mt_envoye, cible_r, poste_recept, ide_nd_emet, compte_recu, date_recu, mt_recu, cod_ferm from a_traiter
inner join fc_calend_hist on date_envoye = dat_jc
and poste_emet = ide_poste
--and cod_ferm = 'C'
order by ide_poste_centra, poste_emet, date_envoye;

select * from a_traite_avec_journee 
where cod_ferm <> 'O'
and poste_emet not like '4%'
--order by ;