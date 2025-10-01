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
--and ide_cpt in 
--(
--'581111'
--)
and ( substr(ide_cpt,1,3) =  '473' or substr(ide_cpt,1,3) =  '478' )
--and ide_poste = '603'
--and dat_ecr <= '31/12/2023'
group by ide_poste, b.libn, a.ide_cpt, c.libn
having sum(decode(cod_sens, 'D', mt, -mt)) <> 0
order by a.ide_cpt, a.ide_poste
;