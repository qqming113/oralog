--------------------------------------------------------
--  DDL for Procedure P_ORALOG
--------------------------------------------------------

/*******************************************************

  DESCRIPTION:      Receives a number of parameters from outside and marks the
                    main table with the execution details in a specific point
                    in time
  INPUT PARAMS:     N/A
  OUTPUT PARAMS:    N/A
  COMMENTS:

********************************************************/

set define off;

  CREATE OR REPLACE PROCEDURE "P_ORALOG"
(
        V_JOB_NAME                  IN VARCHAR2,
        V_START_DATE                IN DATE,
        V_END_DATE                  IN DATE,
        V_COMMENT_                  IN VARCHAR2,
        V_SUCCESSFULL               IN VARCHAR2,
        V_TOTAL_READ_ROWS           IN NUMBER,
        V_TOTAL_INSERTED_ROWS       IN NUMBER,
        V_TOTAL_DISCARDED_ROWS      IN NUMBER,
        V_TOTAL_UPDATED_ROWS        IN NUMBER,
        V_DB_USER                   IN VARCHAR2,
        V_JOB_OWNER                 IN VARCHAR2 := NULL,
        V_ETL                       IN NUMBER,
        V_JOB_TYPE                  IN VARCHAR2,
        V_DATA_DATE                 IN DATE DEFAULT NULL
) IS

--Query for a specific job
CURSOR C_JOB IS
SELECT *
  FROM JOB
 WHERE JOB_NAME=V_JOB_NAME;

V_JOB JOB%ROWTYPE;

--Query for a specific job and start moment
CURSOR C_JOB_LOG IS
SELECT *
  FROM ORALOG
 WHERE JOB_NAME=V_JOB_NAME
   AND START_DATE=V_START_DATE;

V_JOB_LOG ORALOG%ROWTYPE;

BEGIN

OPEN C_JOB;
FETCH C_JOB INTO V_JOB;

--When a new job is found, insert into control table
IF V_JOB.JOB_NAME IS NULL THEN
  INSERT INTO JOB (JOB_NAME, ETL, SUBJECT_AREA)
  VALUES (V_JOB_NAME, V_ETL, 'TBD');
END IF;

CLOSE C_JOB;


OPEN C_JOB_LOG;
FETCH C_JOB_LOG INTO V_JOB_LOG;

--When new job, insert into main logging table
IF V_JOB_LOG.JOB_NAME IS NULL THEN


   INSERT INTO ORALOG
   ( JOB_LOG_ID,
     JOB_NAME,
     START_DATE,
     END_DATE,
     COMMENT_,
     SUCCESSFULL,
     TOTAL_READ_ROWS,
     TOTAL_INSERTED_ROWS,
     TOTAL_DISCARDED_ROWS,
     TOTAL_UPDATED_ROWS,
     DB_USER,
     JOB_OWNER,
     ETL,
     JOB_TYPE,
     DATA_DATE
   )
   VALUES
   ( SEQ_ORALOG.NEXTVAL,
     V_JOB_NAME,
     V_START_DATE,
     V_END_DATE,
     V_COMMENT_,
     V_SUCCESSFULL,
     V_TOTAL_READ_ROWS,
     V_TOTAL_INSERTED_ROWS,
     V_TOTAL_DISCARDED_ROWS,
     V_TOTAL_UPDATED_ROWS,
     V_DB_USER,
     V_JOB_OWNER,
     V_ETL,
     V_JOB_TYPE,
     V_DATA_DATE);
ELSE

  --If job already exists, update with most current details
  UPDATE ORALOG
  SET
     END_DATE=V_END_DATE,
     TOTAL_READ_ROWS=V_TOTAL_READ_ROWS,
     TOTAL_INSERTED_ROWS=V_TOTAL_INSERTED_ROWS,
     TOTAL_DISCARDED_ROWS=V_TOTAL_DISCARDED_ROWS,
     TOTAL_UPDATED_ROWS=V_TOTAL_UPDATED_ROWS,
     SUCCESSFULL=V_SUCCESSFULL,
     COMMENT_=V_COMMENT_
  WHERE
     V_JOB_NAME  =JOB_NAME AND
     V_START_DATE=START_DATE;

 END IF;

CLOSE C_JOB_LOG;
END;

/
