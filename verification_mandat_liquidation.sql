select a.mandat_code,c.fon_libelle POSTE_MANDAT,
a.liq_num,
(select fon_libelle from t_fonctions@sigta where fon_code=b.fonc_cod) POSTE_LIQUIDATION,
a.objet_mandat,a.mandat_mont,a.fonc_cpt FONCTION_MANDAT,b.fonc_cod FONCTION_LIQUIDATION
from sib_mandat a, sib_liquidation b, t_fonctions@sigta c
where a.annee='2021'
and a.liq_num=b.liq_num
and  mandat_code in
('314020721100101',
'314014621100099',
'314014621100100',
'314173521100002',
'314014121100210',
'314014121100207',
'314014121100209',
'314014121100208',
'314022021100051',
'314207821100292',
'314207821100293',
'314133021100028',
'314133021100026',
'314133521100016',
'314133521100024',
'314133521100025',
'314133521100026',
'314133521100027',
'314133521100028',
'314133521100029',
'314133521100030',
'314133521100040',
'314133521100041',
'314133521100042',
'314133521100043',
'314133521100044',
'314133521100048',
'314133721100006',
'314133721100011',
'314133021100010',
'314133021100027',
'314133021100029')
and a.fonc_cpt=c.fon_code
--and b.fonc_cod=c.fon_code
--and a.fonc_cpt<>b.fonc_cod
;

select a.mandat_code,c.fon_libelle POSTE_MANDAT,
a.liq_num,
(select fon_libelle from t_fonctions@sigta where fon_code=b.fonc_cod) POSTE_LIQUIDATION,
a.objet_mandat,a.mandat_mont,a.fonc_cpt FONCTION_MANDAT,b.fonc_cod FONCTION_LIQUIDATION
from sib_mandat a, sib_liquidation b, t_fonctions@sigta c
where a.annee='2021'
and a.liq_num=b.liq_num
and  mandat_code in
('314020721100198')
and a.fonc_cpt=c.fon_code