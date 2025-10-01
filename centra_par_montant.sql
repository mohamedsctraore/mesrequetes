select * from centra_envoye;
select * from centra_recu;

select a.cible, a.ide_poste, a.ide_poste_centra, a.ide_cpt, a.mt, b.cible, b.ide_poste, b.ide_nd_emet, b.ide_cpt, b.mt from centra_envoye a
left join centra_recu b on ide_poste_centra = b.ide_poste
and a.ide_poste = ide_nd_emet
and a.ide_cpt = b.ide_cpt
--inner join fc_calend_hist c on a.dat_ecr = c.dat_jc
group by a.cible, a.ide_poste, a.ide_poste_centra, a.ide_cpt, a.mt, b.cible, b.ide_poste, b.ide_nd_emet, b.ide_cpt, b.mt
--having (a.mt + b.mt) <> 0
--having (abs(a.mt) > abs(b.mt)  or b.mt is null)
having abs(a.mt) < abs(b.mt)
order by ide_poste_centra
;

drop table centra_envoye;

create table centra_envoye as
select 'B' cible, a.ide_poste, ide_poste_centra, ide_cpt, sum(decode(cod_sens, 'C', mt, -mt)) mt
from fc_ligne a, rm_poste b
where a.ide_poste = b.ide_poste
and ide_jal <> 'JCENTRAL'
--and a.dat_maj between '23/04/2023' and '04/05/2023'
--and a.dat_maj >= '23/04/2023'
and substr(ide_cpt, 1, 3) = '390'
and substr(ide_cpt, 1, 5) <> '39031'
and a.flg_cptab = 'O'
and dat_ecr >= '01/04/2023'
group by a.ide_poste, ide_poste_centra, ide_cpt
;

drop table centra_recu;

create table centra_recu as
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
and a.ide_jal='JCENTRAL'
--and a.dat_cre between '23/04/2023' and '04/05/2023'
--and a.dat_cre >= '23/04/2023'
and to_date(substr (libn, -9)) >= '01/04/2023'
group by a.ide_poste, ide_nd_emet, ide_cpt

order by 3, 4, 5
;



---------------------------------------------  VERIFICATION DES MONTANTS REMONTEES PAR POSTE ---------------------------

select 'B' cible, ide_cpt, sum(mt)
from fc_ligne
where ide_gest = '2023'
and ide_poste = '739'
and ide_cpt like '390%'
and ide_cpt not like '390311'
and dat_ecr = '20/04/2023'
and flg_cptab = 'O'
group by ide_cpt

union

select 'C', b.ide_cpt, sum(mt)
from fc_ecriture a
left join fc_ligne b on a.ide_poste = b.ide_poste
and a.flg_cptab = b.flg_cptab
and a.ide_gest = b.ide_gest
and a.ide_ecr = b.ide_ecr
and a.ide_jal = b.ide_jal 
where a.ide_gest='2023'
and a.ide_poste = '607C'
and a.ide_jal='JCENTRAL'
and b.ide_cpt like '390%'
and b.ide_cpt not like '390312'
and a.LIBN like 'Centralisation 739 du 20/04/23'
group by b.ide_cpt

order by 2,1;


------------------------- POINT ECHEC JOURNEE --------------------------

select a.numtrt, b.param, c.libn, a.code_fin, a.lib_erreur, a.dat_cre, a.dat_maj, a.uti_cre from b_traitement a, b_paramtrt b,  rm_noeud c
where nomprog<>'QUOT'
and a.numtrt=b.numtrt
and b.param = c.ide_nd
--and a.code_fin in ('D','A','T','L','P')
and a.code_fin in ('A')
and b.nomparam in ('P_IDE_POSTE')
--and a.dat_maj >= '21/01/2023'
--and lib_erreur like '%Ajout du destinataire au message non effectué%'
--and lib_erreur is not null
and b.param in ('407C')
and a.imprimante is  null
--and a.dat_maj >= '26/04/2023'
order by a.dat_maj desc
;


----------------------  POINT CENTRA ET TRANSFERT QUI SONT REMONTEES ----------------------
select a.ide_poste, c.libn, a.libn, count(a.ide_ecr) nb_ecritures
from fc_ecriture a
left join fc_ligne b on a.ide_poste = b.ide_poste
inner join rm_noeud c on a.ide_poste = c.ide_nd 
and a.flg_cptab = b.flg_cptab
and a.ide_gest = b.ide_gest
and a.ide_ecr = b.ide_ecr
and a.ide_jal = b.ide_jal 
where a.ide_gest='2023'
--and a.ide_poste not like '4%'
and a.ide_jal='JTRANSFERT'
--and a.ide_piece like '3%'
--and b.ide_cpt = '4081'
and a.dat_cre >= '04/05/2023'
group by a.ide_poste, a.libn, c.libn
order by a.ide_poste, to_date(substr (a.libn, -9));

----------------------------- POINT JOURNEE OUVERTE  ----------------------------------------------
select unique c.ide_poste_centra CF, a.ide_poste, b.libn, a.dat_jc
from fc_calend_hist a
inner join rm_noeud b on a.ide_poste = b.ide_nd
inner join rm_poste c on a.ide_poste = c.ide_poste
where cod_ferm = 'O'
order by c.ide_poste_centra, a.ide_poste, dat_jc
;


