drop table spring_board;
create table spring_board(
    idx number(8) constraint board_pk primary key, --�۹�ȣ
    name varchar2(30) not null, --�ۼ���
    pwd varchar2(20) not null, --���
    subject varchar2(200), --����
    content varchar2(2000), --�� ����
    wdate timestamp default systimestamp, --�ۼ���
    readnum number(8) default 0, --��ȸ��
    filename varchar2(300), --÷�����ϸ�[����Ͻú���_file.png] =>������ ���ϸ�
    originFilename varchar2(300), --�������ϸ� [file.png]
    filesize number(8), --÷������ũ��
    refer number(8) , --�۱׷� ��ȣ [�亯�� �Խ����� �� ���]
    lev number(8), --�亯 ���� [�亯�� �Խ����� �� ���] 
    sunbun number(8)--���� �۱׷� �������� ���� ���� [�亯�� �Խ����� �� ���]
);

drop sequence spring_board_seq;

IDX
2.�ι����� (refer : 2, lev : 0, sunbun : 0)
3.  +--[RE] �ι������� �亯 (refer:2, lev : 1, sunbun : 1)

1.ù��°�� (refer : 1, lev : 0 {�������� ������ 0},sunbun : 0)
4.    +--[RE] ù�������� �亯 (refer : 1, lev :1 sunbun : 1)
	   +------[RE] �亯�� �亯(refer : 1, lev : 2 sunbun : 2)
create sequence spring_board_seq
start with 1
increment by 1
nocache;

select * from orderDesc;
create or replace view orderView
as
select a.onum, idx_fk, ototalPrice, ototalPoint, odeliverCost,
         odeliverState, opayWay, opayState, omileage, orderDate, omemo,
         pnum_fk, pimage, ( select pname from product where pnum = b.pnum_fk) pname,
         oqty, saleprice, opoint, rcvname, hp1, hp2, hp3, zipcode, addr1, addr2
from orderDesc a join orderProduct b
on a.onum = b.onum
join receiver c
on b.onum = c.onum;


select onum, pnum_fk, pname, pimage, orderDate, ototalPrice
from orderView
where idx_fk like 1
order  by orderDate desc;
------------------------------------------------------------------------


