select * from v$session
where blocking_session is not NULL
order by blocking_session
;

select * from v$session
where sid=1377;

ALTER SYSTEM KILL SESSION '1622,146' IMMEDIATE;
ALTER SYSTEM DISCONNECT SESSION 'sid,serial#' IMMEDIATE;

