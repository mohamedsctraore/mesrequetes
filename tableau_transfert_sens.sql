----------------------------------------------------- MASSE TRANSFERT  --------------------------------------------------------------

drop table masse_transfert;

CREATE TABLE masse_transfert as

select 'E' cible, ide_poste emetteur, spec3 recepteur, ide_cpt compte, nvl(decode(cod_sens, 'D',sum(mt),0),0) montant_debit, nvl(decode(cod_sens, 'C',sum(mt),0),0) montant_credit
from fc_ligne
where substr(ide_cpt, 1, 3) = '391'
and flg_cptab = 'O'
and ide_gest = '2024'
--and spec3 is not null
and ide_jal <> 'JTRANSFERT'
and dat_ecr between '01/01/2024' and '30/06/2024'
--and (ide_poste like '2%C' or ide_poste = '507')
--and ide_poste in (select ide_poste from piaf_adm.rm_poste where ide_poste_centra = '501C')
group by ide_poste, ide_cpt, spec3, cod_sens

union

select 'C' cible, a.ide_nd_emet emetteur, a.ide_poste recepteur, b.ide_cpt compte, nvl(decode(cod_sens, 'D',sum(mt),0),0) montant_debit, nvl(decode(cod_sens, 'C',sum(mt),0),0) montant_credit
from fc_ecriture a
left join fc_ligne b on a.ide_poste = b.ide_poste
and a.flg_cptab = b.flg_cptab
and a.ide_gest = b.ide_gest
and a.ide_ecr = b.ide_ecr
and a.ide_jal = b.ide_jal
and a.flg_cptab = 'O'
where a.ide_gest='2024'
and a.ide_jal='JTRANSFERT'
and substr(b.ide_cpt, 1, 3) = '391'
and a.dat_jc <= '30/06/2024'
--and b.dat_ref between '01/01/2023' and '31/05/2023'
and ( regexp_like (substr(libn, -8), '^[0-9]{2}\/[0-9]{2}\/[0-9]{2}$') and  to_date(substr(libn, -8)) between '01/01/2024' and '30/06/2024')
--and (a.ide_poste like '2%C' or a.ide_poste = '507')
--and a.ide_poste in (select ide_poste from piaf_adm.rm_poste where ide_poste_centra = '501C')
group by a.ide_nd_emet, a.ide_poste, b.ide_cpt, cod_sens

union 

select 'H' cible, a.ide_nd_emet emetteur, a.ide_poste recepteur, b.ide_cpt compte, nvl(decode(cod_sens, 'D',sum(mt),0),0) montant_debit, nvl(decode(cod_sens, 'C',sum(mt),0),0) montant_credit
from fc_ecriture a
left join fc_ligne b on a.ide_poste = b.ide_poste
and a.flg_cptab = b.flg_cptab
and a.ide_gest = b.ide_gest
and a.ide_ecr = b.ide_ecr
and a.ide_jal = b.ide_jal
and a.flg_cptab = 'O'
where a.ide_gest='2024'
and a.ide_jal='JTRANSFERT'
and substr(b.ide_cpt, 1, 3) = '391'
and a.dat_jc > '30/06/2024'
--and b.dat_ref between '01/01/2023' and '31/05/2023'
and ( regexp_like (substr(libn, -8), '^[0-9]{2}\/[0-9]{2}\/[0-9]{2}$') and  to_date(substr(libn, -8)) between '01/01/2024' and '30/06/2024')
--and (a.ide_poste like '2%C' or a.ide_poste = '507')
--and a.ide_poste in (select ide_poste from piaf_adm.rm_poste where ide_poste_centra = '501C')
group by a.ide_nd_emet, a.ide_poste, b.ide_cpt, cod_sens

union 

select 'N' cible, a.ide_nd_emet emetteur, a.ide_poste recepteur, b.ide_cpt compte, nvl(decode(cod_sens, 'D',sum(mt),0),0) montant_debit, nvl(decode(cod_sens, 'C',sum(mt),0),0) montant_credit
from fc_ecriture a
left join fc_ligne b on a.ide_poste = b.ide_poste
and a.flg_cptab = b.flg_cptab
and a.ide_gest = b.ide_gest
and a.ide_ecr = b.ide_ecr
and a.ide_jal = b.ide_jal
and a.flg_cptab = 'N'
where a.ide_gest='2024'
and a.ide_jal='JTRANSFERT'
and substr(b.ide_cpt, 1, 3) = '391'
--and a.dat_jc > '30/09/2023'
--and b.dat_ref between '01/01/2023' and '31/05/2023'
and ( regexp_like (substr(libn, -8), '^[0-9]{2}\/[0-9]{2}\/[0-9]{2}$') and  to_date(substr(libn, -8)) between '01/01/2024' and '30/06/2024')
--and (a.ide_poste like '2%C' or a.ide_poste = '507')
--and a.ide_poste in (select ide_poste from piaf_adm.rm_poste where ide_poste_centra = '501C')
group by a.ide_nd_emet, a.ide_poste, b.ide_cpt, cod_sens
;

drop table masse_transfert_emis;

create table masse_transfert_emis as
select cible, emetteur, recepteur, compte, sum(montant_debit) montant_debit, sum(montant_credit) montant_credit
from masse_transfert
where cible = 'E'
group by cible, emetteur, recepteur, compte
order by 4,2,3,1;

drop table masse_transfert_compta;

create table masse_transfert_compta as
select cible, emetteur, recepteur, compte, sum(montant_debit) montant_debit, sum(montant_credit) montant_credit 
from masse_transfert
where cible = 'C'
group by cible, emetteur, recepteur, compte
order by 4,2,3,1;

drop table masse_transfert_hors;

create table masse_transfert_hors as
select cible, emetteur, recepteur, compte, sum(montant_debit) montant_debit, sum(montant_credit) montant_credit
from masse_transfert
where cible = 'H'
group by cible, emetteur, recepteur, compte
order by 4,2,3,1;

drop table masse_transfert_non_pris;

create table masse_transfert_non_pris as
select cible, emetteur, recepteur, compte, sum(montant_debit) montant_debit, sum(montant_credit) montant_credit  
from masse_transfert
where cible = 'N'
group by cible, emetteur, recepteur, compte
order by 4,2,3,1;


drop table masse_trft;

create table masse_trft as
select a.cible a_cible, a.emetteur a_emetteur, a.recepteur a_recepteur, a.compte a_compte, nvl(a.montant_debit, 0) a_montant_debit, nvl(a.montant_credit, 0) a_montant_credit,
       b.cible b_cible, b.emetteur b_emetteur, b.recepteur b_recepteur, b.compte b_compte, nvl(b.montant_debit, 0) b_montant_debit, nvl(b.montant_credit, 0) b_montant_credit
from masse_transfert_emis a
full outer join masse_transfert_compta b on a.emetteur = b.emetteur
and a.recepteur = b.recepteur
and a.compte = b.compte
;

drop table masse_trft_bis;

create table masse_trft_bis as
select a_cible a_cible, a_emetteur a_emetteur, a_recepteur a_recepteur, a_compte a_compte, nvl(a_montant_debit, 0) a_montant_debit, nvl(a_montant_credit, 0) a_montant_credit,
       b_cible b_cible, b_emetteur b_emetteur, b_recepteur b_recepteur, b_compte b_compte, nvl(b_montant_debit, 0) b_montant_debit, nvl(b_montant_credit, 0) b_montant_credit,
       b.cible c_cible, b.emetteur c_emetteur, b.recepteur c_recepteur, b.compte c_compte, nvl(b.montant_debit, 0) c_montant_debit, nvl(b.montant_credit, 0) c_montant_credit  
from masse_trft a
full outer join masse_transfert_hors b on a_emetteur = b.emetteur
and a_recepteur = b.recepteur
and a_compte = b.compte
;

drop table masse_trft_bis_final;

create table masse_trft_bis_final as
select a_cible a_cible, a_emetteur a_emetteur, a_recepteur a_recepteur, a_compte a_compte, nvl(a_montant_debit, 0) a_montant_debit, nvl(a_montant_credit, 0) a_montant_credit,
       b_cible b_cible, b_emetteur b_emetteur, b_recepteur b_recepteur, b_compte b_compte, nvl(b_montant_debit, 0) b_montant_debit, nvl(b_montant_credit, 0) b_montant_credit,
       c_cible c_cible, c_emetteur c_emetteur, c_recepteur c_recepteur, c_compte c_compte, nvl(c_montant_debit, 0) c_montant_debit, nvl(c_montant_credit, 0) c_montant_credit,
       b.cible d_cible, b.emetteur d_emetteur, b.recepteur d_recepteur, b.compte d_compte, nvl(b.montant_debit, 0) d_montant_debit, nvl(b.montant_credit, 0) d_montant_credit  
from masse_trft_bis a
full outer join masse_transfert_non_pris b on a_emetteur = b.emetteur
and a_recepteur = b.recepteur
and a_compte = b.compte
;

---------------------------------------- TRANSFERT EMIS MOIS SUIVANT  --------------------------------------------------

DROP TABLE masse_transfert_mois_suivant;

CREATE TABLE masse_transfert_mois_suivant as

select 'ES' cible, ide_poste emetteur, spec3 recepteur, ide_cpt compte, nvl(decode(cod_sens, 'D',sum(mt),0),0) montant_debit, nvl(decode(cod_sens, 'C',sum(mt),0),0) montant_credit
from fc_ligne
where substr(ide_cpt, 1, 3) = '391'
and flg_cptab = 'O'
and ide_gest = '2024'
--and spec3 is not null
and ide_jal <> 'JTRANSFERT'
and dat_ecr between '01/07/2024' and '31/12/2024'
--and (ide_poste like '2%C' or ide_poste = '507')
--and ide_poste in (select ide_poste from piaf_adm.rm_poste where ide_poste_centra = '501C')
group by ide_poste, ide_cpt, spec3, cod_sens

union

select 'CS' cible, a.ide_nd_emet emetteur, a.ide_poste recepteur, b.ide_cpt compte, nvl(decode(cod_sens, 'D',sum(mt),0),0) montant_debit, nvl(decode(cod_sens, 'C',sum(mt),0),0) montant_credit
from fc_ecriture a
left join fc_ligne b on a.ide_poste = b.ide_poste
and a.flg_cptab = b.flg_cptab
and a.ide_gest = b.ide_gest
and a.ide_ecr = b.ide_ecr
and a.ide_jal = b.ide_jal
and a.flg_cptab = 'O'
where a.ide_gest='2024'
and a.ide_jal='JTRANSFERT'
and substr(b.ide_cpt, 1, 3) = '391'
and a.dat_jc <= '30/06/2024'
--and b.dat_ref between '01/01/2023' and '31/05/2023'
and ( regexp_like (substr(libn, -8), '^[0-9]{2}\/[0-9]{2}\/[0-9]{2}$') and  to_date(substr(libn, -8)) between '01/07/2024' and '31/12/2024')
--and (a.ide_poste like '2%C' or a.ide_poste = '507')
--and a.ide_poste in (select ide_poste from piaf_adm.rm_poste where ide_poste_centra = '501C')
group by a.ide_nd_emet, a.ide_poste, b.ide_cpt, cod_sens;

drop table masse_transfert_emis_suiv;

create table masse_transfert_emis_suiv as
select cible, emetteur, recepteur, compte, sum(montant_debit) montant_debit, sum(montant_credit) montant_credit 
from masse_transfert_mois_suivant
where cible = 'ES'
group by cible, emetteur, recepteur, compte
order by 4,2,3,1;

drop table masse_transfert_compta_suiv;

create table masse_transfert_compta_suiv as
select cible, emetteur, recepteur, compte, sum(montant_debit) montant_debit, sum(montant_credit) montant_credit
from masse_transfert_mois_suivant
where cible = 'CS'
group by cible, emetteur, recepteur, compte
order by 4,2,3,1;

drop table masse_trft_suiv;

create table masse_trft_suiv as
select a.cible es_cible, a.emetteur es_emetteur, a.recepteur es_recepteur, a.compte es_compte, a.montant_debit es_montant_debit, b.montant_credit es_montant_credit, 
       b.cible cs_cible, b.emetteur cs_emetteur, b.recepteur cs_recepteur, b.compte cs_compte, b.montant_debit cs_montant_debit, b.montant_credit cs_montant_credit
from masse_transfert_emis_suiv a
full outer join masse_transfert_compta_suiv b on a.emetteur = b.emetteur
and a.recepteur = b.recepteur
and a.compte = b.compte
;

---------------------------------------- FIN -------------------------------------------


drop table masse_trft_bis_sss;

create table masse_trft_bis_sss as
select a_cible a_cible, a_emetteur a_emetteur, a_recepteur a_recepteur, a_compte a_compte, nvl(a_montant_debit, 0) a_montant_debit, nvl(a_montant_credit, 0) a_montant_credit,
       b_cible b_cible, b_emetteur b_emetteur, b_recepteur b_recepteur, b_compte b_compte, nvl(b_montant_debit, 0) b_montant_debit, nvl(b_montant_credit, 0) b_montant_credit,
       c_cible c_cible, c_emetteur c_emetteur, c_recepteur c_recepteur, c_compte c_compte, nvl(c_montant_debit, 0) c_montant_debit, nvl(c_montant_credit, 0) c_montant_credit,
       d_cible d_cible, d_emetteur d_emetteur, d_recepteur d_recepteur, d_compte d_compte, nvl(d_montant_debit, 0) d_montant_debit, nvl(d_montant_credit, 0) d_montant_credit,
       b.cs_cible e_cible, b.cs_emetteur e_emetteur, b.cs_recepteur e_recepteur, b.cs_compte e_compte, nvl(b.cs_montant_debit, 0) e_montant_debit, nvl(b.cs_montant_credit, 0) e_montant_credit
from masse_trft_bis_final a
full outer join masse_trft_suiv b on a_emetteur = b.cs_emetteur
and a_recepteur = b.cs_recepteur
and a_compte = b.cs_compte
;


select a_cible, a_emetteur, a_recepteur, a_compte, nvl(a_montant_debit,0) montant_emis_debit , nvl(a_montant_credit,0) montant_emis_credit,
       b_cible, b_emetteur, b_recepteur, b_compte, nvl(b_montant_debit,0) montant_bonne_periode_debit, nvl(b_montant_debit,0) montant_bonne_periode_credit,
       c_cible, c_emetteur, c_recepteur, c_compte, nvl(c_montant_debit,0) montant_hors_periode_debit, nvl(c_montant_credit,0) montant_hors_periode_credit,
       e_cible, e_emetteur, e_recepteur, e_compte, nvl(e_montant_debit,0) mauvaise_periode_debit, nvl(e_montant_credit,0) mauvaise_periode_credit,
       d_cible, d_emetteur, d_recepteur, d_compte, nvl(d_montant_debit,0) montant_non_denoue_debit, nvl(d_montant_credit,0) montant_non_denoue_credit
from masse_trft_bis_sss
group by a_cible, a_emetteur, a_recepteur, a_compte, a_montant_debit, a_montant_credit, 
      b_cible, b_emetteur, b_recepteur, b_compte, b_montant_debit, b_montant_credit,
      c_cible, c_emetteur, c_recepteur, c_compte, c_montant_debit, c_montant_credit, 
      d_cible, d_emetteur, d_recepteur, d_compte, d_montant_debit, d_montant_credit,
      e_cible, e_emetteur, e_recepteur, e_compte, e_montant_debit, e_montant_credit
--having ((a_montant_debit - b_montant_debit) <> 0 or a_montant_debit is null or b_montant_debit is null)
order by 4,3,1
;

-------------------- TOUS LES COMPTES -------------------------------
drop table tableau_transfert;

create table tableau_transfert as
select nvl(a_recepteur, e_recepteur) destinataire, nvl(a_emetteur, e_emetteur) emetteur, nvl(a_compte, e_compte) compte, 
       nvl(a_montant_debit,0) montant_emis_debit , nvl(a_montant_credit,0) montant_emis_credit,
       nvl(b_montant_debit,0) montant_bonne_periode_debit, nvl(b_montant_credit,0) montant_bonne_periode_credit,
       nvl(c_montant_debit,0) sept_pris_en_octobre_debit, nvl(c_montant_credit,0) sept_pris_en_octobre_credit,
       nvl(e_montant_debit,0) octobre_pris_sept_debit, nvl(e_montant_credit,0) octobre_pris_sept_credit, 
       nvl(d_montant_debit,0) montant_non_denoue_debit, nvl(d_montant_credit,0) montant_non_denoue_credit 
from masse_trft_bis_sss
group by a_cible, a_emetteur, a_recepteur, a_compte, a_montant_debit, a_montant_credit,
      b_cible, b_emetteur, b_recepteur, b_compte, b_montant_debit, b_montant_credit,
      c_cible, c_emetteur, c_recepteur, c_compte, c_montant_debit, c_montant_credit,  
      d_cible, d_emetteur, d_recepteur, d_compte, d_montant_debit, d_montant_credit,
      e_cible, e_emetteur, e_recepteur, e_compte, e_montant_debit, e_montant_credit
--having ((a_montant_debit - b_montant_debit) <> 0 or a_montant_debit is null or b_montant_debit is null)
order by 3,1,2
;


---------------------------------- PRODUCTION TABLEAU -----------------------------------------


select compte, emetteur, montant_emis_debit emis_debit, montant_emis_credit emis_credit, 
       destinataire poste, montant_bonne_periode_debit ok_debit, montant_bonne_periode_credit ok_credit,
       sept_pris_en_octobre_debit non_ok_debit, sept_pris_en_octobre_credit non_ok_credit,
       octobre_pris_sept_debit ok_non_debit, octobre_pris_sept_credit ok_non_credit,
       montant_non_denoue_debit pas_debit, montant_non_denoue_credit pas_credit,
       ((montant_bonne_periode_debit + montant_bonne_periode_credit + sept_pris_en_octobre_debit + sept_pris_en_octobre_credit + montant_non_denoue_debit + montant_non_denoue_credit) 
       - 
       (montant_emis_debit + montant_emis_credit)) anomalie
from tableau_transfert
;

-------------------------------------- 39111 --------------------------------------------------

select compte, emetteur, montant_emis_debit emis_debit, montant_emis_credit emis_credit, 
       destinataire poste, montant_bonne_periode_debit ok_debit, montant_bonne_periode_credit ok_credit,
       sept_pris_en_octobre_debit non_ok_debit, sept_pris_en_octobre_credit non_ok_credit,
       octobre_pris_sept_debit ok_non_debit, octobre_pris_sept_credit ok_non_credit,
       montant_non_denoue_debit pas_debit, montant_non_denoue_credit pas_credit,
       ((montant_bonne_periode_debit + montant_bonne_periode_credit + sept_pris_en_octobre_debit + sept_pris_en_octobre_credit + montant_non_denoue_debit + montant_non_denoue_credit) 
       - 
       (montant_emis_debit + montant_emis_credit)) anomalie
from tableau_transfert
where compte = '39111'
;

-------------------------------------- 39111 PCD ----------------------------------------------

select compte, emetteur, montant_emis_debit emis_debit, montant_emis_credit emis_credit, 
       destinataire poste, montant_bonne_periode_debit ok_debit, montant_bonne_periode_credit ok_credit,
       sept_pris_en_octobre_debit non_ok_debit, sept_pris_en_octobre_credit non_ok_credit,
       octobre_pris_sept_debit ok_non_debit, octobre_pris_sept_credit ok_non_credit,
       montant_non_denoue_debit pas_debit, montant_non_denoue_credit pas_credit,
       ((montant_bonne_periode_debit + montant_bonne_periode_credit + sept_pris_en_octobre_debit + sept_pris_en_octobre_credit + montant_non_denoue_debit + montant_non_denoue_credit) 
       - 
       (montant_emis_debit + montant_emis_credit)) anomalie
from tableau_transfert
where compte = '39111'
and destinataire in (select ide_poste from rm_poste where ide_typ_poste = 'TC')
;

-------------------------------------- 39111 ACCD ----------------------------------------------

select compte, emetteur, montant_emis_debit emis_debit, montant_emis_credit emis_credit, 
       destinataire poste, montant_bonne_periode_debit ok_debit, montant_bonne_periode_credit ok_credit,
       sept_pris_en_octobre_debit non_ok_debit, sept_pris_en_octobre_credit non_ok_credit,
       octobre_pris_sept_debit ok_non_debit, octobre_pris_sept_credit ok_non_credit,
       montant_non_denoue_debit pas_debit, montant_non_denoue_credit pas_credit,
       ((montant_bonne_periode_debit + montant_bonne_periode_credit + sept_pris_en_octobre_debit + sept_pris_en_octobre_credit + montant_non_denoue_debit + montant_non_denoue_credit) 
       - 
       (montant_emis_debit + montant_emis_credit)) anomalie
from tableau_transfert
where compte = '39111'
and destinataire in (select ide_poste from rm_poste where ide_typ_poste in ('AACDC','ACCD'))
;

-------------------------------------- 39111 ACCT ----------------------------------------------

select compte, emetteur, montant_emis_debit emis_debit, montant_emis_credit emis_credit, 
       destinataire poste, montant_bonne_periode_debit ok_debit, montant_bonne_periode_credit ok_credit,
       sept_pris_en_octobre_debit non_ok_debit, sept_pris_en_octobre_credit non_ok_credit,
       octobre_pris_sept_debit ok_non_debit, octobre_pris_sept_credit ok_non_credit,
       montant_non_denoue_debit pas_debit, montant_non_denoue_credit pas_credit,
       ((montant_bonne_periode_debit + montant_bonne_periode_credit + sept_pris_en_octobre_debit + sept_pris_en_octobre_credit + montant_non_denoue_debit + montant_non_denoue_credit) 
       - 
       (montant_emis_debit + montant_emis_credit)) anomalie
from tableau_transfert
where compte = '39111'
and destinataire in (select ide_poste from rm_poste where ide_typ_poste = 'ACCT')
;

-------------------------------------- 39111 PGSP ----------------------------------------------

select compte, emetteur, montant_emis_debit emis_debit, montant_emis_credit emis_credit, 
       destinataire poste, montant_bonne_periode_debit ok_debit, montant_bonne_periode_credit ok_credit,
       sept_pris_en_octobre_debit non_ok_debit, sept_pris_en_octobre_credit non_ok_credit,
       octobre_pris_sept_debit ok_non_debit, octobre_pris_sept_credit ok_non_credit,
       montant_non_denoue_debit pas_debit, montant_non_denoue_credit pas_credit,
       ((montant_bonne_periode_debit + montant_bonne_periode_credit + sept_pris_en_octobre_debit + sept_pris_en_octobre_credit + montant_non_denoue_debit + montant_non_denoue_credit) 
       - 
       (montant_emis_debit + montant_emis_credit)) anomalie
from tableau_transfert
where compte = '39111'
and destinataire in (select ide_poste from rm_poste where ide_typ_poste in ('PGSP', 'PGSPC'))
;

-------------------------------------- 39111 PGAE ----------------------------------------------

select compte, emetteur, montant_emis_debit emis_debit, montant_emis_credit emis_credit, 
       destinataire poste, montant_bonne_periode_debit ok_debit, montant_bonne_periode_credit ok_credit,
       sept_pris_en_octobre_debit non_ok_debit, sept_pris_en_octobre_credit non_ok_credit,
       octobre_pris_sept_debit ok_non_debit, octobre_pris_sept_credit ok_non_credit,
       montant_non_denoue_debit pas_debit, montant_non_denoue_credit pas_credit,
       ((montant_bonne_periode_debit + montant_bonne_periode_credit + sept_pris_en_octobre_debit + sept_pris_en_octobre_credit + montant_non_denoue_debit + montant_non_denoue_credit) 
       - 
       (montant_emis_debit + montant_emis_credit)) anomalie
from tableau_transfert
where compte = '39111'
and destinataire in (select ide_poste from rm_poste where ide_typ_poste = 'PGAE')
;

-------------------------------------- 39111 PGSGAP --------------------------------------------

select compte, emetteur, montant_emis_debit emis_debit, montant_emis_credit emis_credit, 
       destinataire poste, montant_bonne_periode_debit ok_debit, montant_bonne_periode_credit ok_credit,
       sept_pris_en_octobre_debit non_ok_debit, sept_pris_en_octobre_credit non_ok_credit,
       octobre_pris_sept_debit ok_non_debit, octobre_pris_sept_credit ok_non_credit,
       montant_non_denoue_debit pas_debit, montant_non_denoue_credit pas_credit,
       ((montant_bonne_periode_debit + montant_bonne_periode_credit + sept_pris_en_octobre_debit + sept_pris_en_octobre_credit + montant_non_denoue_debit + montant_non_denoue_credit) 
       - 
       (montant_emis_debit + montant_emis_credit)) anomalie
from tableau_transfert
where compte = '39111'
and destinataire in (select ide_poste from rm_poste where ide_typ_poste = 'PGAP')
;

-------------------------------------- 39111 PGENS --------------------------------------------

select compte, emetteur, montant_emis_debit emis_debit, montant_emis_credit emis_credit, 
       destinataire poste, montant_bonne_periode_debit ok_debit, montant_bonne_periode_credit ok_credit,
       sept_pris_en_octobre_debit non_ok_debit, sept_pris_en_octobre_credit non_ok_credit,
       octobre_pris_sept_debit ok_non_debit, octobre_pris_sept_credit ok_non_credit,
       montant_non_denoue_debit pas_debit, montant_non_denoue_credit pas_credit,
       ((montant_bonne_periode_debit + montant_bonne_periode_credit + sept_pris_en_octobre_debit + sept_pris_en_octobre_credit + montant_non_denoue_debit + montant_non_denoue_credit) 
       - 
       (montant_emis_debit + montant_emis_credit)) anomalie
from tableau_transfert
where compte = '39111'
and destinataire in (select ide_poste from rm_poste where ide_typ_poste = 'PGENS')
;

-------------------------------------- 39112  -------------------------------------------------

select compte, emetteur, montant_emis_debit emis_debit, montant_emis_credit emis_credit, 
       destinataire poste, montant_bonne_periode_debit ok_debit, montant_bonne_periode_credit ok_credit,
       sept_pris_en_octobre_debit non_ok_debit, sept_pris_en_octobre_credit non_ok_credit,
       octobre_pris_sept_debit ok_non_debit, octobre_pris_sept_credit ok_non_credit,
       montant_non_denoue_debit pas_debit, montant_non_denoue_credit pas_credit,
       ((montant_bonne_periode_debit + montant_bonne_periode_credit + sept_pris_en_octobre_debit + sept_pris_en_octobre_credit + montant_non_denoue_debit + montant_non_denoue_credit) 
       - 
       (montant_emis_debit + montant_emis_credit)) anomalie
from tableau_transfert
where compte = '39112'
;

-------------------------------------- 39112 PCD ----------------------------------------------

select compte, emetteur, montant_emis_debit emis_debit, montant_emis_credit emis_credit, 
       destinataire poste, montant_bonne_periode_debit ok_debit, montant_bonne_periode_credit ok_credit,
       sept_pris_en_octobre_debit non_ok_debit, sept_pris_en_octobre_credit non_ok_credit,
       octobre_pris_sept_debit ok_non_debit, octobre_pris_sept_credit ok_non_credit,
       montant_non_denoue_debit pas_debit, montant_non_denoue_credit pas_credit,
       ((montant_bonne_periode_debit + montant_bonne_periode_credit + sept_pris_en_octobre_debit + sept_pris_en_octobre_credit + montant_non_denoue_debit + montant_non_denoue_credit) 
       - 
       (montant_emis_debit + montant_emis_credit)) anomalie
from tableau_transfert
where compte = '39112'
and destinataire in (select ide_poste from rm_poste where ide_typ_poste = 'TC')
;

-------------------------------------- 39112 ACCD ----------------------------------------------

select compte, emetteur, montant_emis_debit emis_debit, montant_emis_credit emis_credit, 
       destinataire poste, montant_bonne_periode_debit ok_debit, montant_bonne_periode_credit ok_credit,
       sept_pris_en_octobre_debit non_ok_debit, sept_pris_en_octobre_credit non_ok_credit,
       octobre_pris_sept_debit ok_non_debit, octobre_pris_sept_credit ok_non_credit,
       montant_non_denoue_debit pas_debit, montant_non_denoue_credit pas_credit,
       ((montant_bonne_periode_debit + montant_bonne_periode_credit + sept_pris_en_octobre_debit + sept_pris_en_octobre_credit + montant_non_denoue_debit + montant_non_denoue_credit) 
       - 
       (montant_emis_debit + montant_emis_credit)) anomalie
from tableau_transfert
where compte = '39112'
and destinataire in (select ide_poste from rm_poste where ide_typ_poste in ('AACDC','ACCD'))
;

-------------------------------------- 39112 ACCT ----------------------------------------------

select compte, emetteur, montant_emis_debit emis_debit, montant_emis_credit emis_credit, 
       destinataire poste, montant_bonne_periode_debit ok_debit, montant_bonne_periode_credit ok_credit,
       sept_pris_en_octobre_debit non_ok_debit, sept_pris_en_octobre_credit non_ok_credit,
       octobre_pris_sept_debit ok_non_debit, octobre_pris_sept_credit ok_non_credit,
       montant_non_denoue_debit pas_debit, montant_non_denoue_credit pas_credit,
       ((montant_bonne_periode_debit + montant_bonne_periode_credit + sept_pris_en_octobre_debit + sept_pris_en_octobre_credit + montant_non_denoue_debit + montant_non_denoue_credit) 
       - 
       (montant_emis_debit + montant_emis_credit)) anomalie
from tableau_transfert
where compte = '39112'
and destinataire in (select ide_poste from rm_poste where ide_typ_poste = 'ACCT')
;

-------------------------------------- 39112 PGSP ----------------------------------------------

select compte, emetteur, montant_emis_debit emis_debit, montant_emis_credit emis_credit, 
       destinataire poste, montant_bonne_periode_debit ok_debit, montant_bonne_periode_credit ok_credit,
       sept_pris_en_octobre_debit non_ok_debit, sept_pris_en_octobre_credit non_ok_credit,
       octobre_pris_sept_debit ok_non_debit, octobre_pris_sept_credit ok_non_credit,
       montant_non_denoue_debit pas_debit, montant_non_denoue_credit pas_credit,
       ((montant_bonne_periode_debit + montant_bonne_periode_credit + sept_pris_en_octobre_debit + sept_pris_en_octobre_credit + montant_non_denoue_debit + montant_non_denoue_credit) 
       - 
       (montant_emis_debit + montant_emis_credit)) anomalie
from tableau_transfert
where compte = '39112'
and destinataire in (select ide_poste from rm_poste where ide_typ_poste in ('PGSP', 'PGSPC'))
;

-------------------------------------- 39112 PGAE ----------------------------------------------

select compte, emetteur, montant_emis_debit emis_debit, montant_emis_credit emis_credit, 
       destinataire poste, montant_bonne_periode_debit ok_debit, montant_bonne_periode_credit ok_credit,
       sept_pris_en_octobre_debit non_ok_debit, sept_pris_en_octobre_credit non_ok_credit,
       octobre_pris_sept_debit ok_non_debit, octobre_pris_sept_credit ok_non_credit,
       montant_non_denoue_debit pas_debit, montant_non_denoue_credit pas_credit,
       ((montant_bonne_periode_debit + montant_bonne_periode_credit + sept_pris_en_octobre_debit + sept_pris_en_octobre_credit + montant_non_denoue_debit + montant_non_denoue_credit) 
       - 
       (montant_emis_debit + montant_emis_credit)) anomalie
from tableau_transfert
where compte = '39112'
and destinataire in (select ide_poste from rm_poste where ide_typ_poste = 'PGAE')
;

-------------------------------------- 39112 PGSGAP --------------------------------------------

select compte, emetteur, montant_emis_debit emis_debit, montant_emis_credit emis_credit, 
       destinataire poste, montant_bonne_periode_debit ok_debit, montant_bonne_periode_credit ok_credit,
       sept_pris_en_octobre_debit non_ok_debit, sept_pris_en_octobre_credit non_ok_credit,
       octobre_pris_sept_debit ok_non_debit, octobre_pris_sept_credit ok_non_credit,
       montant_non_denoue_debit pas_debit, montant_non_denoue_credit pas_credit,
       ((montant_bonne_periode_debit + montant_bonne_periode_credit + sept_pris_en_octobre_debit + sept_pris_en_octobre_credit + montant_non_denoue_debit + montant_non_denoue_credit) 
       - 
       (montant_emis_debit + montant_emis_credit)) anomalie
from tableau_transfert
where compte = '39112'
and destinataire in (select ide_poste from rm_poste where ide_typ_poste = 'PGAP')
;

-------------------------------------- 39112 PGENS --------------------------------------------

select compte, emetteur, montant_emis_debit emis_debit, montant_emis_credit emis_credit, 
       destinataire poste, montant_bonne_periode_debit ok_debit, montant_bonne_periode_credit ok_credit,
       sept_pris_en_octobre_debit non_ok_debit, sept_pris_en_octobre_credit non_ok_credit,
       octobre_pris_sept_debit ok_non_debit, octobre_pris_sept_credit ok_non_credit,
       montant_non_denoue_debit pas_debit, montant_non_denoue_credit pas_credit,
       ((montant_bonne_periode_debit + montant_bonne_periode_credit + sept_pris_en_octobre_debit + sept_pris_en_octobre_credit + montant_non_denoue_debit + montant_non_denoue_credit) 
       - 
       (montant_emis_debit + montant_emis_credit)) anomalie
from tableau_transfert
where compte = '39112'
and destinataire in (select ide_poste from rm_poste where ide_typ_poste = 'PGENS')
;

-------------------------------------- 39113  -------------------------------------------------

select compte, emetteur, montant_emis_debit emis_debit, montant_emis_credit emis_credit, 
       destinataire poste, montant_bonne_periode_debit ok_debit, montant_bonne_periode_credit ok_credit,
       sept_pris_en_octobre_debit non_ok_debit, sept_pris_en_octobre_credit non_ok_credit,
       octobre_pris_sept_debit ok_non_debit, octobre_pris_sept_credit ok_non_credit,
       montant_non_denoue_debit pas_debit, montant_non_denoue_credit pas_credit,
       ((montant_bonne_periode_debit + montant_bonne_periode_credit + sept_pris_en_octobre_debit + sept_pris_en_octobre_credit + montant_non_denoue_debit + montant_non_denoue_credit) 
       - 
       (montant_emis_debit + montant_emis_credit)) anomalie
from tableau_transfert
where compte = '39113'
;

-------------------------------------- 391211  -------------------------------------------------

select compte, emetteur, montant_emis_debit emis_debit, montant_emis_credit emis_credit, 
       destinataire poste, montant_bonne_periode_debit ok_debit, montant_bonne_periode_credit ok_credit,
       sept_pris_en_octobre_debit non_ok_debit, sept_pris_en_octobre_credit non_ok_credit,
       octobre_pris_sept_debit ok_non_debit, octobre_pris_sept_credit ok_non_credit,
       montant_non_denoue_debit pas_debit, montant_non_denoue_credit pas_credit,
       ((montant_bonne_periode_debit + montant_bonne_periode_credit + sept_pris_en_octobre_debit + sept_pris_en_octobre_credit + montant_non_denoue_debit + montant_non_denoue_credit) 
       - 
       (montant_emis_debit + montant_emis_credit)) anomalie
from tableau_transfert
where compte = '391211'
;

-------------------------------------- 391212  -------------------------------------------------

select compte, emetteur, montant_emis_debit emis_debit, montant_emis_credit emis_credit, 
       destinataire poste, montant_bonne_periode_debit ok_debit, montant_bonne_periode_credit ok_credit,
       sept_pris_en_octobre_debit non_ok_debit, sept_pris_en_octobre_credit non_ok_credit,
       octobre_pris_sept_debit ok_non_debit, octobre_pris_sept_credit ok_non_credit,
       montant_non_denoue_debit pas_debit, montant_non_denoue_credit pas_credit,
       ((montant_bonne_periode_debit + montant_bonne_periode_credit + sept_pris_en_octobre_debit + sept_pris_en_octobre_credit + montant_non_denoue_debit + montant_non_denoue_credit) 
       - 
       (montant_emis_debit + montant_emis_credit)) anomalie
from tableau_transfert
where compte = '391212'
;

-------------------------------------- 391311  -------------------------------------------------

select compte, emetteur, montant_emis_debit emis_debit, montant_emis_credit emis_credit, 
       destinataire poste, montant_bonne_periode_debit ok_debit, montant_bonne_periode_credit ok_credit,
       sept_pris_en_octobre_debit non_ok_debit, sept_pris_en_octobre_credit non_ok_credit,
       octobre_pris_sept_debit ok_non_debit, octobre_pris_sept_credit ok_non_credit,
       montant_non_denoue_debit pas_debit, montant_non_denoue_credit pas_credit,
       ((montant_bonne_periode_debit + montant_bonne_periode_credit + sept_pris_en_octobre_debit + sept_pris_en_octobre_credit + montant_non_denoue_debit + montant_non_denoue_credit) 
       - 
       (montant_emis_debit + montant_emis_credit)) anomalie
from tableau_transfert
where compte = '391311'
;

-------------------------------------- 391312  -------------------------------------------------

select compte, emetteur, montant_emis_debit emis_debit, montant_emis_credit emis_credit, 
       destinataire poste, montant_bonne_periode_debit ok_debit, montant_bonne_periode_credit ok_credit,
       sept_pris_en_octobre_debit non_ok_debit, sept_pris_en_octobre_credit non_ok_credit,
       octobre_pris_sept_debit ok_non_debit, octobre_pris_sept_credit ok_non_credit,
       montant_non_denoue_debit pas_debit, montant_non_denoue_credit pas_credit,
       ((montant_bonne_periode_debit + montant_bonne_periode_credit + sept_pris_en_octobre_debit + sept_pris_en_octobre_credit + montant_non_denoue_debit + montant_non_denoue_credit) 
       - 
       (montant_emis_debit + montant_emis_credit)) anomalie
from tableau_transfert
where compte = '391312'
;

-------------------------------------- 391322  -------------------------------------------------

select compte, emetteur, montant_emis_debit emis_debit, montant_emis_credit emis_credit, 
       destinataire poste, montant_bonne_periode_debit ok_debit, montant_bonne_periode_credit ok_credit,
       sept_pris_en_octobre_debit non_ok_debit, sept_pris_en_octobre_credit non_ok_credit,
       octobre_pris_sept_debit ok_non_debit, octobre_pris_sept_credit ok_non_credit,
       montant_non_denoue_debit pas_debit, montant_non_denoue_credit pas_credit,
       ((montant_bonne_periode_debit + montant_bonne_periode_credit + sept_pris_en_octobre_debit + sept_pris_en_octobre_credit + montant_non_denoue_debit + montant_non_denoue_credit) 
       - 
       (montant_emis_debit + montant_emis_credit)) anomalie
from tableau_transfert
where compte = '391322'
;


--------------------------------------  ACCD ----------------------------------------------

select compte, emetteur, montant_emis_debit emis_debit, montant_emis_credit emis_credit, 
       destinataire poste, montant_bonne_periode_debit ok_debit, montant_bonne_periode_credit ok_credit,
       sept_pris_en_octobre_debit non_ok_debit, sept_pris_en_octobre_credit non_ok_credit,
       octobre_pris_sept_debit ok_non_debit, octobre_pris_sept_credit ok_non_credit,
       montant_non_denoue_debit pas_debit, montant_non_denoue_credit pas_credit,
       ((montant_bonne_periode_debit + montant_bonne_periode_credit + sept_pris_en_octobre_debit + sept_pris_en_octobre_credit + montant_non_denoue_debit + montant_non_denoue_credit) 
       - 
       (montant_emis_debit + montant_emis_credit)) anomalie
from tableau_transfert
where destinataire in (select ide_poste from rm_poste where ide_typ_poste in ('AACDC','ACCD'))
;


--------------------------------- ACCT -------------------------------------------

select compte, emetteur, montant_emis_debit emis_debit, montant_emis_credit emis_credit, 
       destinataire poste, montant_bonne_periode_debit ok_debit, montant_bonne_periode_credit ok_credit,
       sept_pris_en_octobre_debit non_ok_debit, sept_pris_en_octobre_credit non_ok_credit,
       octobre_pris_sept_debit ok_non_debit, octobre_pris_sept_credit ok_non_credit,
       montant_non_denoue_debit pas_debit, montant_non_denoue_credit pas_credit,
       ((montant_bonne_periode_debit + montant_bonne_periode_credit + sept_pris_en_octobre_debit + sept_pris_en_octobre_credit + montant_non_denoue_debit + montant_non_denoue_credit) 
       - 
       (montant_emis_debit + montant_emis_credit)) anomalie       
from tableau_transfert
where destinataire in (select ide_poste from rm_poste where ide_typ_poste = 'ACCT')
;


------------------------------ ACCD ---------------------------------

select compte, emetteur, montant_emis_debit emis_debit, montant_emis_credit emis_credit, 
       destinataire poste, montant_bonne_periode_debit ok_debit, montant_bonne_periode_credit ok_credit,
       sept_pris_en_octobre_debit non_ok_debit, sept_pris_en_octobre_credit non_ok_credit,
       octobre_pris_sept_debit ok_non_debit, octobre_pris_sept_credit ok_non_credit,
       montant_non_denoue_debit pas_debit, montant_non_denoue_credit pas_credit,
       ((montant_bonne_periode_debit + montant_bonne_periode_credit + sept_pris_en_octobre_debit + sept_pris_en_octobre_credit + montant_non_denoue_debit + montant_non_denoue_credit) 
       - 
       (montant_emis_debit + montant_emis_credit)) anomalie
from tableau_transfert
where destinataire in (select ide_poste from rm_poste where ide_typ_poste in ('AACDC','ACCD'))
;


-------------------------------- UN POSTE DONNE -------------------------------

select compte, emetteur, montant_emis_debit emis_debit, montant_emis_credit emis_credit, 
       destinataire poste, montant_bonne_periode_debit ok_debit, montant_bonne_periode_credit ok_credit,
       sept_pris_en_octobre_debit non_ok_debit, sept_pris_en_octobre_credit non_ok_credit,
       octobre_pris_sept_debit ok_non_debit, octobre_pris_sept_credit ok_non_credit,
       montant_non_denoue_debit pas_debit, montant_non_denoue_credit pas_credit,
       ((montant_bonne_periode_debit + montant_bonne_periode_credit + sept_pris_en_octobre_debit + sept_pris_en_octobre_credit + montant_non_denoue_debit + montant_non_denoue_credit) 
       - 
       (montant_emis_debit + montant_emis_credit)) anomalie
from tableau_transfert
where destinataire = '502'
;