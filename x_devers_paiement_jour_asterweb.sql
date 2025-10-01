alter session set nls_date_format = 'DD/MM/RRRR';

select unique 'execute NIABA.P_DEVERS_FINAL_Web ('''||pc_code||''',''2024'','''||to_char(rgl_dte_reglement, 'dd/mm/rrrr')||''')'
from cut_reglement@lkcut where
(pc_code, rgl_num)
in
(
    select pc_code, rgl_num
    from cut_reglement@lkcut
    where rgl_statut in ('V','P','S')
    and RGL_MRG_CODE = '01'
    and to_date(rgl_dte_reglement,'DD/MM/RRRR') between '&&debut' and '&&fin'
    and RGL_CODE_OP is null
    minus
    select pc_code, rgl_num
    from cut_reglement@lkcut
    where rgl_statut in ('V','P','S')
    and RGL_MRG_CODE = '01'
    and to_date(rgl_dte_reglement,'DD/MM/RRRR') between '&&debut' and '&&fin'
    and (pc_code, rgl_num) in (select ide_poste, ide_piece from fc_ecriture@lknewp where ide_gest = '2024')
    union
    select pc_code, rgl_num
    from cut_reglement@lkcut
    where rgl_statut in ('V','P')
    and RGL_MRG_CODE = '02'
    and to_date(rgl_dte_reglement,'DD/MM/RRRR') between '&&debut' and '&&fin'
    and RGL_CODE_OP is null
    minus
    select pc_code, rgl_num
    from cut_reglement@lkcut
    where rgl_statut in ('V','P')
    and RGL_MRG_CODE = '02'
    and to_date(rgl_dte_reglement,'DD/MM/RRRR') between '&&debut' and '&&fin'
    and (pc_code, rgl_num) in (select ide_poste, ide_piece from fc_ecriture@lknewp where ide_gest = '2024')
)
and pc_code in (select pc_code from cut.cut_poste@lkcut where pc_gp='TP')
union
select unique 'execute NIABA.P_DEVERS_FINAL_Web ('''||CHQ_PC_CODE||''',''2024'','''||to_char(chq_dte_confirm, 'dd/mm/rrrr')||''')'
from cut_cheque_tresor@lkcut
where (CHQ_PC_CODE, CHQ_CODE)
in
(
    select CHQ_PC_CODE, CHQ_CODE
    from cut_cheque_tresor@lkcut
    where chq_statut in ('P')
    and to_date(chq_dte_confirm,'DD/MM/RRRR') between '&&debut' and '&&fin'
    minus
    select CHQ_PC_CODE, CHQ_CODE
    from cut_cheque_tresor@lkcut
    where chq_statut in ('P')
    and to_date(chq_dte_confirm,'DD/MM/RRRR') between '&&debut' and '&&fin'
    and (CHQ_PC_CODE, CHQ_CODE) in (select ide_poste, ide_piece from fc_ecriture@lknewp where ide_gest = '2024')
)
and chq_pc_code in (select pc_code from cut.cut_poste@lkcut where pc_gp='TP')
order by 1