CREATE OR REPLACE PROCEDURE PIAF_ADM.P_TRANSF_NON_ABOUTI_PC(v_gest varchar2,p_poste_emet varchar2, p_dat_ecr date) IS


CURSOR cur_fc_ligne is select a.ide_poste,a.ide_gest,a.ide_jal,a.flg_cptab,a.ide_ecr,a.ide_lig,a.cod_sens,a.ide_cpt,a.mt,a.spec2,a.spec3,a.observ,a.dat_transf,b.dat_jc from fc_ligne a, fc_ecriture b
			where a.ide_poste=b.ide_poste
			and a.ide_gest= b.ide_gest
			and a.ide_jal=b.ide_jal
			and a.ide_ecr=b.ide_ecr
			and a.flg_cptab=b.flg_cptab
			and a.ide_poste=p_poste_emet
			and a.ide_gest=v_gest
			and a.ide_jal<>'JTRANSFERT'
			and a.ide_cpt in ('391.30','391.31')
			and a.flg_cptab='O'
            and a.dat_ecr<=p_dat_ecr
			order by 1;

			
v_ide_cpt   			FC_LIGNE.ide_cpt%TYPE;
v_mt        			FC_LIGNE.mt%TYPE;
v_cod_ferm  			FC_CALEND_HIST.cod_ferm%TYPE;
v_count     			INTEGER;
v_ide_ecr   			FC_LIGNE.ide_ecr%TYPE;
v_flg_cptab 			FC_LIGNE.flg_cptab%TYPE;
v_ide_poste 			FC_LIGNE.ide_poste%TYPE;
v_ide_poste_transf 		T_TRANSFERT_NON_ABOUTI.ide_poste_dest%TYPE;
v_num_transf 	   		FC_TRANSFERT.num_transf%TYPE;

BEGIN

	 --DELETE FROM T_TRANSFERT_NON_ABOUTI;
	 
	 --COMMIT;

	 FOR v_cur in cur_fc_ligne LOOP

		    BEGIN
				 select cod_ferm INTO v_cod_ferm from fc_calend_hist where ide_poste=p_poste_emet and ide_gest=v_gest and dat_jc=v_cur.dat_jc;
			
			EXCEPTION WHEN NO_DATA_FOUND THEN
					  
					  NULL;
			END;
			
			IF v_cod_ferm='C' and v_cur.dat_transf is null THEN
			
			   INSERT INTO T_TRANSFERT_NON_ABOUTI (IDE_POSTE_EMET ,IDE_GEST,IDE_JAL ,FLG_CPTAB ,IDE_ECR ,IDE_LIG ,IDE_CPT ,MT, IDE_POSTE_DEST ,DAT_TRANSF ,COD_FERM,IDE_CPT_CONTREPARTIE,OBSERV,DAT_JC_EMET,COD_SENS)
			   VALUES (v_cur.ide_poste,v_cur.ide_gest,v_cur.ide_jal,v_cur.flg_cptab,v_cur.ide_ecr,v_cur.ide_lig,v_cur.ide_cpt,v_cur.mt,v_cur.spec3,v_cur.dat_transf,v_cod_ferm,v_cur.spec2,v_cur.observ,v_cur.dat_jc,v_cur.cod_sens);

			   COMMIT;
			 
			ELSE -- v_cur.dat_transf is not null THEN
			 
			 	BEGIN
				
					select ide_poste,ide_poste_transf,num_transf INTO v_ide_poste,v_ide_poste_transf,v_num_transf from fc_transfert a
					where a.ide_jal=v_cur.ide_jal
					and a.ide_ecr=v_cur.ide_ecr
					and a.ide_lig=v_cur.ide_lig
					and a.flg_cptab=v_cur.flg_cptab
					and a.ide_poste=p_poste_emet
					and a.ide_gest=v_gest;
					
					
					
						
					--IF v_count =0 THEN
				EXCEPTION WHEN NO_DATA_FOUND THEN
	
						   INSERT INTO T_TRANSFERT_NON_ABOUTI (IDE_POSTE_EMET ,IDE_GEST,IDE_JAL ,FLG_CPTAB ,IDE_ECR ,IDE_LIG ,IDE_CPT ,MT, IDE_POSTE_DEST ,DAT_TRANSF ,COD_FERM,IDE_CPT_CONTREPARTIE,OBSERV,DAT_JC_EMET, COD_SENS)
						   VALUES (v_cur.ide_poste,v_cur.ide_gest,v_cur.ide_jal,v_cur.flg_cptab,v_cur.ide_ecr,v_cur.ide_lig,v_cur.ide_cpt,v_cur.mt,v_cur.spec3,v_cur.dat_transf,v_cod_ferm,v_cur.spec2,v_cur.observ,v_cur.dat_jc,v_cur.cod_sens);
	
				   		   COMMIT;
	
					--END IF;
				
				END;
				
				BEGIN
					
					select a.ide_ecr  INTO v_ide_ecr  from fc_transfert a, fc_ligne b
					where a.ide_poste=b.ide_poste
					and a.ide_gest= b.ide_gest
					and a.ide_jal=b.ide_jal
					and a.ide_ecr=b.ide_ecr
					and a.ide_lig=b.ide_lig
					and a.flg_cptab=b.flg_cptab
					and a.ide_poste=v_ide_poste_transf
					and a.ide_gest=v_gest
					and cod_sens_transf='R'
					and num_transf=v_num_transf
					and ide_poste_transf=v_ide_poste
					and a.ide_jal='JTRANSFERT'
					and b.ide_cpt=v_cur.ide_cpt
					and b.mt=v_cur.mt
					and a.flg_cptab='N';

					--IF v_flg_cptab='N' THEN
					
					   INSERT INTO T_TRANSFERT_NON_ABOUTI (IDE_POSTE_EMET ,IDE_GEST,IDE_JAL ,FLG_CPTAB ,IDE_ECR ,IDE_LIG ,IDE_CPT ,MT, IDE_POSTE_DEST ,DAT_TRANSF ,COD_FERM ,FLG_CPTAB_DEST ,IDE_ECR_DEST,IDE_CPT_CONTREPARTIE,OBSERV,DAT_JC_EMET,COD_SENS)
					   VALUES (v_cur.ide_poste,v_cur.ide_gest,v_cur.ide_jal,v_cur.flg_cptab,v_cur.ide_ecr,v_cur.ide_lig,v_cur.ide_cpt,v_cur.mt,v_cur.spec3,v_cur.dat_transf,v_cod_ferm,'N',v_ide_ecr,v_cur.spec2,v_cur.observ,v_cur.dat_jc,v_cur.cod_sens);
					
					   COMMIT;
					--END IF;
					
				EXCEPTION WHEN NO_DATA_FOUND THEN 
						  	   				 	  BEGIN
														select count(*) INTO v_count from fc_transfert a
														where a.ide_poste=v_ide_poste_transf
														and a.ide_gest=v_gest
														and cod_sens_transf='R'
														and num_transf=v_num_transf
														and ide_poste_transf=v_ide_poste;
														--and a.ide_jal='JTRANSFERT'
														--and b.ide_cpt=v_cur.ide_cpt
														--and b.mt=v_cur.mt;
														--and a.flg_cptab='O';
									
														IF v_count=0 THEN
														
														   INSERT INTO T_TRANSFERT_NON_ABOUTI (IDE_POSTE_EMET ,IDE_GEST,IDE_JAL ,FLG_CPTAB ,IDE_ECR ,IDE_LIG ,IDE_CPT ,MT, IDE_POSTE_DEST ,DAT_TRANSF ,COD_FERM ,FLG_CPTAB_DEST ,IDE_ECR_DEST,IDE_CPT_CONTREPARTIE,OBSERV,DAT_JC_EMET,COD_SENS)
														   VALUES (v_cur.ide_poste,v_cur.ide_gest,v_cur.ide_jal,v_cur.flg_cptab,v_cur.ide_ecr,v_cur.ide_lig,v_cur.ide_cpt,v_cur.mt,v_cur.spec3,v_cur.dat_transf,v_cod_ferm,NULL,NULL,v_cur.spec2,v_cur.observ,v_cur.dat_jc,v_cur.cod_sens);
														
														   COMMIT;
														   
														END IF;
														
													END;
													
						  WHEN TOO_MANY_ROWS THEN NULL;
				END;
				 
					
			 END IF;
			
			
	 END LOOP;
END;
/
