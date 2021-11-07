1. Network 이란?
   - 하나의 Device(컴퓨터)로부터 다른 device로
     데이터를 옮기는 것
   - 네트워크 프로그램이란, 통신 프로그램을 의미
     ..자바의 네트워크 프로그램은 타 언어에 비해
    편리. 프로그램 개발시 해야 할 많은 기능들
    이 이미 core api에 구현되어 있기 때문

2. 통신의 3대 요소
  
 1) Server
 2) Client
 3) Network : 서버와 클라이언트를 연결해
              주는 근간
3. 통신 방법

 1) TCP 통신 방식

    - 양방향 연결 지향성 통신 방식
      (Connection Oriented 방식)
       - 신뢰적
    - 전화통화 방식과 비슷

    철이          순이  
    Server---------Network---------Client

    서버와 클라이언트가 통신하고자 할 때
    TCP 방식을 하고자 한다면
    1> 우선 서버와 클라이언트가 존재해야 함
       (즉 양 방향 이어야 함)
    2> 둘 사이에 연결이 이뤄져야 함
    3> 연결이 이뤄진 후 이들간에 대화가 오고
       갈 때 순이가 전달한 말을 철이가 
    못 알아 들었다면, 철이는 순이에게
    다시 말해달라고 요청해서 정확한
    내용을 들을 수 있다.
    ex) 전화 통화 방식과 유사
   
   2) UDP 통신 방식
    - 비연결 지향형 통신 방식
    - 비 신뢰적
    - 우편 배달 방식과 비슷
    1> UDP 방식은 데이터 손실이 있을 수 있다.
    2> 또한 클라이언트와 서버간에 연결이 이뤄
       지지 않은 상태에서도 데이터를 보낼 수
    있다
    ex)  우편물 배달 방식과 유사

4. TCP 방식을 쓸 경우

   1) TCP로의 연결은 Socket 클래스를 사용

   -TCP/IP를 써서 서버와 통신하기 위해
    클라이언트가 서버에 대한 소켓을
    생성해야 함
      - 이 때 TCP연결을 위해
        HOST(서버) 이름(ip)과 PORT번호를 
  정해줘야 함
      - 포트 번호는 1~65535 까지의 정수값이지만,
     0 ~ 1024 사이의 값은 시스템이 사용하는
  포트 번호이므로 사용하지 말아야
  cf> http는 80 포트, telnet은 23번
      ftp는 21번
      - 설정된 포트에서 대기(listening)하고
     있는 서버가 존재하고 있으면 연결되고
  그렇지 않으면 실패
      - 소켓 연결이 이뤄지면 이 Socket 을 이용해
     서버로의 Stream을 얻어낸다.
 ...Socket의 getInputStream()/getOutputStream()
    을 이용

   - 이 스트림을 통해 데이터를 주고 받는다.
     이 때 노드 스트림에 필터스트림을 덧입혀
  좀더 고 수준의 데이터 교환이 가능

5. 네트워크 프로그램 절차
    1) IP를 알아낸다.---> InetAddress클래스로
 2) TCP로 연결 ---> Socket을 이용
  
  ---------------------------------------
  서버의 경우			| 클라이언트 경우
  ----------------------+------------------
  1) ServerSocket			|1) Socket 
  2) Socket			|하나만 있으면 된다.
  두가지가 필요			|
  ----------------------+-------------------
  1)서버 소켓에서는		|1)클 소켓에서는
    열어둘 포트번호		|  서버의 ip주소와
    를 인자로		|  port번호 두개를
			|  인자로 받는다.
  ServerSocket ser		|
 =new ServerSocket(5555)| Socket cs
  2)서버 소켓을 통해		|   =new Socket(ip,5555)
    클과 통신할		|
    소켓을 얻는다.		|
  Socket sock=		|
   ser.accept()		|
			|
  -----------------------------------------
    3) 소켓 연결이 이뤄지고 나면
    Socket을 사용하요 서버로의 Stream을 얻어냄
    -> sock.getInputStream()
       sock.getOutputStream()
 4) 이 스트림을 통해 데이터를 주고 받는다.
///////////////////////////////////////////////////
6. RMI란?
 ... Remote Method Invocation

1) RMI에 대한 기본 이해
    cf> RPC(Remote Procedure Call)
  : 네트워크 상에서 데이터를 자연스럽게 주고
    받기 위해 사용되던 방식
    특정 프로그램이 네트워크로 연결된 다른
    컴퓨터에 있는 함수를 호출하고, 그 결과
    값을 반환받을 수 있도록 해준다.
    다른 컴퓨터에 있는 함수를 호출하기 때문에
    소켓 프로그래밍보다 훨씬 수월.

    Java(jdk1.1부터)에서는 RPC의 장점을 살려
    분산객체 애플리케이셔을 쉽게 만들 수 있는
    개념을 제시했는데 이것이 바로
    RMI 이다.
    분산컴퓨터 환경을 지원하여 한 목적으로
    네트워크상의 여러 컴퓨터들이 협동작을
    수행하도록 해주는 기술이다.

 지금까지 프로그램들은 한 컴퓨터(하나의 JVM)에서
 만 실행된 프로그램이었다.
 이에 반해 RMI 에서는 원격 컴퓨터의 자바가상머신
 에 존재하는 클래스 객체의 메소드를 호출할 수 있
 도록 해준다.

 
*****************************************
7. DB 접근 모델
   1) Two Tier Model
   2) Three Tier Model (N-Tier Model)

   ..분산 환경에서 DB를 연동하기 위한 구현 모델로
     자바 프로그램에서 JDBC 드라이버를 통해 직접
  DBMS에 연동하는 Two티어 모델과 
  중간에 미들웨어 역할의 프로그램을 거쳐
  DBMS와 연동하는 Three티어 모델이 지원된다.

1) 2-tier 모델
   ...클라이언트 서버 기술 출현과 함께 등장한 
      설계 방식
   - db를 연동하는 Java 프로그램이 클라이언트가
     되고, DBMS는 서버가 된다.
 
   --------------+    ------------
   자바 프로그램 |    | DBMS
   --------------+ <----------> |
   JDBC 드라이버 |    |
   --------------+    +-----------

  [클라이언트]     [서버]

   - 2-tier의 장점 및 단점
------------------------------------------------
   장점     | 단점
------------------------------------------------
1> 쉽게 구현   | 1> client쪽에 Driver가
      |    준비되어 있어야 함
2> 일관된 연결방식  |
   유지가 가능   | 2> 애플릿의 경우 다운받은   
3> 연결하거나 연결해제 |    서버로만 연결될 수 
   시 발생하는 과부하를 |    있다. 즉 애플릿쪽에
   제거할 수 있다.  |  드라이버라 load되어
4> 3-tier보다 속도가 |  있어야 한다.
   빠르다.    |  DB 서버== WEB 서버가
      |   같은 시스템이어야 한다.
      |   -> 보안모드 때문에
------------------------------------------------

2) 3-tier 모델

 ..다층 구조 설계 방식
   중간에 Middle Ware 가 하나 또는 2개
   이상인 모델 방식을 의미한다.

 - 클라이언트와 DBMS 서버사이에 중간 서버를
   두고, 중간 서버가 여러 클라이언트의 요청을
   처리하고, 하나 이상의 데이터베이스 서버에
   대한 접속을 유지하도록 설계 된다.
 
 - 클라이언트와 중간 서버간에 어떤 방식으로
   연결하고 통신하도록 할 것인가에 따라서
   Socket, RMI, CORBA 등의 네트워크/분산처리
   기술이 활용된다.

클라이언트                 중간서버                      db서버
-------------+			+------------------+        -------- 
자바프로그램 |<-->		|Application Server|<-->	| DBMS  
-------------+			| (Java)           |		+-------
                        |JDBC Driver       |  
                        |  (중간서버)      |
                        +------------------+

 
- 3tier의 장점과 단점
--------------------------------------------------
  장점                             | 단점
--------------------------------------------------
1> 클라이언트가 지역적				|1> db와 연결을 일관되게
   으로 로드되는 jdbc				|   유지하지 못함(client가
   driver를 보유하지				|   직접 디비와 연결하는것
   않아도 됨						|   이 아니기 때문에)
2> 중앙통제 방식으로				|2> 별도의 중간 서버를 개발
   드라이버를 로드할				|   해야 하는 부담이 있다.
   수 있음							|
3> DB서버를 반드시 WEB				|cf)애플릿에서 db연동시
   서버와 동일한 시스				|   db서버와 웹서버가 다른
   템으로 구축할 필요가				|   시스템이라면, 3tier로
   없음								|   구현해야 한다.
                                    |3> 속도가 2tier보다 떨어짐
--------------------------------------------------

 
