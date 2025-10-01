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
and dat_ecr between '01/01/2023' and '30/09/2023'
--and (ide_poste like '2%C' or ide_poste = '507')
--and ide_poste in (select ide_poste from piaf_adm.rm_poste where ide_poste_centra = '501C')
group by ide_poste, ide_cpt, spec3

union

select 'C' cible, a.ide_nd_emet emetteur, a.ide_poste recepteur, b.ide_cpt compte, nvl(sum(mt),0) montant
from fc_ecriture a
left join fc_ligne b on a.ide_poste = b.ide_poste
and a.flg_cptab = b.flg_cptab
and a.ide_gest = b.ide_gest
and a.ide_ecr = b.ide_ecr
and a.ide_jal = b.ide_jal
and a.flg_cptab = 'O'
where a.ide_gest='2023'
and a.ide_jal='JTRANSFERT'
and substr(b.ide_cpt, 1, 3) = '391'
and a.dat_jc <= '30/09/2023'
--and b.dat_ref between '01/01/2023' and '31/05/2023'
and ( regexp_like (substr(libn, -8), '^[0-9]{2}\/[0-9]{2}\/[0-9]{2}$') and  to_date(substr(libn, -8)) between '01/01/2023' and '30/09/2023')
--and (a.ide_poste like '2%C' or a.ide_poste = '507')
--and a.ide_poste in (select ide_poste from piaf_adm.rm_poste where ide_poste_centra = '501C')
group by a.ide_nd_emet, a.ide_poste, b.ide_cpt

union 

select 'H' cible, a.ide_nd_emet emetteur, a.ide_poste recepteur, b.ide_cpt compte, nvl(sum(mt),0) montant
from fc_ecriture a
left join fc_ligne b on a.ide_poste = b.ide_poste
and a.flg_cptab = b.flg_cptab
and a.ide_gest = b.ide_gest
and a.ide_ecr = b.ide_ecr
and a.ide_jal = b.ide_jal
and a.flg_cptab = 'O'
where a.ide_gest='2023'
and a.ide_jal='JTRANSFERT'
and substr(b.ide_cpt, 1, 3) = '391'
and a.dat_jc > '30/09/2023'
--and b.dat_ref between '01/01/2023' and '31/05/2023'
and ( regexp_like (substr(libn, -8), '^[0-9]{2}\/[0-9]{2}\/[0-9]{2}$') and  to_date(substr(libn, -8)) between '01/01/2023' and '30/09/2023')
--and (a.ide_poste like '2%C' or a.ide_poste = '507')
--and a.ide_poste in (select ide_poste from piaf_adm.rm_poste where ide_poste_centra = '501C')
group by a.ide_nd_emet, a.ide_poste, b.ide_cpt

union 

select 'N' cible, a.ide_nd_emet emetteur, a.ide_poste recepteur, b.ide_cpt compte, nvl(sum(mt),0) montant
from fc_ecriture a
left join fc_ligne b on a.ide_poste = b.ide_poste
and a.flg_cptab = b.flg_cptab
and a.ide_gest = b.ide_gest
and a.ide_ecr = b.ide_ecr
and a.ide_jal = b.ide_jal
and a.flg_cptab = 'N'
where a.ide_gest='2023'
and a.ide_jal='JTRANSFERT'
and substr(b.ide_cpt, 1, 3) = '391'
--and a.dat_jc > '30/09/2023'
--and b.dat_ref between '01/01/2023' and '31/05/2023'
and ( regexp_like (substr(libn, -8), '^[0-9]{2}\/[0-9]{2}\/[0-9]{2}$') and  to_date(substr(libn, -8)) between '01/01/2023' and '30/09/2023')
--and (a.ide_poste like '2%C' or a.ide_poste = '507')
--and a.ide_poste in (select ide_poste from piaf_adm.rm_poste where ide_poste_centra = '501C')
group by a.ide_nd_emet, a.ide_poste, b.ide_cpt
;

drop table masse_transfert_emis;

create table masse_transfert_emis as
select * from masse_transfert
where cible = 'E'
order by 4,2,3,1;

drop table masse_transfert_compta;

create table masse_transfert_compta as
select * from masse_transfert
where cible = 'C'
order by 4,2,3,1;

drop table masse_transfert_hors;

create table masse_transfert_hors as
select * from masse_transfert
where cible = 'H'
order by 4,2,3,1;

drop table masse_transfert_non_pris;

create table masse_transfert_non_pris as
select * from masse_transfert
where cible = 'N'
order by 4,2,3,1;


drop table masse_trft;

create table masse_trft as
select a.cible a_cible, a.emetteur a_emetteur, a.recepteur a_recepteur, a.compte a_compte, a.montant a_montant, 
       b.cible b_cible, b.emetteur b_emetteur, b.recepteur b_recepteur, b.compte b_compte, b.montant b_montant
from masse_transfert_emis a
full outer join masse_transfert_compta b on a.emetteur = b.emetteur
and a.recepteur = b.recepteur
and a.compte = b.compte
;

drop table masse_trft_bis;

create table masse_trft_bis as
select a_cible a_cible, a_emetteur a_emetteur, a_recepteur a_recepteur, a_compte a_compte, a_montant a_montant, 
       b_cible b_cible, b_emetteur b_emetteur, b_recepteur b_recepteur, b_compte b_compte, b_montant b_montant,
       b.cible c_cible, b.emetteur c_emetteur, b.recepteur c_recepteur, b.compte c_compte, b.montant c_montant 
from masse_trft a
full outer join masse_transfert_hors b on a_emetteur = b.emetteur
and a_recepteur = b.recepteur
and a_compte = b.compte
;

drop table masse_trft_bis_final;

create table masse_trft_bis_final as
select a_cible a_cible, a_emetteur a_emetteur, a_recepteur a_recepteur, a_compte a_compte, a_montant a_montant, 
       b_cible b_cible, b_emetteur b_emetteur, b_recepteur b_recepteur, b_compte b_compte, b_montant b_montant,
       c_cible c_cible, c_emetteur c_emetteur, c_recepteur c_recepteur, c_compte c_compte, c_montant c_montant,
       b.cible d_cible, b.emetteur d_emetteur, b.recepteur d_recepteur, b.compte d_compte, b.montant d_montant 
from masse_trft_bis a
full outer join masse_transfert_non_pris b on a_emetteur = b.emetteur
and a_recepteur = b.recepteur
and a_compte = b.compte
;

---------------------------------------- TRANSFERT EMIS MOIS SUIVANT  --------------------------------------------------

DROP TABLE masse_transfert_mois_suivant;

CREATE TABLE masse_transfert_mois_suivant as

select 'ES' cible, ide_poste emetteur, spec3 recepteur, ide_cpt compte, nvl(sum(mt),0) montant
from fc_ligne
where substr(ide_cpt, 1, 3) = '391'
and flg_cptab = 'O'
and ide_gest = '2023'
--and spec3 is not null
and ide_jal <> 'JTRANSFERT'
and dat_ecr between '01/10/2023' and '31/10/2023'
--and (ide_poste like '2%C' or ide_poste = '507')
--and ide_poste in (select ide_poste from piaf_adm.rm_poste where ide_poste_centra = '501C')
group by ide_poste, ide_cpt, spec3

union

select 'CS' cible, a.ide_nd_emet emetteur, a.ide_poste recepteur, b.ide_cpt compte, nvl(sum(mt),0) montant
from fc_ecriture a
left join fc_ligne b on a.ide_poste = b.ide_poste
and a.flg_cptab = b.flg_cptab
and a.ide_gest = b.ide_gest
and a.ide_ecr = b.ide_ecr
and a.ide_jal = b.ide_jal
and a.flg_cptab = 'O'
where a.ide_gest='2023'
and a.ide_jal='JTRANSFERT'
and substr(b.ide_cpt, 1, 3) = '391'
and a.dat_jc <= '30/09/2023'
--and b.dat_ref between '01/01/2023' and '31/05/2023'
and ( regexp_like (substr(libn, -8), '^[0-9]{2}\/[0-9]{2}\/[0-9]{2}$') and  to_date(substr(libn, -8)) between '01/10/2023' and '31/10/2023')
--and (a.ide_poste like '2%C' or a.ide_poste = '507')
--and a.ide_poste in (select ide_poste from piaf_adm.rm_poste where ide_poste_centra = '501C')
group by a.ide_nd_emet, a.ide_poste, b.ide_cpt;

drop table masse_transfert_emis_suiv;

create table masse_transfert_emis_suiv as
select * from masse_transfert_mois_suivant
where cible = 'ES'
order by 4,2,3,1;

drop table masse_transfert_compta_suiv;

create table masse_transfert_compta_suiv as
select * from masse_transfert_mois_suivant
where cible = 'CS'
order by 4,2,3,1;

drop table masse_trft_suiv;

create table masse_trft_suiv as
select a.cible es_cible, a.emetteur es_emetteur, a.recepteur es_recepteur, a.compte es_compte, a.montant es_montant, 
       b.cible cs_cible, b.emetteur cs_emetteur, b.recepteur cs_recepteur, b.compte cs_compte, b.montant cs_montant
from masse_transfert_emis_suiv a
full outer join masse_transfert_compta_suiv b on a.emetteur = b.emetteur
and a.recepteur = b.recepteur
and a.compte = b.compte
;


---------------------------------------- FIN -------------------------------------------


drop table masse_trft_bis_sss;

create table masse_trft_bis_sss as
select a_cible a_cible, a_emetteur a_emetteur, a_recepteur a_recepteur, a_compte a_compte, a_montant a_montant, 
       b_cible b_cible, b_emetteur b_emetteur, b_recepteur b_recepteur, b_compte b_compte, b_montant b_montant,
       c_cible c_cible, c_emetteur c_emetteur, c_recepteur c_recepteur, c_compte c_compte, c_montant c_montant,
       d_cible d_cible, d_emetteur d_emetteur, d_recepteur d_recepteur, d_compte d_compte, d_montant d_montant,
       b.cs_cible e_cible, b.cs_emetteur e_emetteur, b.cs_recepteur e_recepteur, b.cs_compte e_compte, b.cs_montant e_montant
from masse_trft_bis_final a
full outer join masse_trft_suiv b on a_emetteur = b.cs_emetteur
and a_recepteur = b.cs_recepteur
and a_compte = b.cs_compte
;


select a_cible, a_emetteur, a_recepteur, a_compte, nvl(a_montant,0) montant_emis, 
       b_cible, b_emetteur, b_recepteur, b_compte, nvl(b_montant,0) montant_bonne_periode,
       c_cible, c_emetteur, c_recepteur, c_compte, nvl(c_montant,0) montant_hors_periode,
       e_cible, e_emetteur, e_recepteur, e_compte, nvl(e_montant,0) montant_mauvaise_periode, 
       d_cible, d_emetteur, d_recepteur, d_compte, nvl(d_montant,0) montant_non_denoue 
from masse_trft_bis_sss
group by a_cible, a_emetteur, a_recepteur, a_compte, a_montant, 
      b_cible, b_emetteur, b_recepteur, b_compte, b_montant,
      c_cible, c_emetteur, c_recepteur, c_compte, c_montant, 
      d_cible, d_emetteur, d_recepteur, d_compte, d_montant,
      e_cible, e_emetteur, e_recepteur, e_compte, e_montant
--having ((a_montant - b_montant) <> 0 or a_montant is null or b_montant is null)
order by 4,3,1
;

-------------------- TOUS LES COMPTES -------------------------------
drop table tableau_transfert;

create table tableau_transfert as
select nvl(a_recepteur, e_recepteur) destinataire, nvl(a_emetteur, e_emetteur) emetteur, nvl(a_compte, e_compte) compte, nvl(a_montant,0) montant_emis, 
       nvl(b_montant,0) montant_bonne_periode,
       nvl(c_montant,0) montant_septembre_pris_octobre,
       nvl(e_montant,0) montant_octobre_pris_septembre, 
       nvl(d_montant,0) montant_non_denoue 
from masse_trft_bis_sss
group by a_cible, a_emetteur, a_recepteur, a_compte, a_montant,
      b_cible, b_emetteur, b_recepteur, b_compte, b_montant,
      c_cible, c_emetteur, c_recepteur, c_compte, c_montant, 
      d_cible, d_emetteur, d_recepteur, d_compte, d_montant,
      e_cible, e_emetteur, e_recepteur, e_compte, e_montant
--having ((a_montant - b_montant) <> 0 or a_montant is null or b_montant is null)
order by 3,1,2
;


select destinataire, emetteur, compte, montant_emis, montant_bonne_periode, montant_septembre_pris_octobre, montant_octobre_pris_septembre, montant_non_denoue, 
((montant_bonne_periode + montant_septembre_pris_octobre + montant_non_denoue) - montant_emis) ecart
from tableau_transfert;


--------------------- 39111 -------------------------------
select nvl(a_recepteur, e_recepteur) destinataire, nvl(a_emetteur, e_emetteur) emetteur, nvl(a_compte, e_compte) compte, nvl(a_montant,0) montant_emis, 
       nvl(b_montant,0) montant_bonne_periode,
       nvl(c_montant,0) montant_septembre_pris_octobre,
       nvl(e_montant,0) montant_octobre_pris_septembre, 
       nvl(d_montant,0) montant_non_denoue 
from masse_trft_bis_sss
where a_compte = '39111'
group by a_cible, a_emetteur, a_recepteur, a_compte, a_montant,
      b_cible, b_emetteur, b_recepteur, b_compte, b_montant,
      c_cible, c_emetteur, c_recepteur, c_compte, c_montant, 
      d_cible, d_emetteur, d_recepteur, d_compte, d_montant,
      e_cible, e_emetteur, e_recepteur, e_compte, e_montant
--having ((a_montant - b_montant) <> 0 or a_montant is null or b_montant is null)
order by 3,1,2
;
--------------------- 39111 PCD -------------------------------
select nvl(a_recepteur, e_recepteur) destinataire, nvl(a_emetteur, e_emetteur) emetteur, nvl(a_compte, e_compte) compte, nvl(a_montant,0) montant_emis, 
       nvl(b_montant,0) montant_bonne_periode,
       nvl(c_montant,0) montant_septembre_pris_octobre,
       nvl(e_montant,0) montant_octobre_pris_septembre, 
       nvl(d_montant,0) montant_non_denoue 
from masse_trft_bis_sss
where a_compte = '39111'
and a_recepteur in (select ide_poste from rm_poste where ide_typ_poste = 'TC')
group by a_cible, a_emetteur, a_recepteur, a_compte, a_montant,
      b_cible, b_emetteur, b_recepteur, b_compte, b_montant,
      c_cible, c_emetteur, c_recepteur, c_compte, c_montant, 
      d_cible, d_emetteur, d_recepteur, d_compte, d_montant,
      e_cible, e_emetteur, e_recepteur, e_compte, e_montant
--having ((a_montant - b_montant) <> 0 or a_montant is null or b_montant is null)
order by 3,1,2
;
--------------------- 39111 ACCD -------------------------------
select nvl(a_recepteur, e_recepteur) destinataire, nvl(a_emetteur, e_emetteur) emetteur, nvl(a_compte, e_compte) compte, nvl(a_montant,0) montant_emis, 
       nvl(b_montant,0) montant_bonne_periode,
       nvl(c_montant,0) montant_septembre_pris_octobre,
       nvl(e_montant,0) montant_octobre_pris_septembre, 
       nvl(d_montant,0) montant_non_denoue 
from masse_trft_bis_sss
where a_compte = '39111'
and a_recepteur in (select ide_poste from rm_poste where ide_typ_poste in ('AACDC','ACCD'))
group by a_cible, a_emetteur, a_recepteur, a_compte, a_montant,
      b_cible, b_emetteur, b_recepteur, b_compte, b_montant,
      c_cible, c_emetteur, c_recepteur, c_compte, c_montant, 
      d_cible, d_emetteur, d_recepteur, d_compte, d_montant,
      e_cible, e_emetteur, e_recepteur, e_compte, e_montant
--having ((a_montant - b_montant) <> 0 or a_montant is null or b_montant is null)
order by 3,1,2
;
--------------------- 39111 PGSP -------------------------------
select nvl(a_recepteur, e_recepteur) destinataire, nvl(a_emetteur, e_emetteur) emetteur, nvl(a_compte, e_compte) compte, nvl(a_montant,0) montant_emis, 
       nvl(b_montant,0) montant_bonne_periode,
       nvl(c_montant,0) montant_septembre_pris_octobre,
       nvl(e_montant,0) montant_octobre_pris_septembre, 
       nvl(d_montant,0) montant_non_denoue 
from masse_trft_bis_sss
where a_compte = '39111'
and a_recepteur in (select ide_poste from rm_poste where ide_typ_poste in ('PGSP','PGSPC'))
group by a_cible, a_emetteur, a_recepteur, a_compte, a_montant,
      b_cible, b_emetteur, b_recepteur, b_compte, b_montant,
      c_cible, c_emetteur, c_recepteur, c_compte, c_montant, 
      d_cible, d_emetteur, d_recepteur, d_compte, d_montant,
      e_cible, e_emetteur, e_recepteur, e_compte, e_montant
--having ((a_montant - b_montant) <> 0 or a_montant is null or b_montant is null)
order by 3,1,2
;
--------------------- 39111 PGDP -------------------------------
select nvl(a_recepteur, e_recepteur) destinataire, nvl(a_emetteur, e_emetteur) emetteur, nvl(a_compte, e_compte) compte, nvl(a_montant,0) montant_emis, 
       nvl(b_montant,0) montant_bonne_periode,
       nvl(c_montant,0) montant_septembre_pris_octobre,
       nvl(e_montant,0) montant_octobre_pris_septembre, 
       nvl(d_montant,0) montant_non_denoue 
from masse_trft_bis_sss
where a_compte = '39111'
and a_recepteur in (select ide_poste from rm_poste where ide_typ_poste in ('PGDP','PGDPC'))
group by a_cible, a_emetteur, a_recepteur, a_compte, a_montant,
      b_cible, b_emetteur, b_recepteur, b_compte, b_montant,
      c_cible, c_emetteur, c_recepteur, c_compte, c_montant, 
      d_cible, d_emetteur, d_recepteur, d_compte, d_montant,
      e_cible, e_emetteur, e_recepteur, e_compte, e_montant
--having ((a_montant - b_montant) <> 0 or a_montant is null or b_montant is null)
order by 3,1,2
;
--------------------- 39111 ACCT -------------------------------
select nvl(a_recepteur, e_recepteur) destinataire, nvl(a_emetteur, e_emetteur) emetteur, nvl(a_compte, e_compte) compte, nvl(a_montant,0) montant_emis, 
       nvl(b_montant,0) montant_bonne_periode,
       nvl(c_montant,0) montant_septembre_pris_octobre,
       nvl(e_montant,0) montant_octobre_pris_septembre, 
       nvl(d_montant,0) montant_non_denoue 
from masse_trft_bis_sss
where a_compte = '39111'
and a_recepteur in (select ide_poste from rm_poste where ide_typ_poste = 'ACCT')
group by a_cible, a_emetteur, a_recepteur, a_compte, a_montant,
      b_cible, b_emetteur, b_recepteur, b_compte, b_montant,
      c_cible, c_emetteur, c_recepteur, c_compte, c_montant, 
      d_cible, d_emetteur, d_recepteur, d_compte, d_montant,
      e_cible, e_emetteur, e_recepteur, e_compte, e_montant
--having ((a_montant - b_montant) <> 0 or a_montant is null or b_montant is null)
order by 3,1,2
;
--------------------- 39112 -------------------------------
select nvl(a_recepteur, e_recepteur) destinataire, nvl(a_emetteur, e_emetteur) emetteur, nvl(a_compte, e_compte) compte, nvl(a_montant,0) montant_emis, 
       nvl(b_montant,0) montant_bonne_periode,
       nvl(c_montant,0) montant_septembre_pris_octobre,
       nvl(e_montant,0) montant_octobre_pris_septembre, 
       nvl(d_montant,0) montant_non_denoue 
from masse_trft_bis_sss
where a_compte = '39112'
group by a_cible, a_emetteur, a_recepteur, a_compte, a_montant,
      b_cible, b_emetteur, b_recepteur, b_compte, b_montant,
      c_cible, c_emetteur, c_recepteur, c_compte, c_montant, 
      d_cible, d_emetteur, d_recepteur, d_compte, d_montant,
      e_cible, e_emetteur, e_recepteur, e_compte, e_montant
--having ((a_montant - b_montant) <> 0 or a_montant is null or b_montant is null)
order by 3,1,2
;
--------------------- 39112 PCD -------------------------------
select nvl(a_recepteur, e_recepteur) destinataire, nvl(a_emetteur, e_emetteur) emetteur, nvl(a_compte, e_compte) compte, nvl(a_montant,0) montant_emis, 
       nvl(b_montant,0) montant_bonne_periode,
       nvl(c_montant,0) montant_septembre_pris_octobre,
       nvl(e_montant,0) montant_octobre_pris_septembre, 
       nvl(d_montant,0) montant_non_denoue 
from masse_trft_bis_sss
where a_compte = '39112'
and a_recepteur in (select ide_poste from rm_poste where ide_typ_poste = 'TC')
group by a_cible, a_emetteur, a_recepteur, a_compte, a_montant,
      b_cible, b_emetteur, b_recepteur, b_compte, b_montant,
      c_cible, c_emetteur, c_recepteur, c_compte, c_montant, 
      d_cible, d_emetteur, d_recepteur, d_compte, d_montant,
      e_cible, e_emetteur, e_recepteur, e_compte, e_montant
--having ((a_montant - b_montant) <> 0 or a_montant is null or b_montant is null)
order by 3,1,2
;
--------------------- 39112 ACCD -------------------------------
select nvl(a_recepteur, e_recepteur) destinataire, nvl(a_emetteur, e_emetteur) emetteur, nvl(a_compte, e_compte) compte, nvl(a_montant,0) montant_emis, 
       nvl(b_montant,0) montant_bonne_periode,
       nvl(c_montant,0) montant_septembre_pris_octobre,
       nvl(e_montant,0) montant_octobre_pris_septembre, 
       nvl(d_montant,0) montant_non_denoue 
from masse_trft_bis_sss
where a_compte = '39112'
and a_recepteur in (select ide_poste from rm_poste where ide_typ_poste in ('AACDC','ACCD'))
group by a_cible, a_emetteur, a_recepteur, a_compte, a_montant,
      b_cible, b_emetteur, b_recepteur, b_compte, b_montant,
      c_cible, c_emetteur, c_recepteur, c_compte, c_montant, 
      d_cible, d_emetteur, d_recepteur, d_compte, d_montant,
      e_cible, e_emetteur, e_recepteur, e_compte, e_montant
--having ((a_montant - b_montant) <> 0 or a_montant is null or b_montant is null)
order by 3,1,2
;
--------------------- 39112 PGSP -------------------------------
select nvl(a_recepteur, e_recepteur) destinataire, nvl(a_emetteur, e_emetteur) emetteur, nvl(a_compte, e_compte) compte, nvl(a_montant,0) montant_emis, 
       nvl(b_montant,0) montant_bonne_periode,
       nvl(c_montant,0) montant_septembre_pris_octobre,
       nvl(e_montant,0) montant_octobre_pris_septembre, 
       nvl(d_montant,0) montant_non_denoue 
from masse_trft_bis_sss
where a_compte = '39112'
and a_recepteur in (select ide_poste from rm_poste where ide_typ_poste in ('PGSP','PGSPC'))
group by a_cible, a_emetteur, a_recepteur, a_compte, a_montant,
      b_cible, b_emetteur, b_recepteur, b_compte, b_montant,
      c_cible, c_emetteur, c_recepteur, c_compte, c_montant, 
      d_cible, d_emetteur, d_recepteur, d_compte, d_montant,
      e_cible, e_emetteur, e_recepteur, e_compte, e_montant
--having ((a_montant - b_montant) <> 0 or a_montant is null or b_montant is null)
order by 3,1,2
;
--------------------- 39112 ACCT -------------------------------
select nvl(a_recepteur, e_recepteur) destinataire, nvl(a_emetteur, e_emetteur) emetteur, nvl(a_compte, e_compte) compte, nvl(a_montant,0) montant_emis, 
       nvl(b_montant,0) montant_bonne_periode,
       nvl(c_montant,0) montant_septembre_pris_octobre,
       nvl(e_montant,0) montant_octobre_pris_septembre, 
       nvl(d_montant,0) montant_non_denoue 
from masse_trft_bis_sss
where a_compte = '39112'
and a_recepteur in (select ide_poste from rm_poste where ide_typ_poste = 'ACCT')
group by a_cible, a_emetteur, a_recepteur, a_compte, a_montant,
      b_cible, b_emetteur, b_recepteur, b_compte, b_montant,
      c_cible, c_emetteur, c_recepteur, c_compte, c_montant, 
      d_cible, d_emetteur, d_recepteur, d_compte, d_montant,
      e_cible, e_emetteur, e_recepteur, e_compte, e_montant
--having ((a_montant - b_montant) <> 0 or a_montant is null or b_montant is null)
order by 3,1,2
;