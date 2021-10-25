JDBC개요
1] 환경설정
	1> Oracle설치[XE]
	2> 오러클 설치후 path 설정==>오러클개요.txt 참조

	 3> 오러클 드라이버[ojdbc8.jar] 있는 곳 
	 C:\app\ict01-00\product\18.0.0\dbhomeXE\jdbc\lib


2] 오러클 실행[실행창->services.msc]
시작-->설정->제어판->관리도구-->서비스
--> 에서 OracleServiceXE와  OracleXETNSListener를 시작 시킨다.

3]자바와 연동 테스트
--> TestOracle01.java

4] 이클립스에 ojdbc8.jar 라이브럴리 추가



5] JDBC 프로그래밍 절차**************************************
1. 드라이버 로딩...Class.forName()
2. 커넥션 할당받기... 
DriverManager.getConnectiont() 을 통해..
3. 쿼리문 전송을 위한 Statement  또는 
PreparedStatement
    할당받기.... 
	con.createStatement()/ con.prepareStatement()
					를 통해
4. Statement/PreparedStatement를 통해 쿼리문 전송
    <1> DML(insert, delete, update) 문인 경우...
			-> int updateCount =st.executeUpdate(sql)
	<2> select 문인 경우...
			-->ResultSet rs=st.executeQuery(sql)
5. select 문일 경우
		ResultSet의 논리적 커서를 이동시키면서
		각 컬럼의 데이터를 꺼내온다.
		boolean b=rs.next() : 커서 이동, 커서가 위치한 지점에
										레코드가 있으면 true를 리턴
										없으면 false를 리턴한다.
										커서는 맨처음에 첫번째 행의 직전에
										위치하고 있다가, next()가 호출되면
										후진한다.
		rs.getXXX(컬럼인덱스)
		rs.getXXX(컬럼명) 등의 메소드를 통해 데이터를 꺼내온다.
		...이때 get뒤에는 컬럼의 데이터 유형과 맞춰준 자료형을
		   기재한다.
		   number 인경우 rs.getInt(1)
		   varchar2인경우 rs.getString(2);
		   sysdate인 경우 rs.getDate(3) 등....
6.  다 사용한 자원 반납
		rs.close();
		st.close();
		con.close();
		...이 때 null체크해서 close()해주는 것이 좋다.
			finally 블럭에서 구현하는 것이 좋음
////////////////////////////////////////////
6] JDBC(Java Database Connectivity)

드라이버 개발---> DBMS 사의 개발자가 개발
java.sql패키지를 보고 개발
90%가 인터페이스로 구성되어 있다.--명세서(spec)

Oracle/My-sql/Ms-sql/Infomix

class MssqlConnection implements Connection
{
	public Statement createStatement(){
		//sss
	}
}

Connection 인터페이스
... createStatement() 추상메소드를 가짐

class OracleConnection implements Connection{
	public Statement createStatement(){
		//오러클 db에 맞게 구현	
	}
}////////////////////////////////

Statement st=con.createStatement();


////////Class.forName()을 하면///////////
class OracleDriver implements Driver{

	static{
		new OracleDriver();
	}
	private OracleDriver(){
		DriverManager.registerDriver(this);
		드라이버 매니저는 클래스
		- 드라이버들을 관리 등록하는 역할
		  : 드라이버를 등록해야 사용 가능함
		- 드라이버를 벡터로 관리
		  : 드러이버를 벡터에 넣고 관리하면서 DB와 커넥션을 함
	}//생성자------
}
/////////////////////////////////////////////////////////////
7] DB 접근 모델
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
 
   --------------+					 ------------
   자바 프로그램 |					  | DBMS
   --------------+ <----------> |
   JDBC 드라이버 |				  |
   --------------+					 +-----------

  [클라이언트]     [서버]

   - 2-tier의 장점 및 단점
------------------------------------------------
   장점							 | 단점
------------------------------------------------
1> 쉽게 구현					 | 1> client쪽에 Driver가
									 |    준비되어 있어야 함
2> 일관된 연결방식			 |
   유지가 가능					  | 2> 애플릿의 경우 다운받은   
3> 연결하거나 연결해제	  |    서버로만 연결될 수 
   시 발생하는 과부하를	  |    있다. 즉 애플릿쪽에
   제거할 수 있다.				  |  드라이버라 load되어
4> 3-tier보다 속도가		  |  있어야 한다.
   빠르다.						  |  DB 서버== WEB 서버가
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

클라이언트                 중간서버						db서버
-------------+			+----------------------+		+-------- 
자바프로그램	 |<-->		|Application Server	   |<-->	| DBMS  
-------------+			| (Java)               |		+-------
                        |JDBC Driver           |  
                        |  (중간서버)			   |
                        +----------------------+

 

- 3tier의 장점과 단점
--------------------------------------------------
  장점							| 단점
--------------------------------------------------
1> 클라이언트가 지역적				|1> db와 연결을 일관되게
   으로 로드되는 jdbc				|   유지하지 못함(client가
   driver를 보유하지				|   직접 디비와 연결하는것
   않아도 됨						|   이 아니기 때문에)
2> 중앙통제 방식으로					|2> 별도의 중간 서버를 개발
   드라이버를 로드할					|   해야 하는 부담이 있다.
   수 있음                        |
3> DB서버를 반드시 WEB				|cf)애플릿에서 db연동시
   서버와 동일한 시스					|   db서버와 웹서버가 다른
   템으로 구축할 필요가				|   시스템이라면, 3tier로
   없음                          |   구현해야 한다.
                                |3> 속도가 2tier보다 떨어짐
--------------------------------------------------




