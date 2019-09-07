<%@page import="java.util.Random"%>
<%@page import="java.util.ArrayList"%>
<%@page import="food.FoodVO"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="javax.sql.DataSource"%>
<%@page import="javax.naming.InitialContext"%>
<%@page import="javax.naming.Context"%>
<%@page import="java.sql.Connection"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%

request.setCharacterEncoding("utf-8");
String search = request.getParameter("serach");

System.out.println(search + "검색 했네");

//위 데이터를 데이터 베이스에 넣기
Connection conn = null;			
Boolean connect = false;

ArrayList<FoodVO> list = new ArrayList<>();
	
try {	
	Context init = new InitialContext();
	DataSource ds = (DataSource)init.lookup("java:comp/env/jdbc/kndb");
	conn = ds.getConnection();
	
	String sql = "select * from food";
	PreparedStatement pstmt = conn.prepareStatement(sql);
	ResultSet rs = pstmt.executeQuery();
	
	while (rs.next()) {
		FoodVO vo = new FoodVO();
		vo.setName(rs.getString("name"));
		vo.setMenu(rs.getString("menu"));
		vo.setHome(rs.getString("home"));
		vo.setPrice(rs.getString("price"));
		vo.setLoc(rs.getString("loc"));
		vo.setStar(rs.getString("star"));
		vo.setTel(rs.getString("tel"));
		vo.setTime(rs.getString("time"));
		list.add(vo);
	}
	
	connect = true;
	conn.close();
} catch (Exception e) {	
	connect = false;
	e.printStackTrace();
}	
	
if (connect == true) {	
	System.out.println("연결되었습니다.");
} else {	
	System.out.println("연결실패.");
}	
//랜덤
Random rnd = new Random();
int rNum = rnd.nextInt(list.size());
System.out.println("list 총 갯수: " + list.size());
System.out.println("랜덤값: " + rNum);

FoodVO vo = list.get(rNum);
System.out.println(vo.getMenu());

%>    

<!DOCTYPE html>
<html>
<head>
  <title>맛집 리스트</title>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css">
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js"></script>
  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"></script>
</head>
<body>
<jsp:include page="top.jsp" flush="false"/>
<div class="container">
  <h2>전체 맛집</h2>
  <table class="table">
    <thead>
      <tr>
        <th>가게이름</th>
        <th>메뉴</th>
        <th>원산지</th>
        <th>가격</th>
        <th>위치</th>
        <th>별점</th>
        <th>전화번호</th>
        <th>영업시간</th>
      </tr>
    </thead>
    <tbody>
   
      <tr class="table-dark text-dark">
        <td><%=vo.getName() %></td>
        <td><%=vo.getMenu() %></td>
        <td><%=vo.getHome() %> </td>
        <td><%=vo.getPrice() %></td>
        <td><%=vo.getLoc() %></td>
        <td><%=vo.getStar() %></td>
        <td><%=vo.getTel() %></td>
        <td><%=vo.getTime() %></td>
      </tr>      
 
    </tbody>
  </table>
</div>

</body>
</html>

    