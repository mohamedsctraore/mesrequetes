select unique ide_typ_poste type_poste, a.ide_poste poste, d.libn libl_poste, b.ide_poste_centra pcc, (select libn from rm_noeud where ide_nd = b.ide_poste_centra) libl_pcc, a.ide_jal journal, a.ide_mess bordereau
from fc_ecriture a, rm_poste b, fm_rnl_me c, rm_noeud d
where a.ide_poste = b.ide_poste
and a.ide_poste = c.ide_nd_dest
and a.ide_poste = d.ide_nd
and a.ide_mess = c.ide_mess
and a.ide_gest = '2022'
and a.flg_cptab = 'N'
and c.FLG_EMIS_RECU = 'R'
and c.cod_statut in ('AC', 'SA')
order by ide_typ_poste, a.ide_poste, a.ide_mess;


select a.ide_poste, b.libn, a.dat_jc
from fc_calend_hist a, rm_noeud b
where a.ide_poste = b.ide_nd 
and a.ide_gest = '2022'
and a.cod_ferm = 'O'
order by a.ide_poste, a.dat_jc;