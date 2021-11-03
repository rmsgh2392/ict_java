/*
CREATE OR REPLACE PROCEDURE 프로시저명
IS 
-- 변수 선언문(IS ~ BEGIN) 선택
BEGIN
-- 실행문 (BEGIN ~ END) 필수
END;
/  -- > 세트
*/

--자바에서 메소드 (매개변수 IN 데이터타입) / 받아오는거 IN 내보내는거  OUT
CREATE OR REPLACE PROCEDURE HELLO(NAME IN VARCHAR2) 
IS 
BEGIN
    DBMS_OUTPUT.PUT_LINE('HELLO ' ||NAME); -- 실행문 (자바 - System.out.println())
-- 패키지명(DBMS_OUTPUT).프로시저명(PUT_LINE)
END;
/
SET SERVEROUTPUT ON -- 기본적으로 OUPPUT이 꺼져 있다 쓰기 위해선 서버에서 다시 켜줘야한다.

EXECUTE HELLO; -- HELLO 메소드 호출
EXEC HELLO('윈터');

-------------------------------------------------------------------
-- 현재 시간과 3시간 후의 시간을 출력하는 프로시저를 작성
CREATE OR REPLACE PROCEDURE TIMES
IS
  CURRTIME TIMESTAMP; -- 현재 시간을 할당받을 변수 선언 
  AFTERTIME TIMESTAMP; -- 3시간 후의 시간을 할당 받을 변수 선언
BEGIN
    SELECT SYSTIMESTAMP, SYSTIMESTAMP +3 / 24  INTO CURRTIME, AFTERTIME FROM DUAL;
    --SELECT SYSTIMESTAMP +3 /24  INTO AFTERTIME FROM DUAL;
    DBMS_OUTPUT.PUT_LINE('현재 시간 : ' ||CURRTIME);
    DBMS_OUTPUT.PUT_LINE('3시간 후 시간 : ' ||AFTERTIME);
END;
/

EXEC TIMES;

--MEMO 테이블에 데이터를 INSERT 하는 프로시저를 작성
-- 단, 인파라미터 2개를 받아들여 INSERT
-- 작성자, 메모내용 => INPRARMETER 받자

-- PNAME IN MEMO.NAME%TYPE, PMSG IN MEMO.MSG%TYPE
-- MEMO 테이블의 NAME컬럼명의 데이터타입이랑 맞춰준다.
CREATE OR REPLACE PROCEDURE MEMO_ADD(PNAME IN MEMO.NAME%TYPE, PMSG IN MEMO.MSG%TYPE)
IS
BEGIN
    INSERT INTO MEMO(IDX,NAME, MSG) 
    VALUES(MEMO_SEQ.NEXTVAL, PNAME, PMSG);
    COMMIT;
END;
/

EXEC MEMO_ADD('페이꼬우', '페이~~꼬~~우');

SELECT * FROM MEMO;


-- 삭제할 글번호를 IN 파라미터를 받아서 해당글을 삭제하는 프로시저를 작성
CREATE OR REPLACE PROCEDURE MEMO_DELETE(PIDX IN MEMO.IDX%TYPE)
IS
BEGIN
    DELETE FROM MEMO
    WHERE IDX LIKE PIDX;
    COMMIT;
END;
/

EXEC MEMO_DELETE(2);

SELECT * FROM MEMO;
ROLLBACK;

-- 수정할 글 번호, 글 내용을 인파라미터로 받아서 
-- 해당글을 수정하는 프로시저를 작성하세여
CREATE OR REPLACE PROCEDURE MEMO_MFY(MIDX IN MEMO.IDX%TYPE, MMSG IN MEMO.MSG%TYPE)
IS
BEGIN
    UPDATE MEMO
    SET MSG = MMSG
    WHERE IDX LIKE MIDX;
END;
/

EXEC MEMO_MFY(5, '사랑해')

SELECT * FROM MEMO;


-- 사원 이름 사원 번호 사원 급여 출력하는 프로시저
CREATE OR REPLACE PROCEDURE EMP_INFO(P_EMPNO IN EMP.EMPNO%TYPE)
IS
V_EMPNO EMP.EMPNO%TYPE;
V_ENAME EMP.ENAME%TYPE;
V_SAL EMP.SAL%TYPE;
BEGIN
DBMS_OUTPUT.ENABLE;
SELECT EMPNO, ENAME, SAL
INTO V_EMPNO, V_ENAME, V_SAL
FROM EMP
WHERE EMPNO LIKE P_EMPNO;
DBMS_OUTPUT.PUT_LINE('사원번호 :' ||V_EMPNO);
DBMS_OUTPUT.PUT_LINE('사원이름 :' ||V_ENAME);
DBMS_OUTPUT.PUT_LINE('급여 : '||V_SAL);

END;
/

EXEC EMP_INFO(7900);

--글 번호를 전달 하면 해당 글 내용을 가져와 출력하는 프로시저를 작성
CREATE OR REPLACE PROCEDURE MEMO_FIND(PIDX IN MEMO.IDX%TYPE)
IS
V_NAME MEMO.NAME%TYPE;  -- V_NAME VARCHAR2 --스칼라 변수타입
V_MSG MEMO.MSG%TYPE;
V_DATE MEMO.WDATE%TYPE;
BEGIN
    SELECT NAME, MSG, WDATE
    INTO V_NAME, V_MSG, V_DATE
    FROM MEMO
    WHERE IDX LIKE PIDX;
    
    DBMS_OUTPUT.PUT_LINE(V_NAME||'   '||V_DATE||'  '||V_MSG);
EXCEPTION 
WHEN NO_DATA_FOUND THEN  -- 예외처리 EXCEPTION WHEN 예외처리 종류 THEN 예외처리 
    DBMS_OUTPUT.PUT_LINE(PIDX||'번 글을 없습니다');
END;
/

SET SERVEROUTPUT ON
EXEC MEMO_FIND(200);

--부서번호를 입력 해당 부서의 부서명, 위치를 출력하는 프로시저
--%ROWTYPE : 하나 이상의 데이터 값을 갖는 데이터 타입 (복합데이터타입)
CREATE OR REPLACE PROCEDURE DEPT_FIND(PNO IN DEPT.DEPTNO%TYPE)
IS
    VDEPT DEPT%ROWTYPE; -- DEPT 테이블의 하나의 행과 같은 타입 
BEGIN
    SELECT DEPTNO, DNAME, LOC
    INTO VDEPT.DEPTNO, VDEPT.DNAME, VDEPT.LOC
    FROM DEPT
    WHERE DEPTNO LIKE PNO;
    
    DBMS_OUTPUT.PUT_LINE(VDEPT.DEPTNO||' '|| VDEPT.DNAME||'  ' ||VDEPT.LOC);
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
     DBMS_OUTPUT.PUT_LINE(PNO||' 번 부서는 없어요');
END;
/

EXEC DEPT_FIND(40);

-- 사번을 입력 사원의 이름, 업무, 급여 출력
CREATE OR REPLACE PROCEDURE 
(PNO IN EMP.EMPNO%TYPE)
IS
    VEMP EMP%ROWTYPE;
    VDEPT DEPT%ROWTYPE;
BEGIN
    SELECT ENAME, JOB, SAL, DEPTNO
    INTO VEMP.ENAME, VEMP.JOB, VEMP.SAL, VEMP.DEPTNO
    FROM EMP
    WHERE EMPNO LIKE PNO;
    
    SELECT DNAME, LOC
    INTO VDEPT.DNAME, VDEPT.LOC
    FROM DEPT
    WHERE DEPTNO LIKE VEMP.DEPTNO;
    
    DBMS_OUTPUT.PUT_LINE(VEMP.ENAME||'  '||VEMP.JOB||'  '||VEMP.SAL||' '||VEMP.DEPTNO||' '||VDEPT.DNAME||' '||VDEPT.LOC);
    
EXCEPTION 
WHEN NO_DATA_FOUND THEN
DBMS_OUTPUT.PUT_LINE(PNO|| ' 번의 사원은 존재하지 않아요');
END;
/

EXEC EMP_FIND(7788);

--------------------------------------------------------------------------------------
/* 프로시저 파라미터 종류
1) IN Parameter
2) Out Parameter -- 자바에 값을 넘겨줄 때 사용(외부로)
3) IN OUT Parameter
*/
-- #Out Parameter : 프로시저가 외부로 넘겨주는 값 

-- 사번을 인파라미터로 입력 해당 사원의 이름을 아웃 파라미터로 내보내는 프로시저
CREATE OR REPLACE PROCEDURE EMP_FIND2
(
    PNO IN EMP.EMPNO%TYPE,
    ONAME OUT EMP.ENAME%TYPE
)
IS
BEGIN
    SELECT ENAME INTO ONAME
    FROM EMP
    WHERE EMPNO=PNO;
END;
/
--OUT 파라미터가 있는 프로시저를 실행하려면 변수를 선언한 후에 실행해야한다.
VARIABLE NAME VARCHAR2(20); --전역변수, 바인드 변수 => :변수이름 

EXEC EMP_FIND2(7788, :NAME); --프로시저에서 OUT파라미터로 넘겨주는 값을 NAME이라는 변수로 받는다.

PRINT NAME;

-- PL/SQL 제어문
/*
1) IF 문 : IF ~~ END IF;  

2) LOOP 문  
LOOP  
    실행문장;
    EXIT WHEN 조건문; -- LOOP문을 종료시킬 조건문을 반드시 작석 아님 무한루프~~
END LOOP;

3) FOR LOOP 문
FOR 변수 IN [ REVERSE 생략가능] 시작 값 .. END 값 LOOP
    실행문
END LOOP;
- 변수 : BINARY_INTEGER 타입의 변수이고 자동으로 1씩 증가 / REVERSE 감소
- IN 뒤에는 CURSOR, 서브쿼리가 올 수도 있다.

4) WHILE LOOP 문
WHILE 조건식 LOOP
    실행문;
    증감식;
END LOOP;
*/
-- 사번을 입력 해당사원의 이름, 부서명을 출력
CREATE OR REPLACE PROCEDURE EMP_FIND3
( PNO IN EMP.EMPNO%TYPE)
IS
    VDNO EMP.DEPTNO%TYPE;
    VNAME EMP.ENAME%TYPE;
    VDNAME VARCHAR2(20);
BEGIN
    SELECT DEPTNO, ENAME
    INTO VDNO, VNAME
    FROM EMP
    WHERE EMPNO LIKE PNO;
    
    IF VDNO LIKE 10 THEN VDNAME :='회계부서';  -- := 대입연산자
    ELSIF VDNO LIKE 20 THEN VDNAME :='연구부서';  -- ELSE IF (X)   ELSIF로 작성!!!! 주의!!!!
    ELSIF VDNO LIKE 30 THEN VDNAME :='영업부서';
    ELSIF VDNO LIKE 40 THEN VDNAME :='운영부서';
    ELSIF VDNO LIKE 50 THEN VDNAME :='개발부서';
    ELSE VDNAME :='부서가 없어요';
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('사번 : ' ||PNO);
    DBMS_OUTPUT.PUT_LINE('이름 : ' ||VNAME);
    DBMS_OUTPUT.PUT_LINE('부서 번호 : ' ||VDNO);
    DBMS_OUTPUT.PUT_LINE('부서 이름 : ' ||VDNAME);
END;
/

EXEC EMP_FIND3(7839);

--MEMO 테이블에 인생살이 100 입력 LOOP사용
CREATE OR REPLACE PROCEDURE LOOT_TEST
IS
    VCNT NUMBER(3) :=100;  -- 할당연산자 :=
BEGIN
    LOOP
        INSERT INTO MEMO(IDX, NAME, MSG, WDATE)
        VALUES(MEMO_SEQ.NEXTVAL, 'TEST', '인생살이'||VCNT, SYSDATE);
        VCNT := VCNT+1;
        EXIT WHEN VCNT > 105;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('데이터 입력완료');
    DBMS_OUTPUT.PUT_LINE(VCNT);
    DBMS_OUTPUT.PUT_LINE(VCNT - 100||'개의 데이터가 삽입되었어요');
END;
/
EXEC LOOT_TEST;
SELECT * FROM MEMO ORDER BY IDX DESC;
----------------------------------------------------------------
-- 익명 프로시저 작성 
-- DECLARE
     -- 변수 선언문
-- BEGIN
    -- 실행문, 예외처리문
-- END
--/
DECLARE
--변수 선언문
BEGIN
-- 실행문 , 예외처리문
    FOR J IN REVERSE 1 .. 10 LOOP
          DBMS_OUTPUT.PUT_LINE('Hello'||J);
    END LOOP;
END;
/

--DEPT 테이블의 모든 부서정보를 가져와출력하는프로시저
CREATE OR REPLACE PROCEDURE DEPT_INFO
IS
BEGIN
    FOR J IN (SELECT * FROM DEPT ORDER BY DEPTNO) LOOP
        DBMS_OUTPUT.PUT_LINE(J.DEPTNO||'  '||J.DNAME||'  '||J.LOC);
    END LOOP;
END;
/
EXEC DEPT_INFO;

DECLARE   
BEGIN
    FOR J IN (SELECT * FROM DEPT ORDER BY DEPTNO) LOOP
         DBMS_OUTPUT.PUT_LINE(J.DEPTNO||'  '||J.LOC||'  '||J.DNAME);
    END LOOP;
END;
/
---------------------------------------------------------------------------
-- WHILE 문 실습
DECLARE
    CNT NUMBER := 1;
BEGIN
    WHILE CNT < 5 LOOP
        INSERT INTO EMP(EMPNO, ENAME, HIREDATE)
        VALUES(CNT, '윈터'||CNT, SYSDATE);
        CNT := CNT + 1; -- CNT 값 1씩 증가
        EXIT WHEN CNT = 3; --LOOP문 빠지는 조건을 작성 할 수있다.
    END LOOP;
    DBMS_OUTPUT.PUT_LINE(CNT-1||'개의 레코드 삽입');
END;
/
SELECT * FROM EMP;
ROLLBACK;

---------------------------------------------------------------------------
--실습 부서별 평균 급여, 최대 급여, 최소급여, 인원수를 가져와 출력하는 프로시저
--부서번호, 인원수, 평균급여, 최대급여, 최소급여

DECLARE
BEGIN -- 그룹함수는 별칭을 사용하여 값을 가져온다.
    FOR J IN (SELECT DEPTNO, COUNT(EMPNO) CNT, TRUNC(AVG(SAL), 2) AG, MAX(SAL) MX, MIN(SAL) MN
                 FROM EMP
                 GROUP BY DEPTNO
                 ORDER BY DEPTNO) LOOP
    DBMS_OUTPUT.PUT_LINE(J.DEPTNO||' '||J.CNT||' '||J.AG||' '||J.MX||' '||J.MN);
    END LOOP;
END;
/

----------------------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE EMPSEL
IS
VNO EMP.EMPNO%TYPE :=0;
VNAME EMP.ENAME %TYPE :=NULL;
VSAL EMP.SAL%TYPE :=0;
VDATE EMP.HIREDATE%TYPE;
BEGIN
SELECT EMPNO, ENAME, SAL, HIREDATE
INTO VNO, VNAME, VSAL, VDATE
FROM EMP;
END;
/
---------------------------------------------------------------------------
EXEC EMPSEL;

--명시적 커서를 이용해서 여러개의 레코드를 추출
create or replace procedure empsel
is
vno emp.empno%type:=0; --DEFAULT 값 할당
vname emp.ename%type:=null;
vsal emp.sal%type:=0;
vdate emp.hiredate%type;
VCNT NUMBER :=1;
--명시적 커서 선언  CURSOR 커서이름 IS ~
CURSOR EMP_CR IS 
    SELECT EMPNO, ENAME, SAL, HIREDATE
    FROM EMP
    ORDER BY 1;
begin
--커서를 OPEN
    OPEN EMP_CR;
        LOOP 
        -- 데이터 추출 Fetch
            FETCH EMP_CR INTO VNO, VNAME, VSAL, VDATE;
            VCNT := VCNT +1;
            EXIT WHEN EMP_CR%NOTFOUND; -- 데이터가 없으면 TRUE를 반환함
            DBMS_OUTPUT.PUT_LINE(VNO||'  '||VNAME||' '||VSAL||'  '||VDATE);
        END LOOP;
        DBMS_OUTPUT.PUT_LINE(VCNT||' 개의 행이 추출되었습니다');
--커서를 CLOSE
    CLOSE EMP_CR;
end;
/
EXEC EMPSEL;

------------------------------------------------------------
CREATE OR REPLACE PROCEDURE EMP_INFO2
(PRESULT OUT SYS_REFCURSOR,
PEMPNO IN EMP.EMPNO%TYPE)
IS
BEGIN
    OPEN PRESULT FOR
    SELECT EMPNO, ENAME, SAL
    FROM EMP
    WHERE EMPNO LIKE PEMPNO;
END;
/

----------------------------------------------------------------
CREATE OR REPLACE PROCEDURE MEMO_INFO
(MYCR OUT SYS_REFCURSOR)
IS
BEGIN
    OPEN MYCR FOR
    SELECT IDX, NAME, MSG, WDATE
    FROM MEMO
    ORDER BY IDX DESC;
END;
/