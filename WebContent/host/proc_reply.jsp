<%@page import="java.util.Calendar"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page contentType="text/html; charset=EUC-KR"%>
<%	request.setCharacterEncoding("EUC-KR");	%>
<jsp:useBean id="gMgr" class="connectDB.GuestMgr"/>
<%
	String method = request.getMethod().toUpperCase();
	String host = (String) session.getAttribute("HOST");
	
	String reply_idx = request.getParameter("reply_idx");
	String path = getServletContext().getRealPath("images/reply");
	
	if(method != null && method.equals("POST") && host != null )
		gMgr.deleteReply(Integer.parseInt(reply_idx), path);
	else{
		out.write("<script> alert('잘못된 접근입니다.');</script>");
	}
%>