drop table spring_board;
create table spring_board(
    idx number(8) constraint board_pk primary key, --글번호
    name varchar2(30) not null, --작성자
    pwd varchar2(20) not null, --비번
    subject varchar2(200), --제목
    content varchar2(2000), --글 내용
    wdate timestamp default systimestamp, --작성일
    readnum number(8) default 0, --조회수
    filename varchar2(300), --첨부파일명[년월일시분초_file.png] =>물리적 파일명
    originFilename varchar2(300), --원본파일명 [file.png]
    filesize number(8), --첨부파일크기
    refer number(8) , --글그룹 번호 [답변형 게시판일 때 사용]
    lev number(8), --답변 레벨 [답변형 게시판일 때 사용] 
    sunbun number(8)--같은 글그룹 내에서의 순서 정렬 [답변형 게시판일 때 사용]
);

drop sequence spring_board_seq;

IDX
2.두번쨰글 (refer : 2, lev : 0, sunbun : 0)
3.  +--[RE] 두번쨰글의 답변 (refer:2, lev : 1, sunbun : 1)

1.첫번째글 (refer : 1, lev : 0 {원본글은 무조건 0},sunbun : 0)
4.    +--[RE] 첫번쨰글의 답변 (refer : 1, lev :1 sunbun : 1)
	   +------[RE] 답변의 답변(refer : 1, lev : 2 sunbun : 2)
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


