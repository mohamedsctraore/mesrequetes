alter session set nls_date_format = 'DD/MM/RRRR';

select unique 'execute CUT.P_BALAIS_DEVERS ('''||pc_code||''',''2024'','''||to_char(rgl_dte_reglement, 'dd/mm/rrrr')||''')'
from cut_reglement where
(pc_code, rgl_num)
in
(
    select pc_code, rgl_num
    from cut_reglement
    where rgl_statut in ('V','P','S')
    and RGL_MRG_CODE = '01'
    and to_date(rgl_dte_reglement,'DD/MM/RRRR') between '&&debut' and '&&fin'
    and RGL_CODE_OP is null
    minus
    select pc_code, rgl_num
    from cut_reglement
    where rgl_statut in ('V','P','S')
    and RGL_MRG_CODE = '01'
    and to_date(rgl_dte_reglement,'DD/MM/RRRR') between '&&debut' and '&&fin'
    and (pc_code, rgl_num) in (select ide_poste, ide_piece from fc_ecriture@asterndir where ide_gest = '2024')
    union
    select pc_code, rgl_num
    from cut_reglement
    where rgl_statut in ('V','P')
    and RGL_MRG_CODE = '02'
    and to_date(rgl_dte_reglement,'DD/MM/RRRR') between '&&debut' and '&&fin'
    and RGL_CODE_OP is null
    minus
    select pc_code, rgl_num
    from cut_reglement
    where rgl_statut in ('V','P')
    and RGL_MRG_CODE = '02'
    and to_date(rgl_dte_reglement,'DD/MM/RRRR') between '&&debut' and '&&fin'
    and (pc_code, rgl_num) in (select ide_poste, ide_piece from fc_ecriture@asterndir where ide_gest = '2024')
)
and pc_code in (select pc_code from cut.cut_poste where pc_gp='T') 
union
select unique 'execute CUT.P_BALAIS_DEVERS ('''||CHQ_PC_CODE||''',''2024'','''||to_char(chq_dte_confirm, 'dd/mm/rrrr')||''')'
from cut_cheque_tresor
where (CHQ_PC_CODE, CHQ_CODE)
in
(
    select CHQ_PC_CODE, CHQ_CODE
    from cut_cheque_tresor
    where chq_statut in ('P')
    and to_date(chq_dte_confirm,'DD/MM/RRRR') between '&&debut' and '&&fin'
    minus
    select CHQ_PC_CODE, CHQ_CODE
    from cut_cheque_tresor
    where chq_statut in ('P')
    and to_date(chq_dte_confirm,'DD/MM/RRRR') between '&&debut' and '&&fin'
    and (CHQ_PC_CODE, CHQ_CODE) in (select ide_poste, ide_piece from fc_ecriture@asterndir where ide_gest = '2024')
)
and chq_pc_code in (select pc_code from cut.cut_poste where pc_gp='T') 
order by 1;


select unique pc_gp from cut.cut_poste