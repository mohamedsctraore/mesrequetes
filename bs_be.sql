create table bs_be_mohamed as
select ide_poste, ide_cpt, debit as "DEBIT BS 2021", credit as "CREDIT BS 2021" from bs_2021_mohamed
--order by ide_poste, ide_cpt
union all
select ide_poste, ide_cpt, debit as "DEBIT BE 2022", credit as "CREDIT BE 2022" from be_2022_mohamed
--order by ide_poste, ide_cpt
;

select * from bs_be_mohamed;

select unique a.ide_poste, a.ide_cpt, a.debit as "DEBIT BS 2021", a.credit as "CREDIT BS 2021", b.ide_cpt, b.debit as "DEBIT BE 2022", b.credit as "CREDIT BE 2022" 
from bs_2021_mohamed a, be_2022_mohamed b
where a.ide_poste=b.ide_poste
--and b.ide_cpt=a.ide_cpt
order by a.ide_poste, a.ide_cpt, b.ide_cpt
;