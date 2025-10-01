BEGIN
  SYS.DBMS_SCHEDULER.CREATE_JOB
    (
       job_name        => 'PIAF_ADM.JOB_MAJ_SOLDE_CPT5'
      ,start_date      => TO_TIMESTAMP_TZ('2024/10/08 15:45:50.018234 +00:00','yyyy/mm/dd hh24:mi:ss.ff tzh:tzm')
      ,repeat_interval => 'FREQ=MINUTELY;INTERVAL=60'
      ,end_date        => TO_TIMESTAMP_TZ('2024/12/31 23:59:01.200804 +00:00','yyyy/mm/dd hh24:mi:ss.ff tzh:tzm')
      ,job_class       => 'DEFAULT_JOB_CLASS'
      ,job_type        => 'STORED_PROCEDURE'
      ,job_action      => 'PIAF_ADM.MAJ_SOLDE_CPT5'
      ,comments        => NULL
    );
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE
    ( name      => 'PIAF_ADM.JOB_MAJ_SOLDE_CPT5'
     ,attribute => 'RESTARTABLE'
     ,value     => FALSE);
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE
    ( name      => 'PIAF_ADM.JOB_MAJ_SOLDE_CPT5'
     ,attribute => 'LOGGING_LEVEL'
     ,value     => SYS.DBMS_SCHEDULER.LOGGING_OFF);
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE_NULL
    ( name      => 'PIAF_ADM.JOB_MAJ_SOLDE_CPT5'
     ,attribute => 'MAX_FAILURES');
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE_NULL
    ( name      => 'PIAF_ADM.JOB_MAJ_SOLDE_CPT5'
     ,attribute => 'MAX_RUNS');
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE
    ( name      => 'PIAF_ADM.JOB_MAJ_SOLDE_CPT5'
     ,attribute => 'STOP_ON_WINDOW_CLOSE'
     ,value     => FALSE);
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE
    ( name      => 'PIAF_ADM.JOB_MAJ_SOLDE_CPT5'
     ,attribute => 'JOB_PRIORITY'
     ,value     => 3);
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE_NULL
    ( name      => 'PIAF_ADM.JOB_MAJ_SOLDE_CPT5'
     ,attribute => 'SCHEDULE_LIMIT');
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE
    ( name      => 'PIAF_ADM.JOB_MAJ_SOLDE_CPT5'
     ,attribute => 'AUTO_DROP'
     ,value     => FALSE);

  SYS.DBMS_SCHEDULER.ENABLE
    (name                  => 'PIAF_ADM.JOB_MAJ_SOLDE_CPT5');
END;
/
