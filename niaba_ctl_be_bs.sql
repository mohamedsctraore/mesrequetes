drop table ctl_bs_be;

create table ctl_bs_be as
select 'BS' cible,ide_poste,ide_cpt,sum(decode(cod_sens,NIABA.ASTER_get_COD_SENS (ide_poste,ide_cpt),mt,-mt)) mt 
from fc_ligne 
where ide_gest='2024'
and flg_cptab='O' 
and ide_cpt in (select ide_cpt from fn_compte where cod_typ_be='P')
--and ide_poste in (select unique ide_poste from be_a_gener)
--and ide_poste in ('721')
--and ide_poste not like '4%'
--and ide_poste in (select ide_poste from rm_poste where ide_poste_centra in ('510C'))
group by ide_poste,ide_cpt
having sum(decode(cod_sens,'C',mt,-mt)) <> 0
union
select 'BE',ide_poste,ide_cpt,sum(decode(cod_sens,NIABA.ASTER_get_COD_SENS (ide_poste,ide_cpt),mt,-mt)) 
from fc_ligne 
where ide_gest='2025' 
and ide_jal='TREP' 
and ide_cpt in (select ide_cpt from fn_compte where cod_typ_be='P')
--and ide_poste in (select unique ide_poste from be_a_gener)
--and ide_poste in ('721')
--and ide_poste in (select ide_poste from rm_poste where ide_poste_centra in ('510C'))
--and ide_poste not like '4%'
group by ide_poste,ide_cpt
order by 2,3,1;

drop table poste_be;

create table poste_be as
select ide_poste,ide_cpt from ctl_bs_be 
--where ide_poste not like '3%'
group by ide_poste,ide_cpt having sum(decode(cible,'BS',mt,-mt))<>0
order by ide_poste,ide_cpt;

select ide_poste, ide_cpt, sum(decode(cible,'BS',mt,-mt))
from ctl_bs_be
--where Ide_Poste In 
--(Select Ide_Poste from Rm_Poste where Ide_Typ_Poste In ('P','PC'))
group by ide_poste,ide_cpt
HAVING sum(decode(cible,'BS',mt,-mt)) <> 0
order by ide_poste, ide_cpt;

select unique ide_poste
from poste_be
order by ide_poste;

drop table be_a_reprendre;

create table be_a_reprendre as
select unique ide_poste from poste_be
;

Select * from be_a_reprendre
--Where Ide_Poste in (Select Ide_Poste from Rm_Poste where Ide_Typ_Poste In ('P','PC'))
--Where Ide_Poste In 
--(
--Select Ide_Poste From Rm_Poste Where Ide_Typ_Poste = 'TCDGD' 
--Union 
--Select Ide_Poste From Rm_Poste Where Ide_Poste_Centra In (Select Ide_Poste From Rm_Poste Where ide_Typ_poste in('TCDGD'))
--)
order by 1;

Select unique 'exec NIABA.Gener_cloture_journee_pc_bis ('''||ide_gest||''','''||dat_jc||''','''||ide_poste||''')'
from fc_calend_hist
where ide_gest = '2024'
and cod_ferm = 'O'
and dat_jc <= '31/01/2025'
and ide_poste in (select ide_poste from be_a_reprendre)
--and Ide_Poste In  (Select Ide_Poste from Rm_Poste where Ide_Typ_Poste In ('P','PC'))
--and ide_poste in ('3019','630','691')
--and to_char(dat_maj, 'dd/mm/yyyy') <> '16/09/2024'
;