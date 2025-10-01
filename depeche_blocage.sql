select ide_depeche, commentaire, dat_maj
from fm_message
where commentaire is not null
and ide_depeche is not null
--and dat_maj like '%' ||to_char(sysdate) || '%'
order by dat_maj desc;