<%@page import="food.menuVO"%>
<%@page import="food.StoreVO"%>
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
String s_id = request.getParameter("s_id");
String ob = request.getParameter("orderby");
System.out.println(ob);
//위 데이터를 데이터 베이스에 넣기
Connection conn = null;			
Boolean connect = false;

ArrayList<menuVO> list = new ArrayList<>();
	
try {	
	Context init = new InitialContext();
	DataSource ds = (DataSource)init.lookup("java:comp/env/jdbc/kndb");
	conn = ds.getConnection();
	String sql = null;

	
	if (ob == null)
	//오름차순
	{
	sql = "SELECT * FROM menu WHERE s_id = ? ORDER BY price desc;"; 

   		} else {
	// 내림 차순
	sql = "SELECT * FROM menu WHERE s_id = ? ORDER BY price desc;";
   		}
	PreparedStatement pstmt = conn.prepareStatement(sql);
	pstmt.setString(1, s_id);
	ResultSet rs = pstmt.executeQuery();
	
	while (rs.next()) {
		menuVO vo = new menuVO();
		vo.setId(rs.getInt("id"));
		vo.setName(rs.getString("name"));
		vo.setPrice(rs.getString("price"));
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
<style>
	.starR {				
	background: url('http://miuu227.godohosting.com/images/icon/ico_review.png') no-repeat right 0;				
	background-size: auto 100%;				
	width: 30px;				
	height: 30px;				
	display: inline-block;				
	text-indent: -9999px;				
	cursor: pointer;				
	}				
	.starR.on{background-position:0 0;}				
				
</style>

<script>	
var score = 5;
$(document).ready(function(){	
	$('.starRev span').click(function(){					
		$(this).parent().children('span').removeClass('on');		
		$(this).addClass('on').prevAll('span').addClass('on');
		
		console.log($(this).addClass('on').text());
		score = $(this).addClass('on').text();
		return false;		
		});		
	
	$("#submit").click(function(){
	    $.post("star_proc.jsp",
	    {
	      menu:$('#m_menuname').text(),
	      star: score
	    },   
	    function(data,status){
	      alert("Data: " + data + "\nStatus: " + status);
	      modalClose;
	    });
	  });
	
	
});			

function getMenuName(name) {
	// alert(name);	
	$('#m_menuname').text(name);
	$('#myModal').show();
}

function modalClose() {
	score = 5;
	$('#myModal').hide();
}
</script>			

</head>
<body>
<jsp:include page="top.jsp" flush="false"/>
<div class="container">
  <h2>전체 맛집</h2>
  <table class="table">
    <thead>
      <tr>
        <%if (ob == null) { %>
        <th>메뉴이름<a href="menu.jsp?s_id=<%=s_id %>orderby=1">↑</a></th>
        <% } else { %>
        <th>메뉴이름<a href="menu.jsp?s_id=<%=s_id %>orderby=1">↓</a></th>
        <% } %>
        <th>이름</th>
        <th>가격</th>
      </tr>
    </thead>
    <tbody>
    <%for (menuVO vo : list) { %>
      <tr class="table-dark text-dark">
        <td><%=vo.getName() %></td>
        <td><%=vo.getPrice() %></td>
      </tr>      
  	<% } %>
    </tbody>
  </table>
</div>

  <!-- The Modal 시작 -->
  <div class="modal" id="myModal">
    <div class="modal-dialog">
      <div class="modal-content">
      
        <!-- Modal Header -->
        <div class="modal-header">
          <h4 class="modal-title">평가하기</h4>
          <button type="button" class="close" data-dismiss="modal">&times;</button>
        </div>
        
        <!-- Modal body -->
        <div class="model-body">
        <p id="m_menuname"></p>
     <div class="starRev">		
<span class="starR on">1</span>		
<span class="starR on">2</span>		
<span class="starR on">3</span>		
<span class="starR on">4</span>		
<span class="starR on">5</span>		
</div>
    
        </div>
        
        <!-- Modal footer -->
        <div class="modal-footer">
        <button type="button" class="btn btn-primary" id="submit">평가하기</button>
        <button type="button" class="btn btn-danger" data-dismiss="modal" onclick="modalClose()">취소</button>
        </div>
        </div>
    </div>
  </div>
        <!-- 모달 끝 -->


</body>
</html>

    