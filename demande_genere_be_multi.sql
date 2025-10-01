alter session set nls_date_format = 'DD/MM/RRRR';

select unique 'NIABA.Gener_Demand_Be_Pc_last (''2022'',''31/12/2022'',''02/01/2023'','''||ide_poste||''')'
from rm_poste
where ide_typ_poste not in ('P', 'PC')
and ide_poste not like 'A%' and ide_poste not like 'P%' and ide_poste not like 'R%';
--order by ide_poste;

select unique 'exec NIABA.Gener_Demand_Be_Pc_last (''2022'','''||max(c.dat_jc)||''',''02/01/2023'','''||a.ide_poste||''')'
from be_a_refaire a, rm_poste b, fc_calend_hist c
where a.ide_poste = b.ide_poste
and a.ide_poste = c.ide_poste
and c.ide_gest = '2022'
and b.ide_typ_poste in ('RPI','TDGI','TCDGI','RPD','TDGD','TCDGD','TDGI','TDGD','EPN')
--and b.ide_typ_poste in ('AACCD','AACCDC')
group by a.ide_poste;

select unique 'exec NIABA.Verrou_mois_PC (''2022'',''20/01/2023'','''||a.ide_poste||''')'
from be_a_refaire a, rm_poste b
where a.ide_poste = b.ide_poste
and b.ide_typ_poste not in ('RPI','TDGI','TCDGI','RPD','TDGD','TCDGD','TDGI','TDGD')
;

select unique 'exec NIABA.Gener_cloture_journee_pc ('''||ide_gest||''','''||a.ide_poste||''','''||dat_jc||''')'
from fc_calend_hist a
inner join rm_poste b on a.ide_poste = b.ide_poste
where ide_gest = '2022'
and cod_ferm = 'O'
--and dat_jc <= '31/07/2022'
--and a.ide_poste  like '2%'
and ide_typ_poste not in ('P','PC','ACCTC','RPI','TDGI','TCDGI','RPD','TDGD','TCDGD','TDGI','TDGD');

drop table be_a_refaire;
drop table be_a_faire;

create table be_a_refaire as
select ide_poste,ide_cpt from ctl_bs_be 
where ide_poste not like '4%'
group by ide_poste,ide_cpt having sum(decode(cible,'BS',mt,-mt))<>0
order by ide_poste,ide_cpt;

select unique a.ide_poste
from be_a_refaire a, rm_poste b
where a.ide_poste = b.ide_poste
and b.ide_typ_poste not in ('RPI','TDGI','TCDGI','RPD','TDGD','TCDGD','TDGI','TDGD','P','PC','ACCTC');

create table be_a_faire as
select ide_poste,ide_cpt from ctl_bs_be 
where ide_poste not like '4%'
and ide_poste not in
(
select unique ide_poste
from fc_calend_hist
where ide_gest = '2022'
and ide_poste not like '4%'
and cod_ferm <> 'C'
)
group by ide_poste,ide_cpt having sum(decode(cible,'BS',mt,-mt))<>0
order by ide_poste,ide_cpt;


create table be_a_refaire as
select unique ide_poste from be_a_faire;
--exec NIABA.Verrou_mois_PC('2022','20/01/2023','')