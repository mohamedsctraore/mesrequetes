select ide_nd, libn, libc, dat_jc, cod_ferm, b.dat_maj, b.uti_maj
from mohamed_agence_accd a
inner join fc_calend_hist b on a.ide_nd = b.ide_poste
and b.ide_gest = '2022'
and dat_jc = '30/04/2022';