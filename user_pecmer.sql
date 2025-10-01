select distinct a.ASS_NUM, a.ASS_OPR_MATRICULE, a.ASS_FON_CODE, a.ASS_FON_CODE_DET, b.OPR_NOM, c.MDP_MDP, d.FON_PCT_CODE
from t_assignations a, t_operateurs b, t_mot_de_passes c, t_fonctions d
where a.ass_opr_matricule=b.OPR_MATRICULE
and a.ASS_OPR_MATRICULE=c.MDP_OPR_MATRICULE 
and a.ASS_FON_CODE_DET=d.FON_CODE
and a.ass_opr_matricule='134057L'
;

