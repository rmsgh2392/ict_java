--��Ű��
--[1] �����
--[2] ����

--[1] �����
CREATE OR REPLACE PACKAGE EMPINFO AS
PROCEDURE ALLEMP;
PROCEDURE ALLSAL;
END EMPINFO;
/

--[2] ��������
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
        DBMS_OUTPUT.PUT_LINE('��Ÿ ���� �߻�');
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

--EXEC ��Ű����.���ν�����

EXEC EMPINFO.ALLEMP;
EXEC EMPINFO.ALLSAL;

------------------------------------------------------------------------
--�Լ� (FUNCTION)
/*
    CREATE OR REPLACE FUNCTION  �Լ���
    (���Ķ����....)
    RETURN  ��ȯŸ��
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
    DBMS_OUTPUT.PUT_LINE('���: '||VENO);
    RETURN VENO;
    
    exception
        when no_data_found then
        dbms_output.put_line('�Է��� ����� �����');
        when too_many_rows then
        dbms_output.put_line('�ڷᰡ 2�� �̻��̿���');
        when others then
        dbms_output.put_line('��Ÿ �����Դϴ�');    
END;
/
------------------------------------------------------------------------
--�Լ��� ��ȯ���ִ� ���� �޾��� ������ �����ؾ� �Ѵ�.
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
    DBMS_OUTPUT.PUT_LINE('���� �� �÷���: '|| :OLD.DNAME);
    DBMS_OUTPUT.PUT_LINE('���� �� �÷���: '|| :NEW.DNAME);
END;
/
------------------------------------------------------------------------
SELECT * FROM DEPT;

UPDATE DEPT SET DNAME ='DEVELOPEMENT' WHERE DEPTNO=50;

COMMIT;
-------------------------------------------------------
/*
- INSERT���� ��� �Էµ� �����Ͱ�=> :NEW.�÷���
- UPDATE���� ���
    [1] ������ ������ =>:OLD.�÷���
    [2] ������ ������ =>:NEW.�÷���
- DELETE���� ��� �����Ǵ� ������ => :OLD.�÷���
*/
--------------------------------------------------------
/*
[�ǽ�] emp���̺� ���ؼ� �޿� ������ ������ ������
������ �޿� ������ ����� �޿� ����, �޿� ������ ����ϴ� Ʈ���Ÿ� 
�ۼ��غ��ô�

Ʈ���Ÿ�: LOG_SAL_TRG
�̺�Ʈ : UPDATE �޿� ON EMP
*/
--------------------------------------------------------

CREATE OR REPLACE TRIGGER LOG_SAL_TRG
AFTER UPDATE OR INSERT OR DELETE ON EMP
FOR EACH ROW
BEGIN
    DBMS_OUTPUT.PUT_LINE('���� �޿�: '||:OLD.SAL);
    DBMS_OUTPUT.PUT_LINE('���� �޿�: '||:NEW.SAL);
    DBMS_OUTPUT.PUT_LINE('�޿� ����: '||(:NEW.SAL - :OLD.SAL));
END;
/

UPDATE EMP SET SAL = SAL*1.1 WHERE ENAME='SCOTT';

ROLLBACK;
SELECT * FROM EMP WHERE ENAME='JAMES';

DELETE FROM EMP WHERE EMPNO=7900;

ROLLBACK;

SELECT NVL(SAL, 100) *1.1 FROM EMP WHERE ENAME='JAMES';
---------------------------------------------------
������ �������� Ʈ���� ��ȸ

SELECT * FROM USER_TRIGGERS;

Ʈ���� Ȱ��ȭ/��Ȱ����

ALTER TRIGGER Ʈ���Ÿ�  ENABLE/DISABLE

--ALTER TRIGGER LOG_SAL_TRG DISABLE;
ALTER TRIGGER LOG_SAL_TRG ENABLE;

UPDATE EMP SET SAL = SAL*1.1 WHERE ENAME='SCOTT';

ROLLBACK;

-- Ʈ���� ����
-- DROP TRIGGER Ʈ���Ÿ�
DROP TRIGGER LOG_SAL_TRG;
------------------------------------------------------------------------
-- Ʈ���� Ȱ�� �ǽ�
-- [1] �԰� ���̺�, ��ǰ ���̺� ����
-- [2] �԰� ���̺� ��ǰ�� �԰�Ǹ� ��ǰ ���̺��� ���������� �ڵ����� �����ǵ��� Ʈ���Ÿ� �ۼ��غ���
------------------------------------------------------------------------

--��ǰ ���̺� ����

CREATE TABLE ��ǰ(
    ��ǰ�ڵ� VARCHAR2(20) PRIMARY KEY,
    ��ǰ�� VARCHAR2(50) NOT NULL,
    ������ VARCHAR2(30),
    ���� NUMBER(8),
    �������� NUMBER(8) DEFAULT 0
);

--�԰� ���̺� ����
/* �԰��ڵ� : NUMBER PK
   ��ǰ�ڵ�: VARCHAR2(20) FK
   �԰���: NUMBER(8)
   �԰����: NUMBER(8)
   �԰�����: DATE 
*/
CREATE TABLE �԰�(
    �԰��ڵ� NUMBER(8) PRIMARY KEY,
    ��ǰ�ڵ� VARCHAR2(20) REFERENCES ��ǰ(��ǰ�ڵ�),
    �԰��� NUMBER(8),
    �԰���� NUMBER(8),
    �԰����� DATE DEFAULT SYSDATE
);

--��ǰ���̺� ��ǰ ���
INSERT INTO ��ǰ VALUES('A001','��Ʈ��','LG', 1000000, 5);
INSERT INTO ��ǰ VALUES('A002','TV','�Ｚ', 1200000, 10);
INSERT INTO ��ǰ VALUES('A003','�����','���Ͼ�', 1500000, 15);
COMMIT;

SELECT * FROM ��ǰ;

CREATE SEQUENCE �԰�_SEQ NOCACHE;

--[1] �԰� ���̺� ��ǰ�� �԰�Ǹ� ��ǰ ���̺��� ���������� �����ϴ� Ʈ���Ÿ� �ۼ��ϼ���
-- �������� = ���� ���� + �԰� ����
-- Ʈ���Ÿ�: SHOP_TRG1

CREATE OR REPLACE TRIGGER SHOP_TRG1
AFTER INSERT ON �԰� FOR EACH ROW
BEGIN
    UPDATE ��ǰ SET �������� = �������� + :NEW.�԰���� WHERE ��ǰ�ڵ� = :NEW.��ǰ�ڵ�;
END;
/

SELECT * FROM �԰�;
SELECT * FROM ��ǰ;

INSERT INTO �԰� VALUES(�԰�_SEQ.NEXTVAL, 'A001', 900000, 20, SYSDATE);
INSERT INTO �԰� VALUES(�԰�_SEQ.NEXTVAL, 'A002', 800000, 10, SYSDATE);

--[����1] �԰� ���̺��� ���� ���� �� ��ǰ ���̺��� ���������� ����Ǿ�� �Ѵ�.
-- ��� �����ؾ����� ����غ��� Ʈ���Ÿ� �ۼ��ϼ���
-- SHOP_TRG2
-- UPDATE �԰� ===> ��ǰ ��������
-- :OLD.�԰����(20��)   :NEW.�԰����(19��)

CREATE OR REPLACE TRIGGER SHOP_TRG2
AFTER UPDATE ON �԰� FOR EACH ROW
BEGIN
    UPDATE ��ǰ SET �������� = (�������� - :OLD.�԰���� + :NEW.�԰����)
    WHERE ��ǰ�ڵ� = :OLD.��ǰ�ڵ�;
    DBMS_OUTPUT.PUT_LINE('���� �԰����: '|| :OLD.�԰����);
    DBMS_OUTPUT.PUT_LINE('����� �԰����: '|| :NEW.�԰����);
END;
/

CREATE OR REPLACE TRIGGER MODIFY_TRG1
AFTER UPDATE ON �԰�
FOR EACH ROW
BEGIN
    UPDATE ��ǰ
    SET �������� = (�������� - :OLD.�԰���� + :NEW.�԰����)
    WHERE ��ǰ�ڵ� LIKE :OLD.��ǰ�ڵ�;
    DBMS_OUTPUT.PUT_LINE('���� �԰���� '|| :OLD.�԰����);
    DBMS_OUTPUT.PUT_LINE('���� �� �԰����' || :NEW.�԰����);
END;
/


UPDATE �԰� SET �԰���� = 5 WHERE �԰��ڵ�= 1;

-- �԰�, ��ǰ JOIN�ؼ� �����ּ���

SELECT A.*, B.*
FROM �԰� A RIGHT OUTER JOIN ��ǰ B
ON A.��ǰ�ڵ� = B.��ǰ�ڵ�;

UPDATE �԰� SET �԰���� =18 WHERE �԰��ڵ�=1;

--[����2] �԰� ���̺��� �԰��ǰ ������ ��ǰ���̺��� ���� ������ �ڵ����� ����Ǿ�� �Ѵ�.
-- Ʈ���� �ۼ��ϼ���
-- Ʈ���Ÿ�: SHOP_TRG3











