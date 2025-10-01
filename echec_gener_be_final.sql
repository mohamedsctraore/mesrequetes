alter session set nls_date_format = 'DD/MM/RRRR';
alter session set nls_date_format = 'DD/MM/RRRR HH24:MI:SS';

select a.numtrt, b.param poste, c.libn libelle, a.code_fin, a.lib_erreur observ, a.dat_cre, a.dat_maj, a.uti_cre  from b_traitement a, b_paramtrt b, rm_noeud c
where nomprog='U212_200B'
and a.numtrt=b.numtrt
and b.param = c.ide_nd
--and a.code_fin in ('D','A','T','L','P')
and b.nomparam in ('P_IDE_POSTE')
and a.dat_maj >= '02/01/2025'
--and a.code_fin = 'A'
--and b.param not like '4%'
--and lib_erreur like '%La journée comptable de reprise n%'
order by a.dat_maj desc
;


select b.param, c.libn, a.code_fin, a.lib_erreur, a.dat_cre, a.dat_maj, a.uti_cre from b_traitement a, b_paramtrt b,  rm_noeud c
where nomprog='U212_200B'
and a.numtrt=b.numtrt
and b.param = c.ide_nd
--and a.code_fin in ('D','A','T','L','P')
and a.code_fin in ('L')
and b.nomparam in ('P_IDE_POSTE')
and a.dat_maj >= '03/01/2024'
--and lib_erreur like '%La journée comptable de reprise n%'
order by a.dat_maj desc
;

select b.param, c.libn, a.code_fin, a.lib_erreur, a.dat_cre, a.dat_maj, a.uti_cre from b_traitement a, b_paramtrt b,  rm_noeud c
where nomprog='U212_200B'
and a.numtrt=b.numtrt
and b.param = c.ide_nd
--and a.code_fin in ('D','A','T','L','P')
and a.code_fin in ('T')
and b.nomparam in ('P_IDE_POSTE')
and a.dat_maj >= '21/01/2023'
and b.param in
(
select unique a.ide_poste
from fc_ecriture a
inner join rm_poste b on a.ide_poste = b.ide_poste
where a.ide_gest = '2022'
and ide_typ_poste not in ('P','PC','ACCTC')
)
--and lib_erreur like '%La journée comptable de reprise n%'
order by a.dat_maj desc
;


select b.param, c.libn, a.code_fin, a.lib_erreur, a.dat_cre, a.dat_maj, a.uti_cre from b_traitement a, b_paramtrt b, rm_noeud c
where nomprog='U212_200B'
and a.numtrt=b.numtrt
and b.param = c.ide_nd
--and a.code_fin in ('D','A','T','L','P')
and a.code_fin in ('A')
and b.nomparam in ('P_IDE_POSTE')
and a.dat_maj >= '21/01/2023'
and lib_erreur like '%La journée comptable de reprise n%'
and b.param in
(
select unique a.ide_poste
from fc_ecriture a
inner join rm_poste b on a.ide_poste = b.ide_poste
where a.ide_gest = '2022'
and ide_typ_poste not in ('P','PC','PGI','ACCTC')
)
order by a.dat_maj desc
;


select b.param, c.libn, a.code_fin, a.lib_erreur, a.dat_cre, a.dat_maj, a.uti_cre from b_traitement a, b_paramtrt b, rm_noeud c
where nomprog='U212_200B'
and a.numtrt=b.numtrt
and b.param = c.ide_nd
--and a.code_fin in ('D','A','T','L','P')
and a.code_fin in ('A')
and b.nomparam in ('P_IDE_POSTE')
and a.dat_maj >= '23/01/2023'
and b.param in
(
select unique a.ide_poste
from fc_ecriture a
inner join rm_poste b on a.ide_poste = b.ide_poste
where a.ide_gest = '2022'
--and ide_typ_poste not in ('P','PC','PGI','ACCTC')
)
--and lib_erreur not like '%La journée comptable de reprise n%'
order by a.dat_maj desc
;

--exec NIABA.Verrou_mois_PC('2022','31/12/2022','851C')


select a.numtrt, b.param poste, c.libn libelle, a.code_fin, a.lib_erreur observ, a.dat_cre, a.dat_maj, a.uti_cre  from b_traitement a, b_paramtrt b, rm_noeud c
where a.numtrt=b.numtrt
and b.param = c.ide_nd
and a.code_fin in ('L')
and b.nomparam in ('P_IDE_POSTE')
--and a.dat_maj like '%27/02/2024%'
--and lib_erreur like '%La journée comptable de reprise n%'
order by a.dat_maj desc
;


