delete from maj_pc_511;
delete from maj_pc_511_mt;

insert into maj_pc_511 
select a.ide_poste, ide_mess, count(a.ide_ecr) nbr_piece, sum(decode(cod_sens, 'D', mt, 0)) mt_db , 0 mt_cr
from fc_ecriture a
left join fc_ligne b on a.ide_poste = b.ide_poste
and a.flg_cptab = b.flg_cptab
and a.ide_gest = b.ide_gest
and a.ide_ecr = b.ide_ecr
and a.ide_jal = b.ide_jal 
where a.ide_gest='2024'
and a.ide_poste like '5%'
and a.flg_cptab = 'N'
and a.ide_mess in
(
    select unique ide_mess
    from fc_ecriture
    where (ide_gest, ide_poste, ide_mess)
    in
    (
    select ide_gest, ide_nd_emet, ide_mess
    from fm_message
    where ide_gest = '2024'
    and cod_typ_mess = 24
    and ide_nd_emet like '5%'
    and (nbr_piece = 0 or mt_db is null or mt_cr is null)
    )
    and ide_jal like 'JOD%'
)
and a.ide_jal like 'JOD%'
and cod_sens = 'D'
group by a.ide_poste, ide_mess

union 

select a.ide_poste, ide_mess, count(a.ide_ecr), 0 mt_db, sum(decode(cod_sens, 'C', mt, 0)) mt_cr
from fc_ecriture a
left join fc_ligne b on a.ide_poste = b.ide_poste
and a.flg_cptab = b.flg_cptab
and a.ide_gest = b.ide_gest
and a.ide_ecr = b.ide_ecr
and a.ide_jal = b.ide_jal 
where a.ide_gest='2024'
and a.ide_poste like '5%'
and a.flg_cptab = 'N'
and a.ide_mess in
(
    select unique ide_mess
    from fc_ecriture
    where (ide_gest, ide_poste, ide_mess)
    in
    (
    select ide_gest, ide_nd_emet, ide_mess
    from fm_message
    where ide_gest = '2024'
    and cod_typ_mess = 24
    and ide_nd_emet like '5%'
    and (nbr_piece = 0 or mt_db is null or mt_cr is null)
    )
    and ide_jal like 'JOD%'
)
and a.ide_jal like 'JOD%'
and cod_sens = 'C'
group by a.ide_poste, ide_mess
;

insert into maj_pc_511_mt 
select ide_poste, ide_mess, nbr_piece, sum(mt_db) mt_db, sum(mt_cr) mt_cr from maj_pc_511
group by ide_poste, ide_mess, nbr_piece;

select * from fm_message
where (ide_gest, ide_nd_emet, ide_mess)
in
(
    select '2024', ide_poste, ide_mess
    from maj_pc_511_mt
)
order by ide_nd_emet, ide_mess;

select * from maj_pc_511_mt
order by ide_mess
;

declare
    var_ide_poste piaf_adm.fm_message.ide_nd_emet%TYPE;
    var_ide_mess piaf_adm.fm_message.ide_mess%TYPE;
    var_nbr_piece piaf_adm.fm_message.nbr_piece%TYPE;
    var_mt_db PIAF_ADM.FM_MESSAGE.MT_CR%TYPE;
    var_mt_cr piaf_adm.fm_message.mt_db%TYPE;
    cursor c_infos is select ide_poste, ide_mess, nbr_piece, mt_db, mt_cr from maj_pc_511_mt where ide_poste like '5%';
begin
    
    open c_infos;
    
    loop 
        fetch c_infos into var_ide_poste, var_ide_mess, var_nbr_piece, var_mt_db, var_mt_cr;
        exit when c_infos%NOTFOUND;
        
        update fm_message
        set nbr_piece = var_nbr_piece, mt_cr = var_mt_cr, mt_db = var_mt_db
        where ide_nd_emet = var_ide_poste
        and (mt_cr = 0 or mt_db = 0)
        and cod_typ_mess = 24
        and ide_mess = var_ide_mess
        ;
        
        commit;        
    end loop;
    
end;