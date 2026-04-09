SELECT * FROM TAB;
----------------------------------------------------
SUBQUERY : SQL문 안에 SQL문을 넣어서 실행하는 방법
         : 반드시 () 안에 있어야 한다
         : () 안에는 ORDER BY 사용 불가
         : WHERE 조건에 맞도록 작성한다
         : QUERY를 실행하는 순서가 중요할 때
----------------------------------------------------
-- IT 부서의 직원 정보를 출력하시오
1) IT부서의 부서 번호를 찾는다 -- 60
SELECT DEPARTMENT_ID
FROM   DEPARTMENTS
WHERE  DEPARTMENT_NAME = 'IT';
2) 60번 부서의 직원 정보를 출력
SELECT EMPLOYEE_ID 사번,
       FIRST_NAME || ' ' || LAST_NAME 이름,
       DEPARTMENT_ID 부서
FROM   EMPLOYEES
WHERE  DEPARTMENT_ID = 60;
1) + 2)
SELECT EMPLOYEE_ID 사번,
       FIRST_NAME || ' ' || LAST_NAME 이름,
       DEPARTMENT_ID 부서
FROM   EMPLOYEES
WHERE  DEPARTMENT_ID IN (
       SELECT DEPARTMENT_ID
       FROM   DEPARTMENTS
       WHERE  DEPARTMENT_NAME IN ('IT', 'Sales')
       );


-- 평균 월급보다 많은 월급을 받는 사람의 명단
1) 평균 월급 -- 6461.831775700934579439252336448598130841
SELECT AVG(SALARY)
FROM   EMPLOYEES;
2) 월급이 평균 월급 -- 6461.831775700934579439252336448598130841 보다 많은 직원
SELECT EMPLOYEE_ID 사번,
       FIRST_NAME || ' ' || LAST_NAME 이름,
       SALARY
FROM   EMPLOYEES
WHERE  SALARY >= 6461.831775700934579439252336448598130841;
1) + 2)
SELECT EMPLOYEE_ID 사번,
       FIRST_NAME || ' ' || LAST_NAME 이름,
       SALARY
FROM   EMPLOYEES
WHERE  SALARY >= (
       SELECT AVG(SALARY)
       FROM EMPLOYEES);
       
       
-- 60번 부서의 평균 월급보다 많은 월급을 받는 사람의 명단
1) 60번 부서 찾기
SELECT DEPARTMENT_ID
FROM   DEPARTMENTS
WHERE  DEPARTMENT_NAME = 'IT';
2) 60번 부서의 평균 월급
SELECT AVG(SALARY)
FROM   EMPLOYEES
WHERE  DEPARTMENT_ID = 60;
3) 2)번 보다 많은 월급을 받는 사람
SELECT EMPLOYEE_ID, FIRST_NAME || ' ' || LAST_NAME, SALARY
FROM   EMPLOYEES
WHERE  SALARY >= 5760;


SELECT EMPLOYEE_ID, FIRST_NAME || ' ' || LAST_NAME, SALARY
FROM   EMPLOYEES
WHERE  SALARY >= (
       SELECT AVG(SALARY)
       FROM   EMPLOYEES
       WHERE  DEPARTMENT_ID = (
              SELECT DEPARTMENT_ID
              FROM   DEPARTMENTS
              WHERE  DEPARTMENT_NAME = 'IT'
    )
);

-- 50 번 부서의 최고 월급자의 이름을 출력
1) 50번 부서 찾기
SELECT MAX(SALARY)
FROM   EMPLOYEES
WHERE  DEPARTMENT_ID = 50;
2) 최고 월급자의 이름
SELECT EMPLOYEE_ID, FIRST_NAME, LAST_NAME, SALARY
FROM   EMPLOYEES
WHERE  SALARY = 8200;

1) + 2)
SELECT EMPLOYEE_ID, FIRST_NAME, LAST_NAME, SALARY, DEPARTMENT_ID
FROM   EMPLOYEES
WHERE  SALARY = (
       SELECT MAX(SALARY)
       FROM   EMPLOYEES
       WHERE  DEPARTMENT_ID = 50
       ) AND  DEPARTMENT_ID = 50;


-- SALES 부서의 평균 월급보다 많은 월급을 받는 사람의 명단
1) SALES 부서의 부서 번호
SELECT DEPARTMENT_ID
FROM   DEPARTMENTS
WHERE  UPPER(DEPARTMENT_NAME) = 'SALES';

2) 1) 부서의 평균 월급 -- 8955.882352941176470588235294117647058824
SELECT AVG(SALARY)
FROM   EMPLOYEES
WHERE  DEPARTMENT_ID = 80;

3) 2) 보다 많은 월급자의 명단
SELECT EMPLOYEE_ID, FIRST_NAME, LAST_NAME, SALARY
FROM   EMPLOYEES
WHERE  SALARY >= 8955.882352941176470588235294117647058824;

1) + 2) + 3)
SELECT EMPLOYEE_ID, FIRST_NAME, LAST_NAME, SALARY
FROM   EMPLOYEES
WHERE  SALARY >= (
       SELECT AVG(SALARY)
       FROM   EMPLOYEES
       WHERE  DEPARTMENT_ID = (
              SELECT DEPARTMENT_ID
              FROM   DEPARTMENTS
              WHERE  UPPER(DEPARTMENT_NAME) = 'SALES'
    )
);

-- 
SELECT *
FROM   EMPLOYEES A
WHERE  (A.JOB_ID, A.SALARY) IN (
        SELECT   JOB_ID, MIN(SALARY) 그룹별급여
        FROM     EMPLOYEES
        GROUP BY JOB_ID
        )
        ORDER BY A.SALARY DESC;
        
-- 상관 서브 쿼리 CORELATIVE SUBQUERY
-- JOB_HISTORY에 있는 부서 번호와 DEPARTMENTS 에 있는 부서번호가 같은 부서를 찾아서
-- DEPARTMENTS에 있는 부서 번호와 부서명을 출력
    SELECT a.department_id, a.department_name
      FROM departments a
     WHERE EXISTS ( SELECT 1
                    FROM  job_history b
                    WHERE a.department_id = b.department_id );


-- SHIPPING 부서의 직원 명단
1) SHIPPING 부서 번호
SELECT DEPARTMENT_ID
FROM   DEPARTMENTS
WHERE  UPPER(DEPARTMENT_NAME) = 'SHIPPING';

SELECT EMPLOYEE_ID, FIRST_NAME, LAST_NAME
FROM   EMPLOYEES
WHERE  DEPARTMENT_ID = (
        SELECT DEPARTMENT_ID
        FROM   DEPARTMENTS
        WHERE  UPPER(DEPARTMENT_NAME) = 'SHIPPING');

--------------------------------------------------------------------------------
join
--------------------------------------------------------------------------------
직원이름, 부서명 -- 출력 줄 수 109줄

ORACLE OLD문법

1) 카티션프로덕트 : 109(사원 수) * 27(부서) = 2943개 -> CROSS JOIN, 조건이 없는
SELECT FIRST_NAME || ' ' || LAST_NAME 직원이름,
       DEPARTMENT_NAME                부서명
FROM   EMPLOYEES, DEPARTMENTS;

2) 내부조인 : 양쪽 다 존재한 DATA, NULL 제외
   : 109 - 3(부서번호 null) = 106개 -> INNER JOIN
   비교 조건 필수
SELECT EMPLOYEES.FIRST_NAME || ' ' || EMPLOYEES.LAST_NAME 직원이름,
       DEPARTMENTS.DEPARTMENT_NAME                        부서명
FROM   EMPLOYEES, DEPARTMENTS
WHERE  EMPLOYEES.DEPARTMENT_ID = DEPARTMENTS.DEPARTMENT_ID;

SELECT e.FIRST_NAME || ' ' || e.LAST_NAME 직원이름,
       d.DEPARTMENT_NAME                  부서명
FROM   EMPLOYEES e, DEPARTMENTS d
WHERE  e.DEPARTMENT_ID = d.DEPARTMENT_ID;

3) LEFT OUTER JOIN
3) 모든 직원을 출력하라 : 109줄
-- 직원의 부서 번호가 null 이라도 출력해야한다
-- (+) : 기준(직원)이 되는 조건의 반대방향에 붙인다
         NULL이 출력될 곳
   
SELECT e.FIRST_NAME || ' ' || e.LAST_NAME 이름, 
       d.DEPARTMENT_NAME 부서명
FROM   EMPLOYEES e, DEPARTMENTS d
WHERE  e.DEPARTMENT_ID = d.DEPARTMENT_ID(+);

4) RIGHT OUTER JOIN
SELECT e.FIRST_NAME || ' ' || e.LAST_NAME 이름, 
       d.DEPARTMENT_NAME 부서명
FROM   EMPLOYEES e, DEPARTMENTS d
WHERE  e.DEPARTMENT_ID(+) = d.DEPARTMENT_ID;


4) RIGHT OUTER JOIN
   모든 부서를 출력 -- 122 : (109 - 3) + (27 - 11)
   직원정보가 없더라도 출력해야한다
   
SELECT e.FIRST_NAME || ' ' || e.LAST_NAME 이름, 
       d.DEPARTMENT_NAME 부서명
FROM   EMPLOYEES e, DEPARTMENTS d
WHERE  e.DEPARTMENT_ID(+) = d.DEPARTMENT_ID;


5) FULL OUTER JOIN - OLD문법에 존재하지 않는 명령
   모든 직원과 모든 부서를 출력

-------------------------------------------------------------
표준 SQL 문법
1. CROSS JOIN : 2943개
SELECT e.FIRST_NAME, e.LAST_NAME, d.DEPARTMENT_NAME
FROM   EMPLOYEES e CROSS JOIN DEPARTMENTS d;


2. INNER JOIN : 106개 (null 제외) 테이블 두 개를 붙일 때만 ON을 사용
SELECT e.FIRST_NAME, e.LAST_NAME, d.DEPARTMENT_NAME
FROM   EMPLOYEES e INNER JOIN DEPARTMENTS d 
ON     e.DEPARTMENT_ID = d.DEPARTMENT_ID;


3. OUTER JOIN
1) LEFT  (OUTER) JOIN -- 109개
SELECT e.FIRST_NAME, e.LAST_NAME, d.DEPARTMENT_NAME
FROM   EMPLOYEES e LEFT JOIN DEPARTMENTS d
ON     e.DEPARTMENT_ID = d.DEPARTMENT_ID;

2) RIGHT (OUTER) JOIN -- 122개
SELECT e.FIRST_NAME, e.LAST_NAME, d.DEPARTMENT_NAME
FROM   EMPLOYEES e RIGHT JOIN DEPARTMENTS d
ON     e.DEPARTMENT_ID = d.DEPARTMENT_ID;

3) FULL  (OUTER) JOIN -- 125개 109 + 27 - 16
SELECT e.FIRST_NAME, e.LAST_NAME, d.DEPARTMENT_NAME
FROM   EMPLOYEES e FULL JOIN DEPARTMENTS d
ON     e.DEPARTMENT_ID = d.DEPARTMENT_ID;

-- 직원 이름, 담당업무(JOB_TITLE)
SELECT e.FIRST_NAME, e.LAST_NAME, j.JOB_TITLE
FROM   EMPLOYEES e JOIN JOBS j
ON     j.JOB_ID = e.JOB_ID;

-- 부서명, 부서위치(CITY, STREE_ADDRESS)
SELECT d.DEPARTMENT_NAME, l.CITY, l.STREET_ADDRESS
FROM   DEPARTMENTS d JOIN LOCATIONS l
ON     l.LOCATION_ID = d.LOCATION_ID;


-- 직원명, 부서명, 부서위치(CITY, STREE_ADDRESS)
SELECT e.FIRST_NAME || ' ' || e.LAST_NAME 직원명,
       d.DEPARTMENT_NAME                  부서명, 
       l.STREET_ADDRESS                   부서위치
FROM   EMPLOYEES e JOIN DEPARTMENTS d ON e.DEPARTMENT_ID = d.DEPARTMENT_ID
                   JOIN LOCATIONS   l ON d.LOCATION_ID   = l.LOCATION_ID;


-- LEFT OUTER JOIN (OUTER 조인은 하나만 해서는 안 된다)
SELECT e.FIRST_NAME || ' ' || e.LAST_NAME 직원명,
       d.DEPARTMENT_NAME                  부서명,
       l.CITY                             도시,
       l.STREET_ADDRESS                   부서위치
FROM   EMPLOYEES e LEFT JOIN DEPARTMENTS d ON e.DEPARTMENT_ID = d.DEPARTMENT_ID
                   LEFT JOIN LOCATIONS   l ON d.LOCATION_ID   = l.LOCATION_ID
ORDER BY 직원명 ASC;
                   
                   
-- 직원명, 부서명, 국가, 부서위치(CITY, STREE_ADDRESS)
SELECT e.FIRST_NAME || ' ' || e.LAST_NAME 직원명,
       d.DEPARTMENT_NAME                  부서명,
       c.COUNTRY_NAME                     국가,
       l.CITY || '' || l.STREET_ADDRESS   부서위치
FROM   EMPLOYEES e LEFT JOIN DEPARTMENTS d ON e.DEPARTMENT_ID = d.DEPARTMENT_ID
                   LEFT JOIN LOCATIONS   l ON d.LOCATION_ID   = l.LOCATION_ID
                   LEFT JOIN COUNTRIES   c ON l.COUNTRY_ID    = c.COUNTRY_ID
ORDER BY 직원명, 부서명 ASC;
                   
                   
-- 부서명, 국가 : 모든 부서 : 27줄 이상
SELECT d.DEPARTMENT_NAME 부서명, 
       c.COUNTRY_NAME    국가
FROM   DEPARTMENTS d FULL JOIN LOCATIONS l ON d.LOCATION_ID = l.LOCATION_ID
                     FULL JOIN COUNTRIES c ON l.COUNTRY_ID  = c.COUNTRY_ID
ORDER BY 부서명, 국가;


-- 직원명, 부서위치 단 IT부서만
SELECT e.FIRST_NAME || ' ' || e.LAST_NAME 직원명,
       l.STATE_PROVINCE || '/' || l.CITY || '/' || l.STREET_ADDRESS 부서위치
FROM   EMPLOYEES   e 
JOIN   DEPARTMENTS d ON e.DEPARTMENT_ID = d.DEPARTMENT_ID
JOIN   LOCATIONS    l ON d.LOCATION_ID   = l.LOCATION_ID
WHERE  D.DEPARTMENT_NAME = 'IT'
ORDER BY 직원명;


-- 부서명별 월급평균
1) 부서 번호, 월급 평균
SELECT DEPARTMENT_ID         부서번호,
       ROUND(AVG(SALARY), 2) 월급평균
FROM   EMPLOYEES e
GROUP BY DEPARTMENT_ID
ORDER BY DEPARTMENT_ID;

2) 부서명, 월급 평균 -- 11개 INNER JOIN
SELECT d.DEPARTMENT_NAME       부서명,
       ROUND(AVG(SALARY), 2) 월급평균
FROM   EMPLOYEES   e 
JOIN   DEPARTMENTS d ON e.DEPARTMENT_ID = d.DEPARTMENT_ID
GROUP BY d.DEPARTMENT_NAME
ORDER BY d.DEPARTMENT_NAME;

3) 모든 부서를 출력 -- 27개 OUTER JOIN
   월급 평균이 null '직원없음'
SELECT d.DEPARTMENT_NAME             부서명,
       DECODE( AVG(e.SALARY), NULL, '직원 없음',
                                    ROUND(AVG(e.SALARY), 2)    ) 평균월급
FROM   EMPLOYEES   e RIGHT JOIN   DEPARTMENTS d ON e.DEPARTMENT_ID = d.DEPARTMENT_ID
GROUP BY d.DEPARTMENT_NAME
ORDER BY d.DEPARTMENT_NAME;


-- 직원의 근무 연수
-- MONTH_BETWEEN(날짜1, 날짜2) : 날짜1 - 날짜2 : 월 단위로
-- ADD_MONTH(날짜, n) : 날짜+n개월 / 날짜-n개월
SELECT  FIRST_NAME || ' ' || LAST_NAME                    직원명,
        TO_CHAR(HIRE_DATE, 'YYYY-MM-DD')                  입사일,
        TO_CHAR(TRUNC(HIRE_DATE, 'MONTH'), 'YYYY-MM-DD')  "입사월의 첫번쨰날",
        TO_CHAR(LAST_DAY(HIRE_DATE), 'YYYY-MM-DD')        "입사월의 마지막날",
        TRUNC(SYSDATE - HIRE_DATE)                        근무일수,
        TRUNC((SYSDATE - HIRE_DATE) / 365.2422)           근무연수,
        TRUNC(MONTHS_BETWEEN(SYSDATE, HIRE_DATE) / 12)    근무연수
FROM   EMPLOYEES;


-- 60번 부서 최소월급과 같은 월급자의 명단 출력
1) 60번 부서 최소 월급
SELECT MIN(SALARY)
FROM   EMPLOYEES
WHERE  DEPARTMENT_ID = 60; -- 2100

2)
SELECT FIRST_NAME, LAST_NAME, SALARY
FROM   EMPLOYEES
WHERE  SALARY = 2100;

1)+2)+3)
SELECT FIRST_NAME, LAST_NAME, SALARY
FROM   EMPLOYEES
WHERE  SALARY = (
       SELECT MIN(SALARY)
       FROM   EMPLOYEES
       WHERE  DEPARTMENT_ID = 60
       );


-- 부서명, 부서장의 이름
1) INNER JOIN : 양쪽 다 존재하는 데이터만 출력
SELECT d.DEPARTMENT_NAME 부서명,
       e.FIRST_NAME || ' ' || e.LAST_NAME     "부서 장 이름"
FROM   DEPARTMENTS d JOIN EMPLOYEES e ON e.EMPLOYEE_ID = d.MANAGER_ID
ORDER BY 부서명;

2) 모든 부서에 대해 출력 -- 27
SELECT d.DEPARTMENT_NAME 부서명,
       e.FIRST_NAME || ' ' || e.LAST_NAME     "부서 장 이름"
FROM   DEPARTMENTS d LEFT JOIN EMPLOYEES e ON e.EMPLOYEE_ID = d.MANAGER_ID
ORDER BY 부서명;


---------------------------------------------------------
결합연산자 - 줄 단위 결합
      조건 - 두 테이블의 칸 수와 타입이 동일해야한다
      1) UNION      중복 제거
      2) UNION ALL  중복 포함 제거
      3) INTERSECT  교집합 : 공통 부분
      4) MINUS      차집합 : a - b
      
SELECT * FROM EMPLOYEES WHERE DEPARTMENT_ID = 80; -- 34줄
SELECT * FROM EMPLOYEES WHERE DEPARTMENT_ID = 50; -- 45줄

SELECT * FROM EMPLOYEES WHERE DEPARTMENT_ID = 80
UNION
SELECT * FROM EMPLOYEES WHERE DEPARTMENT_ID = 50; -- 79줄

-- 칼럼 수와 칼럼들의 TYPE이 같으면 합쳐진다 -> 주의할 것
SELECT EMPLOYEE_ID, FIRST_NAME FROM EMPLOYEES
UNION
SELECT DEPARTMENT_ID, DEPARTMENT_NAME FROM DEPARTMENTS;

-- 직원정보, 담당업무

-- 직원명, 담당업무, 담당업무 히스토리

-- 사번, 업무시작일, 업무종료일, 담당업무, 부서번호