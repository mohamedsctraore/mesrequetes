--select * from b_traitement a
update b_traitement a set code_fin = 'P'
--, b_paramtrt b, rm_noeud c
where nomprog='U212_200B'
--and a.numtrt=b.numtrt
--and b.param = c.ide_nd
--and a.code_fin in ('D','A','T','L','P')
and a.code_fin in ('A')
--and b.nomparam in ('P_IDE_POSTE')
and a.dat_maj >= '21/01/2023'
and lib_erreur like '%#E#U212_210B(23/01/2023 11:00:52) : Sens du solde calculé # sens autorisé pour le compte 4751608. =%'
--order by a.dat_maj desc
;