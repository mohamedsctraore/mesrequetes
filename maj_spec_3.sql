--1--
--select * from fc_ligne
update fc_ligne set ide_tiers = '501'
--update fc_ligne set ide_cpt = '39030399', spec1='39111',spec2='47012106',spec3='501', ide_modele_lig='DEBIT+3SPEC'
where (ide_poste,ide_gest,ide_jal,flg_cptab,ide_ecr)
in (select ide_poste, ide_gest,ide_jal,flg_cptab,ide_ecr
from fc_ecriture where 
ide_gest in ('2023')
--and ide_poste in ('3044')
and ide_mess in (select ide_mess from fm_message where cod_typ_mess = 24 and libl like '%CONF%')
)
and flg_cptab = 'N'
and ide_cpt = '58112103'
--and ide_cpt = '47512235'
and ide_tiers is null
--and ide_ecr between 363 and 364
;

------------------  COMPTE 531123 ---------------------------------

--select * from fc_ligne
update fc_ligne set ide_cpt = '531122'
--update fc_ligne set ide_cpt = '39030399', spec1='39111',spec2='47012106',spec3='501', ide_modele_lig='DEBIT+3SPEC'
where (ide_poste,ide_gest,ide_jal,flg_cptab,ide_ecr)
in (select ide_poste, ide_gest,ide_jal,flg_cptab,ide_ecr
from fc_ecriture where 
ide_gest in ('2023')
--and ide_poste in ('3044')
and ide_mess in (select ide_mess from fm_message where cod_typ_mess = 24 and libl like '%NUMERAIRE%')
)
and flg_cptab = 'N'
and ide_cpt = '531123'
--and ide_cpt = '47512235'
--and ide_ecr between 363 and 364
;

------------------  COMPTE 531123 ---------------------------------

--select * from fc_ligne
update fc_ligne set ide_cpt = '531122'
--update fc_ligne set ide_cpt = '39030399', spec1='39111',spec2='47012106',spec3='501', ide_modele_lig='DEBIT+3SPEC'
where (ide_poste,ide_gest,ide_jal,flg_cptab,ide_ecr)
in (select ide_poste, ide_gest,ide_jal,flg_cptab,ide_ecr
from fc_ecriture where 
ide_gest in ('2023')
--and ide_poste in ('3044')
and ide_mess in (select ide_mess from fm_message where cod_typ_mess = 24 )
)
and flg_cptab = 'N'
and ide_cpt = '531123'
--and ide_cpt = '47512235'
--and ide_ecr between 363 and 364
;

---------------  CEI  --------------------------
--select * from fc_ligne
update fc_ligne set ide_tiers = 'CEI'
--update fc_ligne set ide_cpt = '39030399', spec1='39111',spec2='47012106',spec3='501', ide_modele_lig='DEBIT+3SPEC'
where (ide_poste,ide_gest,ide_jal,flg_cptab,ide_ecr)
in (select ide_poste, ide_gest,ide_jal,flg_cptab,ide_ecr
from fc_ecriture where 
ide_gest in ('2023')
--and ide_poste in ('3044')
and ide_mess in (select ide_mess from fm_message where cod_typ_mess = 24 and libl like '%NUMERAIRE%')
)
and flg_cptab = 'N'
and ide_cpt = '47512235'
and ide_tiers is null
--and ide_ecr between 363 and 364
;

------------------------ MAJ TIERS PC 645 6450001 -----------------------------------

--select * from fc_ligne
update fc_ligne set ide_tiers = 'REGIE AVIP'
--update fc_ligne set ide_cpt = '39030399', spec1='39111',spec2='47012106',spec3='501', ide_modele_lig='DEBIT+3SPEC'
where (ide_poste,ide_gest,ide_jal,flg_cptab,ide_ecr)
in (select ide_poste, ide_gest,ide_jal,flg_cptab,ide_ecr
from fc_ecriture where 
ide_gest in ('2023')
and ide_poste in ('645')
and ide_mess in (select ide_mess from fm_message where cod_typ_mess = 24 and libl like '%NUMERAIRE%')
)
and flg_cptab = 'N'
and ide_cpt in ('44811','44812','44813','44814')
and ide_tiers = '645001'
--and ide_ecr between 363 and 364
;

------------------------ MAJ TIERS PC 645 6450001 -----------------------------------

--select * from fc_ligne
update fc_ligne set ide_tiers = 'FAJ'
--update fc_ligne set ide_cpt = '39030399', spec1='39111',spec2='47012106',spec3='501', ide_modele_lig='DEBIT+3SPEC'
where (ide_poste,ide_gest,ide_jal,flg_cptab,ide_ecr)
in (select ide_poste, ide_gest,ide_jal,flg_cptab,ide_ecr
from fc_ecriture where 
ide_gest in ('2023')
and ide_poste in ('645')
and ide_mess in (select ide_mess from fm_message where cod_typ_mess = 24 and libl like '%NUMERAIRE%')
)
and flg_cptab = 'N'
and ide_cpt = '44816'
and ide_tiers = '645001'
--and ide_ecr between 363 and 364
;

------------------------ MAJ TIERS PC 645 6450001 -----------------------------------

--select * from fc_ligne
update fc_ligne set ide_tiers = 'PMI TIASSALE'
--update fc_ligne set ide_cpt = '39030399', spec1='39111',spec2='47012106',spec3='501', ide_modele_lig='DEBIT+3SPEC'
where (ide_poste,ide_gest,ide_jal,flg_cptab,ide_ecr)
in (select ide_poste, ide_gest,ide_jal,flg_cptab,ide_ecr
from fc_ecriture where 
ide_gest in ('2023')
and ide_poste in ('645')
and ide_mess in (select ide_mess from fm_message where cod_typ_mess = 24 and libl like '%NUMERAIRE%')
)
and flg_cptab = 'N'
and ide_cpt = '44801'
and ide_tiers = '243299R'
--and ide_ecr between 363 and 364
;

------------------------ MAJ TIERS PC 645 6450001 -----------------------------------

--select * from fc_ligne
update fc_ligne set ide_tiers = 'CSU AFFIKRO'
--update fc_ligne set ide_cpt = '39030399', spec1='39111',spec2='47012106',spec3='501', ide_modele_lig='DEBIT+3SPEC'
where (ide_poste,ide_gest,ide_jal,flg_cptab,ide_ecr)
in (select ide_poste, ide_gest,ide_jal,flg_cptab,ide_ecr
from fc_ecriture where 
ide_gest in ('2023')
and ide_poste in ('645')
and ide_mess in (select ide_mess from fm_message where cod_typ_mess = 24 and libl like '%NUMERAIRE%')
)
and flg_cptab = 'N'
and ide_cpt = '44801'
and ide_tiers = '645015'
--and ide_ecr between 363 and 364
;

------------------------ MAJ TIERS PC 645 6450001 -----------------------------------

--select * from fc_ligne
update fc_ligne set ide_tiers = 'REGIE AVFJ'
--update fc_ligne set ide_cpt = '39030399', spec1='39111',spec2='47012106',spec3='501', ide_modele_lig='DEBIT+3SPEC'
where (ide_poste,ide_gest,ide_jal,flg_cptab,ide_ecr)
in (select ide_poste, ide_gest,ide_jal,flg_cptab,ide_ecr
from fc_ecriture where 
ide_gest in ('2023')
and ide_poste in ('645')
and ide_mess in (select ide_mess from fm_message where cod_typ_mess = 24 and libl like '%NUMERAIRE%')
)
and flg_cptab = 'N'
and ide_cpt = '44809'
and ide_tiers = '645001'
--and ide_ecr between 363 and 364
;

------------------------ MAJ TIERS PC 645 6450001 -----------------------------------

--select * from fc_ligne
update fc_ligne set ide_tiers = 'REGIE CCGC'
--update fc_ligne set ide_cpt = '39030399', spec1='39111',spec2='47012106',spec3='501', ide_modele_lig='DEBIT+3SPEC'
where (ide_poste,ide_gest,ide_jal,flg_cptab,ide_ecr)
in (select ide_poste, ide_gest,ide_jal,flg_cptab,ide_ecr
from fc_ecriture where 
ide_gest in ('2023')
and ide_poste in ('645')
and ide_mess in (select ide_mess from fm_message where cod_typ_mess = 24 and libl like '%NUMERAIRE%')
)
and flg_cptab = 'N'
and ide_cpt = '44817'
and ide_tiers = '645001'
--and ide_ecr between 363 and 364
;

------------------------ MAJ TIERS PC 645 6450001 -----------------------------------

--select * from fc_ligne
update fc_ligne set ide_tiers = 'CSU NZIANOUA'
--update fc_ligne set ide_cpt = '39030399', spec1='39111',spec2='47012106',spec3='501', ide_modele_lig='DEBIT+3SPEC'
where (ide_poste,ide_gest,ide_jal,flg_cptab,ide_ecr)
in (select ide_poste, ide_gest,ide_jal,flg_cptab,ide_ecr
from fc_ecriture where 
ide_gest in ('2023')
and ide_poste in ('645')
and ide_mess in (select ide_mess from fm_message where cod_typ_mess = 24 and libl like '%NUMERAIRE%')
)
and flg_cptab = 'N'
and ide_cpt = '44801'
and ide_tiers = '645007'
--and ide_ecr between 363 and 364
;

------------------------ MAJ TIERS PC 645 6450002 -----------------------------------

--select * from fc_ligne
update fc_ligne set ide_tiers = 'HG TIASSALE'
--update fc_ligne set ide_cpt = '39030399', spec1='39111',spec2='47012106',spec3='501', ide_modele_lig='DEBIT+3SPEC'
where (ide_poste,ide_gest,ide_jal,flg_cptab,ide_ecr)
in (select ide_poste, ide_gest,ide_jal,flg_cptab,ide_ecr
from fc_ecriture where 
ide_gest in ('2023')
and ide_poste in ('645')
and ide_mess in (select ide_mess from fm_message where cod_typ_mess = 24 and libl like '%NUMERAIRE%')
)
and flg_cptab = 'N'
and ide_cpt = '44801'
and ide_tiers = '645002'
--and ide_ecr between 363 and 364
;

------------------------ MAJ TIERS PC 645 6450004 -----------------------------------

--select * from fc_ligne
update fc_ligne set ide_tiers = 'CSU NDOUCI'
--update fc_ligne set ide_cpt = '39030399', spec1='39111',spec2='47012106',spec3='501', ide_modele_lig='DEBIT+3SPEC'
where (ide_poste,ide_gest,ide_jal,flg_cptab,ide_ecr)
in (select ide_poste, ide_gest,ide_jal,flg_cptab,ide_ecr
from fc_ecriture where 
ide_gest in ('2023')
and ide_poste in ('645')
and ide_mess in (select ide_mess from fm_message where cod_typ_mess = 24 and libl like '%NUMERAIRE%')
)
and flg_cptab = 'N'
and ide_cpt = '44801'
and ide_tiers = '645004'
--and ide_ecr between 363 and 364
;

------------------------ MAJ TIERS PC 649 649-1 -----------------------------------
update fc_ligne set ide_tiers = 'HG TOUMODI'
--update fc_ligne set ide_cpt = '39030399', spec1='39111',spec2='47012106',spec3='501', ide_modele_lig='DEBIT+3SPEC'
where (ide_poste,ide_gest,ide_jal,flg_cptab,ide_ecr)
in (select ide_poste, ide_gest,ide_jal,flg_cptab,ide_ecr
from fc_ecriture where 
ide_gest in ('2023')
and ide_poste in ('649')
and ide_mess in (select ide_mess from fm_message where cod_typ_mess = 24 and libl like '%NUMERAIRE%')
)
and flg_cptab = 'N'
and ide_cpt = '44801'
and ide_tiers = '649-1'
--and ide_ecr between 363 and 364
;

------------------------ MAJ TIERS PC 649 649-2 -----------------------------------
update fc_ligne set ide_tiers = 'HG DJEKANOU'
--update fc_ligne set ide_cpt = '39030399', spec1='39111',spec2='47012106',spec3='501', ide_modele_lig='DEBIT+3SPEC'
where (ide_poste,ide_gest,ide_jal,flg_cptab,ide_ecr)
in (select ide_poste, ide_gest,ide_jal,flg_cptab,ide_ecr
from fc_ecriture where 
ide_gest in ('2023')
and ide_poste in ('649')
and ide_mess in (select ide_mess from fm_message where cod_typ_mess = 24 and libl like '%NUMERAIRE%')
)
and flg_cptab = 'N'
and ide_cpt = '44801'
and ide_tiers = '649-2'
--and ide_ecr between 363 and 364
;

------------------------ MAJ TIERS PC 649 649-3 -----------------------------------
update fc_ligne set ide_tiers = 'CSU KPOUEBO'
--update fc_ligne set ide_cpt = '39030399', spec1='39111',spec2='47012106',spec3='501', ide_modele_lig='DEBIT+3SPEC'
where (ide_poste,ide_gest,ide_jal,flg_cptab,ide_ecr)
in (select ide_poste, ide_gest,ide_jal,flg_cptab,ide_ecr
from fc_ecriture where 
ide_gest in ('2023')
and ide_poste in ('649')
and ide_mess in (select ide_mess from fm_message where cod_typ_mess = 24 and libl like '%NUMERAIRE%')
)
and flg_cptab = 'N'
and ide_cpt = '44801'
and ide_tiers = '649-3'
--and ide_ecr between 363 and 364
;

------------------------ MAJ TIERS PC 668 000 -----------------------------------
update fc_ligne set ide_tiers = 'HG'
--update fc_ligne set ide_cpt = '39030399', spec1='39111',spec2='47012106',spec3='501', ide_modele_lig='DEBIT+3SPEC'
where (ide_poste,ide_gest,ide_jal,flg_cptab,ide_ecr)
in (select ide_poste, ide_gest,ide_jal,flg_cptab,ide_ecr
from fc_ecriture where 
ide_gest in ('2023')
and ide_poste in ('668')
and ide_mess in (select ide_mess from fm_message where cod_typ_mess = 24 and libl like '%NUMERAIRE%')
)
and flg_cptab = 'N'
and ide_cpt = '44801'
and uti_maj <> 'E000618'
--and ide_tiers = '649-3'
--and ide_ecr between 363 and 364
;


------------------------ MAJ TIERS PC 621 CSU -----------------------------------
--update fc_ligne set ide_tiers = 'CSU'
----update fc_ligne set ide_cpt = '39030399', spec1='39111',spec2='47012106',spec3='501', ide_modele_lig='DEBIT+3SPEC'
--where (ide_poste,ide_gest,ide_jal,flg_cptab,ide_ecr)
--in (select ide_poste, ide_gest,ide_jal,flg_cptab,ide_ecr
--from fc_ecriture where 
--ide_gest in ('2023')
--and ide_poste in ('621')
--and ide_mess in (select ide_mess from fm_message where cod_typ_mess = 24 and libl like '%NUMERAIRE%')
--)
--and flg_cptab = 'N'
--and ide_cpt = '44801'
--and ide_tiers = '649-3'
--and ide_ecr between 363 and 364
--;

------------------------ MAJ TIERS PC 621 CSU -----------------------------------
update fc_ligne set ide_tiers = null, var_tiers = null
--update fc_ligne set ide_cpt = '39030399', spec1='39111',spec2='47012106',spec3='501', ide_modele_lig='DEBIT+3SPEC'
where (ide_poste,ide_gest,ide_jal,flg_cptab,ide_ecr)
in (select ide_poste, ide_gest,ide_jal,flg_cptab,ide_ecr
from fc_ecriture where 
ide_gest in ('2023')
--and ide_poste in ('621')
and ide_mess in (select ide_mess from fm_message where cod_typ_mess = 24)
)
and flg_cptab = 'N'
and ide_cpt = '448032'
and ide_tiers is not null
--and ide_ecr between 363 and 364
;

------------------------ MAJ TIERS PC 731 BRIGADE GENDARMERIE -----------------------------------
update fc_ligne set ide_tiers = 'BRIG GEND TAABO'
--update fc_ligne set ide_cpt = '39030399', spec1='39111',spec2='47012106',spec3='501', ide_modele_lig='DEBIT+3SPEC'
where (ide_poste,ide_gest,ide_jal,flg_cptab,ide_ecr)
in (select ide_poste, ide_gest,ide_jal,flg_cptab,ide_ecr
from fc_ecriture where 
ide_gest in ('2023')
and ide_poste in ('731')
and ide_mess in (select ide_mess from fm_message where cod_typ_mess = 24 and libl like '%NUMERAIRE%')
)
and flg_cptab = 'N'
and ide_cpt = '44899'
and uti_maj <> 'E000618'
--and ide_tiers = '649-3'
--and ide_ecr between 363 and 364
;


------------------------ MAJ TIERS PC 639 SUR 44811, 44812, 44813, 44814 -----------------------------------
update fc_ligne set ide_tiers = 'REGIE AVIP'
--update fc_ligne set ide_cpt = '39030399', spec1='39111',spec2='47012106',spec3='501', ide_modele_lig='DEBIT+3SPEC'
where (ide_poste,ide_gest,ide_jal,flg_cptab,ide_ecr)
in (select ide_poste, ide_gest,ide_jal,flg_cptab,ide_ecr
from fc_ecriture where 
ide_gest in ('2023')
and ide_poste in ('639')
and ide_mess in (select ide_mess from fm_message where cod_typ_mess = 24 and libl like '%NUMERAIRE%')
)
and flg_cptab = 'N'
and ide_cpt in ('44811','44812','44813','44814')
and ide_tiers = '63906'
--and ide_ecr between 363 and 364
;

------------------------ MAJ TIERS PC 626 SUR 44811, 44812, 44813, 44814 -----------------------------------
update fc_ligne set ide_tiers = 'REGIE AVIP'
--update fc_ligne set ide_cpt = '39030399', spec1='39111',spec2='47012106',spec3='501', ide_modele_lig='DEBIT+3SPEC'
where (ide_poste,ide_gest,ide_jal,flg_cptab,ide_ecr)
in (select ide_poste, ide_gest,ide_jal,flg_cptab,ide_ecr
from fc_ecriture where 
ide_gest in ('2023')
and ide_poste in ('626')
and ide_mess in (select ide_mess from fm_message where cod_typ_mess = 24 and libl like '%NUMERAIRE%')
)
and flg_cptab = 'N'
and ide_cpt in ('44811','44812','44813','44814')
and ide_tiers = '626JUSTICE'
--and ide_ecr between 363 and 364
;

------------------------ MAJ TIERS PC 622 SUR 44811, 44812, 44813, 44814 -----------------------------------
update fc_ligne set ide_tiers = 'REGIE AVIP'
--update fc_ligne set ide_cpt = '39030399', spec1='39111',spec2='47012106',spec3='501', ide_modele_lig='DEBIT+3SPEC'
where (ide_poste,ide_gest,ide_jal,flg_cptab,ide_ecr)
in (select ide_poste, ide_gest,ide_jal,flg_cptab,ide_ecr
from fc_ecriture where 
ide_gest in ('2023')
and ide_poste in ('622')
and ide_mess in (select ide_mess from fm_message where cod_typ_mess = 24 and libl like '%NUMERAIRE%')
)
and flg_cptab = 'N'
and ide_cpt in ('44811','44812','44813','44814')
and ide_tiers = '622-02'
--and ide_ecr between 363 and 364
;

------------------------ MAJ TIERS PC 639 SUR 44816-----------------------------------
update fc_ligne set ide_tiers = 'FAJ'
--update fc_ligne set ide_cpt = '39030399', spec1='39111',spec2='47012106',spec3='501', ide_modele_lig='DEBIT+3SPEC'
where (ide_poste,ide_gest,ide_jal,flg_cptab,ide_ecr)
in (select ide_poste, ide_gest,ide_jal,flg_cptab,ide_ecr
from fc_ecriture where 
ide_gest in ('2023')
and ide_poste in ('639')
and ide_mess in (select ide_mess from fm_message where cod_typ_mess = 24 and libl like '%NUMERAIRE%')
)
and flg_cptab = 'N'
and ide_cpt = '44816'
and ide_tiers = '63906'
--and ide_ecr between 363 and 364
;

------------------------ MAJ TIERS PC 626 SUR 44816-----------------------------------
update fc_ligne set ide_tiers = 'FAJ'
--update fc_ligne set ide_cpt = '39030399', spec1='39111',spec2='47012106',spec3='501', ide_modele_lig='DEBIT+3SPEC'
where (ide_poste,ide_gest,ide_jal,flg_cptab,ide_ecr)
in (select ide_poste, ide_gest,ide_jal,flg_cptab,ide_ecr
from fc_ecriture where 
ide_gest in ('2023')
and ide_poste in ('626')
and ide_mess in (select ide_mess from fm_message where cod_typ_mess = 24 and libl like '%NUMERAIRE%')
)
and flg_cptab = 'N'
and ide_cpt = '44816'
and ide_tiers = '626JUSTICE'
--and ide_ecr between 363 and 364
;

------------------------ MAJ TIERS PC 626 SUR 44816-----------------------------------
update fc_ligne set ide_tiers = 'FAJ'
--update fc_ligne set ide_cpt = '39030399', spec1='39111',spec2='47012106',spec3='501', ide_modele_lig='DEBIT+3SPEC'
where (ide_poste,ide_gest,ide_jal,flg_cptab,ide_ecr)
in (select ide_poste, ide_gest,ide_jal,flg_cptab,ide_ecr
from fc_ecriture where 
ide_gest in ('2023')
and ide_poste in ('622')
and ide_mess in (select ide_mess from fm_message where cod_typ_mess = 24 and libl like '%NUMERAIRE%')
)
and flg_cptab = 'N'
and ide_cpt = '44816'
and ide_tiers = '622-02'
--and ide_ecr between 363 and 364
;

------------------------ MAJ TIERS PC 639 SUR 44809-----------------------------------
update fc_ligne set ide_tiers = 'REGIE AVFJ'
--update fc_ligne set ide_cpt = '39030399', spec1='39111',spec2='47012106',spec3='501', ide_modele_lig='DEBIT+3SPEC'
where (ide_poste,ide_gest,ide_jal,flg_cptab,ide_ecr)
in (select ide_poste, ide_gest,ide_jal,flg_cptab,ide_ecr
from fc_ecriture where 
ide_gest in ('2023')
and ide_poste in ('639')
and ide_mess in (select ide_mess from fm_message where cod_typ_mess = 24 and libl like '%NUMERAIRE%')
)
and flg_cptab = 'N'
and ide_cpt = '44809'
and ide_tiers = '63906'
--and ide_ecr between 363 and 364
;

------------------------ MAJ TIERS PC 626 SUR 44809-----------------------------------
update fc_ligne set ide_tiers = 'REGIE AVFJ'
--update fc_ligne set ide_cpt = '39030399', spec1='39111',spec2='47012106',spec3='501', ide_modele_lig='DEBIT+3SPEC'
where (ide_poste,ide_gest,ide_jal,flg_cptab,ide_ecr)
in (select ide_poste, ide_gest,ide_jal,flg_cptab,ide_ecr
from fc_ecriture where 
ide_gest in ('2023')
and ide_poste in ('626')
and ide_mess in (select ide_mess from fm_message where cod_typ_mess = 24 and libl like '%NUMERAIRE%')
)
and flg_cptab = 'N'
and ide_cpt = '44809'
and ide_tiers = '626JUSTICE'
--and ide_ecr between 363 and 364
;

------------------------ MAJ TIERS PC 622 SUR 44809-----------------------------------
update fc_ligne set ide_tiers = 'REGIE AVFJ'
--update fc_ligne set ide_cpt = '39030399', spec1='39111',spec2='47012106',spec3='501', ide_modele_lig='DEBIT+3SPEC'
where (ide_poste,ide_gest,ide_jal,flg_cptab,ide_ecr)
in (select ide_poste, ide_gest,ide_jal,flg_cptab,ide_ecr
from fc_ecriture where 
ide_gest in ('2023')
and ide_poste in ('622')
and ide_mess in (select ide_mess from fm_message where cod_typ_mess = 24 and libl like '%NUMERAIRE%')
)
and flg_cptab = 'N'
and ide_cpt = '44809'
and ide_tiers = '622-02'
--and ide_ecr between 363 and 364
;

------------------------ MAJ TIERS PC 639 SUR 44817-----------------------------------
update fc_ligne set ide_tiers = 'REGIE CCGC'
--update fc_ligne set ide_cpt = '39030399', spec1='39111',spec2='47012106',spec3='501', ide_modele_lig='DEBIT+3SPEC'
where (ide_poste,ide_gest,ide_jal,flg_cptab,ide_ecr)
in (select ide_poste, ide_gest,ide_jal,flg_cptab,ide_ecr
from fc_ecriture where 
ide_gest in ('2023')
and ide_poste in ('639')
and ide_mess in (select ide_mess from fm_message where cod_typ_mess = 24 and libl like '%NUMERAIRE%')
)
and flg_cptab = 'N'
and ide_cpt = '44817'
and ide_tiers = '63906'
--and ide_ecr between 363 and 364
;

------------------------ MAJ TIERS PC 626 SUR 44817-----------------------------------
update fc_ligne set ide_tiers = 'REGIE CCGC'
--update fc_ligne set ide_cpt = '39030399', spec1='39111',spec2='47012106',spec3='501', ide_modele_lig='DEBIT+3SPEC'
where (ide_poste,ide_gest,ide_jal,flg_cptab,ide_ecr)
in (select ide_poste, ide_gest,ide_jal,flg_cptab,ide_ecr
from fc_ecriture where 
ide_gest in ('2023')
and ide_poste in ('626')
and ide_mess in (select ide_mess from fm_message where cod_typ_mess = 24 and libl like '%NUMERAIRE%')
)
and flg_cptab = 'N'
and ide_cpt = '44817'
and ide_tiers = '626JUSTICE'
--and ide_ecr between 363 and 364
;

------------------------ MAJ TIERS PC 622 SUR 44817-----------------------------------
update fc_ligne set ide_tiers = 'REGIE CCGC'
--update fc_ligne set ide_cpt = '39030399', spec1='39111',spec2='47012106',spec3='501', ide_modele_lig='DEBIT+3SPEC'
where (ide_poste,ide_gest,ide_jal,flg_cptab,ide_ecr)
in (select ide_poste, ide_gest,ide_jal,flg_cptab,ide_ecr
from fc_ecriture where 
ide_gest in ('2023')
and ide_poste in ('626')
and ide_mess in (select ide_mess from fm_message where cod_typ_mess = 24 and libl like '%NUMERAIRE%')
)
and flg_cptab = 'N'
and ide_cpt = '44817'
and ide_tiers = '622-02'
--and ide_ecr between 363 and 364
;

------------------------ MAJ TIERS PC 639 SUR 44801-----------------------------------
update fc_ligne set ide_tiers = 'CSU DABOUYO'
--update fc_ligne set ide_cpt = '39030399', spec1='39111',spec2='47012106',spec3='501', ide_modele_lig='DEBIT+3SPEC'
where (ide_poste,ide_gest,ide_jal,flg_cptab,ide_ecr)
in (select ide_poste, ide_gest,ide_jal,flg_cptab,ide_ecr
from fc_ecriture where 
ide_gest in ('2023')
and ide_poste in ('639')
and ide_mess in (select ide_mess from fm_message where cod_typ_mess = 24 and libl like '%NUMERAIRE%')
)
and flg_cptab = 'N'
and ide_cpt = '44801'
and ide_tiers = '1153'
--and ide_ecr between 363 and 364
;

------------------------ MAJ TIERS PC 639 SUR 44801-----------------------------------
update fc_ligne set ide_tiers = 'HG'
--update fc_ligne set ide_cpt = '39030399', spec1='39111',spec2='47012106',spec3='501', ide_modele_lig='DEBIT+3SPEC'
where (ide_poste,ide_gest,ide_jal,flg_cptab,ide_ecr)
in (select ide_poste, ide_gest,ide_jal,flg_cptab,ide_ecr
from fc_ecriture where 
ide_gest in ('2023')
and ide_poste in ('639')
and ide_mess in (select ide_mess from fm_message where cod_typ_mess = 24 and libl like '%NUMERAIRE%')
)
and flg_cptab = 'N'
and ide_cpt = '44801'
and ide_tiers = '63901'
--and ide_ecr between 363 and 364
;

------------------------ MAJ TIERS PC 622 SUR 44801 A VERIFIER LUNDI 23110606220001 -----------------------------------
update fc_ligne set ide_tiers = 'CHR'
--update fc_ligne set ide_cpt = '39030399', spec1='39111',spec2='47012106',spec3='501', ide_modele_lig='DEBIT+3SPEC'
where (ide_poste,ide_gest,ide_jal,flg_cptab,ide_ecr)
in (select ide_poste, ide_gest,ide_jal,flg_cptab,ide_ecr
from fc_ecriture where 
ide_gest in ('2023')
and ide_poste in ('622')
and ide_mess in (select ide_mess from fm_message where cod_typ_mess = 24 and libl like '%NUMERAIRE%')
)
and flg_cptab = 'N'
and ide_cpt = '44801'
and ide_tiers = '622-02'
--and ide_ecr between 363 and 364
;

------------------------ MAJ TIERS PC 725 SUR 44801-----------------------------------
update fc_ligne set ide_tiers = 'CSU'
--update fc_ligne set ide_cpt = '39030399', spec1='39111',spec2='47012106',spec3='501', ide_modele_lig='DEBIT+3SPEC'
where (ide_poste,ide_gest,ide_jal,flg_cptab,ide_ecr)
in (select ide_poste, ide_gest,ide_jal,flg_cptab,ide_ecr
from fc_ecriture where 
ide_gest in ('2023')
and ide_poste in ('725')
and ide_mess in (select ide_mess from fm_message where cod_typ_mess = 24 and libl like '%NUMERAIRE%')
)
and flg_cptab = 'N'
and ide_cpt = '44801'
and ide_tiers = '0627'
--and ide_ecr between 363 and 364
;

------------------------ MAJ TIERS PC 7010 -----------------------------------
update fc_ligne set ide_tiers = '7010'
--update fc_ligne set ide_cpt = '39030399', spec1='39111',spec2='47012106',spec3='501', ide_modele_lig='DEBIT+3SPEC'
where (ide_poste,ide_gest,ide_jal,flg_cptab,ide_ecr)
in (select ide_poste, ide_gest,ide_jal,flg_cptab,ide_ecr
from fc_ecriture where 
ide_gest in ('2023')
and ide_poste in ('7010')
and ide_mess in (select ide_mess from fm_message where cod_typ_mess = 24)
)
and flg_cptab = 'N'
and ide_cpt = '4411'
--and uti_maj <> 'E000618'
and ide_tiers = '701001'
and ide_modele_lig = 'DEBIT+T'
--and ide_ecr between 363 and 364
;

------------------------ MAJ TIERS PC 7023 7023 1 -----------------------------------
update fc_ligne set ide_tiers = '7023'
--update fc_ligne set ide_cpt = '39030399', spec1='39111',spec2='47012106',spec3='501', ide_modele_lig='DEBIT+3SPEC'
where (ide_poste,ide_gest,ide_jal,flg_cptab,ide_ecr)
in (select ide_poste, ide_gest,ide_jal,flg_cptab,ide_ecr
from fc_ecriture where 
ide_gest in ('2023')
and ide_poste in ('7023')
and ide_mess in (select ide_mess from fm_message where cod_typ_mess = 24)
)
and flg_cptab = 'N'
and ide_cpt = '4411'
--and uti_maj <> 'E000618'
and ide_tiers = '7023 1'
and ide_modele_lig = 'DEBIT+T'
--and ide_ecr between 363 and 364
;

------------------------ MAJ TIERS PC 694 694-02 -----------------------------------
update fc_ligne set ide_tiers = 'HG'
--update fc_ligne set ide_cpt = '39030399', spec1='39111',spec2='47012106',spec3='501', ide_modele_lig='DEBIT+3SPEC'
where (ide_poste,ide_gest,ide_jal,flg_cptab,ide_ecr)
in (select ide_poste, ide_gest,ide_jal,flg_cptab,ide_ecr
from fc_ecriture where 
ide_gest in ('2023')
and ide_poste in ('694')
and ide_mess in (select ide_mess from fm_message where cod_typ_mess = 24)
)
and flg_cptab = 'N'
and ide_cpt = '44801'
--and uti_maj <> 'E000618'
and ide_tiers = '694-02'
--and ide_modele_lig = 'DEBIT+T'
--and ide_ecr between 363 and 364
;

------------------------ MAJ TIERS PC 622 CHR -----------------------------------
update fc_ligne set ide_tiers = 'CHR'
--update fc_ligne set ide_cpt = '39030399', spec1='39111',spec2='47012106',spec3='501', ide_modele_lig='DEBIT+3SPEC'
where (ide_poste,ide_gest,ide_jal,flg_cptab,ide_ecr)
in (select ide_poste, ide_gest,ide_jal,flg_cptab,ide_ecr
from fc_ecriture where 
ide_gest in ('2023')
and ide_poste in ('622')
and ide_mess in (select ide_mess from fm_message where cod_typ_mess = 24)
)
and flg_cptab = 'N'
and ide_cpt = '44801'
and uti_maj <> 'E000618'
--and ide_tiers = '694-02'
--and ide_modele_lig = 'DEBIT+T'
--and ide_ecr between 363 and 364
;

------------------------ MAJ TIERS TG Ristourne Timbre -----------------------------------
update fc_ligne set spec3 = '501'
--update fc_ligne set ide_cpt = '39030399', spec1='39111',spec2='47012106',spec3='501', ide_modele_lig='DEBIT+3SPEC'
where (ide_poste,ide_gest,ide_jal,flg_cptab,ide_ecr)
in (select ide_poste, ide_gest,ide_jal,flg_cptab,ide_ecr
from fc_ecriture where 
ide_gest in ('2023')
and ide_poste in (select ide_poste from rm_poste where ide_typ_poste = 'TG')
and ide_mess in (select ide_mess from fm_message where cod_typ_mess = 24)
)
and flg_cptab = 'N'
and ide_cpt = '390303111'
and spec3= '@PC'
;

------------------------ MAJ 39051 EPN -----------------------------------
--select * from fc_ligne
update fc_ligne set spec1 = '391311', spec2= '390313', ide_modele_lig = 'C 39051'
--update fc_ligne set ide_cpt = '39030399', spec1='39111',spec2='47012106',spec3='501', ide_modele_lig='DEBIT+3SPEC'
where (ide_poste,ide_gest,ide_jal,flg_cptab,ide_ecr)
in (select ide_poste, ide_gest,ide_jal,flg_cptab,ide_ecr
from fc_ecriture where 
ide_gest in ('2023')
and ide_poste in (select ide_poste from rm_poste where ide_typ_poste = 'EPN')
and ide_mess in (select ide_mess from fm_message where cod_typ_mess = 24 and libl like '%CUT%')
)
and flg_cptab = 'N'
and ide_cpt = '39051'
and ide_modele_lig <> 'C 39051'
;


------------------------ MAJ 390313 -----------------------------------
--select * from fc_ligne
update fc_ligne set spec1='391311', spec2= '390313'
--update fc_ligne set ide_cpt = '39030399', spec1='39111',spec2='47012106',spec3='501', ide_modele_lig='DEBIT+3SPEC'
where (ide_poste,ide_gest,ide_jal,flg_cptab,ide_ecr)
in (select ide_poste, ide_gest,ide_jal,flg_cptab,ide_ecr
from fc_ecriture where 
ide_gest in ('2023')
--and ide_poste in (select ide_poste from rm_poste where ide_typ_poste = 'EPN')
and ide_mess in (select ide_mess from fm_message where cod_typ_mess = 24 and libl like '%CUT%')
)
and flg_cptab = 'N'
and spec2 = '39031'
and ide_cpt in ('3903027295', '39051')
;

------------------------ MAJ 390313 -----------------------------------
--select * from fc_ligne
update fc_ligne set spec2= '390313'
--update fc_ligne set ide_cpt = '39030399', spec1='39111',spec2='47012106',spec3='501', ide_modele_lig='DEBIT+3SPEC'
where (ide_poste,ide_gest,ide_jal,flg_cptab,ide_ecr)
in (select ide_poste, ide_gest,ide_jal,flg_cptab,ide_ecr
from fc_ecriture where 
ide_gest in ('2023')
--and ide_poste in (select ide_poste from rm_poste where ide_typ_poste = 'EPN')
and ide_mess in (select ide_mess from fm_message where cod_typ_mess = 24 and libl like '%CUT%')
)
and flg_cptab = 'N'
and spec2 = '39031'
and ide_cpt = '391311'
;

------------------------ MAJ TIERS PC 448082 -----------------------------------

--select * from fc_ligne
update fc_ligne set ide_modele_lig = 'DEBIT'
--update fc_ligne set ide_cpt = '39030399', spec1='39111',spec2='47012106',spec3='501', ide_modele_lig='DEBIT+3SPEC'
where (ide_poste,ide_gest,ide_jal,flg_cptab,ide_ecr)
in (select ide_poste, ide_gest,ide_jal,flg_cptab,ide_ecr
from fc_ecriture where 
ide_gest in ('2023')
--and ide_poste in ('645')
and ide_mess in (select ide_mess from fm_message where cod_typ_mess = 24)
)
and flg_cptab = 'N'
and ide_cpt = '448082'
and ide_modele_lig = 'DEBIT+TP'
;

------------------------ MAJ TIERS PC 687 4413 313 -----------------------------------

--select * from fc_ligne
update fc_ligne set ide_tiers = '313'
--update fc_ligne set ide_cpt = '39030399', spec1='39111',spec2='47012106',spec3='501', ide_modele_lig='DEBIT+3SPEC'
where (ide_poste,ide_gest,ide_jal,flg_cptab,ide_ecr)
in (select ide_poste, ide_gest,ide_jal,flg_cptab,ide_ecr
from fc_ecriture where 
ide_gest in ('2023')
and ide_poste = '687'
and ide_mess in (select ide_mess from fm_message where cod_typ_mess = 24)
)
and flg_cptab = 'N'
and ide_cpt = '4413'
and ide_tiers = '687/313'
;

------------------------ MAJ TIERS PC 654 44801 0002 -----------------------------------

--select * from fc_ligne
update fc_ligne set ide_tiers = 'CSU-BINGERVILLE'
--update fc_ligne set ide_cpt = '39030399', spec1='39111',spec2='47012106',spec3='501', ide_modele_lig='DEBIT+3SPEC'
where (ide_poste,ide_gest,ide_jal,flg_cptab,ide_ecr)
in (select ide_poste, ide_gest,ide_jal,flg_cptab,ide_ecr
from fc_ecriture where 
ide_gest in ('2023')
and ide_poste = '654'
and ide_mess in (select ide_mess from fm_message where cod_typ_mess = 24)
)
and flg_cptab = 'N'
and ide_cpt = '44801'
and ide_tiers = '0002'
;

------------------------ MAJ TIERS PC 654 44801 0077 -----------------------------------

--select * from fc_ligne
update fc_ligne set ide_tiers = 'HG BINGERVILLE'
--update fc_ligne set ide_cpt = '39030399', spec1='39111',spec2='47012106',spec3='501', ide_modele_lig='DEBIT+3SPEC'
where (ide_poste,ide_gest,ide_jal,flg_cptab,ide_ecr)
in (select ide_poste, ide_gest,ide_jal,flg_cptab,ide_ecr
from fc_ecriture where 
ide_gest in ('2023')
and ide_poste = '654'
and ide_mess in (select ide_mess from fm_message where cod_typ_mess = 24)
)
and flg_cptab = 'N'
and ide_cpt = '44801'
and ide_tiers = '0077'
;

------------------------ MAJ TIERS PC 654 44801 0077 -----------------------------------

--select * from fc_ligne
update fc_ligne set ide_tiers = 'HP BINGERVILLE'
--update fc_ligne set ide_cpt = '39030399', spec1='39111',spec2='47012106',spec3='501', ide_modele_lig='DEBIT+3SPEC'
where (ide_poste,ide_gest,ide_jal,flg_cptab,ide_ecr)
in (select ide_poste, ide_gest,ide_jal,flg_cptab,ide_ecr
from fc_ecriture where 
ide_gest in ('2023')
and ide_poste = '654'
and ide_mess in (select ide_mess from fm_message where cod_typ_mess = 24)
)
and flg_cptab = 'N'
and ide_cpt = '44801'
and ide_tiers = '128'
;

------------------------ MAJ TIERS PC 654 44801 0077 -----------------------------------

--select * from fc_ligne
update fc_ligne set ide_tiers = 'CSU-BINGERVILLE'
--update fc_ligne set ide_cpt = '39030399', spec1='39111',spec2='47012106',spec3='501', ide_modele_lig='DEBIT+3SPEC'
where (ide_poste,ide_gest,ide_jal,flg_cptab,ide_ecr)
in (select ide_poste, ide_gest,ide_jal,flg_cptab,ide_ecr
from fc_ecriture where 
ide_gest in ('2023')
and ide_poste = '654'
and ide_mess in (select ide_mess from fm_message where cod_typ_mess = 24)
)
and flg_cptab = 'N'
and ide_cpt = '44801'
and ide_tiers in ('0134','335 MSHP','073','CSU COLOMBIE')
;

------------------------ MAJ TIERS PC 717 44801 71701 -----------------------------------

--select * from fc_ligne
update fc_ligne set ide_tiers = 'CSU HIRE'
--update fc_ligne set ide_cpt = '39030399', spec1='39111',spec2='47012106',spec3='501', ide_modele_lig='DEBIT+3SPEC'
where (ide_poste,ide_gest,ide_jal,flg_cptab,ide_ecr)
in (select ide_poste, ide_gest,ide_jal,flg_cptab,ide_ecr
from fc_ecriture where 
ide_gest in ('2023')
and ide_poste = '717'
and ide_mess in (select ide_mess from fm_message where cod_typ_mess = 24)
)
and flg_cptab = 'N'
and ide_cpt = '44801'
and ide_tiers = '71701'
;


------------------------ MAJ TIERS PC 626 44899 6901 -----------------------------------

--select * from fc_ligne
update fc_ligne set ide_tiers = 'BRIG GEND'
--update fc_ligne set ide_cpt = '39030399', spec1='39111',spec2='47012106',spec3='501', ide_modele_lig='DEBIT+3SPEC'
where (ide_poste,ide_gest,ide_jal,flg_cptab,ide_ecr)
in (select ide_poste, ide_gest,ide_jal,flg_cptab,ide_ecr
from fc_ecriture where 
ide_gest in ('2023')
and ide_poste = '626'
and ide_mess in (select ide_mess from fm_message where cod_typ_mess = 24)
)
and flg_cptab = 'N'
and ide_cpt = '44899'
and ide_tiers = '6901'
;

------------------------ MAJ TIERS PC 626 44899 6902 -----------------------------------

--select * from fc_ligne
update fc_ligne set ide_tiers = 'CAIRE POLICE'
--update fc_ligne set ide_cpt = '39030399', spec1='39111',spec2='47012106',spec3='501', ide_modele_lig='DEBIT+3SPEC'
where (ide_poste,ide_gest,ide_jal,flg_cptab,ide_ecr)
in (select ide_poste, ide_gest,ide_jal,flg_cptab,ide_ecr
from fc_ecriture where 
ide_gest in ('2023')
and ide_poste = '626'
and ide_mess in (select ide_mess from fm_message where cod_typ_mess = 24)
)
and flg_cptab = 'N'
and ide_cpt = '44899'
and ide_tiers = '6902'
;


---------------------- MAJ JODPGA 475XXX --------------------
select * from fc_ligne where
(ide_poste, ide_ecr, ide_gest, ide_jal, flg_cptab)
in
(
select ide_poste, ide_ecr, ide_gest, ide_jal, flg_cptab
from fc_ecriture where
ide_gest = '2024'
and ide_poste = '508'
and ide_mess in (select ide_mess from fm_message where ide_gest = '2024' and cod_typ_mess )
and flg_cptab = 'N'
)
and ide_cpt = '4751153'
and ide_modele_lig = 'CREDIT'
;

commit;