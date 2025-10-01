BEGIN
  SYS.DBMS_SCHEDULER.DROP_JOB
    (job_name  => 'NIABA.ASTERWEB_JOB_PREPA_DEVERS');
END;
/

BEGIN
  SYS.DBMS_SCHEDULER.CREATE_JOB
    (
       job_name        => 'NIABA.ASTERWEB_JOB_PREPA_DEVERS'
      ,start_date      => TO_TIMESTAMP_TZ('2025/03/17 09:05:00.030827 +00:00','yyyy/mm/dd hh24:mi:ss.ff tzh:tzm')
      ,repeat_interval => 'FREQ=MINUTELY;INTERVAL=90'
      ,end_date        => TO_TIMESTAMP_TZ('2025/12/31 23:59:08.035819 +00:00','yyyy/mm/dd hh24:mi:ss.ff tzh:tzm')
      ,job_class       => 'DEFAULT_JOB_CLASS'
      ,job_type        => 'STORED_PROCEDURE'
      ,job_action      => 'NIABA.PM_PREPA_DEVERS'
      ,comments        => NULL
    );
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE
    ( name      => 'NIABA.ASTERWEB_JOB_PREPA_DEVERS'
     ,attribute => 'RESTARTABLE'
     ,value     => FALSE);
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE
    ( name      => 'NIABA.ASTERWEB_JOB_PREPA_DEVERS'
     ,attribute => 'LOGGING_LEVEL'
     ,value     => SYS.DBMS_SCHEDULER.LOGGING_OFF);
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE_NULL
    ( name      => 'NIABA.ASTERWEB_JOB_PREPA_DEVERS'
     ,attribute => 'MAX_FAILURES');
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE_NULL
    ( name      => 'NIABA.ASTERWEB_JOB_PREPA_DEVERS'
     ,attribute => 'MAX_RUNS');
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE
    ( name      => 'NIABA.ASTERWEB_JOB_PREPA_DEVERS'
     ,attribute => 'STOP_ON_WINDOW_CLOSE'
     ,value     => FALSE);
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE
    ( name      => 'NIABA.ASTERWEB_JOB_PREPA_DEVERS'
     ,attribute => 'JOB_PRIORITY'
     ,value     => 3);
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE_NULL
    ( name      => 'NIABA.ASTERWEB_JOB_PREPA_DEVERS'
     ,attribute => 'SCHEDULE_LIMIT');
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE
    ( name      => 'NIABA.ASTERWEB_JOB_PREPA_DEVERS'
     ,attribute => 'AUTO_DROP'
     ,value     => TRUE);
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE
    ( name      => 'NIABA.ASTERWEB_JOB_PREPA_DEVERS'
     ,attribute => 'RESTART_ON_RECOVERY'
     ,value     => FALSE);
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE
    ( name      => 'NIABA.ASTERWEB_JOB_PREPA_DEVERS'
     ,attribute => 'RESTART_ON_FAILURE'
     ,value     => FALSE);
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE
    ( name      => 'NIABA.ASTERWEB_JOB_PREPA_DEVERS'
     ,attribute => 'STORE_OUTPUT'
     ,value     => TRUE);
END;
/