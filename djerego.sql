create table fichier_ens_djerego (
matricule varchar2(255),
nom varchar2(255),
prenom varchar(255),
date_paiement date,
parcours varchar2(255),
niveau varchar2(255),
statut varchar2(255),
montant varchar2(255)
);
 
select unique avr from tremoney_djerego
minus
select matricule from fichier_ens_djerego;

select beneficiaire, montant, avr from tremoney_djerego order by 1;
select nom || ' ' || prenom, montant, matricule from fichier_ens_djerego order by 1;


drop table fichier_croise;

create table fichier_croise as
select normalize_text(a.beneficiaire) benef, a.montant, a.avr, normalize_text(b.nom || ' ' || b.prenom) nom, b.montant mt, b.matricule from tremoney_djerego a, fichier_ens_djerego b
where a.avr = b.matricule (+)
order by 1;

create table fichier_reste as
select * from fichier_croise
where length(nom) = 1;


select unique matricule, normalize_text(nom || ' ' || prenom) from fichier_ens_djerego;
select unique avr, normalize_text(beneficiaire) from tremoney_djerego;

select * from fichier_reste where (benef) not In
(
select normalize_text(nom || ' ' || prenom) from fichier_ens_djerego
)
;