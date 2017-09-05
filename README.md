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



## Monitoring via SQL (AKA querying jobs)



## Have fun! :sunglasses:

Please report any issues you may encounter
