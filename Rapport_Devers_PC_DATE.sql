/*<TOAD_FILE_CHUNK>*/
set heading OFF
--set feedback OFF
SET VERIFY OFF

define poste=&Code_pc
define date_reglement=&date_paiement

alter session set nls_date_format = 'DD/MM/YYYY';
/
/*<TOAD_FILE_CHUNK>*/
spool c:\Sygacut\Rapport_devesr_x.xls

select '00-ASTER-NUM',count(*),sum(mt) from fc_ligne@asterndir 
where (ide_poste,ide_gest,ide_jal,flg_cptab,ide_ecr) in (
select ide_poste,ide_gest,ide_jal,flg_cptab,ide_ecr from fc_ecriture@asterndir where (ide_poste,ide_gest,ide_jal,flg_cptab,ide_ecr) in (select ide_poste,ide_gest,ide_jal,flg_cptab,ide_ecr from fc_ecriture@asterndir where (flg_emis_recu,cod_typ_nd,ide_nd_emet,ide_mess) in 
                            (select flg_emis_recu,cod_typ_nd,ide_nd_emet,ide_mess from fm_message@asterndir where 
                            COD_TYP_MESS = 24 
                            and libl  like 'CUT%PAIEMENT%NUMERAIRE%DU%&&date_paiement%'
                            and ide_nd_emet ='&&poste' 
                            ) ))
group by cod_sens
union
select '00-SYG-NUM',count(*),sum(rgl_montant_net) from cut_reglement where pc_code='&&poste' and rgl_dte_reglement like '%&&date_paiement%' and  RGL_STATUT  in ('V','S') and rgl_mrg_code='01'
union
select '01-ASTER-VIR',count(*),sum(mt) from fc_ligne@asterndir 
where (ide_poste,ide_gest,ide_jal,flg_cptab,ide_ecr) in (
select ide_poste,ide_gest,ide_jal,flg_cptab,ide_ecr from fc_ecriture@asterndir where (ide_poste,ide_gest,ide_jal,flg_cptab,ide_ecr) in (select ide_poste,ide_gest,ide_jal,flg_cptab,ide_ecr from fc_ecriture@asterndir where (flg_emis_recu,cod_typ_nd,ide_nd_emet,ide_mess) in 
                            (select flg_emis_recu,cod_typ_nd,ide_nd_emet,ide_mess from fm_message@asterndir where 
                            COD_TYP_MESS = 24 
                            and libl  like 'CUT%PAIEMENT%EF%DU%&&date_paiement%'
                            and ide_nd_emet ='&&poste' 
                            ))) and substr(ide_cpt,1,2)='57'
group by cod_sens
union
select '01-SYG-VIR',count(*),sum(rgl_montant_net) from cut_reglement where pc_code='&&poste' and rgl_dte_reglement like '%&&date_paiement%' and  RGL_STATUT  in ('V','P','R') and rgl_mrg_code='02' and rgl_regul_num is null
union
select '02-ASTER-CUT-REGUL DE REJET',count(*),sum(mt) from fc_ligne@asterndir 
where (ide_poste,ide_gest,ide_jal,flg_cptab,ide_ecr) in (
select ide_poste,ide_gest,ide_jal,flg_cptab,ide_ecr from fc_ecriture@asterndir where (ide_poste,ide_gest,ide_jal,flg_cptab,ide_ecr) in (select ide_poste,ide_gest,ide_jal,flg_cptab,ide_ecr from fc_ecriture@asterndir where (flg_emis_recu,cod_typ_nd,ide_nd_emet,ide_mess) in 
                            (select flg_emis_recu,cod_typ_nd,ide_nd_emet,ide_mess from fm_message@asterndir where 
                            COD_TYP_MESS = 24 
                            and libl  like 'CUT-REGUL DE REJET VIREMENT DU%&&date_paiement%'
                            and ide_nd_emet ='&&poste' 
                            ) ))
group by cod_sens
union
select '02-SYG-CUT-REGUL DE REJET',count(*),sum(rgl_montant_net) from cut_reglement where pc_code='&&poste' and rgl_dte_reglement like '%&&date_paiement%' and  RGL_STATUT  in ('V','P','R') and rgl_mrg_code='02' and rgl_regul_num is not null
union
select '03-RET',count(*),sum(ret_montant) from cut_retenue where (RET_RGL_NUM,ret_mdt_num)  in (select mer_rgl_num,rgl_mdt_num from cut_reglement where pc_code='&&poste' and rgl_dte_reglement like '%&&date_paiement%' and rgl_statut in ('V','P','R'))
union
select '03-ASTER-RET',count(*),sum(mt) from fc_ligne@asterndir 
where (ide_poste,ide_gest,ide_jal,flg_cptab,ide_ecr) in (
select ide_poste,ide_gest,ide_jal,flg_cptab,ide_ecr from fc_ecriture@asterndir where (ide_poste,ide_gest,ide_jal,flg_cptab,ide_ecr) in (select ide_poste,ide_gest,ide_jal,flg_cptab,ide_ecr from fc_ecriture@asterndir where (flg_emis_recu,cod_typ_nd,ide_nd_emet,ide_mess) in 
                            (select flg_emis_recu,cod_typ_nd,ide_nd_emet,ide_mess from fm_message@asterndir where 
                            COD_TYP_MESS = 24 
                            and libl  like 'CUT-PAIEMENT EFFECTIF DU%&&date_paiement%'
                            and ide_nd_emet ='&&poste' 
                            ) )) 
                            and (ide_cpt like '390302%' or ide_cpt='391311' and spec3 like '%C' or spec3='502')
group by cod_sens
union
select '04-OPP',count(*),sum(opp_montant) from cut_opposition where opp_RGL_NUM  in (select mer_rgl_num from cut_reglement where pc_code='&&poste' and rgl_dte_reglement like '%&&date_paiement%' and rgl_statut in ('V','P','R'))
union
select '04-ASTER-OPP',count(*),sum(mt) from fc_ligne@asterndir 
where (ide_poste,ide_gest,ide_jal,flg_cptab,ide_ecr) in (
select ide_poste,ide_gest,ide_jal,flg_cptab,ide_ecr from fc_ecriture@asterndir where (ide_poste,ide_gest,ide_jal,flg_cptab,ide_ecr) in (select ide_poste,ide_gest,ide_jal,flg_cptab,ide_ecr from fc_ecriture@asterndir where (flg_emis_recu,cod_typ_nd,ide_nd_emet,ide_mess) in 
                            (select flg_emis_recu,cod_typ_nd,ide_nd_emet,ide_mess from fm_message@asterndir where 
                            COD_TYP_MESS = 24 
                            and libl  like 'CUT-PAIEMENT EFFECTIF DU%&&date_paiement%'
                            and ide_nd_emet ='&&poste' 
                            ) )) 
                            and (ide_cpt ='39051')
group by cod_sens
union
select '05-CONFIRM-CHQ',count(*),sum(CHQ_montant) from cut_cheque_tresor where chq_pc_code='&&poste' and chq_dte_confirm like '%&&date_paiement%' and chq_statut in ('P')
union
select '05-ASTER-CONFIRM-CHQ',count(*),sum(mt) from fc_ligne@asterndir 
where (ide_poste,ide_gest,ide_jal,flg_cptab,ide_ecr) in (
select ide_poste,ide_gest,ide_jal,flg_cptab,ide_ecr from fc_ecriture@asterndir where (ide_poste,ide_gest,ide_jal,flg_cptab,ide_ecr) in (select ide_poste,ide_gest,ide_jal,flg_cptab,ide_ecr from fc_ecriture@asterndir where (flg_emis_recu,cod_typ_nd,ide_nd_emet,ide_mess) in 
                            (select flg_emis_recu,cod_typ_nd,ide_nd_emet,ide_mess from fm_message@asterndir where 
                            COD_TYP_MESS = 24 
                            and libl  like 'CUT-CONFIRMATION DEPOTS DU %&&date_paiement%'
                            and ide_nd_emet ='&&poste' 
                            ) ))
group by cod_sens
union
select '06-ASTER-CHQ DE COUV NUMERAIRE DU',count(*),sum(mt) from fc_ligne@asterndir 
where (ide_poste,ide_gest,ide_jal,flg_cptab,ide_ecr) in (
select ide_poste,ide_gest,ide_jal,flg_cptab,ide_ecr from fc_ecriture@asterndir where (ide_poste,ide_gest,ide_jal,flg_cptab,ide_ecr) in (select ide_poste,ide_gest,ide_jal,flg_cptab,ide_ecr from fc_ecriture@asterndir where (flg_emis_recu,cod_typ_nd,ide_nd_emet,ide_mess) in 
                            (select flg_emis_recu,cod_typ_nd,ide_nd_emet,ide_mess from fm_message@asterndir where 
                            COD_TYP_MESS = 24 
                            and libl  like 'CUT-CHQ DE COUV NUMERAIRE DU%&&date_paiement%'
                            and ide_nd_emet ='&&poste' 
                            )))
group by cod_sens
union
select '06-ASTER-CUT-RETOUR DE FDS REJET VIREMENT DU',count(*),sum(mt) from fc_ligne@asterndir 
where (ide_poste,ide_gest,ide_jal,flg_cptab,ide_ecr) in (
select ide_poste,ide_gest,ide_jal,flg_cptab,ide_ecr from fc_ecriture@asterndir where (ide_poste,ide_gest,ide_jal,flg_cptab,ide_ecr) in (select ide_poste,ide_gest,ide_jal,flg_cptab,ide_ecr from fc_ecriture@asterndir where (flg_emis_recu,cod_typ_nd,ide_nd_emet,ide_mess) in 
                            (select flg_emis_recu,cod_typ_nd,ide_nd_emet,ide_mess from fm_message@asterndir where 
                            COD_TYP_MESS = 24 
                            and libl  like 'CUT-RETOUR DE FDS REJET VIREMENT DU%&&date_paiement%'
                            and ide_nd_emet ='&&poste' 
                            ) ))
group by cod_sens
union
select '06-SYG-RETOUR DE FDS',count(*),sum(rgl_montant_net) from cut_reglement where pc_code='&&poste' and cut.CUT_FB_DATE_REJET (rgl_num) like '%&&date_paiement%' and  RGL_STATUT  in ('R') and rgl_mrg_code='02'
union
select '07-ASTER-CUT-CONFIRMATION DE DEBIT DU',count(*),sum(mt) from fc_ligne@asterndir 
where (ide_poste,ide_gest,ide_jal,flg_cptab,ide_ecr) in (
select ide_poste,ide_gest,ide_jal,flg_cptab,ide_ecr from fc_ecriture@asterndir where (ide_poste,ide_gest,ide_jal,flg_cptab,ide_ecr) in (select ide_poste,ide_gest,ide_jal,flg_cptab,ide_ecr from fc_ecriture@asterndir where (flg_emis_recu,cod_typ_nd,ide_nd_emet,ide_mess) in 
                            (select flg_emis_recu,cod_typ_nd,ide_nd_emet,ide_mess from fm_message@asterndir where 
                            COD_TYP_MESS = 24 
                            and libl  like 'CUT-CONFIRMATION DE DEBIT DU%&&date_paiement%'
                            and ide_nd_emet ='&&poste' 
                            )))
group by cod_sens;


 spool off
