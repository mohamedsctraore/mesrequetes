-- ## ETAPE 1 CONSTITUTION DE LA TABLE DE TRAVAIL
drop table diff_balance_ndir_web;

create table diff_balance_ndir_web as
select 'web' cible, a.ide_cpt compte, c.libn libelle_compte, cod_sens_solde, cod_typ_be,    case 
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
and ide_poste = '&&pc_code'
and dat_ecr <= '&&date_arrete'
group by a.ide_cpt, c.libn, cod_sens_solde, cod_typ_be
union all
select 'ndir' cible, a.ide_cpt compte, c.libn libelle_compte, cod_sens_solde, cod_typ_be,    case 
                                                                                                when sum(decode(cod_sens, 'D', mt, -mt)) > 0
                                                                                                then sum(decode(cod_sens, 'D', mt, -mt))
                                                                                                else 0
                                                                                            end debit,                                    
                                                                                            case 
                                                                                                when sum(decode(cod_sens, 'D', mt, -mt)) < 0
                                                                                                then abs(sum(decode(cod_sens, 'D', mt, -mt)))
                                                                                                else 0 
                                                                                            end credit                                     
from fc_ligne@asterv4 a
inner join rm_noeud@asterv4 b on ide_poste = ide_nd
inner join fn_compte@asterv4 c on a.ide_cpt = c.ide_cpt
where ide_gest = '2024'
and flg_cptab = 'O'
and ide_poste = '&&pc_code'
and dat_ecr <= '&&date_arrete'
group by a.ide_cpt, c.libn, cod_sens_solde, cod_typ_be
order by 2,1
;

-- ## ETAPE 2 AFFICHAGE INTEGRAL DES DONNEES

select * from diff_balance_ndir_web;


-- ## ETAPE 3 AFFICHAGE DES DIFFERENCES

select compte, libelle_compte, sum(decode(cible, 'ndir', debit, -debit)) debit, sum(decode(cible, 'ndir', credit, -credit)) credit from diff_balance_ndir_web
group by compte, libelle_compte
having (sum(decode(cible, 'ndir', debit, -debit)) <> 0 or sum(decode(cible, 'ndir', credit, -credit)) <> 0);