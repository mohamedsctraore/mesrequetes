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
and dat_ecr between '01/01/2023' and '31/12/2023'
and (ide_poste like '2%C' or ide_poste = '507')
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
and ( regexp_like (substr(libn, -8), '^[0-9]{2}\/[0-9]{2}\/[0-9]{2}$') and  to_date(substr(libn, -8)) between '01/01/2023' and '31/12/2023')
and (a.ide_poste like '2%C' or a.ide_poste = '507')
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


select a_cible, a_emetteur, a_recepteur, a_compte, a_montant, 
       b_cible, b_emetteur, b_recepteur, b_compte, b_montant from masse_trft
group by a_cible, a_emetteur, a_recepteur, a_compte, a_montant, 
      b_cible, b_emetteur, b_recepteur, b_compte, b_montant
having ((a_montant - b_montant) <> 0 or a_montant is null or b_montant is null)
order by 2,4,3
;




----------------------------------------  MASSE CENTRALISATION  ----------------------------------

drop table masse_envoye;

create table masse_envoye as
select 'B' cible, a.ide_poste, ide_poste_centra, ide_cpt, sum(decode(cod_sens, 'C', mt, -mt)) mt
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
group by a.ide_poste, ide_poste_centra, ide_cpt
;

drop table masse_recu;

create table masse_recu as
select 'C' cible, a.ide_poste, ide_nd_emet, ide_cpt, sum(decode(cod_sens, 'C', mt, -mt)) mt
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
group by a.ide_poste, ide_nd_emet, ide_cpt

order by 3, 4, 5
;

drop table masse_a_traite;

--create table masse_a_traite as
select a.cible cible_e, a.ide_poste poste_emet, a.ide_poste_centra, a.ide_cpt compte_envoye, a.mt mt_envoye, b.cible cible_r, b.ide_poste poste_recept, b.ide_nd_emet, b.ide_cpt compte_recu, b.mt mt_recu 
from masse_envoye a
--left join centra_recu b on ide_poste_centra = b.ide_poste
full outer join masse_recu b on ide_poste_centra = b.ide_poste
and a.ide_poste = ide_nd_emet
and a.ide_cpt = b.ide_cpt
--and ide_poste_centra = '663C'
--inner join fc_calend_hist c on a.dat_ecr = c.dat_jc
group by a.cible, a.ide_poste, a.ide_poste_centra, a.ide_cpt, a.mt, b.cible, b.ide_poste, b.ide_nd_emet, b.ide_cpt, b.mt
--having (a.mt + b.mt) <> 0
--having ((abs(a.mt) <>  abs(b.mt)) or b.mt is null or a.mt is null)--/ 2    --- tous les cas d'anomalies
--having (abs(a.mt) <  abs(b.mt) or a.mt is null)                              --- cas de centralisation en surplus
--having (abs(a.mt) >  abs(b.mt) or b.mt is null)                              --- cas de centralisations non encore abouties
order by ide_poste_centra, a.ide_poste
;