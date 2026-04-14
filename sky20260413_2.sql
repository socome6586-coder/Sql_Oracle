 성적처리 TABLE
 업무
 학생 : 학번, 이름, 전화, 입학일
 성적 : 학번, 국어, 영어, 수학, 총점, 평균, 석차 결과
 과목은 변경될 수 있다.
 
 TABLE 생성
 학생     : 학번(PK), 이름,   전화,   입학일
 STUDENT    STID      STNAME  PHONE   INDATE
 
 성적     : 일련번호(PK), 교과목,   점수,   학번(FK)
 SCORES     SCID          SUBJECT   SCORE   STID
 
 -- 제약조건(CONSTRAINTS) - 무결성  
  TABLE 에 저장될 데이터에 조건을 부여하여 잘못된 DATA 입려되는 방지
  1. 주식별자 설정 : 기본키
     PRIMARY KEY     : NOT NULL + UNIQUE 기본 적용
     CREATE TABLE 명령안에 한번만 사용가능
  2. NOT NULL / NULL : 필수입력, 컬럼단위 제약조건
  3. UNIQUE          : 중복방지
  4. CHECK           : 값의 범위지정 , DOMAIN 제약 조건 
  5. FOREIGN KEY     : 외래키 제약조건



 학생     : 학번(PK), 이름,   전화,   입학일
 STUDENT    STID      STNAME  PHONE   INDATE
 CREATE TABLE STUDENT(
        STID    NUMBER(6)    PRIMARY KEY,    -- 학번 숫자(6)자리 기본 키  (프라이머리는 한 번만 가능)
        STNAME  VARCHAR2(30) NOT NULL,       -- 이름 문자(30)자 필수 입력
        PHONE   VARCHAR2(20) UNIQUE,         -- 전화 문자20 중복방지
        INDATE  DATE         DEFAULT SYSDATE -- 입학일 날짜 기본 값 오늘
 );
 
 성적     : 일련번호(PK), 교과목,   점수,   학번(FK)
 SCORES     SCID          SUBJECT   SCORE   STID  
 
 CREATE TABLE SCORES(
        SCID    NUMBER(7)    PRIMARY KEY,  -- 일련번호  숫자(7)   기본키, 번호 자동 증가
        SUBJECT VARCHAR2(60) NOT NULL,     -- 교과목    문자(60)  필수입력
        SCORE NUMBER(3), -- 점수 숫자(3) 범위 0~100
        STID NUMBER(6) -- 학번 숫자(6) 외래키
 )