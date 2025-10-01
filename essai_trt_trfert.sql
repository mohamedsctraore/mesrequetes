drop table tfert;

create table tfert as
select 'E' cible, ide_poste emetteur, spec3 recepteur, ide_cpt compte, sum(mt) montant, cod_sens
from fc_ligne
where ide_cpt like '391%'
and flg_cptab = 'O'
and ide_gest = '2023'
--and spec3 is not null
and ide_jal <> 'JTRANSFERT'
and dat_ecr < '01/03/2023'
--and ide_poste in (select ide_poste from piaf_adm.rm_poste where ide_poste_centra = '501C')
group by ide_poste, ide_cpt, spec3, cod_sens

union

select 'R' cible, a.ide_nd_emet emetteur, a.ide_poste recepteur, b.ide_cpt compte, sum(mt) montant, cod_sens
from fc_ecriture a
left join fc_ligne b on a.ide_poste = b.ide_poste
and a.flg_cptab = b.flg_cptab
and a.ide_gest = b.ide_gest
and a.ide_ecr = b.ide_ecr
and a.ide_jal = b.ide_jal
and a.flg_cptab = 'O'
where a.ide_gest='2023'
and a.ide_jal='JTRANSFERT'
and b.ide_cpt like '391%'
and b.dat_ecr < '01/03/2023'
--and a.ide_poste in (select ide_poste from piaf_adm.rm_poste where ide_poste_centra = '501C')
group by a.ide_nd_emet, a.ide_poste, b.ide_cpt, cod_sens
;

drop table tfert_2;

create table tfert_2 as
select 'Transfert envoyé du ' clb, emetteur, ' vers le poste ' frm,  recepteur distinataire, compte, montant mt_envoye, 0 mt_recu, cod_sens
from tfert
--where emetteur = '503'
where cible = 'E'
union 
select 'Transfert recu du ' clb, emetteur, ' par le poste ' frm , recepteur distinataire , compte, 0 mt_envoye, montant mt_recu, cod_sens
from tfert
--where emetteur = '503'
where cible = 'R'
order by emetteur;

select * from tfert_2 order by emetteur, (mt_envoye + mt_recu);

drop table tfert_envoye;

create table tfert_envoye as
select 'Transfert envoyé par le poste ' clb, emetteur, ' à destination du poste ' frm,  recepteur distinataire, compte, montant mt_envoye, 0 mt_recu, cod_sens
from tfert
--where emetteur = '503'
where cible = 'E';

drop table tfert_recu;

create table tfert_recu as
select 'Transfert en provenance du poste ' clb, emetteur, 'comptabilisé par le poste ' frm , recepteur distinataire , compte, 0 mt_envoye, montant mt_recu, cod_sens
from tfert
--where emetteur = '212C'
where cible = 'R'
order by emetteur;

select a.clb, a.emetteur poste , a.frm, a.distinataire poste, a.compte, a.mt_envoye, a.cod_sens, b.clb, b.emetteur poste, b.frm, b.distinataire poste, b.compte, b.mt_recu, b.cod_sens from tfert_envoye a, tfert_recu b
where a.emetteur = b.emetteur
and a.distinataire = b.distinataire
and a.compte = b.compte
group by a.clb, a.emetteur,a.frm, a.distinataire, a.compte, b.clb, b.emetteur, b.frm, b.distinataire, b.compte, a.mt_envoye , b.mt_recu, a.cod_sens, b.cod_sens
having (a.mt_envoye - b.mt_recu) <> 0
order by a.compte, b.distinataire
;



select 'E' cible, ide_poste emetteur, spec3 recepteur, ide_cpt compte, mt montant, observ, cod_sens
from fc_ligne
where ide_cpt like '391%'
and flg_cptab = 'O'
and ide_gest = '2022'
and ide_poste = '663C'
and spec3 = '501'
--and spec3 is not null
and ide_jal <> 'JTRANSFERT'
--and dat_ecr < '01/03/2022'
--and ide_poste in (select ide_poste from piaf_adm.rm_poste where ide_poste_centra = '501C')
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
where a.ide_gest='2022'
and a.ide_jal='JTRANSFERT'
and b.ide_cpt like '391%'
--and b.dat_ecr < '01/03/2022'
and a.ide_poste = '501'
and a.ide_nd_emet = '663C'
--and a.ide_poste in (select ide_poste from piaf_adm.rm_poste where ide_poste_centra = '501C')
--group by a.ide_nd_emet, a.ide_poste, b.ide_cpt, cod_sens
order by observ,montant, 1
;