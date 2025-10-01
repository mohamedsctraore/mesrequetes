drop table etat_comptabilite;

create table etat_comptabilite as
select a.ide_poste poste, a.etat_cloture etat_cloture_ndir, a.etat_ouvert etat_ouvert_ndir, a.etat_comptabilise etat_comptabilise_ndir, b.etat_cloture etat_cloture_web, b.etat_ouvert etat_ouvert_web, b.etat_comptabilise etat_comptabilise_web 
from e000618.tac_paierie@asterv4 a
left join tac_paierie b
on a.ide_poste = b.ide_poste
order by 1
;

select * from etat_comptabilite;