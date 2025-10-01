drop table tbl_transf;

create table tbl_transf as
select compte, emetteur, montant_emis_debit emis_debit, montant_emis_credit emis_credit, 
       destinataire poste, montant_bonne_periode_debit ok_debit, montant_bonne_periode_credit ok_credit,
       sept_pris_en_octobre_debit non_ok_debit, sept_pris_en_octobre_credit non_ok_credit,
       octobre_pris_sept_debit ok_non_debit, octobre_pris_sept_credit ok_non_credit,
       montant_non_denoue_debit pas_debit, montant_non_denoue_credit pas_credit,
       ((montant_bonne_periode_debit + montant_bonne_periode_credit + sept_pris_en_octobre_debit + sept_pris_en_octobre_credit + montant_non_denoue_debit + montant_non_denoue_credit) 
       - 
       (montant_emis_debit + montant_emis_credit)) anomalie
from tableau_transfert
;

select * from 
tbl_transf
where anomalie <> 0;