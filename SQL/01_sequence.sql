--------------------------------------------------------
--  DDL for Sequence SEQ_ORALOG
--------------------------------------------------------

/*******************************************************

  DESCRIPTION:      This sequence will keep track of individual jobs by
                    assigning a unique key
  INPUT PARAMS:     N/A
  OUTPUT PARAMS:    N/A
  COMMENTS:

********************************************************/

   CREATE SEQUENCE  "SEQ_ORALOG"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 ORDER  NOCYCLE ;
