drop table piece_pgi;

create table piece_pgi as
select '509' ide_poste, '2025' ide_gest, 'TREP' ide_jal, 'O' flg_cptab, 148 ide_ecr, 1680 ide_lig, 'C2020' var_cpta, 'T2012' var_tiers, b.ide_tiers ide_tiers, a.ide_cpt ide_cpt, a.ide_ref_piece ide_ref_piece, a.cod_ref_piece cod_ref_piece,
'C' cod_sens, sum(decode(cod_sens, 'C', mt, -mt)) mt, 'REP PARTIELLE' ide_schema, 'A' cod_typ_schema, 'DEBIT' ide_modele_lig, '01/01/2025' dat_ecr, '01/01/2025' dat_ref, sysdate dat_cre, 'MES' uti_cre, sysdate dat_maj, 'MES' uti_maj, 'MES' terminal,
'N' flg_annul_dcst, sum(decode(cod_sens, 'C', mt, -mt)) mt_dev
from fc_ligne a
inner join fc_ref_piece b on a.ide_ref_piece = b.ide_ref_piece
and a.ide_poste = b.ide_poste
where a.ide_gest = '2024'
and a.flg_cptab = 'O'
and ide_cpt in (select unique ide_cpt from fc_ligne where ide_gest = '2025' and ide_jal = 'TREP' and ide_poste = '509' and ide_cpt in (select ide_cpt from fn_compte where flg_justif = 'O') and ide_ref_piece is null)
and a.ide_poste = '509'
and flg_solde = 'O'
and (a.ide_ref_piece, a.cod_ref_piece) in 
(
    select a.ide_ref_piece, a.cod_ref_piece
    from fc_ligne a
    inner join fc_ref_piece b on a.ide_ref_piece = b.ide_ref_piece
    and a.ide_poste = b.ide_poste
    where a.ide_gest = '2024'
    and a.flg_cptab = 'O'
    and ide_cpt in (select unique ide_cpt from fc_ligne where ide_gest = '2025' and ide_jal = 'TREP' and ide_poste = '509' and ide_cpt in (select ide_cpt from fn_compte where flg_justif = 'O') and ide_ref_piece is null)
    and a.ide_poste = '509'
    and flg_solde = 'O'
    group by a.ide_ref_piece, a.cod_ref_piece
    having sum(decode(cod_sens, 'C', mt, -mt)) <> 0
    minus
    select a.ide_ref_piece, a.cod_ref_piece
    from fc_ligne a
    where ide_gest = '2025'
    and ide_jal = 'TREP'
    and ide_cpt in (select unique ide_cpt from fc_ligne where ide_gest = '2025' and ide_jal = 'TREP' and ide_poste = '509' and ide_cpt in (select ide_cpt from fn_compte where flg_justif = 'O') and ide_ref_piece is null)
    and ide_poste = '509'
)
and ide_cpt like '475%'
group by a.ide_cpt, a.ide_ref_piece, a.cod_ref_piece, b.ide_tiers
having sum(decode(cod_sens, 'C', mt, -mt)) <> 0
order by a.ide_cpt, ide_ref_piece
;


select * from piece_pgi;

select ide_poste, ide_gest, ide_jal, flg_cptab, ide_ecr, ide_cpt from fc_ligne
where (ide_poste, ide_gest, ide_jal, flg_cptab, ide_ecr)
in
(
select ide_poste, ide_gest, ide_jal, flg_cptab, ide_ecr
from fc_ecriture
where ide_gest = '2025'
and ide_poste in ('509')
and ide_jal = 'TREP'
--and ide_ecr = 26
--and dat_jc = '31/01/2025'
)
and ide_cpt in (select ide_cpt from fn_compte where flg_justif = 'O')
and ide_cpt like '475%'
and ide_ref_piece is null
order by ide_cpt, ide_ecr;

declare
    cursor c_pgi is select unique ide_poste, ide_ecr, ide_lig, ide_cpt 
    from fc_ligne
    where (ide_poste, ide_gest, ide_jal, flg_cptab, ide_ecr)
    in
    (
    select ide_poste, ide_gest, ide_jal, flg_cptab, ide_ecr
    from fc_ecriture
    where ide_gest = '2025'
    and ide_poste in ('509')
    and ide_jal = 'TREP'
    --and ide_ecr = 26
    --and dat_jc = '31/01/2025'
    )
    and ide_cpt in (select ide_cpt from fn_compte where flg_justif = 'O')
    and ide_cpt like '475%'
    and ide_ref_piece is null
    order by ide_cpt, ide_ecr;
    
    cursor c_piece_reprise_pgi(v_ide_cpt varchar2) is select ide_poste, ide_gest, ide_jal, flg_cptab, ide_ecr, ide_lig, var_cpta, var_tiers, ide_tiers, ide_cpt, 
    ide_ref_piece, cod_ref_piece, cod_sens, mt, ide_schema, cod_typ_schema, ide_modele_lig, dat_ecr, dat_cre, uti_cre, dat_maj, uti_maj, terminal, flg_annul_dcst, mt_dev
    from piece_pgi
    where ide_cpt = v_ide_cpt;
    
    v_ide_ecr piaf_adm.fc_ligne.ide_ecr%type;
    v_ide_lig piaf_adm.fc_ligne.ide_lig%type;
begin
    for param_ligne in c_pgi
        loop
            select ide_ecr into v_ide_ecr from fc_ligne where ide_gest = '2025' and ide_poste = '509' and ide_jal = 'TREP' and ide_cpt = param_ligne.ide_cpt and ide_lig = param_ligne.ide_lig;
            select max(ide_lig) + 1 into v_ide_lig from fc_ligne where ide_gest = '2025' and ide_poste = '509' and ide_jal = 'TREP' and ide_ecr = param_ligne.ide_ecr;
            for param_pgi in c_piece_reprise_pgi(param_ligne.ide_cpt)
                loop
                    insert into recap_piece (ide_poste,
                    ide_gest,
                    ide_jal,
                    flg_cptab,
                    ide_ecr,
                    ide_lig,
                    var_cpta,
                    var_tiers,
                    ide_tiers,
                    ide_cpt,
                    ide_ref_piece,
                    cod_ref_piece,
                    cod_sens,
                    mt,
                    ide_schema,
                    cod_typ_schema,
                    ide_modele_lig,
                    dat_ecr,
                    dat_cre,
                    uti_cre,
                    dat_maj,
                    uti_maj,
                    terminal,
                    flg_annul_dcst,
                    mt_dev) values 
                    (param_pgi.ide_poste,
                    param_pgi.ide_gest,
                    param_pgi.ide_jal,
                    param_pgi.flg_cptab,
                    v_ide_ecr,
                    v_ide_lig,
                    param_pgi.var_cpta,
                    param_pgi.var_tiers,
                    param_pgi.ide_tiers,
                    param_pgi.ide_cpt,
                    param_pgi.ide_ref_piece,
                    param_pgi.cod_ref_piece,
                    param_pgi.cod_sens,
                    param_pgi.mt,
                    param_pgi.ide_schema,
                    param_pgi.cod_typ_schema,
                    param_pgi.ide_modele_lig,
                    param_pgi.dat_ecr,
                    param_pgi.dat_cre,
                    param_pgi.uti_cre,
                    param_pgi.dat_maj,
                    param_pgi.uti_maj,
                    param_pgi.terminal,
                    param_pgi.flg_annul_dcst,
                    param_pgi.mt_dev);
                    v_ide_lig := v_ide_lig + 1;
                end loop;
        end loop;
        commit;
end;


select ide_ecr, ide_jal, sum(decode(cod_sens,'C',mt,-mt))
from fc_ligne
where ide_gest = '2025'
and ide_jal = 'TREP'
and ide_poste = '509'
group by ide_ecr, ide_jal
having sum(decode(cod_sens,'C',mt,-mt)) <> 0;