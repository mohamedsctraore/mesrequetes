select distinct b.NOM, b.PRENOM, a.ide_util, a.ide_profil, a.ide_poste, c.libn, d.libn, a.dat_dval, a.dat_fval, b.DAT_PWD, b.pwd 
from fh_ut_pu a, fh_util b, fh_profil_util c, rm_noeud d
where a.ide_util=b.ide_util
and  a.ide_poste=d.ide_nd
and c.ide_profil=a.IDE_PROFIL
and a.ide_util in
(
   select ide_util from fh_util where cod_util in ('B343580')
)
order by a.ide_poste
;

update fh_util set pwd='.', dat_pwd=ADD_MONTHS(sysdate,-4)
where cod_util='N309002';

alter user N309002 identified by a;

select * from fh_util where cod_util='H253314';