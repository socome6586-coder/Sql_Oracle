-----------------------------------------------------------------------------
DDL : data definition language
구조를 생성, 변경, 제거

CREATE 
ALTER
DROP

계정생성
아이디 : SKY
비밀번호 : 1234

cmd 실행

Microsoft Windows [Version 10.0.19045.6218]
(c) Microsoft Corporation. All rights reserved.

C:\Users\GGG>sqlplus /nolog

SQL> conn /as sysdba
연결되었습니다.

SQL> show user
USER은 "SYS"입니다

SQL> alter session set "_ORACLE_SCRIPT"=true;

세션이 변경되었습니다.

SQL> create user SKY identifeid by 1234;
create user SKY identifeid by 1234
                *
1행에 오류:
ORA-00922: 누락된 또는 부적합한 옵션


SQL> create user SKY identified by 1234;

사용자가 생성되었습니다.

SQL> grant connect, resource to SKY;

권한이 부여되었습니다.

SQL> alter user SKY default tablespace users quota unlimited on users;

사용자가 변경되었습니다.

----------------------------------------------------------------------
새 계정으로 접속 한 뒤에 작업

sky 에서 hr 계정의 data를 가져온다
sqlplus 에서 작업
1. hr 로 로그인
    window + r : cmd
    c:\> sqlplus hr/1234

2. hr 에서 다른 계정인 sky 에게 select 할 수 있는 권한을 부여
    > grant select on employees to sky;

3. sky 로 로그인
    SQL> conn sky/1234
    연결되었습니다.
    SQL> show user
    USER은 "SKY"입니다
    SQL> select * from tab;
    선택된 레코드가 없습니다.

4. sky 에서 hr 계정의 Employees 를 조회
    SQL> select * from hr.employees;   -- 조회 성공
    SQL> select * from hr.departments; -- 조회 실패
    
-----------------------------------------------------------------------------
ORACLE 의 TABLE 복사하기
hr 의 employees TABLE 을 복사해서 sky 로 가져온다

[1] 테이블 생성
1. 테이블 복사
    대상 : 테이블 구조, 데이터(제약 조건의 일부만 복사(NOT NULL))

    1) 구조, 데이터 다 복사, 제약조건은 일부만 복사(null) - 
    CREATE TABLE EMP1
    AS 
      SELECT * FROM hr.EMPLOYEES;
    
      
    2) 구조, 데이터 다 복사, 50번, 80번 부서만 복사 -- 59건
    CREATE TABLE EMP2
    AS 
      SELECT * FROM hr.EMPLOYEES
      WHERE DEPARTMENT_ID IN (50, 80);
    
      
    3) DATA 빼고 구조만 복사
    CREATE TABLE EMP3
    AS
      SELECT * FROM hr.EMPLOYEES
      WHERE 1 = 0; 
    
    
    4) 구조만 복사 된 TABLE EMP3 에 DATA 만 추가
    CREATE TABLE EMP4
    AS
      SELECT * FROM hr.EMPLOYEES
      WHERE 1 = 0;
      
 -- DATA 만 추가
INSERT INTO EMP4
SELECT * FROM hr.EMPLOYEES;
COMMIT;


    5) 일부 칼럼만 복사해서 새로운 테이블 생성
    CREATE TABLE  EMP5
    AS
      SELECT EMPLOYEE_ID                   EMPID,
             FIRST_NAME ||' '|| LAST_NAME  ENAME,
             SALARY                        SAL,
             SALARY * COMMISSION_PCT       BONUS,
             MANAGER_ID                    MGR,
             DEPARTMENT_ID                 DEPTID
       FROM  hr.EMPLOYEES;

