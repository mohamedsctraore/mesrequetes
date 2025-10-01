(ide_poste, ide_gest, flg_cptab, ide_jal, ide_ecr) in
(select ide_poste, ide_gest, flg_cptab, ide_jal, ide_ecr
from fc_ecriture where
ide_gest = '2022'
and ide_jal not in ('JCENTRAL', 'JTRANSFERT')
and (ide_poste,ide_mess) in 
(
    select ide_nd_emet,ide_mess 
    from fm_message
    where ide_gest='2022'
    and cod_typ_mess=24
    and libl like 'CUT-CONFIRMATION DEPOTS DU %'
)
)
and flg_cptab = 'N'
and ide_jal not in ('JCENTRAL', 'JTRANSFERT', 'JODPGI')
and ide_modele_lig not in ('CREDIT+T', 'DEBIT')