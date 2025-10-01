--select * from cut_nivellement
update cut_nivellement set niv_dte_transfert = '31/12/2022'
where niv_dte_transfert like '%/23'
and niv_statut = 'V'
and (chq_code, pc_code) in
(
select chq_code, chq_pc_code from cut_cheque_tresor
where chq_dte_saisie < '01/01/2023'
);