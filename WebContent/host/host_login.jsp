<%@ page contentType="text/html; charset=EUC-KR"%>
<%	request.setCharacterEncoding("EUC-KR");	%>
<jsp:useBean id="fMgr" class="connectDB.FranchiseMgr"/>
<%
	String url = request.getParameter("p");

	String shop_name = fMgr.getFranchInfo(url).getShop_name();
	if(shop_name==null) response.sendRedirect("host_login.jsp?p="+url);
%>
<jsp:include page="host_header.jsp">
	<jsp:param value="<%=url%>" name="p"/>
	<jsp:param value="로그인" name="h"/>
</jsp:include>
<section class="section_host">
	<div class="host_login_guid">
		<span><%=shop_name%></span><span> 점주님 환영합니다.</span><br>
		<span>비밀번호를 입력해주세요.</span>
	</div>
	<form method="POST" action="proc_login.jsp?p=<%=url%>">
	<div class="host_login_password">
	<%if( url != null && url.equals("djs1a0122")){%>
		<input type="number" name="password" placeholder="비밀번호"><%}
	else{%>
		<input type="password" name="password" placeholder="비밀번호">
	<%} %>
		<button type="submit">로그인</button>	
	</div></form>
</section>
</html>