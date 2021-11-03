--패키지
--[1] 선언부
--[2] 본문

--[1] 선언부
CREATE OR REPLACE PACKAGE EMPINFO AS
PROCEDURE ALLEMP;
PROCEDURE ALLSAL;
END EMPINFO;
/

--[2] 본문구성
CREATE OR REPLACE PACKAGE BODY EMPINFO AS
PROCEDURE ALLEMP
IS
    CURSOR EMPCR IS
        SELECT EMPNO, ENAME FROM EMP ORDER BY 1;
BEGIN
    FOR K IN EMPCR LOOP
        DBMS_OUTPUT.PUT_LINE(K.EMPNO|| LPAD(K.ENAME, 16,' '));
    END LOOP;
    EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('기타 에러 발생');
END ALLEMP;

PROCEDURE ALLSAL
IS
BEGIN
    FOR K IN ( SELECT ROUND(AVG(SAL)) AG_SAL, MAX(SAL) MX_SAL, MIN(SAL) MN_SAL FROM EMP) LOOP
        DBMS_OUTPUT.PUT_LINE(K.AG_SAL|| LPAD(K.MX_SAL,10,' ')|| LPAD(K.MN_SAL, 10,' '));
    END LOOP;
END ALLSAL;
END EMPINFO;
/


SET SERVEROUTPUT ON

--EXEC 패키지명.프로시저명

EXEC EMPINFO.ALLEMP;
EXEC EMPINFO.ALLSAL;

------------------------------------------------------------------------
--함수 (FUNCTION)
/*
    CREATE OR REPLACE FUNCTION  함수명
    (인파라미터....)
    RETURN  반환타입
    IS
    BEGIN
    END;
    /
*/
------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION GET_EMPNO
(PNAME IN EMP.ENAME%TYPE)
RETURN EMP.EMPNO%TYPE
IS
VENO EMP.EMPNO%TYPE;
BEGIN
    SELECT EMPNO INTO VENO
    FROM EMP
    WHERE ENAME = UPPER(PNAME);
    DBMS_OUTPUT.PUT_LINE('사번: '||VENO);
    RETURN VENO;
    
    exception
        when no_data_found then
        dbms_output.put_line('입력한 사원은 없어요');
        when too_many_rows then
        dbms_output.put_line('자료가 2건 이상이에요');
        when others then
        dbms_output.put_line('기타 에러입니다');    
END;
/
------------------------------------------------------------------------
--함수가 반환해주는 값을 받아줄 변수를 선언해야 한다.
SET SERVEROUTPUT ON

VAR G_NO NUMBER

EXEC :G_NO := GET_EMPNO('scott');

PRINT G_NO
------------------------------------------------------------------------
-- TRIGGER
------------------------------------------------------------------------
CREATE OR REPLACE TRIGGER MY_TRG
BEFORE UPDATE ON DEPT
FOR EACH ROW
BEGIN
    DBMS_OUTPUT.PUT_LINE('변경 전 컬럼값: '|| :OLD.DNAME);
    DBMS_OUTPUT.PUT_LINE('변경 후 컬럼값: '|| :NEW.DNAME);
END;
/
------------------------------------------------------------------------
SELECT * FROM DEPT;

UPDATE DEPT SET DNAME ='DEVELOPEMENT' WHERE DEPTNO=50;

COMMIT;
-------------------------------------------------------
/*
- INSERT문의 경우 입력된 데이터값=> :NEW.컬럼명
- UPDATE문의 경우
    [1] 변경전 데이터 =>:OLD.컬럼명
    [2] 변경후 데이터 =>:NEW.컬럼명
- DELETE문의 경우 삭제되는 데이터 => :OLD.컬럼명
*/
--------------------------------------------------------
/*
[실습] emp테이블에 대해서 급여 정보를 수정할 때마다
이전의 급여 정보와 변경된 급여 정보, 급여 차액을 출력하는 트리거를 
작성해봅시다

트리거명: LOG_SAL_TRG
이벤트 : UPDATE 급여 ON EMP
*/
--------------------------------------------------------

CREATE OR REPLACE TRIGGER LOG_SAL_TRG
AFTER UPDATE OR INSERT OR DELETE ON EMP
FOR EACH ROW
BEGIN
    DBMS_OUTPUT.PUT_LINE('이전 급여: '||:OLD.SAL);
    DBMS_OUTPUT.PUT_LINE('이후 급여: '||:NEW.SAL);
    DBMS_OUTPUT.PUT_LINE('급여 차액: '||(:NEW.SAL - :OLD.SAL));
END;
/

UPDATE EMP SET SAL = SAL*1.1 WHERE ENAME='SCOTT';

ROLLBACK;
SELECT * FROM EMP WHERE ENAME='JAMES';

DELETE FROM EMP WHERE EMPNO=7900;

ROLLBACK;

SELECT NVL(SAL, 100) *1.1 FROM EMP WHERE ENAME='JAMES';
---------------------------------------------------
데이터 사전에서 트리거 조회

SELECT * FROM USER_TRIGGERS;

트리거 활성화/비활성하

ALTER TRIGGER 트리거명  ENABLE/DISABLE

--ALTER TRIGGER LOG_SAL_TRG DISABLE;
ALTER TRIGGER LOG_SAL_TRG ENABLE;

UPDATE EMP SET SAL = SAL*1.1 WHERE ENAME='SCOTT';

ROLLBACK;

-- 트리거 삭제
-- DROP TRIGGER 트리거명
DROP TRIGGER LOG_SAL_TRG;
------------------------------------------------------------------------
-- 트리거 활용 실습
-- [1] 입고 테이블, 상품 테이블 생성
-- [2] 입고 테이블에 상품이 입고되면 상품 테이블의 보유수량이 자동으로 조절되도록 트리거를 작성해보자
------------------------------------------------------------------------

--상품 테이블 생성

CREATE TABLE 상품(
    상품코드 VARCHAR2(20) PRIMARY KEY,
    상품명 VARCHAR2(50) NOT NULL,
    제조사 VARCHAR2(30),
    가격 NUMBER(8),
    보유수량 NUMBER(8) DEFAULT 0
);

--입고 테이블 생성
/* 입고코드 : NUMBER PK
   상품코드: VARCHAR2(20) FK
   입고가격: NUMBER(8)
   입고수량: NUMBER(8)
   입고일자: DATE 
*/
CREATE TABLE 입고(
    입고코드 NUMBER(8) PRIMARY KEY,
    상품코드 VARCHAR2(20) REFERENCES 상품(상품코드),
    입고가격 NUMBER(8),
    입고수량 NUMBER(8),
    입고일자 DATE DEFAULT SYSDATE
);

--상품테이블에 상품 등록
INSERT INTO 상품 VALUES('A001','노트북','LG', 1000000, 5);
INSERT INTO 상품 VALUES('A002','TV','삼성', 1200000, 10);
INSERT INTO 상품 VALUES('A003','냉장고','위니아', 1500000, 15);
COMMIT;

SELECT * FROM 상품;

CREATE SEQUENCE 입고_SEQ NOCACHE;

--[1] 입고 테이블에 상품이 입고되면 상품 테이블의 보유수량을 수정하는 트리거를 작성하세요
-- 보유수량 = 기존 수량 + 입고 수량
-- 트리거명: SHOP_TRG1

CREATE OR REPLACE TRIGGER SHOP_TRG1
AFTER INSERT ON 입고 FOR EACH ROW
BEGIN
    UPDATE 상품 SET 보유수량 = 보유수량 + :NEW.입고수량 WHERE 상품코드 = :NEW.상품코드;
END;
/

SELECT * FROM 입고;
SELECT * FROM 상품;

INSERT INTO 입고 VALUES(입고_SEQ.NEXTVAL, 'A001', 900000, 20, SYSDATE);
INSERT INTO 입고 VALUES(입고_SEQ.NEXTVAL, 'A002', 800000, 10, SYSDATE);

--[문제1] 입고 테이블의 수량 변경 시 상품 테이블의 보유수량도 변경되어야 한다.
-- 어떻게 변경해야할지 고민해보고 트리거를 작성하세요
-- SHOP_TRG2
-- UPDATE 입고 ===> 상품 보유수량
-- :OLD.입고수량(20개)   :NEW.입고수량(19개)

CREATE OR REPLACE TRIGGER SHOP_TRG2
AFTER UPDATE ON 입고 FOR EACH ROW
BEGIN
    UPDATE 상품 SET 보유수량 = (보유수량 - :OLD.입고수량 + :NEW.입고수량)
    WHERE 상품코드 = :OLD.상품코드;
    DBMS_OUTPUT.PUT_LINE('기존 입고수량: '|| :OLD.입고수량);
    DBMS_OUTPUT.PUT_LINE('변경된 입고수량: '|| :NEW.입고수량);
END;
/

CREATE OR REPLACE TRIGGER MODIFY_TRG1
AFTER UPDATE ON 입고
FOR EACH ROW
BEGIN
    UPDATE 상품
    SET 보유수량 = (보유수량 - :OLD.입고수량 + :NEW.입고수량)
    WHERE 상품코드 LIKE :OLD.상품코드;
    DBMS_OUTPUT.PUT_LINE('기존 입고수량 '|| :OLD.입고수량);
    DBMS_OUTPUT.PUT_LINE('변경 된 입고수량' || :NEW.입고수량);
END;
/


UPDATE 입고 SET 입고수량 = 5 WHERE 입고코드= 1;

-- 입고, 상품 JOIN해서 보여주세요

SELECT A.*, B.*
FROM 입고 A RIGHT OUTER JOIN 상품 B
ON A.상품코드 = B.상품코드;

UPDATE 입고 SET 입고수량 =18 WHERE 입고코드=1;

--[문제2] 입고 테이블의 입고상품 삭제시 상품테이블의 보유 수량도 자동으로 변경되어야 한다.
-- 트리거 작성하세요
-- 트리거명: SHOP_TRG3











