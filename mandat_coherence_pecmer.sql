drop table mandat_coherence;

create table mandat_coherence as

select 'P' cible, ead_num_acte, ead_mnt_cp_tre from t_entete_acte_depenses
where ead_cde_pc_assi = '602'
and ead_journee_pec <= '31/05/2023'
and ead_exe = '2023'
and ead_type = 'M'
and ead_statut in ('PEC','MER')

union 

select 'A' cible, a.ide_piece, (-mt)
from fc_ecriture@lkast a
left join fc_ligne@lkast b on a.ide_poste = b.ide_poste
and a.flg_cptab = b.flg_cptab
and a.ide_gest = b.ide_gest
and a.ide_ecr = b.ide_ecr
and a.ide_jal = b.ide_jal 
where a.ide_gest='2023'
and a.ide_jal='JPECDEPBG'
and b.ide_cpt like '474%'
and b.dat_ecr <= '31/05/2023'
and a.ide_poste = '602C'

order by 2,1;


select ead_num_acte, sum(ead_mnt_cp_tre) from mandat_coherence
group by ead_num_acte
having sum(ead_mnt_cp_tre) <> 0
;