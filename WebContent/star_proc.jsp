<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
    <%
     request.setCharacterEncoding("utf-8");
     String menu = request.getParameter("menu");
     String star = request.getParameter("star");
     
     out.println(menu + "��" + "����" + star + "���� ���.");
    %>
