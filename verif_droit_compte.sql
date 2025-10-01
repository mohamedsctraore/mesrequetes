select unique ide_cpt
from fc_ligne
where ide_gest='2021'
and ide_poste='503'
and flg_cptab='O'
and ide_cpt not in 
(
select ide_cpt
from rc_droit_compte
where ide_typ_poste='PGAE'
);

select ide_cpt
from rc_droit_compte
where ide_typ_poste='PGAE';

select *
from fc_ligne
where ide_gest='2021'
and ide_poste='503'
and ide_cpt in (2310,2620,626146);

select * from fc_ecriture
where ide_gest='2021'
and ide_poste='503'
and ide_jal='JPECDEPBG'
and ide_ecr=19001;

select *
from fn_compte
where ide_cpt='262';