/*
 ��Ű�� (����� / ���� �ΰ����� ������)
    [1] �����
    [2] ����
*/
-- 1. �����
-- CREATE OR REPALCE PACKAGE ��Ű���� AS
-- ���ν��� ����������; ...
-- END
--/
CREATE OR REPLACE PACKAGE EMPINFO AS
PROCEDURE ALLEMP;
PROCEDURE ALLSAL;
END EMPINFO;
/

--2.����
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
        DBMS_OUTPUT.PUT_LINE('��Ÿ ���� �߻�');
END ALLEMP;

PROCEDURE ALLSAL
IS
BEGIN
    FOR J IN (SELECT ROUND(AVG(SAL)) AVG_SAL, MAX(SAL) MAX_SAL, MIN(SAL) MIN_SAL 
                 FROM EMP) LOOP
                 DBMS_OUTPUT.PUT_LINE(J.AVG_SAL|| LPAD(J.MAX_SAL, 10, ' ') || LPAD(J.MIN_SAL, 10, ' '));
                 -- DBMS_OUTPUT.PUT_LINE  : DBMS_OUTPUT (��Ű����). PUT_LINE(���ν�����)!!!
    END LOOP;
END ALLSAL;
END EMPINFO; -- BODY ��Ű���� ~(���ν��� �����ų �����)~ END ��Ű����
/

EXEC EMPINFO.ALLEMP;
EXEC EMPINFO.ALLSAL;

EXEC DEPT_EMPINFO(10);
-----------------------------------------------------------------------------------------------------
/*
 �Լ� ( FUNCTION ) ��ȯŸ���� �ִ� (���ν����� ����Ÿ���� ����)
    ���� : CREATE OR REPLACE FUNCTION �Լ��̸�
            (�Ű����� IN, OUT, IN OUT ���ν����� ����)
            RETURN ��ȯ Ÿ�� !!
            IS
            BEGIN
            RETURN ��ȯ�� ������
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
    DBMS_OUTPUT.PUT_LINE('���'||VENO);
    RETURN VENO;
    
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
            dbms_output.put_line('�Է��� ����� �����');
    when too_many_rows then
        dbms_output.put_line('�ڷᰡ 2�� �̻��̿���');
    when others then
        dbms_output.put_line('��Ÿ �����Դϴ�');
END;
/
------------------
--�Լ��� ��ȯ���ִ� ���� �޾� �� ������ �����ؾ��Ѵ�.
SET SERVEROUTPUT ON;

VAR G_NO NUMBER;

EXEC : G_NO := GET_EMPNO('SCOTT');

PRINT G_NO;
        
-----------------------------------------------------------------------------
/*
    Trigger (Ʈ����) 
        �ַ� DML������ ���� �ɶ� �ڵ����� ����Ǵ� ���ν���
*/
CREATE OR REPLACE TRIGGER MY_TRG
BEFORE UPDATE ON DEPT -- Ʈ���� �̺�Ʈ : UPDATE
FOR EACH ROW --�� Ʈ����
BEGIN
    DBMS_OUTPUT.PUT_LINE('���� �� �÷� ��: ' || :OLD.DNAME);
    DBMS_OUTPUT.PUT_LINE('���� �� �÷� �� :' || :NEW.DNAME);
END;
/

SELECT * FROM DEPT;

UPDATE DEPT
SET DNAME = 'DEVELOPMENT'
WHERE DEPTNO LIKE 50;

COMMIT;

-----------------------------------------------------
--INSERT ���� ��� �Էµ� ������ �� => :NEW.�÷���
--UPDATE���� ���
--   [1] ���� �� ������ => :OLD.�÷���
--   [2] ���� �� ������ =>  :NEW.�÷���
--DELETE���� ��� �����Ǵ� ������ => :OLD.�÷���
-------------------------------------------------------
/*
 [�ǽ�] emp���̺� ���ؼ� �޿� ������ ������ ������
         ������ �޿� ������ ����� �޿� ����, �޿� ������ ����ϴ� Ʈ���Ÿ� 
         �ۼ��غ��ô�
*/

CREATE OR REPLACE TRIGGER LOG_SAL_TRG
AFTER UPDATE OR INSERT OR DELETE ON EMP
FOR EACH ROW
BEGIN
    DBMS_OUTPUT.PUT_LINE('����� �޿�' || :NEW.SAL);
    DBMS_OUTPUT.PUT_LINE('���� �޿�' || :OLD.SAL);
    DBMS_OUTPUT.PUT_LINE('�޿� ���� : ' || (:NEW.SAL - :OLD.SAL));
END;
/

SELECT * FROM EMP;

UPDATE EMP
SET SAL = SAL * 1.1
WHERE EMPNO LIKE 7788;

ROLLBACK;
------------------------------------------------------------------
--������ �������� Ʈ���� ��ȸ
SELECT * FROM USER_TRIGGERS;

--Ʈ���� Ȱ��ȭ / ��Ȱ��ȭ
-- ALTER TRIGGER Ʈ�����̸� ENABLE /DISABLE
ALTER TRIGGER LOG_SAL_TRG DISABLE; -- Ʈ���� ��Ȱ��ȭ
ALTER TRIGGER LOG_SAL_TRG ENABLE; -- Ʈ���� Ȱ��ȭ

--Ʈ���� ���� 
-- DROP TRIGGER Ʈ���� �̸�;
DROP TRIGGER LOG_SAL_TRG;
-----------------------------------------------------------------------------------
-- Ʈ���� Ȱ�� �ǽ�
-- 1. �԰� ���̺�, ��ǰ ���̺� ����
-- 2. �԰� ���̺� ��ǰ�� �԰�Ǹ� ��ǰ ���̺��� ���������� �ڵ����� �����ǵ��� Ʈ���� �ۼ�

CREATE TABLE ��ǰ(
    ��ǰ�ڵ� VARCHAR2(20) PRIMARY KEY,
    ��ǰ�� VARCHAR2(50) NOT NULL,
    ������ VARCHAR2(30),
    ���� NUMBER(8),
    �������� NUMBER(8) DEFAULT 0
);
CREATE TABLE �԰�(
    �԰��ڵ� NUMBER PRIMARY KEY,
    ��ǰ�ڵ� VARCHAR2(20) REFERENCES ��ǰ(��ǰ�ڵ�),
    �԰�¥ DATE DEFAULT SYSDATE,
    �԰��� NUMBER(8),
    �԰���� NUMBER(8)
);

--��ǰ ���̺� ��ǰ ���
INSERT INTO ��ǰ VALUES ('A001', '��Ʈ��', 'LG', 100000, 5);
INSERT INTO ��ǰ VALUES ('A002', 'TV', '�Ｚ', 2000000, 10);
INSERT INTO ��ǰ VALUES ('A003', '�����', '��ä', 150000, 15);
COMMIT;

SELECT * FROM ��ǰ;

CREATE SEQUENCE �԰�_SEQ
NOCACHE;

-- �԰� ���̺� ��ǰ�� �԰� �Ǹ� ��ǰ ���̺��� �������� �����ϴ� Ʈ���Ÿ� �ۼ��ϼ���
CREATE OR REPLACE TRIGGER MODIFY_TRG
AFTER UPDATE OR INSERT ON �԰�
FOR EACH ROW

BEGIN
    UPDATE ��ǰ
    SET �������� = �������� + :NEW.�԰����
    WHERE ��ǰ�ڵ� LIKE :NEW.��ǰ�ڵ�;
END;
/

SELECT * FROM �԰�;
SELECT * FROM ��ǰ;
INSERT INTO �԰� VALUES(�԰�_SEQ.NEXTVAL, 'A001', DEFAULT, 1000000, 10);
INSERT INTO �԰� VALUES(�԰�_SEQ.NEXTVAL, 'A002', DEFAULT, 800000, 10);

--�԰� ���̺��� ������ ���� �� ��ǰ ���̺��� ���������� ����Ǿ���Ѵ�.
-- UPDATE�԰� => ��ǰ.��������
CREATE OR REPLACE TRIGGER MODIFY_TRG1
AFTER UPDATE ON �԰�
FOR EACH ROW
BEGIN
    UPDATE ��ǰ
    SET �������� = (�������� - :OLD.�԰���� + :NEW.�԰����)
    WHERE ��ǰ�ڵ� = :OLD.��ǰ�ڵ�;
    DBMS_OUTPUT.PUT_LINE('���� �԰���� '|| :OLD.�԰����);
    DBMS_OUTPUT.PUT_LINE('���� �� �԰����' || :NEW.�԰����);
END;
/

DROP TRIGGER MODIFY_TRG1;

SELECT A.*, B.*
FROM �԰� A RIGHT JOIN ��ǰ B
ON A.��ǰ�ڵ� = B.��ǰ�ڵ�;

UPDATE �԰�
SET  �԰���� = 5
WHERE �԰��ڵ� = 2;

ROLLBACK;

----------------------------------------------------------------------------------------------
-- �԰� ���̺��� �԰��ǰ ������ ��ǰ���̺��� ���� ������ �ڵ����� ����Ǿ�� �Ѵ�.
-- Ʈ�����ۼ�
CREATE OR REPLACE TRIGGER MODIFY_TRG3
AFTER DELETE ON �԰�
FOR EACH ROW
BEGIN
    UPDATE ��ǰ
    SET �������� = �������� - :OLD.�԰���� 
    WHERE ��ǰ�ڵ� LIKE :OLD.��ǰ�ڵ�;
END;
/

DELETE FROM �԰� 
WHERE ��ǰ�ڵ� LIKE 'A002';