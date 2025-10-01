--alter session set nls_date_format = 'DD/MM/RRRR';

variable sortie refcursor
--exec PIAF_ADM.TAC_ASTERWEB(:sortie)
exec PIAF_ADM.ASN_GET_FICHE_CPT_CF('2025','510C','390315','01/04/2025','31/05/2025',:sortie)
--exec PIAF_ADM.ASN_GET_FICHE_PGSP('2025','510C','01/01/2025','31/05/2025',:sortie)
--exec PIAF_ADM.ASN_GET_TAC_FOR_ALL('2025',:sortie)
--exec PIAF_ADM.ASN_GET_TAC_DTE_POSTE('2025','30/04/2025','464',:sortie)
--exec PIAF_ADM.ASN_GET_TAC_DTE_FOR_ALL('2025','30/04/2025',:sortie)
print sortie
--exec PIAF_ADM.MC_CENTRA_INABOUTI('620','620C', :sortie)
--exec PIAF_ADM.MC_LISTE_POSTE_CENTRA(:sortie)
--exec PIAF_ADM.MC_RECHERCHE_USER('B256313', :sortie)


--update fh_util set pwd='.', dat_pwd=ADD_MONTHS(sysdate,-4)
--where cod_util='J343728';

--alter user J343728 identified by a;