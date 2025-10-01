--select *  from b_traitement a--, b_paramtrt b
update b_traitement set code_fin = 'P'
where nomprog='U212_200B'
--and a.numtrt=b.numtrt
--and a.code_fin in ('D','A','T','L','P')
and code_fin in ('L')
--and b.nomparam in ('P_IDE_POSTE')
and (dat_maj like '%04/01/23%' or dat_maj like '%05/01/23%')
and numtrt = 3139887;
--and lib_erreur like '%La journée comptable de reprise n%';