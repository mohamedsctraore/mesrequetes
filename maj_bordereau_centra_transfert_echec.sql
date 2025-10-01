delete from maj_pc_511_c;
delete from maj_pc_511_mt_c;

insert into maj_pc_511_c
select a.ide_nd_emet, ide_mess, count(a.ide_ecr) nbr_piece, sum(decode(cod_sens, 'D', mt, 0)) mt_db , 0 mt_cr
from fc_ecriture a
left join fc_ligne b on a.ide_poste = b.ide_poste
and a.flg_cptab = b.flg_cptab
and a.ide_gest = b.ide_gest
and a.ide_ecr = b.ide_ecr
and a.ide_jal = b.ide_jal 
where a.ide_gest='2023'
and a.ide_poste in (select ide_poste from rm_poste)
and a.flg_cptab = 'N'
and a.ide_mess in
(
    select unique ide_mess
    from fc_ecriture
    where (ide_gest, ide_nd_emet, ide_mess)
    in
    (
    select ide_gest, ide_nd_emet, ide_mess
    from fm_message
    where ide_gest = '2023'
    and cod_typ_mess in (11,12)
    and ide_nd_emet in (select ide_poste from rm_poste)
    and (nbr_piece = 0 or mt_db is null or mt_cr is null)
    )
    and ide_jal in ('JCENTRAL','JTRANSFERT')
)
and a.ide_jal in ('JCENTRAL','JTRANSFERT')
and cod_sens = 'D'
group by a.ide_nd_emet, ide_mess

union 

select a.ide_nd_emet, ide_mess, count(a.ide_ecr), 0 mt_db, sum(decode(cod_sens, 'C', mt, 0)) mt_cr
from fc_ecriture a
left join fc_ligne b on a.ide_poste = b.ide_poste
and a.flg_cptab = b.flg_cptab
and a.ide_gest = b.ide_gest
and a.ide_ecr = b.ide_ecr
and a.ide_jal = b.ide_jal 
where a.ide_gest='2023'
and a.ide_poste in (select ide_poste from rm_poste)
and a.flg_cptab = 'N'
and a.ide_mess in
(
    select unique ide_mess
    from fc_ecriture
    where (ide_gest, ide_nd_emet, ide_mess)
    in
    (
    select ide_gest, ide_nd_emet, ide_mess
    from fm_message
    where ide_gest = '2023'
    and cod_typ_mess in (11,12)
    and ide_nd_emet in (select ide_poste from rm_poste)
    and (nbr_piece = 0 or mt_db is null or mt_cr is null)
    )
    and ide_jal in ('JCENTRAL','JTRANSFERT')
)
and a.ide_jal in ('JCENTRAL','JTRANSFERT')
and cod_sens = 'C'
group by a.ide_nd_emet, ide_mess
;

insert into maj_pc_511_mt_c
select ide_nd_emet, ide_mess, nbr_piece, sum(mt_db) mt_db, sum(mt_cr) mt_cr from maj_pc_511_c
group by ide_nd_emet, ide_mess, nbr_piece;

select * from fm_message
where (ide_gest, ide_nd_emet, ide_mess)
in
(
    select '2023', ide_nd_emet, ide_mess
    from maj_pc_511_mt_c
)
order by ide_nd_emet, ide_mess;

select * from maj_pc_511_mt_c
order by ide_mess
;

declare
    var_ide_poste piaf_adm.fm_message.ide_nd_emet%TYPE;
    var_ide_mess piaf_adm.fm_message.ide_mess%TYPE;
    var_nbr_piece piaf_adm.fm_message.nbr_piece%TYPE;
    var_mt_db PIAF_ADM.FM_MESSAGE.MT_CR%TYPE;
    var_mt_cr piaf_adm.fm_message.mt_db%TYPE;
    cursor c_infos is select ide_nd_emet, ide_mess, nbr_piece, mt_db, mt_cr from maj_pc_511_mt_c where ide_nd_emet = '511';
begin
    
    open c_infos;
    
    loop 
        fetch c_infos into var_ide_poste, var_ide_mess, var_nbr_piece, var_mt_db, var_mt_cr;
        exit when c_infos%NOTFOUND;
        
        update fm_message
        set nbr_piece = var_nbr_piece, mt_cr = var_mt_cr, mt_db = var_mt_db
        where ide_nd_emet = var_ide_poste
        and (mt_cr is null or mt_db is null)
        and cod_typ_mess in (11,12)
        and ide_mess = var_ide_mess
        ;
        
        commit;        
    end loop;
    
end;


select *
from fm_de_me
where (ide_nd_emet, ide_mess)
in
(
select ide_nd_emet, ide_mess from maj_pc_511_mt_c
);

