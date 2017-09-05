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
    p_job_log (v_job_name
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
    p_job_log (v_job_name
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
  p_job_log (v_job_name
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

## Monitoring via SQL (AKA querying jobs)



## Have fun! :sunglasses:

Please report any issues you may encounter

