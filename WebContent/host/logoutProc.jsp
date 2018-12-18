<%@ page contentType="text/html; charset=utf-8"%>

<%
	String param = request.getParameter("p");
	String host = (String) session.getAttribute("HOST");
	
	session.invalidate();
%>

<script>
	alert("로그아웃 되었습니다.");
	location.href="host_board.jsp?p=<%=param%>";	
</script>
