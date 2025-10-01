select unique poste,/*mandat,*/datepec from
    (select a.ead_cde_pc_assi poste,/* a.ead_num_acte mandat, */a.ead_dte_pec datepec from sigta.t_entete_acte_depenses a, t_pec_journees b 
        where a.ead_exe='2021'
        --and ead_cde_pc_assi='501'
        and a.ead_statut not in ('ANN') 
        and ead_dte_pec between '01/08/2021' and '07/09/2021'
        and (b.jrl_dte_cloture is not null and b.jrl_date=a.ead_dte_pec)
        and a.ead_num_acte not in(
        select ide_piece from fb_piece@asterndir where ide_gest='2021' 
        and ide_poste not like '4%'
        --and ide_poste like '%C'
        and dat_cad between '01/08/2021' and '07/09/2021') 
    ) 
order by poste,datepec
;