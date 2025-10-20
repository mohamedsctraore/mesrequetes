--select * from fm_rnl_me
update fm_rnl_me set cod_statut = 'AN'
where (ide_nd_dest, ide_nd_emet, ide_mess, flg_emis_recu)
in
(
select ide_poste, ide_nd_emet, ide_mess, flg_emis_recu
from fc_ecriture
where ide_gest = '2023'
and (ide_nd_emet, ide_mess) in 
    (
        select ide_nd_emet, ide_mess from fm_message where ide_gest = '2023' and cod_typ_mess = 8 
        --and libl like '%TRANSFERT ORION ASTER DU%'
    )
and ide_poste in (select ide_poste from rm_poste where ide_typ_poste in ('AACCD', 'ACCD'))
and (ide_gest, ide_poste, flg_cptab, ide_ecr, ide_jal)
not in
(
    select ide_gest, ide_poste, flg_cptab, ide_ecr, ide_jal
    from fc_ligne
    where ide_gest = '2023'
    and ide_poste in (select ide_poste from rm_poste where ide_typ_poste in ('AACCD', 'ACCD'))
)
)
and cod_statut not in ('AN','TR')
--order by ide_nd_dest, ide_mess
;

-------------------------------------------  CUT --------------------------------------------------------------

--select * from fc_ecriture
delete from fc_ecriture
where ide_gest = '2025'
and (ide_nd_emet, ide_mess) in 
    (
        select ide_nd_emet, ide_mess from fm_message where ide_gest = '2025' and cod_typ_mess In (8,11,12,24,27)
    )
and (ide_gest, ide_poste, flg_cptab, ide_ecr, ide_jal)
not in
(
    select ide_gest, ide_poste, flg_cptab, ide_ecr, ide_jal
    from fc_ligne
    where ide_gest = '2025'
)
and flg_cptab = 'N'
--and ide_poste = '511'
--and ide_mess in (876539,876538,876537,876535,876533)
;


----------------------------------- JPECDEPBG --------------------------------
select *
from fc_ecriture
where ide_gest = '2023'
and ide_jal = 'JPECDEPBG'
and ide_poste like '5%'
and (ide_gest, ide_poste, flg_cptab, ide_ecr, ide_jal)
not in
(
    select ide_gest, ide_poste, flg_cptab, ide_ecr, ide_jal
    from fc_ligne
    where ide_gest = '2023'
    and ide_jal = 'JPECDEPBG'
    and ide_poste like '5%'
);