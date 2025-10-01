SELECT jrl_date, jrl_pct FROM sigta.t_mis_journees
WHERE jrl_dte_cloture IS NOT NULL
AND jrl_date LIKE '%2021'
AND jrl_date NOT IN 
(SELECT rgl_journee FROM piaf_adm.fc_transfert_mer@asterndir WHERE ead_exe='2021') ORDER BY jrl_pct DESC
;

select * from fc_transfert_mer@asterndir;

select unique poste,mandat,datergl from
    (select a.rgl_pct_code poste,a.rgl_ead_num_acte mandat,a.rgl_journee datergl from sigta.t_reglements a, sigta.t_mis_journees b 
        where rgl_pct_code='506'
        and a.rgl_journee between '01/01/2021' and '30/09/2021'
        --and (b.jrl_dte_cloture is not null and b.jrl_date=a.rgl_journee)
        and a.rgl_ead_num_acte not in(
        select ead_num_acte from fc_transfert_mer@asterndir where ead_exe='2021' 
        and rgl_pct_code not like '4%'
        --and ide_poste like '%C'
        and rgl_journee between '01/01/2021' and '30/09/2021') 
    ) 
order by poste,datergl
;