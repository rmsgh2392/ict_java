create table orderDesc(
    onum varchar2(30) not null, --주문번호
    ototalPrice number(10), --총결제금액  
    ototalPoint number(10), --총결제포인트
    odeliverCost number(8) default 3000, --배송비
    odeliverState varchar2(20), --배송상태
    opayWay varchar2(20), --지불방법
    opayState varchar2(20), --지불상태
    omileage number(10), --사용적립금
    orderDate date, --주문일
    omemo varchar2(100), --배송시요청사항
    idx_fk number(8),
    constraint orderDesc_onum_pk primary key (onum),
    constraint orderDesc_idx_fk foreign key (idx_fk)
    references jsp_member (idx)
);

--주문상품 [orderProduct]
drop table orderProduct;

create table orderProduct(
    onum varchar2(30), --주문번호
    pnum_fk number(8), --상품번호
    oqty number(10), --수량
    saleprice number(10), --단가
    opoint number(10), --지급 포인트
    pimage varchar2(300),
    constraint orderProduct_pk primary key (onum, pnum_fk),
    constraint orderProduct_onum_fk foreign key (onum)
        references orderDesc (onum),
    constraint orderProduct_pnum_fk foreign key (pnum_fk)
        references product (pnum)
);

--수령자 [receiver]
drop table receiver;
create table receiver(
    onum varchar2(30), --주문번호
    rcvname varchar2(30), --수령자 이름
    hp1 char(3) not null,
    hp2 char(4) not null,
    hp3 char(4) not null,
    zipcode char(5) not null,
    addr1 varchar2(200) not null,
    addr2 varchar2(200) not null,
    constraint receiver_onum_pk primary key (onum),
    constraint receiver_onum_fk foreign key (onum)
        references orderDesc (onum)
);
desc orderdesc;
desc orderproduct;
desc receiver;