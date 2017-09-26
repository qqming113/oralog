--------------------------------------------------------
--  DDL for Table JOB
--------------------------------------------------------

/*******************************************************

  DESCRIPTION:      Utility table where main procedure keeps track of job names
  INPUT PARAMS:     N/A
  OUTPUT PARAMS:    N/A
  COMMENTS:

********************************************************/

  CREATE TABLE "JOB"
   (
    "JOB_NAME"              VARCHAR2(255 BYTE),
	"SUBJECT_AREA"          VARCHAR2(50 BYTE),
	"ETL"                   NUMBER,
	"JOB_DSC"               VARCHAR2(255 BYTE),
	"JOB_NAME_DS"           VARCHAR2(255 BYTE),
	"JOB_NAME_PL"           VARCHAR2(255 BYTE),
	"JOB_PATH"              VARCHAR2(255 BYTE),
	"JOB_ID"                NUMBER,
	"JOB_TYPE"              NUMBER,
	"JOB_TYPE_DESC"         VARCHAR2(12 BYTE)
   )  ;
