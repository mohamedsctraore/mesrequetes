select distinct ide_typ_poste, ide_cpt 
from fc_ligne a, piaf_adm.rm_poste b 
where a.ide_poste in (select unique ide_poste from fc_ecriture where ide_gest = '2024' and flg_cptab = 'O')
and flg_cptab = 'O' and ide_gest = '2023' and a.ide_poste = b.ide_poste
minus
select ide_typ_poste, ide_cpt from rc_droit_compte
order by ide_typ_poste, ide_cpt;

--------------------------------------------------------------------------------------------------------------------

select unique ide_cpt
from fc_ligne
where ide_gest = '2024'
and flg_cptab = 'O'
and ide_poste = '501'
minus
select ide_cpt
from rc_droit_compte
where ide_typ_poste In (Select Ide_Typ_Poste From Rm_Poste Where Ide_Poste = '501');

--------------------------------------------------------------------------------------------------------------------------------------------


select distinct ide_typ_poste, ide_cpt 
from fc_ligne a, piaf_adm.rm_poste b 
where flg_cptab = 'O' and ide_gest = '2023' and a.ide_poste = b.ide_poste
minus
select ide_typ_poste, ide_cpt from rc_droit_compte
order by ide_typ_poste, ide_cpt;

--------------------------------------------------------------------------------------------------------------------------------------------


select ide_cpt, ide_cpt_be, libn, libl from fn_compte where
ide_cpt in
(
select unique ide_cpt from fc_ligne
where (ide_poste, ide_gest, flg_cptab, ide_jal, ide_ecr) in
(select ide_poste, ide_gest, flg_cptab, ide_jal, ide_ecr
from fc_ecriture where
ide_gest = '2023'
and ide_poste = '926'
and ide_jal = 'T10BISDGI'
and ide_mess = 894
and flg_cptab = 'N'
)

minus 
select ide_cpt from rc_droit_compte
where ide_typ_poste = (select ide_typ_poste from piaf_adm.rm_poste where ide_poste = '926') 
);

