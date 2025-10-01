select distinct a.NUM_BORDEREAU,a.POSTE_CENTRA,a.GESTION,a.CODE_FONCTION,a.POSTE,a.type_acte from SIGOBE_RNE.T_ACTE_RNE a, SIGOBE_RNE.T_ACTE_RNE_DETAIL b 
where a.STATUT='TR' 
 and A.gestion >'2022'
 and a.num_acte in
 (
    
'317109324100185',
'317219324100293',
'317219324100294',
'317219324100295',
'317219324100296',
'211782824100284',
'211782824100285',
'211782824100286',
'211782824100287'

 )
 and A.NUM_ACTE=B.NUM_ACTE_DETAIL 
 and A.NUM_BORDEREAU is not null
 --and ( (a.num_liquid in (select num_acte from SIGOBE_RNE.T_ACTE_RNE b where a.num_liquid=b.num_acte and a.poste=b.poste and b.type_acte in ('L','AL') ) 
  and ( (a.num_liquid in (select num_acte from SIGOBE_RNE.T_ACTE_RNE b , SIGOBE_RNE.T_ACTE_RNE_DETAIL c where a.num_liquid=b.num_acte and a.poste=b.poste and b.type_acte in ('L','AL') and b.NUM_ACTE=c.NUM_ACTE_DETAIL )
 and a.type_acte in ('M','AM'))
 or a.type_acte in ('AL','L'))
  order by NUM_BORDEREAU;