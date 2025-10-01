

---- bon ecart de change positif ---

select 'Insert into PIAF_ADM.FC_LIGNE  (ide_poste,ide_gest,ide_jal,flg_cptab,ide_ecr,ide_lig,var_cpta,ide_cpt,ide_ref_piece,cod_ref_piece,cod_sens,mt,observ,ide_schema,cod_typ_schema,ide_modele_lig,dat_ecr,dat_cre,uti_cre,dat_maj,uti_maj,terminal,FLG_ANNUL_DCST,IDE_DEVISE,mt_dev)   Values ('''||a.ide_poste||''', '''||a.ide_gest||''', ''A29'', ''O'','||max(IDE_ECR)||',''3'', ''C2020'', '''||IDE_CPT||''', '||IDE_REF_PIECE||', '''||COD_REF_PIECE||''',''D'',  '||sum(decode(cod_sens,'C',mt,-mt))||', ''Ecart de change - A29 - '||min(a.IDE_ECR)||' - 1'', ''4'', ''A'',''DEBIT'', '''||max(DAT_ECR)||''', sysdate, ''L349990'', sysdate,''L349990'', ''SRV-CTVA2'', ''N'', ''SAR'',0);'
from fc_ligne a
where ide_gest='2025' and ide_ref_piece is not null and ide_poste like '424%' and flg_cptab='O' and ide_cpt like '470123101%' and ide_cpt not in ('3991','3992')
group by ide_poste, ide_gest,ide_cpt,ide_ref_piece,cod_ref_piece having sum(decode(cod_sens,'D',mt,-mt)) > 0 and sum(decode(cod_sens,'D',mt_dev,-mt_dev)) = 0   --;
union
select 'Insert into PIAF_ADM.FC_LIGNE  (ide_poste,ide_gest,ide_jal,flg_cptab,ide_ecr,ide_lig,var_cpta,ide_cpt,cod_sens,mt,observ,ide_schema,cod_typ_schema,ide_modele_lig,dat_ecr,dat_cre,uti_cre,dat_maj,uti_maj,terminal,FLG_ANNUL_DCST,mt_dev)   Values ('''||ide_poste||''', '''||ide_gest||''', ''A29'', ''O'', '||max(IDE_ECR)||',4, ''C2020'', ''3991'', ''C'', '||sum(decode(cod_sens,'C',mt,-mt))||',''Ecart de change - A29 - '||min(a.IDE_ECR)||' - 1'', ''4'', ''A'', ''CREDIT 3991'', '''||max(DAT_ECR)||''',sysdate, ''L349990'', sysdate, ''L349990'', ''SRV-CTVA2'',''N'', 0);'
from fc_ligne a
where ide_gest='2025' and ide_ref_piece is not null and ide_poste like '424%' and flg_cptab='O' and ide_cpt like '470123101%' and ide_cpt not in ('3991','3992')
group by ide_poste, ide_gest,ide_cpt,ide_ref_piece,cod_ref_piece having sum(decode(cod_sens,'D',mt,-mt)) > 0 and sum(decode(cod_sens,'D',mt_dev,-mt_dev)) = 0;

----- bon ecart d'arrondi negatif ----

select 'Insert into PIAF_ADM.FC_LIGNE  (ide_poste,ide_gest,ide_jal,flg_cptab,ide_ecr,ide_lig,var_cpta,ide_cpt,ide_ref_piece,cod_ref_piece,cod_sens,mt,observ,ide_schema,cod_typ_schema,ide_modele_lig,dat_ecr,dat_cre,uti_cre,dat_maj,uti_maj,terminal,FLG_ANNUL_DCST,IDE_DEVISE,mt_dev)   Values ('''||a.ide_poste||''', '''||a.ide_gest||''', ''A29'', ''O'','||max(IDE_ECR)||',''3'', ''C2020'', '''||IDE_CPT||''', '||IDE_REF_PIECE||', '''||COD_REF_PIECE||''',''D'',  '||sum(decode(cod_sens,'D',mt,-mt))||', ''Ecart de change - A29 - '||min(a.IDE_ECR)||' - 1'', ''4'', ''A'',''DEBIT'', '''||max(DAT_ECR)||''', sysdate, ''L349990'', sysdate,''L349990'', ''SRV-CTVA2'', ''N'', ''SAR'',0);'
from fc_ligne a
where ide_gest='2025' and ide_ref_piece is not null and ide_poste like '424%' and flg_cptab='O' and ide_cpt like '470123101%' and ide_cpt not in ('3991','3992')
group by ide_poste, ide_gest,ide_cpt,ide_ref_piece,cod_ref_piece having sum(decode(cod_sens,'D',mt,-mt)) < 0 and sum(decode(cod_sens,'D',mt_dev,-mt_dev)) = 0   --;
union
select 'Insert into PIAF_ADM.FC_LIGNE   (ide_poste,ide_gest,ide_jal,flg_cptab,ide_ecr,ide_lig,var_cpta,ide_cpt,cod_sens,mt,observ,ide_schema,cod_typ_schema,ide_modele_lig,dat_ecr,dat_cre,uti_cre,dat_maj,uti_maj,terminal,FLG_ANNUL_DCST,mt_dev)  Values ('''||ide_poste||''', '''||ide_gest||''', ''A29'', ''O'', '||max(IDE_ECR)||',4, ''C2020'', ''3991'', ''C'', '||sum(decode(cod_sens,'D',mt,-mt))||',''Ecart de change - A29 - '||min(a.IDE_ECR)||' - 1'', ''4'', ''A'', ''CREDIT 3991'', '''||max(DAT_ECR)||''',sysdate, ''L349990'', sysdate, ''L349990'', ''SRV-CTVA2'',''N'', 0);'
from fc_ligne a
where ide_gest='2025' and ide_ref_piece is not null and ide_poste like '424%' and flg_cptab='O' and ide_cpt like '470123101%' and ide_cpt not in ('3991','3992')
group by ide_poste, ide_gest,ide_cpt,ide_ref_piece,cod_ref_piece having sum(decode(cod_sens,'D',mt,-mt)) < 0 and sum(decode(cod_sens,'D',mt_dev,-mt_dev)) = 0;
