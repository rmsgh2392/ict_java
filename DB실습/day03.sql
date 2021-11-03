/*
 패키지 (선언부 / 본문 두가지로 나뉜다)
    [1] 선언부
    [2] 본문
*/
-- 1. 선언부
-- CREATE OR REPALCE PACKAGE 패키지명 AS
-- 프로시저 프로지저명; ...
-- END
--/
CREATE OR REPLACE PACKAGE EMPINFO AS
PROCEDURE ALLEMP;
PROCEDURE ALLSAL;
END EMPINFO;
/

--2.본문
CREATE OR REPLACE PACKAGE BODY EMPINFO AS
PROCEDURE ALLEMP
IS 
    CURSOR EMPCR IS
        SELECT EMPNO, ENAME FROM EMP ORDER BY 1;
BEGIN
    FOR J IN EMPCR LOOP
        DBMS_OUTPUT.PUT_LINE(J.EMPNO || LPAD(J.ENAME, 16, ' '));
    END LOOP;
    EXCEPTION 
    WHEN OTHERS THEN 
        DBMS_OUTPUT.PUT_LINE('기타 에러 발생');
END ALLEMP;

PROCEDURE ALLSAL
IS
BEGIN
    FOR J IN (SELECT ROUND(AVG(SAL)) AVG_SAL, MAX(SAL) MAX_SAL, MIN(SAL) MIN_SAL 
                 FROM EMP) LOOP
                 DBMS_OUTPUT.PUT_LINE(J.AVG_SAL|| LPAD(J.MAX_SAL, 10, ' ') || LPAD(J.MIN_SAL, 10, ' '));
                 -- DBMS_OUTPUT.PUT_LINE  : DBMS_OUTPUT (패키지명). PUT_LINE(프로시저명)!!!
    END LOOP;
END ALLSAL;
END EMPINFO; -- BODY 패키지명 ~(프로시저 실행시킬 내용들)~ END 패키지명
/

EXEC EMPINFO.ALLEMP;
EXEC EMPINFO.ALLSAL;

EXEC DEPT_EMPINFO(10);
-----------------------------------------------------------------------------------------------------
/*
 함수 ( FUNCTION ) 반환타입이 있다 (프로시저는 리턴타입이 없다)
    구문 : CREATE OR REPLACE FUNCTION 함수이름
            (매개변수 IN, OUT, IN OUT 프로시저랑 동일)
            RETURN 반환 타입 !!
            IS
            BEGIN
            RETURN 반환할 데이터
            END;
            /
*/

CREATE OR REPLACE FUNCTION GET_EMPNO
(PNAME IN EMP.ENAME%TYPE)
RETURN EMP.EMPNO%TYPE
IS
VENO EMP.EMPNO%TYPE;
BEGIN
    SELECT EMPNO INTO VENO
    FROM EMP
    WHERE ENAME LIKE UPPER(PNAME);
    DBMS_OUTPUT.PUT_LINE('사번'||VENO);
    RETURN VENO;
    
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
            dbms_output.put_line('입력한 사원은 없어요');
    when too_many_rows then
        dbms_output.put_line('자료가 2건 이상이에요');
    when others then
        dbms_output.put_line('기타 에러입니다');
END;
/
------------------
--함수가 반환해주는 값을 받아 줄 변수를 선언해야한다.
SET SERVEROUTPUT ON;

VAR G_NO NUMBER;

EXEC : G_NO := GET_EMPNO('SCOTT');

PRINT G_NO;
        
-----------------------------------------------------------------------------
/*
    Trigger (트리거) 
        주로 DML문장이 적용 될때 자동으로 실행되는 프로시저
*/
CREATE OR REPLACE TRIGGER MY_TRG
BEFORE UPDATE ON DEPT -- 트리거 이벤트 : UPDATE
FOR EACH ROW --행 트리거
BEGIN
    DBMS_OUTPUT.PUT_LINE('변경 전 컬럼 값: ' || :OLD.DNAME);
    DBMS_OUTPUT.PUT_LINE('변경 후 컬럼 값 :' || :NEW.DNAME);
END;
/

SELECT * FROM DEPT;

UPDATE DEPT
SET DNAME = 'DEVELOPMENT'
WHERE DEPTNO LIKE 50;

COMMIT;

-----------------------------------------------------
--INSERT 문의 경우 입력된 데이터 값 => :NEW.컬럼명
--UPDATE문의 경우
--   [1] 변경 전 데이터 => :OLD.컬럼명
--   [2] 변경 후 데이터 =>  :NEW.컬럼명
--DELETE문의 경우 삭제되는 데이터 => :OLD.컬럼명
-------------------------------------------------------
/*
 [실습] emp테이블에 대해서 급여 정보를 수정할 때마다
         이전의 급여 정보와 변경된 급여 정보, 급여 차액을 출력하는 트리거를 
         작성해봅시다
*/

CREATE OR REPLACE TRIGGER LOG_SAL_TRG
AFTER UPDATE OR INSERT OR DELETE ON EMP
FOR EACH ROW
BEGIN
    DBMS_OUTPUT.PUT_LINE('변경된 급여' || :NEW.SAL);
    DBMS_OUTPUT.PUT_LINE('이전 급여' || :OLD.SAL);
    DBMS_OUTPUT.PUT_LINE('급여 차액 : ' || (:NEW.SAL - :OLD.SAL));
END;
/

SELECT * FROM EMP;

UPDATE EMP
SET SAL = SAL * 1.1
WHERE EMPNO LIKE 7788;

ROLLBACK;
------------------------------------------------------------------
--데이터 사전에서 트리거 조회
SELECT * FROM USER_TRIGGERS;

--트리거 활성화 / 비활성화
-- ALTER TRIGGER 트리거이름 ENABLE /DISABLE
ALTER TRIGGER LOG_SAL_TRG DISABLE; -- 트리거 비활성화
ALTER TRIGGER LOG_SAL_TRG ENABLE; -- 트리거 활성화

--트리거 삭제 
-- DROP TRIGGER 트리거 이름;
DROP TRIGGER LOG_SAL_TRG;
-----------------------------------------------------------------------------------
-- 트리거 활용 실습
-- 1. 입고 테이블, 상품 테이블 생성
-- 2. 입고 테이블에 상품이 입고되면 상품 테이블의 보유수량이 자동으로 조절되도록 트리거 작성

CREATE TABLE 상품(
    상품코드 VARCHAR2(20) PRIMARY KEY,
    상품명 VARCHAR2(50) NOT NULL,
    제조사 VARCHAR2(30),
    가격 NUMBER(8),
    보유수량 NUMBER(8) DEFAULT 0
);
CREATE TABLE 입고(
    입고코드 NUMBER PRIMARY KEY,
    상품코드 VARCHAR2(20) REFERENCES 상품(상품코드),
    입고날짜 DATE DEFAULT SYSDATE,
    입고가격 NUMBER(8),
    입고수량 NUMBER(8)
);

--상품 테이블에 상품 등록
INSERT INTO 상품 VALUES ('A001', '노트북', 'LG', 100000, 5);
INSERT INTO 상품 VALUES ('A002', 'TV', '삼성', 2000000, 10);
INSERT INTO 상품 VALUES ('A003', '냉장고', '딤채', 150000, 15);
COMMIT;

SELECT * FROM 상품;

CREATE SEQUENCE 입고_SEQ
NOCACHE;

-- 입고 테이블에 상품이 입고 되면 상품 테이블의 보유수량 수정하는 트리거를 작성하세여
CREATE OR REPLACE TRIGGER MODIFY_TRG
AFTER UPDATE OR INSERT ON 입고
FOR EACH ROW

BEGIN
    UPDATE 상품
    SET 보유수량 = 보유수량 + :NEW.입고수량
    WHERE 상품코드 LIKE :NEW.상품코드;
END;
/

SELECT * FROM 입고;
SELECT * FROM 상품;
INSERT INTO 입고 VALUES(입고_SEQ.NEXTVAL, 'A001', DEFAULT, 1000000, 10);
INSERT INTO 입고 VALUES(입고_SEQ.NEXTVAL, 'A002', DEFAULT, 800000, 10);

--입고 테이블의 수량을 변경 시 상품 테이블의 보유수량도 변경되어야한다.
-- UPDATE입고 => 상품.보유수량
CREATE OR REPLACE TRIGGER MODIFY_TRG1
AFTER UPDATE ON 입고
FOR EACH ROW
BEGIN
    UPDATE 상품
    SET 보유수량 = (보유수량 - :OLD.입고수량 + :NEW.입고수량)
    WHERE 상품코드 = :OLD.상품코드;
    DBMS_OUTPUT.PUT_LINE('기존 입고수량 '|| :OLD.입고수량);
    DBMS_OUTPUT.PUT_LINE('변경 된 입고수량' || :NEW.입고수량);
END;
/

DROP TRIGGER MODIFY_TRG1;

SELECT A.*, B.*
FROM 입고 A RIGHT JOIN 상품 B
ON A.상품코드 = B.상품코드;

UPDATE 입고
SET  입고수량 = 5
WHERE 입고코드 = 2;

ROLLBACK;

----------------------------------------------------------------------------------------------
-- 입고 테이블의 입고상품 삭제시 상품테이블의 보유 수량도 자동으로 변경되어야 한다.
-- 트리거작성
CREATE OR REPLACE TRIGGER MODIFY_TRG3
AFTER DELETE ON 입고
FOR EACH ROW
BEGIN
    UPDATE 상품
    SET 보유수량 = 보유수량 - :OLD.입고수량 
    WHERE 상품코드 LIKE :OLD.상품코드;
END;
/

DELETE FROM 입고 
WHERE 상품코드 LIKE 'A002';