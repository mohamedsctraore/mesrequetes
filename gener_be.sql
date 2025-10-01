exec NIABA.Gener_Demand_Be_Pc_last('2023','29/12/2023','02/01/2024','3010');
exec NIABA.Gener_Demand_Be_Pc_last('2022','31/01/2023','02/01/2023','503');
exec NIABA.Gener_Demand_Be_Pc_last('2021','31/01/2022','02/01/2022','501C');

exec NIABA.Maj_Bgfg_Ord_Cpt_Last('2025','C2020')

select ide_poste, max(dat_jc)
from fc_calend_hist
where ide_gest = '2023'
and ide_poste in
(
    select unique ide_poste
    from fc_ecriture
    where ide_gest = '2023'
    and flg_cptab = 'O'
    and ide_poste in (select ide_poste from rm_poste where ide_typ_poste in ('ACCD','AACCD','AACDC'))
)
group by ide_poste
having max(dat_jc) <> to_date('31/12/2023','DD/MM/RRRR')
order by ide_poste
;

exec NIABA.Gener_Demand_Be_Pc_last('2023','03/01/2024','02/01/2024','632');
exec NIABA.Gener_Demand_Be_Pc_last('2023','31/12/2023','02/01/2024','3019');
exec NIABA.Gener_Demand_Be_Pc_last('2023','31/12/2023','02/01/2024','273');


exec NIABA.Verrou_Finmois_pc('2023','31/12/2023','725');
exec NIABA.Verrou_Finmois_pc('2023','31/12/2023','203C');
exec NIABA.Verrou_Finmois_pc('2023','31/12/2023','218');
exec NIABA.Verrou_Finmois_pc('2023','31/12/2023','218C');



exec NIABA.Gener_Demand_Be_Pc_last('2024','31/12/2024','02/01/2025','504');
exec NIABA.Gener_Demand_Be_Pc_last('2023','31/12/2023','02/01/2024','3080');
exec NIABA.Gener_Demand_Be_Pc_last('2023','31/12/2023','02/01/2024','641');
exec NIABA.Gener_Demand_Be_Pc_last('2023','31/12/2023','02/01/2024','715');
exec NIABA.Gener_Demand_Be_Pc_last('2023','31/12/2023','02/01/2024','704C');
exec NIABA.Gener_Demand_Be_Pc_last('2023','31/12/2023','02/01/2024','621');



select unique 'exec NIABA.Verrou_Finmois_pc ('''||ide_gest||''',''31/12/2024'','''||ide_poste||''')'
from fc_ecriture
where ide_gest='2024'
and flg_cptab = 'O'
;