<%@ page contentType="text/html; charset=utf-8"%>
<jsp:useBean id="bMgr" class="connectDB.BoardMgr"/>
<%
	String url = request.getParameter("p");
	String host = (String)session.getAttribute("HOST");

	int idx = Integer.parseInt(request.getParameter("idx"));
	
	if(url.equals(host))
		bMgr.deleteBoard(idx);
	
	response.sendRedirect("host_board.jsp?p="+url);
%>