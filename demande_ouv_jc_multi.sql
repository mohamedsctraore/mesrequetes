select unique 'exec NIABA.ouvre_jc (''2023'',''02/01/2023'','''||ide_poste||''')'
from rm_poste
where ide_typ_poste not in ('P', 'PC')
and ide_poste not like 'A%' and ide_poste not like 'P%' and ide_poste not like 'R%';

select ide_poste 
from rm_poste
where ide_typ_poste not in ('P', 'PC')
and ide_poste not like 'A%' and ide_poste not like 'P%' and ide_poste not like 'R%'
order by ide_poste;