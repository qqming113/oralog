--------------------------------------------------------
--  DDL for Table ORALOG
--------------------------------------------------------

  CREATE TABLE "ORALOG" 
   (	
    "JOB_NAME"              VARCHAR2(50 BYTE), 
	"START_DATE"            DATE, 
	"END_DATE"              DATE, 
	"COMMENT_"              VARCHAR2(255 BYTE), 
	"SUCCESSFULL"           VARCHAR2(1 BYTE), 
	"TOTAL_READ_ROWS"       NUMBER, 
	"TOTAL_INSERTED_ROWS"   NUMBER, 
	"TOTAL_DISCARDED_ROWS"  NUMBER, 
	"TOTAL_UPDATED_ROWS"    NUMBER, 
	"DB_USER"               VARCHAR2(30 BYTE), 
	"JOB_OWNER"             VARCHAR2(30 BYTE), 
	"ETL"                   NUMBER(1,0), 
	"JOB_TYPE"              VARCHAR2(30 BYTE), 
	"DATA_DATE"             DATE, 
	"JOB_LOG_ID"            NUMBER
   )  ;
--------------------------------------------------------
--  DDL for Index PKC_JOB_LOG_01
--------------------------------------------------------

  CREATE UNIQUE INDEX "PKC_JOB_LOG_01" ON "ORALOG" ("JOB_LOG_ID");
  
--------------------------------------------------------
--  DDL for Index I_JOB_LOG
--------------------------------------------------------

  CREATE INDEX "I_JOB_LOG" ON "ORALOG" ("DB_USER", "JOB_NAME", "START_DATE");
  
--------------------------------------------------------
--  DDL for Index UKC_JOB_LOG
--------------------------------------------------------

  CREATE UNIQUE INDEX "UKC_JOB_LOG" ON "ORALOG" ("JOB_NAME", "START_DATE");
  
--------------------------------------------------------
--  Constraints for Table JOB_LOG
--------------------------------------------------------

  ALTER TABLE "ORALOG" MODIFY ("JOB_LOG_ID" NOT NULL ENABLE);
  ALTER TABLE "ORALOG" ADD CONSTRAINT "PKC_JOB_LOG_01" PRIMARY KEY ("JOB_LOG_ID");
