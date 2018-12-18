<%@ page contentType="text/html; charset=EUC-KR"%>
<%	request.setCharacterEncoding("EUC-KR");	%>
<jsp:useBean id="dMgr" class="connectDB.DriverMgr"/>
<%
	String url = request.getParameter("p");
	
	dMgr.registCallInfo(url);
%>