create table type_cip as
select a.ide_cpt compte, c.libn libelle_compte,    case 
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
and substr(a.ide_cpt,1,3) in ('470','472','473','475','477','478')
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
and dat_ecr between '01/01/2025' and '31/08/2025'
group by ide_poste, b.libn, a.ide_cpt, c.libn
having sum(decode(cod_sens, 'D', mt, -mt)) <> 0
order by a.ide_cpt, a.ide_poste
;


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
and substr(a.ide_cpt,1,3) in ('470','472','473','475','477','478')
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