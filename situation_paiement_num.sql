select rgl_num, rgl_montant_net 
from cut_reglement where pc_code='644' 
and rgl_dte_reglement between '01/01/2023' and '18/10/2023' and  RGL_STATUT  in ('V','S') and rgl_mrg_code='01' and (Rgl_Code_Op not like '%ctualisation%%'  or Rgl_Code_Op is null)

minus

select ide_piece, mt from fc_ligne@asterndir a, fc_ecriture@asterndir b 
where 
a.ide_poste = b.ide_poste
and a.ide_gest = b.ide_gest
and a.ide_jal = b.ide_jal
and a.flg_cptab = b.flg_cptab
and a.ide_ecr = b.ide_ecr
and (a.ide_poste,a.ide_gest,a.ide_jal,a.flg_cptab,a.ide_ecr) in (
select ide_poste,ide_gest,ide_jal,flg_cptab,ide_ecr from fc_ecriture@asterndir where (ide_poste,ide_gest,ide_jal,flg_cptab,ide_ecr) in (select ide_poste,ide_gest,ide_jal,flg_cptab,ide_ecr from fc_ecriture@asterndir where (flg_emis_recu,cod_typ_nd,ide_nd_emet,ide_mess) in 
                            (select flg_emis_recu,cod_typ_nd,ide_nd_emet,ide_mess from fm_message@asterndir where 
                            COD_TYP_MESS = 24 
                            and libl  like 'CUT%PAIEMENT%NUMERAIRE%DU%%'
                            and ide_nd_emet ='644' 
                            ) ))
and dat_ref between '01/01/2023' and '18/10/2023'
and cod_sens = 'C'
;