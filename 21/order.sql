create table orderDesc(
    onum varchar2(30) not null, --�ֹ���ȣ
    ototalPrice number(10), --�Ѱ����ݾ�  
    ototalPoint number(10), --�Ѱ�������Ʈ
    odeliverCost number(8) default 3000, --��ۺ�
    odeliverState varchar2(20), --��ۻ���
    opayWay varchar2(20), --���ҹ��
    opayState varchar2(20), --���һ���
    omileage number(10), --���������
    orderDate date, --�ֹ���
    omemo varchar2(100), --��۽ÿ�û����
    idx_fk number(8),
    constraint orderDesc_onum_pk primary key (onum),
    constraint orderDesc_idx_fk foreign key (idx_fk)
    references jsp_member (idx)
);

--�ֹ���ǰ [orderProduct]
drop table orderProduct;

create table orderProduct(
    onum varchar2(30), --�ֹ���ȣ
    pnum_fk number(8), --��ǰ��ȣ
    oqty number(10), --����
    saleprice number(10), --�ܰ�
    opoint number(10), --���� ����Ʈ
    pimage varchar2(300),
    constraint orderProduct_pk primary key (onum, pnum_fk),
    constraint orderProduct_onum_fk foreign key (onum)
        references orderDesc (onum),
    constraint orderProduct_pnum_fk foreign key (pnum_fk)
        references product (pnum)
);

--������ [receiver]
drop table receiver;
create table receiver(
    onum varchar2(30), --�ֹ���ȣ
    rcvname varchar2(30), --������ �̸�
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