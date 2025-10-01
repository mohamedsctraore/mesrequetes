select b.param, a.code_fin, a.lib_erreur, a.dat_cre, a.uti_cre from b_traitement a, b_paramtrt b
where nomprog='U212_200B'
and a.numtrt=b.numtrt
and a.code_fin in ('D','A','T','L','P')
and b.nomparam in ('P_IDE_POSTE')
and a.dat_cre >= '23/06/2022'
order by a.numtrt desc
;

select * from b_paramtrt
;