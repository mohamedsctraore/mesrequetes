----------------------------------------------------- MASSE TRANSFERT  --------------------------------------------------------------

drop table masse_transfert;

CREATE TABLE masse_transfert as
select 'E' cible, ide_poste emetteur, spec3 recepteur, ide_cpt compte, nvl(sum(mt),0) montant
from fc_ligne
where substr(ide_cpt, 1, 3) = '391'
and flg_cptab = 'O'
and ide_gest = '2023'
--and spec3 is not null
and ide_jal <> 'JTRANSFERT'
and dat_ecr between '01/09/2023' and '30/09/2023'
--and (ide_poste like '2%C' or ide_poste = '507')
--and ide_poste in (select ide_poste from piaf_adm.rm_poste where ide_poste_centra = '501C')
group by ide_poste, ide_cpt, spec3
union
select 'R' cible, a.ide_nd_emet emetteur, a.ide_poste recepteur, b.ide_cpt compte, nvl(sum(mt),0) montant
from fc_ecriture a
left join fc_ligne b on a.ide_poste = b.ide_poste
and a.flg_cptab = b.flg_cptab
and a.ide_gest = b.ide_gest
and a.ide_ecr = b.ide_ecr
and a.ide_jal = b.ide_jal
--and a.flg_cptab = 'O'
where a.ide_gest='2023'
and a.ide_jal='JTRANSFERT'
and substr(b.ide_cpt, 1, 3) = '391'
--and a.dat_jc <= '31/07/2023'
--and b.dat_ref between '01/01/2023' and '31/05/2023'
and ( regexp_like (substr(libn, -8), '^[0-9]{2}\/[0-9]{2}\/[0-9]{2}$') and  to_date(substr(libn, -8)) between '01/09/2023' and '30/09/2023')
--and (a.ide_poste like '2%C' or a.ide_poste = '507')
--and a.ide_poste in (select ide_poste from piaf_adm.rm_poste where ide_poste_centra = '501C')
group by a.ide_nd_emet, a.ide_poste, b.ide_cpt
;

drop table masse_transfert_emis;

create table masse_transfert_emis as
select * from masse_transfert
where cible = 'E'
order by 2,3,4,1;

drop table masse_transfert_recu;

create table masse_transfert_recu as
select * from masse_transfert
where cible = 'R'
order by 2,3,4,1;


drop table masse_trft;

create table masse_trft as
select a.cible a_cible, a.emetteur a_emetteur, a.recepteur a_recepteur, a.compte a_compte, a.montant a_montant, 
       b.cible b_cible, b.emetteur b_emetteur, b.recepteur b_recepteur, b.compte b_compte, b.montant b_montant from masse_transfert_emis a
full outer join masse_transfert_recu b
on a.emetteur = b.emetteur
and a.recepteur = b.recepteur
and a.compte = b.compte;

drop table masse_a_traite;

create table masse_a_traite as
select a_cible, a_emetteur, a_recepteur, a_compte, a_montant, 
       b_cible, b_emetteur, b_recepteur, b_compte, b_montant from masse_trft
group by a_cible, a_emetteur, a_recepteur, a_compte, a_montant, 
      b_cible, b_emetteur, b_recepteur, b_compte, b_montant
having ((a_montant - b_montant) <> 0 or a_montant is null or b_montant is null)
order by 2,4,3
;
--------------------------------------------- AVEC JOURNEES ------------------------------------------------------

drop table tfert;

create table tfert as
select 'E' cible, ide_poste emetteur, spec3 recepteur, ide_cpt compte, nvl(sum(mt),0) montant, cod_sens, dat_ecr
from fc_ligne
where substr(ide_cpt, 1, 3) = '391'
and flg_cptab = 'O'
and ide_gest = '2023'
--and spec3 is not null
and ide_jal <> 'JTRANSFERT'
and dat_ecr between '01/09/2023' and '30/09/2023'
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
and ( regexp_like (substr(libn, -8), '^[0-9]{2}\/[0-9]{2}\/[0-9]{2}$') and  to_date(substr(libn, -8)) between '01/09/2023' and '30/09/2023')
--and b.dat_ecr <= '31/12/2023'
--and a.ide_poste in (select ide_poste from piaf_adm.piaf_adm.rm_poste where ide_poste_centra = '501C')
--and (a.ide_poste like '2%C' or a.ide_poste = '507')
group by a.ide_nd_emet, a.ide_poste, b.ide_cpt, cod_sens, to_date(substr (libn, -9))
;

drop table tfert_envoye;

create table tfert_envoye as
select 'Transfert envoyé par le poste ' clb, emetteur, ' à destination du poste ' frm,  recepteur distinataire, compte, montant mt_envoye, 0 mt_recu, cod_sens, dat_ecr
from tfert
where cible = 'E';

drop table tfert_recu;

create table tfert_recu as
select 'Transfert en provenance du poste ' clb, emetteur, 'reçu par le poste ' frm , recepteur distinataire , compte, 0 mt_envoye, montant mt_recu, cod_sens, dat_ecr
from tfert
where cible = 'R'
order by emetteur;

drop table transf_a_trait;

create table transf_a_trait as
select a.clb env, a.emetteur poste_emet , a.frm frm_env, a.distinataire poste_dest, a.compte compte_envoye, a.mt_envoye, a.cod_sens sens_emet, a.dat_ecr dat_envoye, 
       b.clb recu, b.emetteur poste_emett, b.frm frm_dest, b.distinataire poste_desti, b.compte compte_recu, b.mt_recu, b.cod_sens sens_recept, b.dat_ecr dat_recu
from tfert_envoye a
full outer join tfert_recu b on a.emetteur = b.emetteur
and a.distinataire = b.distinataire
and a.compte = b.compte
and a.dat_ecr = b.dat_ecr
group by a.clb, a.emetteur,a.frm, a.distinataire, a.compte, a.dat_ecr, b.clb, b.emetteur, b.frm, b.distinataire, b.compte, a.mt_envoye , b.mt_recu, a.cod_sens, b.cod_sens, b.dat_ecr 
having ((a.mt_envoye - b.mt_recu) <> 0 or b.mt_recu is null or a.mt_envoye is null)
order by a.emetteur, a.compte, a.dat_ecr
;

drop table transf_a_traite;

create table transf_a_traite as
select env, nvl(poste_emet, poste_emett) poste_emet, frm_env, nvl(poste_dest, poste_desti) poste_dest, compte_envoye, mt_envoye, sens_emet, nvl(dat_envoye, dat_recu) dat_envoye, recu, poste_emett, frm_dest, poste_desti, compte_recu, mt_recu, sens_recept, dat_recu 
from transf_a_trait
;

drop table transf_a_traite_avec_date;

create table transf_a_traite_avec_date as
select env, poste_emet, frm_env, poste_dest, compte_envoye, mt_envoye, sens_emet, dat_envoye, recu, poste_emett, frm_dest, poste_desti, compte_recu, mt_recu, sens_recept, dat_recu, cod_ferm
from transf_a_traite
left join fc_calend_hist on dat_envoye = dat_jc
and poste_emet = ide_poste
order by poste_emet, poste_desti, compte_envoye, dat_envoye;


select * from transf_a_traite_avec_date
where cod_ferm <> 'O';