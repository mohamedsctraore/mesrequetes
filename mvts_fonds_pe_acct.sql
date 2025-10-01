drop table mvts_fonds_acp_rgf;

CREATE TABLE mvts_fonds_acp_rgf as

select 'E' cible, ide_poste emetteur, ide_tiers recepteur, ide_cpt compte, nvl(sum(mt),0) montant
from fc_ligne
where ide_cpt = '581122'
and flg_cptab = 'O'
and ide_gest = '2025'
--and spec3 is not null
--and ide_jal <> 'JTRANSFERT'
and dat_ecr between '01/01/2025' and '31/08/2025'
and cod_sens = 'D'
--and ide_poste in (select ide_poste from piaf_adm.rm_poste where ide_poste_centra = '501C')
group by ide_poste, ide_cpt, ide_tiers

union

select 'R' cible, ide_tiers emetteur, ide_poste recepteur, ide_cpt compte, nvl(sum(mt),0) montant
from fc_ligne
where ide_cpt = '581122'
and flg_cptab = 'O'
and ide_gest = '2025'
--and spec3 is not null
--and ide_jal <> 'JTRANSFERT'
and dat_ecr between '01/01/2025' and '31/08/2025'
and cod_sens = 'C'
--and ide_poste in (select ide_poste from piaf_adm.rm_poste where ide_poste_centra = '501C')
group by ide_poste, ide_cpt, ide_tiers
;

--drop table mvts_fonds_acp_rgf;
--
--create table mvts_fonds_acp_rgf as
--select REPLACE(ide_poste_centra, '501C', ide_poste) from mvts_fonds_acp_rgf;

select * from mvts_fonds_acp_rgf
;

update mvts_fonds_acp_rgf
set recepteur = substr(recepteur,3,5)
where recepteur like 'PE%';

update mvts_fonds_acp_rgf
set emetteur = substr(emetteur,3,5)
where emetteur like 'PE%';

update mvts_fonds_acp_rgf
set emetteur = '501'
where emetteur like '5%';

drop table mvts_fonds_acp_rgf_maj;

create table mvts_fonds_acp_rgf_maj as
select cible, emetteur, recepteur, compte, sum(montant) montant
from mvts_fonds_acp_rgf
group by cible, emetteur, recepteur, compte;


select * from mvts_fonds_acp_rgf_maj;

drop table mvts_fonds_acp_rgf_emis;

create table mvts_fonds_acp_rgf_emis as
select * from mvts_fonds_acp_rgf_maj
where cible = 'E'
order by 2,3,4,1;

drop table mvts_fonds_acp_rgf_recu;

create table mvts_fonds_acp_rgf_recu as
select * from mvts_fonds_acp_rgf_maj
where cible = 'R'
order by 2,3,4,1;

drop table mvts_fonds_acp_rgf_trft;


create table mvts_fonds_acp_rgf_trft as
select a.cible a_cible, a.emetteur a_emetteur, a.recepteur a_recepteur, a.compte a_compte, a.montant a_montant, 
       b.cible b_cible, b.emetteur b_emetteur, b.recepteur b_recepteur, b.compte b_compte, b.montant b_montant from mvts_fonds_acp_rgf_emis a
full outer join mvts_fonds_acp_rgf_recu b
on a.emetteur = b.emetteur
and a.recepteur = b.recepteur
and a.compte = b.compte;

drop table mvts_grp_1;

create table mvts_grp_1 as
select a_cible, a_emetteur, a_recepteur, a_compte, a_montant, 
       b_cible, b_emetteur, b_recepteur, libn, b_compte, b_montant from mvts_fonds_acp_rgf_trft
       left join rm_noeud on b_recepteur = ide_nd
group by a_cible, a_emetteur, a_recepteur, a_compte, a_montant, 
      b_cible, b_emetteur, b_recepteur, libn, b_compte, b_montant
having ((a_montant - b_montant) <> 0 or a_montant is null or b_montant is null)
--having (a_montant - b_montant) = 0
order by 4,2,3
;

select a_cible, a_emetteur, a_recepteur, a_compte, b_cible, b_emetteur, b_recepteur, libn, b_compte, sum(a_montant) a_montant, sum(b_montant) b_montant
from mvts_grp_1
group by a_cible, a_emetteur, a_recepteur, a_compte, b_cible, b_emetteur, b_recepteur, libn, b_compte
order by 3,3;




















drop table mvts_fonds_acp_rgf;

create table mvts_fonds_acp_rgf as

SELECT UNIQUE a.ide_poste,c.libn POSTE, '502' ide_tiers, d.ide_poste_centra, a.ide_cpt, b.libn,a.cod_sens, SUM(a.mt) DEBIT, 0 CREDIT 
FROM fc_ligne a, fn_compte b, rm_noeud c, rm_poste d
WHERE a.ide_cpt=b.ide_cpt
AND a.ide_poste=c.ide_nd 
AND a.ide_poste=d.ide_poste
AND c.ide_nd=d.ide_poste
AND a.ide_cpt in
(
'581122'
)

AND a.cod_sens='D'
AND a.flg_cptab='O'
AND a.ide_gest='2023'
--AND a.ide_poste in (SELECT ide_poste FROM rm_poste WHERE ide_poste_centra='510C' or ide_poste='510C')
AND dat_ecr <= '31/05/2023' --BETWEEN '01/01/2022' AND '31/12/2022'
GROUP BY a.ide_poste,c.libn, a.ide_cpt, b.libn,a.cod_sens,d.ide_poste_centra, a.ide_tiers
UNION
SELECT UNIQUE a.ide_poste,c.libn POSTE, a.ide_tiers, d.ide_poste_centra, a.ide_cpt, b.libn,a.cod_sens, 0 DEBIT, SUM(a.mt) CREDIT
FROM fc_ligne a, fn_compte b, rm_noeud c, rm_poste d
WHERE a.ide_cpt=b.ide_cpt
AND a.ide_poste=c.ide_nd 
AND a.ide_poste=d.ide_poste
AND c.ide_nd=d.ide_poste
AND a.ide_cpt in
(
'581122'
)
AND a.cod_sens='C'
AND a.flg_cptab='O'
AND a.ide_gest='2023'
--AND a.ide_poste in (SELECT ide_poste FROM rm_poste WHERE ide_poste_centra='510C' or ide_poste='510C')
AND dat_ecr <= '31/05/2023'-- BETWEEN '01/01/2022' AND '31/12/2022'
GROUP BY a.ide_poste,c.libn, a.ide_cpt, b.libn,a.cod_sens,d.ide_poste_centra, a.ide_tiers
;


select * from mvts_fonds_acp_rgf;