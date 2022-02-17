ALTER TABLE CATEGORY
	DROP
		PRIMARY KEY
		CASCADE
		KEEP INDEX;

DROP INDEX PK_CATEGORY;

/* 카테고리 */
DROP TABLE CATEGORY 
	CASCADE CONSTRAINTS;

/* 카테고리 */
CREATE TABLE CATEGORY (
	CG_NUM NUMBER(8) NOT NULL, /* 카테고리번호 */
	CG_CODE VARCHAR2(20) NOT NULL, /* 카테고리코드 */
	CG_NAME VARCHAR2(50) NOT NULL /* 카테고리명 */
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
values(category_seq.nextval, 'A001', '전자제품');

insert into category(cg_num, cg_code, cg_name)
values(category_seq.nextval, 'B001', '생활용품');

insert into category(cg_num, cg_code, cg_name)
values(category_seq.nextval, 'C001', '여성의류');

commit;

select * from category;
--------------------------------------------------------------
