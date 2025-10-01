drop table solde_anormal_st_mars;

create table solde_anormal_st_mars as
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
inner join rc_droit_compte on a.ide_cpt = d.ide_cpt
where ide_gest = '2025'
and flg_cptab = 'O'
--and a.ide_poste = '418'
--AND a.ide_poste in (select ide_poste from rm_poste where ide_poste_centra='242C' or ide_poste='242C')
--and a.ide_cpt in ('581122')
--and ide_jal = 'TREP'
--and ide_poste in (select ide_poste from rm_poste where ide_typ_poste in ('ACCD','AACCD','AACDC'))
--and ide_poste in (select ide_poste from rm_poste where ide_typ_poste = 'TCDGI' union select ide_poste from rm_poste where ide_poste_centra in (select ide_poste from rm_poste where ide_typ_poste = 'TCDGI'))
and dat_ecr between '01/01/2025' and '31/03/2025'
--and cod_sens = 'D'
--and substr(ide_cpt, 1,2) = '47' and substr(ide_cpt, 1,3) <> '474'
group by a.ide_cpt, c.libn, cod_sens_solde, cod_typ_be
--having sum(decode(cod_sens, 'D', mt, -mt)) <> 0
having ( (sum(decode(cod_sens, 'D', mt, -mt)) > 0 and cod_sens_solde = 'C') or (sum(decode(cod_sens, 'D', mt, -mt)) < 0 and cod_sens_solde = 'D') )
order by a.ide_cpt
;

select unique compte from solde_anormal_st_mars;