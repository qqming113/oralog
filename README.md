# oralog
#### A logging utility for (Oracle) database jobs


## What this is

Whenever you have PL/SQL programs (procedures) that you want to check, you can integrate this code into your objects so you can:
* Monitor long-running jobs in real time while the are executing :white_check_mark:
* Log exact date and time from start to finish :white_check_mark:
* Assist in program debugging :beetle: by logging an exception and the _aproximate_ line in code where the error occurred :white_check_mark:

## Prerequisites

This utility is (currently) designed to run as a sandbox for objects within the same schema, so you will need permissions to create sequences, stored proceures and tables. You may also need additinal permissions to access DBMS_UTILITY and DBMS_LOCK system packages from your desired schema. Please contact your beloved DBA :unamused: for assistance (where applicable).

:one: Install sequence

:two: Install job table

:three: Install logging table

:four: Install stored procedure

Please see "SQL" folder with source code for prerequisites

## Clone this project

```bash
git clone https://github.com/yllanos/oralog.git
```

## Sample implementation

```sql
--------------------------------------------------------
--  DDL for Procedure P_SAMPLE
--------------------------------------------------------

  CREATE OR REPLACE PROCEDURE "P_SAMPLE" AS

  /********************************************************************************************
    DESCRIPTION:          
    IN PARAMETERS:        N/A
    OUT PARAMETERS:       N/A
    DATE CREATED:         2017-09-05
    AUTHOR:               Yamil Llanos (yamil.llanos@gmail.com)
    
    Example use:          
  *********************************************************************************************/

    --Variables
    v_job_name                  varchar2(30) := 'P_SAMPLE'; --< IMPORTANT: This should match name of procedure above >
    v_start_date                date         := sysdate;
    v_end_date                  date;
    v_comment_                  varchar2(255);
    v_successfull               varchar2(1)  :='N';
    v_total_readed_rows         number:=0;
    v_total_inserted_rows       number:=0;
    v_total_discarded_rows      number:=0;
    v_total_update_rows         number:=0;
    v_usuario_bd                varchar2(30) := user;
    v_job_owner                 varchar2(30) := 'CRMEF';  --< Set this to whatever DB user schema will run this procedure >
    v_etl                       number(1)    := 1;            
    v_job_type                  varchar2(30) := 'PL/SQL';     
    v_where                     varchar2(200) ;
    P_DATE                      date := sysdate;

    
BEGIN

    v_end_date := sysdate;
    v_comment_ := 'Starting '||to_char(P_DATE,'YYYY-MM-DD');
    p_oralog (v_job_name
                  ,v_start_date
                  ,v_end_date
                  ,v_comment_
                  ,v_successfull
                  ,v_total_readed_rows
                  ,v_total_inserted_rows
                  ,v_total_discarded_rows
                  ,v_total_update_rows
                  ,v_usuario_bd
                  ,v_job_owner
                  ,v_etl
                  ,v_job_type
                  ,P_DATE);    


    -- So, this is where the action starts to happen
    dbms_lock.sleep( 120 ); 
    -- And this is the start of the end


    v_end_date := sysdate;
    v_successfull := 'Y';
    v_comment_ := 'Ended OK '||to_char(P_DATE,'YYYY-MM-DD');
    p_oralog (v_job_name
                  ,v_start_date
                  ,v_end_date
                  ,v_comment_
                  ,v_successfull
                  ,v_total_readed_rows
                  ,0
                  ,v_total_discarded_rows
                  ,v_total_update_rows
                  ,v_usuario_bd
                  ,v_job_owner
                  ,v_etl
                  ,v_job_type
                  ,P_DATE);
    COMMIT;
   
exception when others then
  v_end_date := sysdate;
  v_comment_ := (v_comment_ ||DBMS_UTILITY.format_error_backtrace || ' ' || sqlcode || ' ' || sqlerrm);
  p_oralog (v_job_name
                ,v_start_date
                ,v_end_date
                ,v_comment_
                ,v_successfull
                ,v_total_readed_rows
                ,v_total_inserted_rows
                ,v_total_discarded_rows
                ,v_total_update_rows
                ,v_usuario_bd
                ,v_job_owner
                ,v_etl
                ,v_job_type
                ,P_DATE);
   ROLLBACK;   

end;
/

```

Right after the _BEGIN_ statement, you should assign to a variable the current `sysdate` and execute a call to `p_oralog`. This will log to `oralog` table a new job and the exact time it started running.

:bulb: You can repeat the process every time you need to set a "checkpoint" on your program code. Don't worry, `p_oralog` is smart enough to update the record for this specific job instance running every time a checkpoint is added :smiley:

You should also include a call before the end of your procedure to allow for logging of last execution time. Also, as you see on example, there is an additional call is an exception if raised by the DB engine, this will log the current time and the aproximate line where the error was raised, very useful for long and complex programs!

NOTE: DB lock is there to simulate a long running operation or group of operations.

## Monitoring via SQL (AKA querying jobs)

If you run the sample above or your own procedures with the suggested code, you only need to:

```sql
SELECT *
FROM ORALOG
WHERE JOB_NAME = 'YOUR_PROCEDURE_NAME'
```

_Or_

```sql
SELECT JOB_NAME, START_DATE, END_DATE, COMMENT_, SUCCESSFULL
FROM ORALOG
WHERE JOB_NAME = 'YOUR_PROCEDURE_NAME'
ORDER BY 2 DESC;
```

Ideally, you should do this while your procedure is runnig. It´s safe to also query afterwards anyway.

## Issues

It doesn't work so well when subprograms are called from your main procedure (unless you also implement this on your subprograms :wink: )

## Have fun! :sunglasses:

Please :pray: report any issues you may encounter

