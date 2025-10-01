------------------------------  POSTE TIRANT UN SOLDE  -------------------------------

select ide_poste pc_code, b.libn libelle_poste, a.ide_cpt compte, c.libn libelle_compte,    case 
                                                                                                when sum(decode(cod_sens, 'D', mt, -mt)) > 0
                                                                                                then sum(decode(cod_sens, 'D', mt, -mt))
                                                                                                else 0
                                                                                            end debit,                                    
                                                                                            case 
                                                                                                when sum(decode(cod_sens, 'D', mt, -mt)) < 0
                                                                                                then abs(sum(decode(cod_sens, 'D', mt, -mt)))
                                                                                                else 0 
                                                                                            end credit                                     
from fc_ligne a
inner join rm_noeud b on ide_poste = ide_nd
inner join fn_compte c on a.ide_cpt = c.ide_cpt
where ide_gest = '2025'
and flg_cptab = 'O'
--and ide_poste in ('617')
and substr(a.ide_cpt,1,5) in ('47411','47412','47421','47422')
--and dat_ecr = '14/04/2025'
--and a.ide_cpt in
--(
--select unique compte from solde_anormal_st_mars
--)
--and a.ide_cpt in ('40831','47012106','47012115','47012332','47012502','4705203','4721103','4721104','4721108','4721111','4731111','4731113','4731122','47412','474322103','474322102','474322202','4751123','4771216','4772121','51221','581112')
--and (substr(a.ide_cpt, 1,3) = '401' or substr(a.ide_cpt, 1,3) = '402' or substr(a.ide_cpt, 1,3) = '404' or substr(a.ide_cpt, 1,3) = '406' or substr(a.ide_cpt, 1,3) = '408') 
--and ide_poste in (SELECT ide_poste FROM rm_poste WHERE ide_typ_poste in ('TC') union SELECT ide_poste FROM rm_poste WHERE ide_poste_centra in (SELECT ide_poste FROM rm_poste WHERE ide_typ_poste in ('TC')))
--and ide_poste in (SELECT ide_poste FROM rm_poste WHERE ide_poste_centra='510C' or ide_poste='510C')
--and ide_poste in (SELECT ide_poste FROM rm_poste WHERE ide_typ_poste in ('TC'))
--and ide_poste in (SELECT ide_poste FROM rm_poste WHERE ide_poste_centra='510C' union select ide_poste from rm_poste where ide_poste_centra in (select ide_poste from rm_poste where ide_typ_poste = 'TC'))
and dat_ecr between '01/01/2025' and '30/09/2025'
group by ide_poste, b.libn, a.ide_cpt, c.libn
having sum(decode(cod_sens, 'D', mt, -mt)) <> 0
order by a.ide_cpt, a.ide_poste
;


-------------------------------    SPEC 1  -----------------------------------------------------

------------------------------  POSTE TIRANT UN SOLDE  -------------------------------

select ide_poste pc_code, b.libn libelle_poste, spec1 compte, c.libn libelle_compte,    case 
                                                                                                when sum(decode(cod_sens, 'D', mt, -mt)) > 0
                                                                                                then sum(decode(cod_sens, 'D', mt, -mt))
                                                                                                else 0
                                                                                            end debit,                                    
                                                                                            case 
                                                                                                when sum(decode(cod_sens, 'D', mt, -mt)) < 0
                                                                                                then abs(sum(decode(cod_sens, 'D', mt, -mt)))
                                                                                                else 0 
                                                                                            end credit                                     
from fc_ligne a
inner join rm_noeud b on ide_poste = ide_nd
inner join fn_compte c on a.ide_cpt = c.ide_cpt
where ide_gest = '2024'
and flg_cptab = 'O'
and spec1 in
(
'1764','1759','1529','47012202','47012203','47012204','47012206','47011122','4701234','47012116','47012133','4721102',
'4721103','4721111','4731112','4731113','4735124','47411','47421','474313','47517299','47552','47551'
)
--and substr(ide_cpt,1,3) = '582'
--and ide_poste = '625C'
and dat_ecr <= '31/07/2024'
group by ide_poste, b.libn, spec1, c.libn
having sum(decode(cod_sens, 'D', mt, -mt)) <> 0
order by spec1, a.ide_poste
;


------------------------  CF TIRANT UN SOLDE  ---------------------------------
Drop Table solde_simplifie;

Create Table solde_simplifie as
Select a.ide_poste pc_code, ide_poste_centra,  b.libn libelle_poste, a.ide_cpt compte, c.libn libelle_compte, Sum(decode(cod_sens, 'D', mt, -mt)) mt                
From fc_ligne a
Inner Join rm_noeud b on ide_poste = ide_nd
Inner Join rm_poste d on a.ide_poste = d.ide_poste
Inner Join fn_compte c on a.ide_cpt = c.ide_cpt
Where a.ide_gest = '2025'
And a.flg_cptab = 'O'
--and ide_cpt in ('47411','47421')
And Substr(a.ide_cpt, 1, 5) = '39031'
--and a.ide_poste in (select ide_poste from rm_poste where ide_typ_poste in ('ACCD','AACCD','AACDC'))
And dat_ecr <= '30/09/2025'
Group By a.ide_poste, ide_poste_centra, b.libn, a.ide_cpt, c.libn
Having Sum(decode(cod_sens, 'D', mt, -mt)) <> 0
--order by a.ide_cpt, a.ide_poste
;

Update solde_simplifie
set ide_poste_centra = pc_code
where ide_poste_centra = '501C';

select * from solde_simplifie;

select ide_poste_centra cf, compte, libelle_compte, case 
                                                        when sum(mt) > 0
                                                        then sum(mt)
                                                        else 0
                                                end debit,                                    
                                                    case 
                                                        when sum(mt) < 0
                                                        then abs(sum(mt))
                                                        else 0 
                                                end credit  from solde_simplifie
--where ide_poste_centra like '464C'
group by ide_poste_centra, compte, libelle_compte
having sum(mt) <> 0
order by compte, ide_poste_centra
;
---------------------------------------------------------------------------------------------
select a.ide_poste_centra cf, b.libn, a.compte, a.libelle_compte, case 
                                                        when sum(mt) > 0
                                                        then sum(mt)
                                                        else 0
                                                end debit,                                    
                                                    case 
                                                        when sum(mt) < 0
                                                        then abs(sum(mt))
                                                        else 0 
                                                end credit  from solde_simplifie a, rm_noeud b
where a.ide_poste_centra = b.ide_nd
group by ide_poste_centra, b.libn, compte, libelle_compte
having sum(mt) <> 0
order by compte, ide_poste_centra
;
-----------------------------------------------------------------------------------------------------


select ide_poste_centra poste, libn libelle_poste, compte, libelle_compte, case 
                                                        when sum(mt) > 0
                                                        then sum(mt)
                                                        else 0
                                                end debit,                                    
                                                    case 
                                                        when sum(mt) < 0
                                                        then abs(sum(mt))
                                                        else 0 
                                                end credit, cod_sens_solde                             
from solde_simplifie
inner join fn_compte on compte = ide_cpt
inner join rm_noeud on ide_poste_centra = ide_nd
--where ide_poste_centra = '649C'
group by ide_poste_centra, libn, compte, libelle_compte, cod_sens_solde
having sum(mt) <> 0
order by compte, ide_poste_centra
;

select ide_poste_centra poste, libn libelle_poste, compte, libelle_compte, case 
                                                        when sum(mt) > 0
                                                        then sum(mt)
                                                        else 0
                                                end debit,                                    
                                                    case 
                                                        when sum(mt) < 0
                                                        then abs(sum(mt))
                                                        else 0 
                                                end credit, cod_sens_solde                             
from solde_simplifie
inner join fn_compte on compte = ide_cpt
inner join rm_noeud on ide_poste_centra = ide_nd
--where compte = '39030202'
group by ide_poste_centra, libn, compte, libelle_compte, cod_sens_solde
having sum(mt) <> 0
order by ide_poste_centra, compte
;


-------------------------------   BALANCE GENERALE  ----------------------------------------

select a.ide_cpt compte, c.libn libelle_compte, cod_sens_solde, cod_typ_be,    case 
                                                                                                when sum(decode(cod_sens, 'D', mt, -mt)) > 0
                                                                                                then sum(decode(cod_sens, 'D', mt, -mt))
                                                                                                else 0
                                                                                            end debit,                                    
                                                                                            case 
                                                                                                when sum(decode(cod_sens, 'D', mt, -mt)) < 0
                                                                                                then abs(sum(decode(cod_sens, 'D', mt, -mt)))
                                                                                                else 0 
                                                                                            end credit                                     
from fc_ligne a
inner join rm_noeud b on ide_poste = ide_nd
inner join fn_compte c on a.ide_cpt = c.ide_cpt
where ide_gest = '2025'
and flg_cptab = 'O'
and a.ide_poste = '425'
--AND a.ide_poste in (select ide_poste from rm_poste where ide_poste_centra='421' or ide_poste='421')
--and a.ide_cpt in ('390315')
--and ide_jal = 'TREP'
--and ide_poste in (select ide_poste from rm_poste where ide_typ_poste in ('ACCD','AACCD','AACDC'))
--and ide_poste in (select ide_poste from rm_poste where ide_typ_poste = 'TCDGI' union select ide_poste from rm_poste where ide_poste_centra in (select ide_poste from rm_poste where ide_typ_poste = 'TCDGI'))
and dat_ecr between '01/01/2025' and '31/08/2025'
--and cod_sens = 'D'
--and substr(ide_cpt, 1,2) = '47' and substr(ide_cpt, 1,3) <> '474'
group by a.ide_cpt, c.libn, cod_sens_solde, cod_typ_be
--having sum(decode(cod_sens, 'D', mt, -mt)) <> 0
--having ( (sum(decode(cod_sens, 'D', mt, -mt)) > 0 and cod_sens_solde = 'C') or (sum(decode(cod_sens, 'D', mt, -mt)) < 0 and cod_sens_solde = 'D') )
order by a.ide_cpt
;


-------------------------------   BALANCE GENERALE DEVISE  ----------------------------------------

select a.ide_cpt compte, c.libn libelle_compte, cod_sens_solde, cod_typ_be, ide_devise,    case 
                                                                                                when sum(decode(cod_sens, 'D', mt_dev, -mt_dev)) > 0
                                                                                                then sum(decode(cod_sens, 'D', mt_dev, -mt_dev))
                                                                                                else 0
                                                                                            end debit,                                    
                                                                                            case 
                                                                                                when sum(decode(cod_sens, 'D', mt_dev, -mt_dev)) < 0
                                                                                                then abs(sum(decode(cod_sens, 'D', mt_dev, -mt_dev)))
                                                                                                else 0 
                                                                                            end credit                                     
from fc_ligne a
inner join rm_noeud b on ide_poste = ide_nd
inner join fn_compte c on a.ide_cpt = c.ide_cpt
where ide_gest = '2024'
and flg_cptab = 'O'
and ide_poste = '460'
--and ide_jal = 'TREP'
--and ide_cpt in ('515213')
--and ide_poste in (select ide_poste from rm_poste where ide_typ_poste in ('ACCD','AACCD','AACDC'))
--and dat_ecr <= '24/01/2025'
--and substr(ide_cpt, 1,2) = '47' and substr(ide_cpt, 1,3) <> '474'
group by a.ide_cpt, c.libn, cod_sens_solde, cod_typ_be, ide_devise
--having sum(decode(cod_sens, 'D', mt, -mt)) <> 0
--having ( (sum(decode(cod_sens, 'D', mt, -mt)) > 0 and cod_sens_solde = 'C') or (sum(decode(cod_sens, 'D', mt, -mt)) < 0 and cod_sens_solde = 'D') )
order by a.ide_cpt
;

------------------------------------  EQUILIBRE SUR BALANCE GENERALE  -----------------------------------------

select ide_ecr, sum(decode(cod_sens, 'D', mt_dev, 0)) debit, sum(decode(cod_sens, 'C', mt_dev, 0)) credit
from fc_ligne
where ide_gest = '2024'
and flg_cptab = 'O'
and dat_ecr <= '31/10/2024'
and ide_devise = 'EUR'
and ide_jal = 'A29'
and ide_poste = '464'
group by ide_ecr
having (sum(decode(cod_sens, 'D', mt_dev, 0)) - sum(decode(cod_sens, 'C', mt_dev, 0)) ) <> 0
; 


------------------------------------  SOLDE POSTE SUR BALANCE GENERALE ------------------------------------------------------

select ide_poste pc_code, b.libn libelle_poste, a.ide_cpt compte, c.libn libelle_compte,    case 
                                                                                                when sum(decode(cod_sens, 'D', mt, -mt)) > 0
                                                                                                then sum(decode(cod_sens, 'D', mt, -mt))
                                                                                                else 0
                                                                                            end debit,                                    
                                                                                            case 
                                                                                                when sum(decode(cod_sens, 'D', mt, -mt)) < 0
                                                                                                then abs(sum(decode(cod_sens, 'D', mt, -mt)))
                                                                                                else 0 
                                                                                            end credit                                     
from fc_ligne a
inner join rm_noeud b on ide_poste = ide_nd
inner join fn_compte c on a.ide_cpt = c.ide_cpt
where ide_gest = '2023'
and flg_cptab = 'O'
and substr(ide_cpt,1,3) = '390'
--and ide_poste = '625C'
and dat_ecr <= '30/11/2023'
group by ide_poste, b.libn, a.ide_cpt, c.libn
having sum(decode(cod_sens, 'D', mt, -mt)) <> 0
order by a.ide_cpt, a.ide_poste
;

------------------------------  POSTE SOLDE ANORMAL  -------------------------------

select ide_poste pc_code, b.libn libelle_poste, a.ide_cpt compte, cod_sens_solde, cod_typ_be, c.libn libelle_compte,    case 
                                                                                                when sum(decode(cod_sens, 'D', mt, -mt)) > 0
                                                                                                then sum(decode(cod_sens, 'D', mt, -mt))
                                                                                                else 0
                                                                                            end debit,                                    
                                                                                            case 
                                                                                                when sum(decode(cod_sens, 'D', mt, -mt)) < 0
                                                                                                then abs(sum(decode(cod_sens, 'D', mt, -mt)))
                                                                                                else 0 
                                                                                            end credit                                     
from fc_ligne a
inner join rm_noeud b on ide_poste = ide_nd
inner join fn_compte c on a.ide_cpt = c.ide_cpt
where ide_gest = '2025'
and flg_cptab = 'O'
and dat_ecr <= '30/04/2025'
and substr(a.ide_cpt, 1, 3) <> '390'
and substr(a.ide_cpt, 1, 3) <> '363'
and a.ide_cpt not in ('581122','581312','47052071','5811224')
group by ide_poste, b.libn, a.ide_cpt, c.libn, cod_sens_solde, cod_typ_be
having ( (sum(decode(cod_sens, 'D', mt, -mt)) > 0 and cod_sens_solde = 'C')  or (sum(decode(cod_sens, 'D', mt, -mt)) < 0 and cod_sens_solde = 'D') )
order by a.ide_cpt, a.ide_poste
;

select a.ide_cpt compte, c.cod_sens_solde, c.cod_typ_be, c.libn libelle_compte,    case 
                                                                                                when sum(decode(cod_sens, 'D', mt, -mt)) > 0
                                                                                                then sum(decode(cod_sens, 'D', mt, -mt))
                                                                                                else 0
                                                                                            end debit,                                    
                                                                                            case 
                                                                                                when sum(decode(cod_sens, 'D', mt, -mt)) < 0
                                                                                                then abs(sum(decode(cod_sens, 'D', mt, -mt)))
                                                                                                else 0 
                                                                                            end credit                                     
from fc_ligne a
inner join rm_noeud b on ide_poste = ide_nd
inner join fn_compte c on a.ide_cpt = c.ide_cpt
where ide_gest = '2025'
and flg_cptab = 'O'
and dat_ecr <= '30/04/2025'
and substr(a.ide_cpt, 1, 3) <> '390'
and substr(a.ide_cpt, 1, 3) <> '363'
and a.ide_cpt not in ('581122','581312','47052071','5811224')
group by a.ide_cpt, c.cod_sens_solde, c.cod_typ_be, c.libn
having ( (sum(decode(cod_sens, 'D', mt, -mt)) > 0 and cod_sens_solde = 'C')  or (sum(decode(cod_sens, 'D', mt, -mt)) < 0 and cod_sens_solde = 'D') )
order by a.ide_cpt
;



select ide_poste, ide_ecr, sum(decode(cod_sens, 'D', mt, 0)) debit, sum(decode(cod_sens, 'C', mt, 0)) credit
from fc_ligne
where ide_gest = '2025'
and flg_cptab = 'O'
and dat_ecr <= '31/01/2025'
--and ide_devise = 'EUR'
and ide_jal = 'JODACCT'
and ide_poste in (select ide_poste from rm_poste where ide_typ_poste = 'ACCT')
group by ide_poste, ide_ecr
having (sum(decode(cod_sens, 'D', mt, 0)) - sum(decode(cod_sens, 'C', mt, 0)) ) <> 0
; 



--------------------------------------------------------------------------------

select a.ide_poste_centra cf, b.libn, a.compte, a.libelle_compte, case 
                                                        when sum(mt) > 0
                                                        then sum(mt)
                                                        else 0
                                                end debit,                                    
                                                    case 
                                                        when sum(mt) < 0
                                                        then abs(sum(mt))
                                                        else 0 
                                                end credit  from solde_simplifie a, rm_noeud b
where a.ide_poste_centra = b.ide_nd
group by ide_poste_centra, b.libn, compte, libelle_compte
having sum(mt) <> 0
order by compte, ide_poste_centra
;