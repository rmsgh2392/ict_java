ALTER TABLE CATEGORY
	DROP
		PRIMARY KEY
		CASCADE
		KEEP INDEX;

DROP INDEX PK_CATEGORY;

/* ī�װ� */
DROP TABLE CATEGORY 
	CASCADE CONSTRAINTS;

/* ī�װ� */
CREATE TABLE CATEGORY (
	CG_NUM NUMBER(8) NOT NULL, /* ī�װ���ȣ */
	CG_CODE VARCHAR2(20) NOT NULL, /* ī�װ��ڵ� */
	CG_NAME VARCHAR2(50) NOT NULL /* ī�װ��� */
);
CREATE UNIQUE INDEX PK_CATEGORY
	ON CATEGORY (
		CG_NUM ASC
	);

ALTER TABLE CATEGORY
	ADD
		CONSTRAINT PK_CATEGORY
		PRIMARY KEY (
			CG_NUM
		);

DROP SEQUENCE CATEGORY_SEQ;

CREATE SEQUENCE CATEGORY_SEQ NOCACHE;

insert into category(cg_num, cg_code, cg_name)
values(category_seq.nextval, 'A001', '������ǰ');

insert into category(cg_num, cg_code, cg_name)
values(category_seq.nextval, 'B001', '��Ȱ��ǰ');

insert into category(cg_num, cg_code, cg_name)
values(category_seq.nextval, 'C001', '�����Ƿ�');

commit;

select * from category;
--------------------------------------------------------------
