alter session set nls_date_format = 'DD/MM/RRRR';

exec ouvre_jc('2025','31/08/2025','461C');
exec NIABA.Gener_cloture_journee_pc_bis('2024','31/07/2024','411');

