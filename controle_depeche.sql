select * from fm_message
where COMMENTAIRE IS NOT NULL
and ide_depeche is not null
and dat_maj like '17/09/%'