SELECT SYSDATE FROM DUAL;

SELECT EMPLOYEE_ID, HIRE_DATE
FROM   EMPLOYEES
WHERE  HIRE_DATE = '15/09/21';

ALTER SESSION SET NLS_DATE_FORMAT= "YYYY-MM-DD HH24:MI:SS";

SELECT EMPLOYEE_ID, HIRE_DATE
FROM   EMPLOYEES
WHERE  HIRE_DATE = '2015/09/21';

-------------------------------------------------
-- 앞으로 날짜 표현은 다음과 같이 표현
SELECT EMPLOYEE_ID, TO_CHAR(HIRE_DATE, 'YYYY-MM-DD')
FROM   EMPLOYEES
--WHERE  TO_CHAR(HIRE_DATE, 'YYYY-MM-DD') = '2015-09-21';
WHERE  TO_CHAR(HIRE_DATE, 'YYYY-MM-DD') = '2026-04-07';


-- 입사 후 일주일 이내인 직원 명단
SELECT EMPLOYEE_ID, TO_DATE(HIRE_DATE, 'YYYY-MM-DD')
FROM   EMPLOYEES
WHERE  HIRE_DATE >= SYSDATE - 7;


-- 08월 입사자의 사번, 이름, 입사일을 입사일 순으로 OK
SELECT EMPLOYEE_ID 사번,
       FIRST_NAME || ' ' || LAST_NAME 이름, 
       TO_CHAR(HIRE_DATE, 'YYYY-MM-DD') 입사일 -- 셀렉터에서는 표현하기 위함
FROM   EMPLOYEES
WHERE  TO_CHAR(HIRE_DATE, 'MM') ='08';  -- WHERE에서는 뽑아내기(08월) 위함


-- 17. 부서 번호 80이 아닌 직원
SELECT EMPLOYEE_ID, DEPARTMENT_ID
FROM   EMPLOYEES
WHERE  DEPARTMENT_ID <> 80;    -- != 같지 않아
                               -- =, <>, >, >=, <, <=, BETWEEN ~AND
                               -- +, -, *, /, MOD()
-- 2026년 74 07일 17시 16분 04초 오후 수요일
-- 한자로 출력
SELECT SYSDATE, TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'), TO_CHAR(SYSDATE, 'DAY AM')
FROM   DUAL;

-- 오전/오후
-- 년월일시분초
-- 일월화수목금토
-- 요일

SELECT    TO_CHAR(SYSDATE, 'YYYY') || '年'
       || TO_CHAR(SYSDATE, 'MM')   || '月'
       || TO_CHAR(SYSDATE, 'DD')   || '日'
       || TO_CHAR(SYSDATE, 'HH24') || '時'
       || TO_CHAR(SYSDATE, 'MI')   || '分'
       || TO_CHAR(SYSDATE, 'SS')   || '秒'
       || CASE TO_CHAR(SYSDATE, 'DY')
          WHEN '일' THEN '日'
          WHEN '월' THEN '月'
          WHEN '화' THEN '火'
          WHEN '수' THEN '水'
          WHEN '목' THEN '木'
          WHEN '금' THEN '金'
          WHEN '토' THEN '土'
          END                      || '曜日'
       || DECODE( TO_CHAR(SYSDATE, 'AM'), '오전', '午前', '午後' )

FROM   DUAL;


-- 1) TO_CHAR 활용
SELECT SYSDATE, 
       TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS DAY AM') 날짜1,
       TO_CHAR(SYSDATE, 'YYYY"년"MM"월"DD"일" HH24"시"MI"분"SS"초" DAY AM') 날짜2,
       TO_CHAR(SYSDATE, 'YYYY"年"MM"月"DD"日" HH24"時"MI"分"SS"秒" DAY AM') 날짜3,
       TO_CHAR(SYSDATE, 'AM')
FROM   DUAL;

-- 2) IF를 구현
-- 2-1) NVL(), NVL2()
-- 사번, 이름, 월급, COMMISSION_PCT(단 null이면 0으로 출력)
SELECT EMPLOYEE_ID                    사번,
       FIRST_NAME || ' ' || LAST_NAME 이름,
       SALARY                         월급,
       NVL(COMMISSION_PCT, 0)         COMMISSION_PCT,
       NVL2(COMMISSION_PCT, SALARY+(SALARY*COMMISSION_PCT), SALARY) 보너스
FROM   EMPLOYEES;


-- 2-2) NULLIF(expr1, expr2)
-- 둘을 비교해서 같으면 null, 같지 않으면 expr1
  


-- 2-3) DECODE() : ORACLE
-- DECODE (expr, search1, result1, 
--               search2, result2, 
--               …, 
--               default)
-- DECODE는 expr과 search1을 비교해 두 값이 같으면 result1을, 
-- 같지 않으면 다시 search2와 비교해 값이 같으면 result2를 반환하고, 
-- 이런 식으로 계속 비교한 뒤 최종적으로 같은 값이 없으면 default 값을 반환한다.
-- 사번, 부서번호(단 부서번호가 null이면 '부서없음' 표시)
SELECT EMPLOYEE_ID 사번, 
       -- NVL(DEPARTMENT_ID, '부서없음') 부서번호 -- 부서번호는 숫자, 부서없음은 문자열이라 실행 안 됨
       DECODE(DEPARTMENT_ID, NULL, '부서없음', DEPARTMENT_ID)
FROM   EMPLOYEES;


SELECT TO_CHAR(SYSDATE, 'AM'),
       DECODE(TO_CHAR(SYSDATE, 'AM'),'오전', '午前', '午後')
FROM   DUAL;



--------------------------------------------
/*
10	Administration
20	Marketing
30	Purchasing
40	Human Resources
50	Shipping
60	IT
70	Public Relations
80	Sales
90	Executive
100	Finance
110	Accounting
*/
-- DECODE 로
-- 사번, 이름, 부서명
SELECT DEPARTMENT_ID                  사번, 
       FIRST_NAME || ' ' || LAST_NAME 이름,
       DECODE(DEPARTMENT_ID, 10, 'Administration',
                             20, 'Marketing',
                             30, 'Purchasing',
                             40, 'Human Resources',
                             50, 'Shipping',
                             60, 'IT',
                             70, 'Public Relations',
                             80, 'Sales',
                             90, 'Executive',
                             100, 'Finance',
                             110, 'Accounting',
                                 '부서 없음') 부서명
FROM   EMPLOYEES;

-- 사번, 이름, 부서명 : 모든 부서명, NULL : 부서 없음
SELECT EMPLOYEE_ID                    사번, 
       FIRST_NAME || ' ' || LAST_NAME 이름,
       DECODE(DEPARTMENT_ID, 10, 'Administration',
                             20, 'Marketing',
                             30, 'Purchasing',
                             40, 'Human Resources',
                             50, 'Shipping',
                             60, 'IT',
                             70, 'Public Relations',
                             80, 'Sales',
                             90, 'Executive',
                             100, 'Finance',
                             110, 'Accounting',
                                  '부서 없음') 부서명
FROM   EMPLOYEES;


-- null 이 계산에 포함되면 결과는 null
-- 직원 명단, 직원의 월급, 보너스 출력 연봉 출력
SELECT EMPLOYEE_ID                                 사번,
       FIRST_NAME || ' ' || LAST_NAME              이름,
       SALARY                                      월급,
       NVL(SALARY*COMMISSION_PCT, 0)               보너스,
       SALARY * 12 + NVL(SALARY*COMMISSION_PCT, 0) 연봉 
FROM   EMPLOYEES;


--------------------------------------------
-- 3) CASE WHEN THEN END
-- WHEN  SCORE  BETWEEN  90 AND 100   THEN 'A'
-- WHEN  90 <= SCORE AND SCORE <= 100 THEN 'A'

-- 사번, 이름, 부서명
SELECT EMPLOYEE_ID                      사번,
       FIRST_NAME || ' ' || LAST_NAME   이름,
       CASE DEPARTMENT_ID
         WHEN 60   THEN 'IT'
         WHEN 80   THEN 'Sales'
         WHEN 90   THEN 'Executive'
         ELSE           '그 외'
       END
FROM   EMPLOYYES;

SELECT EMPLOYEE_ID                      사번,
       FIRST_NAME || ' ' || LAST_NAME   이름,
       CASE
         WHEN DEPARTMENT_ID = 60   THEN 'IT'
         WHEN DEPARTMENT_ID = 80   THEN 'Sales'
         WHEN DEPARTMENT_ID = 90   THEN 'Executive'
         ELSE           '그 외'
       END                                 부서명
FROM   EMPLOYEES;

----------------------------------------------
-- 집계함수 : AGGREGATE 함수
-- 모든 집계함수는 null 값은 포함하지 않는다
-- sum(), avg(), min(), max(), count(), STDDEV(), variance()
-- 합계,  평균,  최소,  최대,  줄 수,   표준편차, 분산
-- 그루핑 : GROUP BY
-- ~별 인원수

SELECT * FROM EMPLOYEES;
SELECT COUNT(*)             FROM EMPLOYEES; -- 109개 : 줄 수, LOW COUNT
SELECT COUNT(EMPLOYEE_ID)   FROM EMPLOYEES; -- 109개
SELECT COUNT(DEPARTMENT_ID) FROM EMPLOYEES; -- 106개, null 제외

SELECT EMPLOYEE_ID          FROM EMPLOYEES
WHERE  DEPARTMENT_ID        IS   NULL;

SELECT COUNT(EMPLOYEE_ID)   FROM EMPLOYEES
WHERE  DEPARTMENT_ID        IS   NULL;

-- 전체 직원의 월급 합 : 세로 합 (null은 제외)
SELECT COUNT(SALARY)        FROM EMPLOYEES; -- 107
SELECT SUM(SALARY)          FROM EMPLOYEES; -- 직원의 총 월급 691416
SELECT AVG(SALARY)          FROM EMPLOYEES; -- 직원의 평균 월급 6461.831775700934579439252336448598130841
SELECT MAX(SALARY)          FROM EMPLOYEES; -- 직원의 최대 월급 24000
SELECT MIN(SALARY)          FROM EMPLOYEES; -- 직원의 최소 월급 2100

SELECT SUM(SALARY) / COUNT(SALARY) FROM EMPLOYEES;
SELECT SUM(SALARY) / COUNT(*)      FROM EMPLOYEES;


-- 60번 부서의 평균 월급
SELECT AVG(SALARY)
FROM   EMPLOYEES
WHERE  DEPARTMENT_ID = 60; -- 5760

-- EMPLOYEES 테이블의 부서 수를 알고 싶다
SELECT COUNT(DEPARTMENT_ID)
FROM   EMPLOYEES;  -- null을 제외함 106

SELECT DEPARTMENT_ID
FROM   EMPLOYEES;  -- 109

-- 중복을 제거(DISTINCT) 한 부서의 수를 출력
-- 중복을 제거한 부서 번호 리스트 : null 출력 됨
SELECT DISTINCT DEPARTMENT_ID
FROM EMPLOYEES; -- 12줄, NULL을 포함함

SELECT COUNT(DISTINCT DEPARTMENT_ID)
FROM EMPLOYEES; -- 11, COUNT는 NULL을 제외함


-- 직원이 근무하는 부서의 수 : 부서장이 있는 부서 수 : DEPARTMENTS
SELECT COUNT(DEPARTMENT_ID)
FROM   DEPARTMENTS
WHERE  MANAGER_ID IS NOT NULL;

-- 
SELECT 7 / 2, 
       ROUND(156.456, 2), ROUND(156.456, -2),
       TRUNC(156.456, 2), TRUNC(156.456, -2)
FROM DUAL;

-- 직원 수, 월급 합, 월급 평균, 최대 월급, 최소 월급
SELECT COUNT(EMPLOYEE_ID)    "직원 수",
       SUM(SALARY)           "월급 합",
       ROUND(AVG(SALARY), 3) "월급 평균",
       MAX(SALARY)           "최대 월급",
       MIN(SALARY)           "최소 월급"
FROM   EMPLOYEES;

----------------------------------------
/*
SQL문의 실행 순서
1. FROM
2. WHERE
3. GROUP BY
4. HAVING    - 그룹 바이 안에 있어야 사용 가능
3. SELECT
4. ORDER BY
*/
-- 부서 60번 인원 수, 월급 합, 월급 평균
SELECT COUNT(DEPARTMENT_ID) "인원 수",
       SUM(SALARY)          "월급 합",
       AVG(SALARY)          "월급 평균"
FROM   EMPLOYEES
WHERE  DEPARTMENT_ID = 60;


-- 부서 50, 60, 80번 부서가 아닌 인원 수, 월급 합, 월급 평균
SELECT COUNT(DEPARTMENT_ID)  "인원 수",
       SUM(SALARY)           "월급 합",
       ROUND(AVG(SALARY), 3) "월급 평균"
FROM   EMPLOYEES
WHERE  DEPARTMENT_ID != 50 and DEPARTMENT_ID != 60 and DEPARTMENT_ID != 80;

SELECT COUNT(DEPARTMENT_ID)  "인원 수",
       SUM(SALARY)           "월급 합",
       ROUND(AVG(SALARY), 3) "월급 평균"
FROM   EMPLOYEES
WHERE  DEPARTMENT_ID NOT IN (50, 60, 80);

----------------------------------------------------
부서별 사원수
SELECT DEPARTMENT_ID       부서번호, 
       COUNT (EMPLOYEE_ID) "사원 수"
FROM   EMPLOYEES;


SELECT   DEPARTMENT_ID       부서번호, 
         COUNT (EMPLOYEE_ID) "사원 수"
FROM     EMPLOYEES
-- WHERE
GROUP BY ROLLUP (DEPARTMENT_ID)
-- HAVING
ORDER BY DEPARTMENT_ID;


-- 부서별 월급 합, 월급 평균
SELECT   DEPARTMENT_ID 부서,
         SUM(SALARY)   "월급 합",
         ROUND(AVG(SALARY), 3)   월급평균
FROM     EMPLOYEES
GROUP BY DEPARTMENT_ID
ORDER BY DEPARTMENT_ID;


-----------------------------------------
-- 부서별 사원 수 통계 OK
SELECT   DEPARTMENT_ID       부서번호, 
         COUNT (EMPLOYEE_ID) "사원 수"
FROM     EMPLOYEES
GROUP BY DEPARTMENT_ID
ORDER BY DEPARTMENT_ID;


-- 부서별 인원 수, 월급 합 OK
SELECT   DEPARTMENT_ID       부서번호, 
         COUNT (EMPLOYEE_ID) "사원 수",
         SUM (SALARY)
FROM     EMPLOYEES
GROUP BY DEPARTMENT_ID
ORDER BY DEPARTMENT_ID;


-- 부서별 사원 수가 5명 이상인 부서 번호 출력 OK
SELECT   DEPARTMENT_ID       부서번호, 
         COUNT (EMPLOYEE_ID) "사원 수"
FROM     EMPLOYEES
GROUP BY DEPARTMENT_ID
HAVING   COUNT(EMPLOYEE_ID) >= 5
ORDER BY DEPARTMENT_ID;


-- 부서별 월급 총계가 20000이상인 부서 번호 OK
SELECT   DEPARTMENT_ID       부서번호, 
         SUM(SALARY) "월급총계"
FROM     EMPLOYEES
GROUP BY DEPARTMENT_ID
HAVING   SUM(SALARY) >= 20000
ORDER BY DEPARTMENT_ID;


-- JOB-ID 별 인원 수 OK
SELECT   JOB_ID       "직무", 
         COUNT(JOB_ID) "사원 수"
FROM     EMPLOYEES
GROUP BY JOB_ID;


-- JOB_TITLE 별 인원 수
SELECT   JOB_TITLE        "잡 타이틀", 
         COUNT(JOB_TITLE) "사원 수",
         CASE JOB_ID 
              WHEN 'AD_PRES'    THEN 'President'
              WHEN 'AD_VP'      THEN 'Administration Vice President'
              WHEN 'AD_ASST'    THEN 'Administration Assistant'
              WHEN 'FI_MGR'     THEN 'Finance Manager'
              WHEN 'FI_ACCOUNT' THEN 'Accountant'
              WHEN 'AC_MGR'     THEN 'Accounting Manager'
              WHEN 'AC_ACCOUNT' THEN 'Public Accountant'
              WHEN 'SA_MAN'     THEN 'Sales Manager'
              WHEN 'SA_REP'     THEN 'Sales Representative'
              WHEN 'PU_MAN'     THEN 'Purchasing Manager'
              WHEN 'PU_CLERK'   THEN 'Purchasing Clerk'
              WHEN 'ST_MAN'     THEN 'Stock Manager'
              WHEN 'ST_CLERK'   THEN 'Stock Clerk'
              WHEN 'SH_CLERK'   THEN 'Shipping Clerk'
              WHEN 'IT_PROG'    THEN 'Programmer'
              WHEN 'MK_MAN'     THEN 'Marketing Manager'
              WHEN 'MK_REP'     THEN 'Marketing Representative'
              WHEN 'HR_REP'     THEN 'Human Resources Representative'
              WHEN 'PR_REP'     THEN 'Public Relations Representative'
              ELSE '없음'
              END "부서명"
FROM     JOBS

-- 2017년 입사일 기준 월별 사원 수 OK
SELECT   TO_CHAR(HIRE_DATE, 'MM') 입사월,
         COUNT(EMPLOYEE_ID) "월 별 사원 수"
FROM     EMPLOYEES
WHERE    TO_CHAR(HIRE_DATE, 'YYYY') = '2017'
GROUP BY HIRE_DATE
ORDER BY HIRE_DATE;


-- 부서별 최대 월급이 140000 이상인 부서의 부서번호와 최대월급 OK
SELECT   DEPARTMENT_ID 부서번호,
         MAX(SALARY)   최대월급
FROM     EMPLOYEES
WHERE    SALARY >= 14000
GROUP BY DEPARTMENT_ID
ORDER BY DEPARTMENT_ID;


-- 부서별로 모으고 같은 부서는 직업별 인원 수, 월급 평균
SELECT   DEPARTMENT_ID            부서번호,
         JOB_ID                   업무ID,
         COUNT(JOB_ID)            "직업 별 인원 수",
         ROUND(AVG(SALARY), 2)    "평균 월급"
FROM     EMPLOYEES
-- GROUP BY DEPARTMENT_ID, JOB_ID
-- GROUP BY ROLLUP (DEPARTMENT_ID, JOB_ID) -- ROLLUP : 같은 업무ID 인원 수의 평균 월급
GROUP BY CUBE (DEPARTMENT_ID, JOB_ID)      -- CUBE   : 
ORDER BY DEPARTMENT_ID, JOB_ID;
