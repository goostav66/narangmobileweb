<%@ page contentType="text/html; charset=EUC-KR"%>
<%	request.setCharacterEncoding("EUC-KR");	%>

<%
	String url = request.getParameter("p");
	String host = (String) session.getAttribute("HOST");
	if(host==null) response.sendRedirect("host_board.jsp?p="+url);
	
	response.setHeader("pragma","No-cache");
	response.setHeader("Cache-Control","no-cache");
	response.addHeader("Cache-Control","No-store");
	response.setDateHeader("Expires",1L);
%>
<jsp:include page="host_header.jsp">
	<jsp:param value="<%=url%>" name="p"/>
	<jsp:param value="비밀번호 변경" name="h"/>
</jsp:include>
<section class="section_host">
	<form method="POST" action="proc_password.jsp?p=<%=url%>">
	<div class="host_password_update">
		<input type="password" placeholder="변경할 비밀번호">
		<input type="password" placeholder="비밀번호 확인" name="pass">
		<button type="button">확인</button>
	</div></form>
</section>


