/*
  HTH계정 생성 후
  +버튼 클릭 후
  이름 : hthTeacher
  사용자 이름 : hth
  비밀번호    : 1234
  호스트 이름 : 접속 할 ip주소 : cmd > ipconfig -> IPv4 
  포트        : 1521, 방화벽 인바운드, 아웃바운드에 포트 1521추가 필요
  SID         : xe
*/

INSERT INTO MYCLASS
VALUES (3, '조민석', '010-6466-6586', 'm_i_n_e@naver.com', SYSDATE);
COMMIT;

SELECT * FROM MYCLASS
ORDER BY 번호 ASC;