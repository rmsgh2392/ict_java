/*
CREATE OR REPLACE PROCEDURE ���ν�����
IS 
-- ���� ����(IS ~ BEGIN) ����
BEGIN
-- ���๮ (BEGIN ~ END) �ʼ�
END;
/  -- > ��Ʈ
*/

--�ڹٿ��� �޼ҵ� (�Ű����� IN ������Ÿ��) / �޾ƿ��°� IN �������°�  OUT
CREATE OR REPLACE PROCEDURE HELLO(NAME IN VARCHAR2) 
IS 
BEGIN
    DBMS_OUTPUT.PUT_LINE('HELLO ' ||NAME); -- ���๮ (�ڹ� - System.out.println())
-- ��Ű����(DBMS_OUTPUT).���ν�����(PUT_LINE)
END;
/
SET SERVEROUTPUT ON -- �⺻������ OUPPUT�� ���� �ִ� ���� ���ؼ� �������� �ٽ� ������Ѵ�.

EXECUTE HELLO; -- HELLO �޼ҵ� ȣ��
EXEC HELLO('����');

-------------------------------------------------------------------
-- ���� �ð��� 3�ð� ���� �ð��� ����ϴ� ���ν����� �ۼ�
CREATE OR REPLACE PROCEDURE TIMES
IS
  CURRTIME TIMESTAMP; -- ���� �ð��� �Ҵ���� ���� ���� 
  AFTERTIME TIMESTAMP; -- 3�ð� ���� �ð��� �Ҵ� ���� ���� ����
BEGIN
    SELECT SYSTIMESTAMP, SYSTIMESTAMP +3 / 24  INTO CURRTIME, AFTERTIME FROM DUAL;
    --SELECT SYSTIMESTAMP +3 /24  INTO AFTERTIME FROM DUAL;
    DBMS_OUTPUT.PUT_LINE('���� �ð� : ' ||CURRTIME);
    DBMS_OUTPUT.PUT_LINE('3�ð� �� �ð� : ' ||AFTERTIME);
END;
/

EXEC TIMES;

--MEMO ���̺� �����͸� INSERT �ϴ� ���ν����� �ۼ�
-- ��, ���Ķ���� 2���� �޾Ƶ鿩 INSERT
-- �ۼ���, �޸𳻿� => INPRARMETER ����

-- PNAME IN MEMO.NAME%TYPE, PMSG IN MEMO.MSG%TYPE
-- MEMO ���̺��� NAME�÷����� ������Ÿ���̶� �����ش�.
CREATE OR REPLACE PROCEDURE MEMO_ADD(PNAME IN MEMO.NAME%TYPE, PMSG IN MEMO.MSG%TYPE)
IS
BEGIN
    INSERT INTO MEMO(IDX,NAME, MSG) 
    VALUES(MEMO_SEQ.NEXTVAL, PNAME, PMSG);
    COMMIT;
END;
/

EXEC MEMO_ADD('���̲���', '����~~��~~��');

SELECT * FROM MEMO;


-- ������ �۹�ȣ�� IN �Ķ���͸� �޾Ƽ� �ش���� �����ϴ� ���ν����� �ۼ�
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

-- ������ �� ��ȣ, �� ������ ���Ķ���ͷ� �޾Ƽ� 
-- �ش���� �����ϴ� ���ν����� �ۼ��ϼ���
CREATE OR REPLACE PROCEDURE MEMO_MFY(MIDX IN MEMO.IDX%TYPE, MMSG IN MEMO.MSG%TYPE)
IS
BEGIN
    UPDATE MEMO
    SET MSG = MMSG
    WHERE IDX LIKE MIDX;
END;
/

EXEC MEMO_MFY(5, '�����')

SELECT * FROM MEMO;


-- ��� �̸� ��� ��ȣ ��� �޿� ����ϴ� ���ν���
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
DBMS_OUTPUT.PUT_LINE('�����ȣ :' ||V_EMPNO);
DBMS_OUTPUT.PUT_LINE('����̸� :' ||V_ENAME);
DBMS_OUTPUT.PUT_LINE('�޿� : '||V_SAL);

END;
/

EXEC EMP_INFO(7900);

--�� ��ȣ�� ���� �ϸ� �ش� �� ������ ������ ����ϴ� ���ν����� �ۼ�
CREATE OR REPLACE PROCEDURE MEMO_FIND(PIDX IN MEMO.IDX%TYPE)
IS
V_NAME MEMO.NAME%TYPE;  -- V_NAME VARCHAR2 --��Į�� ����Ÿ��
V_MSG MEMO.MSG%TYPE;
V_DATE MEMO.WDATE%TYPE;
BEGIN
    SELECT NAME, MSG, WDATE
    INTO V_NAME, V_MSG, V_DATE
    FROM MEMO
    WHERE IDX LIKE PIDX;
    
    DBMS_OUTPUT.PUT_LINE(V_NAME||'   '||V_DATE||'  '||V_MSG);
EXCEPTION 
WHEN NO_DATA_FOUND THEN  -- ����ó�� EXCEPTION WHEN ����ó�� ���� THEN ����ó�� 
    DBMS_OUTPUT.PUT_LINE(PIDX||'�� ���� �����ϴ�');
END;
/

SET SERVEROUTPUT ON
EXEC MEMO_FIND(200);

--�μ���ȣ�� �Է� �ش� �μ��� �μ���, ��ġ�� ����ϴ� ���ν���
--%ROWTYPE : �ϳ� �̻��� ������ ���� ���� ������ Ÿ�� (���յ�����Ÿ��)
CREATE OR REPLACE PROCEDURE DEPT_FIND(PNO IN DEPT.DEPTNO%TYPE)
IS
    VDEPT DEPT%ROWTYPE; -- DEPT ���̺��� �ϳ��� ��� ���� Ÿ�� 
BEGIN
    SELECT DEPTNO, DNAME, LOC
    INTO VDEPT.DEPTNO, VDEPT.DNAME, VDEPT.LOC
    FROM DEPT
    WHERE DEPTNO LIKE PNO;
    
    DBMS_OUTPUT.PUT_LINE(VDEPT.DEPTNO||' '|| VDEPT.DNAME||'  ' ||VDEPT.LOC);
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
     DBMS_OUTPUT.PUT_LINE(PNO||' �� �μ��� �����');
END;
/

EXEC DEPT_FIND(40);

-- ����� �Է� ����� �̸�, ����, �޿� ���
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
DBMS_OUTPUT.PUT_LINE(PNO|| ' ���� ����� �������� �ʾƿ�');
END;
/

EXEC EMP_FIND(7788);

--------------------------------------------------------------------------------------
/* ���ν��� �Ķ���� ����
1) IN Parameter
2) Out Parameter -- �ڹٿ� ���� �Ѱ��� �� ���(�ܺη�)
3) IN OUT Parameter
*/
-- #Out Parameter : ���ν����� �ܺη� �Ѱ��ִ� �� 

-- ����� ���Ķ���ͷ� �Է� �ش� ����� �̸��� �ƿ� �Ķ���ͷ� �������� ���ν���
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
--OUT �Ķ���Ͱ� �ִ� ���ν����� �����Ϸ��� ������ ������ �Ŀ� �����ؾ��Ѵ�.
VARIABLE NAME VARCHAR2(20); --��������, ���ε� ���� => :�����̸� 

EXEC EMP_FIND2(7788, :NAME); --���ν������� OUT�Ķ���ͷ� �Ѱ��ִ� ���� NAME�̶�� ������ �޴´�.

PRINT NAME;

-- PL/SQL ���
/*
1) IF �� : IF ~~ END IF;  

2) LOOP ��  
LOOP  
    ���๮��;
    EXIT WHEN ���ǹ�; -- LOOP���� �����ų ���ǹ��� �ݵ�� �ۼ� �ƴ� ���ѷ���~~
END LOOP;

3) FOR LOOP ��
FOR ���� IN [ REVERSE ��������] ���� �� .. END �� LOOP
    ���๮
END LOOP;
- ���� : BINARY_INTEGER Ÿ���� �����̰� �ڵ����� 1�� ���� / REVERSE ����
- IN �ڿ��� CURSOR, ���������� �� ���� �ִ�.

4) WHILE LOOP ��
WHILE ���ǽ� LOOP
    ���๮;
    ������;
END LOOP;
*/
-- ����� �Է� �ش����� �̸�, �μ����� ���
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
    
    IF VDNO LIKE 10 THEN VDNAME :='ȸ��μ�';  -- := ���Կ�����
    ELSIF VDNO LIKE 20 THEN VDNAME :='�����μ�';  -- ELSE IF (X)   ELSIF�� �ۼ�!!!! ����!!!!
    ELSIF VDNO LIKE 30 THEN VDNAME :='�����μ�';
    ELSIF VDNO LIKE 40 THEN VDNAME :='��μ�';
    ELSIF VDNO LIKE 50 THEN VDNAME :='���ߺμ�';
    ELSE VDNAME :='�μ��� �����';
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('��� : ' ||PNO);
    DBMS_OUTPUT.PUT_LINE('�̸� : ' ||VNAME);
    DBMS_OUTPUT.PUT_LINE('�μ� ��ȣ : ' ||VDNO);
    DBMS_OUTPUT.PUT_LINE('�μ� �̸� : ' ||VDNAME);
END;
/

EXEC EMP_FIND3(7839);

--MEMO ���̺� �λ����� 100 �Է� LOOP���
CREATE OR REPLACE PROCEDURE LOOT_TEST
IS
    VCNT NUMBER(3) :=100;  -- �Ҵ翬���� :=
BEGIN
    LOOP
        INSERT INTO MEMO(IDX, NAME, MSG, WDATE)
        VALUES(MEMO_SEQ.NEXTVAL, 'TEST', '�λ�����'||VCNT, SYSDATE);
        VCNT := VCNT+1;
        EXIT WHEN VCNT > 105;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('������ �Է¿Ϸ�');
    DBMS_OUTPUT.PUT_LINE(VCNT);
    DBMS_OUTPUT.PUT_LINE(VCNT - 100||'���� �����Ͱ� ���ԵǾ����');
END;
/
EXEC LOOT_TEST;
SELECT * FROM MEMO ORDER BY IDX DESC;
----------------------------------------------------------------
-- �͸� ���ν��� �ۼ� 
-- DECLARE
     -- ���� ����
-- BEGIN
    -- ���๮, ����ó����
-- END
--/
DECLARE
--���� ����
BEGIN
-- ���๮ , ����ó����
    FOR J IN REVERSE 1 .. 10 LOOP
          DBMS_OUTPUT.PUT_LINE('Hello'||J);
    END LOOP;
END;
/

--DEPT ���̺��� ��� �μ������� ����������ϴ����ν���
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
-- WHILE �� �ǽ�
DECLARE
    CNT NUMBER := 1;
BEGIN
    WHILE CNT < 5 LOOP
        INSERT INTO EMP(EMPNO, ENAME, HIREDATE)
        VALUES(CNT, '����'||CNT, SYSDATE);
        CNT := CNT + 1; -- CNT �� 1�� ����
        EXIT WHEN CNT = 3; --LOOP�� ������ ������ �ۼ� �� ���ִ�.
    END LOOP;
    DBMS_OUTPUT.PUT_LINE(CNT-1||'���� ���ڵ� ����');
END;
/
SELECT * FROM EMP;
ROLLBACK;

---------------------------------------------------------------------------
--�ǽ� �μ��� ��� �޿�, �ִ� �޿�, �ּұ޿�, �ο����� ������ ����ϴ� ���ν���
--�μ���ȣ, �ο���, ��ձ޿�, �ִ�޿�, �ּұ޿�

DECLARE
BEGIN -- �׷��Լ��� ��Ī�� ����Ͽ� ���� �����´�.
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

--����� Ŀ���� �̿��ؼ� �������� ���ڵ带 ����
create or replace procedure empsel
is
vno emp.empno%type:=0; --DEFAULT �� �Ҵ�
vname emp.ename%type:=null;
vsal emp.sal%type:=0;
vdate emp.hiredate%type;
VCNT NUMBER :=1;
--����� Ŀ�� ����  CURSOR Ŀ���̸� IS ~
CURSOR EMP_CR IS 
    SELECT EMPNO, ENAME, SAL, HIREDATE
    FROM EMP
    ORDER BY 1;
begin
--Ŀ���� OPEN
    OPEN EMP_CR;
        LOOP 
        -- ������ ���� Fetch
            FETCH EMP_CR INTO VNO, VNAME, VSAL, VDATE;
            VCNT := VCNT +1;
            EXIT WHEN EMP_CR%NOTFOUND; -- �����Ͱ� ������ TRUE�� ��ȯ��
            DBMS_OUTPUT.PUT_LINE(VNO||'  '||VNAME||' '||VSAL||'  '||VDATE);
        END LOOP;
        DBMS_OUTPUT.PUT_LINE(VCNT||' ���� ���� ����Ǿ����ϴ�');
--Ŀ���� CLOSE
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