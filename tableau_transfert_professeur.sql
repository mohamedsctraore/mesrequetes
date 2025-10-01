------------ Recherche et Compilation des Données concernés --------------------

alter session set nls_date_format='DD/MM/RRRR';

drop table rech_doubl_exploit_V3;

------------------  PRODUCTION DE DONNEES --------------------------

create table rech_doubl_exploit_V3 as
select a.ide_poste ide_poste,b.ide_nd_emet ide_nd_emet,a.ide_cpt ide_cpt,a.cod_sens cod_sens,b.libn,a.observ,a.ide_gest ide_gest,
to_date(substr(b.libn,length(b.libn)-8,9),'DD/MM/RRRR') dat_recept,to_date(b.dat_jc,'DD/MM/RRRR') dat_jc,'R' flg,a.mt,a.flg_cptab flg_cptab, 'RCEP0' position 
from fc_ligne a,fc_ecriture b 
where a.ide_gest='2023' and a.ide_cpt in (select ide_cpt from fn_compte where flg_atrans='O')  and a.ide_jal='JTRANSFERT' and 
to_date(substr(b.libn,length(b.libn)-8,9),'DD/MM/RRRR') <= '30/09/2023' and to_date(b.dat_jc,'DD/MM/RRRR') <= '30/09/2023' 
and a.ide_poste=b.ide_poste and a.ide_gest=b.ide_gest and a.ide_jal=b.ide_jal and a.flg_cptab=b.flg_cptab and a.ide_ecr=b.ide_ecr
; 

insert into rech_doubl_exploit_V3 
select a.ide_poste ide_poste,b.ide_nd_emet ide_nd_emet,a.ide_cpt ide_cpt,a.cod_sens cod_sens,b.libn,a.observ,a.ide_gest ide_gest,
to_date(substr(b.libn,length(b.libn)-8,9),'DD/MM/RRRR') dat_recept,to_date(b.dat_jc,'DD/MM/RRRR') dat_jc,'R' flg,a.mt,a.flg_cptab flg_cptab ,'RCHP1'
from fc_ligne a,fc_ecriture b 
where a.ide_gest='2023' and a.ide_cpt in (select ide_cpt from fn_compte where flg_atrans='O')  and a.ide_jal='JTRANSFERT' and 
to_date(substr(b.libn,length(b.libn)-8,9),'DD/MM/RRRR') <= '30/09/2023' and to_date(b.dat_jc,'DD/MM/RRRR') > '30/09/2023'
and a.ide_poste=b.ide_poste and a.ide_gest=b.ide_gest and a.ide_jal=b.ide_jal and a.flg_cptab=b.flg_cptab and a.ide_ecr=b.ide_ecr
; 

insert into rech_doubl_exploit_V3 
select a.ide_poste ide_poste,b.ide_nd_emet ide_nd_emet,a.ide_cpt ide_cpt,a.cod_sens cod_sens,b.libn,a.observ,a.ide_gest ide_gest,
to_date(substr(b.libn,length(b.libn)-8,9),'DD/MM/RRRR') dat_recept,to_date(b.dat_jc,'DD/MM/RRRR') dat_jc,'R' flg,a.mt,a.flg_cptab flg_cptab,'RCHP2' 
from fc_ligne a,fc_ecriture b 
where a.ide_gest='2023' and a.ide_cpt in (select ide_cpt from fn_compte where flg_atrans='O')  and a.ide_jal='JTRANSFERT' and 
to_date(substr(b.libn,length(b.libn)-8,9),'DD/MM/RRRR') > '30/09/2023' and to_date(b.dat_jc,'DD/MM/RRRR') <= '30/09/2023'
and a.ide_poste=b.ide_poste and a.ide_gest=b.ide_gest and a.ide_jal=b.ide_jal and a.flg_cptab=b.flg_cptab and a.ide_ecr=b.ide_ecr
; 

insert into rech_doubl_exploit_V3 
select NVL(a.spec3,'NR') ide_poste,a.ide_poste ide_nd_emet,a.ide_cpt ide_cpt,a.cod_sens cod_sens,b.libn,a.observ,a.ide_gest ide_gest,
to_date(b.dat_jc,'DD/MM/RRRR'),to_date(b.dat_jc,'DD/MM/RRRR') dat_jc,'E' flg,a.mt,a.flg_cptab flg_cptab ,'E'
from fc_ligne a,fc_ecriture b, rm_poste c where 
a.ide_gest='2023' and a.flg_cptab='O' and a.ide_cpt in (select ide_cpt from fn_compte where flg_atrans='O')  and a.ide_jal <> 'JTRANSFERT' and to_date(b.dat_jc,'DD/MM/RRRR') <= '30/09/2023'
and a.ide_poste=b.ide_poste and a.ide_gest=b.ide_gest and a.ide_jal=b.ide_jal and a.flg_cptab=b.flg_cptab and a.ide_ecr=b.ide_ecr
and a.ide_poste=c.ide_poste;

commit;

---------------------- Restitution de données ----------------------------------

SET heading OFF
SET feedback OFF
SET VERIFY OFF

SET linesize 1000000


spool c:\Sygacut\Rap_Ctl_transfert_RPI.xls;
                        
select ide_typ_poste,ide_cpt Compte,ide_nd_emet Emetteur,sum(decode(FLG,'E',decode(cod_sens,'C',mt,0),0)) Credit1,sum(decode(FLG,'E',decode(cod_sens,'D',mt,0),0)) Debit1 
,a.ide_poste destinataire,sum(decode(position,'RCEP0',decode(flg_cptab,'O',decode(FLG,'R',decode(cod_sens,'C',mt,0),0),0),0)) Credit2,sum(decode(position,'RCEP0',decode(flg_cptab,'O',decode(FLG,'R',decode(cod_sens,'D',mt,0),0),0),0)) Debit2
,sum(decode(position,'RCHP1',decode(flg_cptab,'O',decode(FLG,'R',decode(cod_sens,'C',mt,0),0),0),0)) Credit2,sum(decode(position,'RCHP1',decode(flg_cptab,'O',decode(FLG,'R',decode(cod_sens,'D',mt,0),0),0),0)) Debit2
,sum(decode(position,'RCHP2',decode(flg_cptab,'O',decode(FLG,'R',decode(cod_sens,'C',mt,0),0),0),0)) Credit2,sum(decode(position,'RCHP2',decode(flg_cptab,'O',decode(FLG,'R',decode(cod_sens,'D',mt,0),0),0),0)) Debit2
,sum(decode(flg_cptab,'N',decode(FLG,'R',decode(cod_sens,'C',mt,0),0),0)) Credit3,sum(decode(flg_cptab,'N',decode(FLG,'R',decode(cod_sens,'D',mt,0),0),0)) Debit3
from rech_doubl_exploit_V3 a,rm_poste b where (a.ide_poste,ide_nd_emet,ide_cpt,ide_gest,dat_jc,mt) in 
(
select ide_poste,ide_nd_emet,ide_cpt,ide_gest,dat_jc,mt from rech_doubl_exploit_V3 
group by ide_poste,ide_nd_emet,ide_cpt,ide_gest,dat_jc,mt 
)
and a.ide_poste=b.ide_poste and (ide_nd_emet in (select ide_poste from rm_poste where ide_typ_poste ='TCDGI') or a.ide_poste in (select ide_poste from rm_poste where ide_typ_poste ='TCDGI'))
group by ide_typ_poste,ide_cpt,ide_nd_emet,a.ide_poste
order by ide_typ_poste,ide_cpt,ide_nd_emet,a.ide_poste;

spool off;

